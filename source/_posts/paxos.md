title: paxos
tags: [distribution, consensus]
date: 2016-08-28 11:07:17
categories: distribution system
---
部分的看完了数值优化和凸优化，觉得数学方面暂时不需要更多的补充了，所以重启了很久以前的6.824。16年的6.824没有 paxos ，换成了 raft 。但是本着一切分布式一致性协议都是 paxos 变种的思想，还是毅然决然的去做了下15年的 paxos 实验，居然一天就过了所有的 test。想想看去年，做了4，5天都没过啊。。。。。怕以后忘了，所以总结一下。
<!--more-->
# 分布式一致性算法
首先要说一下分布式一致性算法，这东西主要被用在分布式存储当中(不知道分布式计算用不用)。多个操作过来的时候，需要一个确定性的顺序去执行。在 GFS 中，使用了 lease(租约) 的方法，也就是手动指定一个制定者去简化这一过程。但是这种过程会存在一些问题，就像 GFS 这样可能会有脏读的情况出现。

所以分布式一致性算法的场景一般是这样的：有多个客户端需要提交申请，现在需要确定全局一致的申请提交顺序。顺序一旦确定，就不可更改。

在这个场景中，我们将提交的申请称为 proposal， 提交者称为 proposer ，接受提交的一方称为 acceptor。现在来看，我们只需要这两个角色就够了，我们提交的申请记为 v

## single acceptor
在介绍 paxos 之前，我们先简单想想看怎么去做。最简单的场景就是一个 acceptor

这就很简单了。我们在 acceptor 里面存个变量表示当前的 v proposer 访问前先加锁，然后看看 v 有没有确定，确定就算了，没确定就赋个值。最后释放锁。

当然了，这样会有问题：proposal 释放锁之前挂了怎么办？那不就死锁了？所以这里我们引入一个变量 seq ，可以理解为申请的编号。 acceptor 只接受比自己的 seq 大的申请。

这样的话过程就变成了这样：
1. acceptor 先检查 proposal 的 seq ，如果小于自己的，就返回错误；否则更新自己的seq
2. 如果 acceptor 没有返回错误， proposer 查看一下 acceptor 的 v ，没有就赋值。

这样的话 proposer 怎么挂都无所谓了。在 single proposal 的情况下，我们得到一个可行的方案。但是这样的话， acceptor 就成了 single failure ，一旦挂了就完蛋了。当切换到多个 acceptor 的时候，就需要 paxos

# paxos
下面的对 paxos 的描述基本都源自 Paxos Made Simple，建议阅读原 paper 。

在上面 single acceptor 的场景中，单纯用锁已经无法满足需求，在这里自然也是一样。所以我们依然采用 seq 的设计。acceptor 同样被分为2个过程，分别称为 accept 和 choose。我们从上一步的一些基本处理出发，推导 paxos 的过程。

1. 首先，最基础的东西：acceptor 必须 accept 第一份 proposal。这和 single 的是一致的。
2. 如果一个 proposal(值为 v) 被 choose ，那么后面所有被 choose 的 proposal (即有更高的 seq) 的值都必须是 v
3. 一个 proposal 想要被 choose ，就必须被 accept 。所以如果一个 proposal(值为 v) 被 choose， accept 其他值的 proposal 就没有意义了。所以我们进一步强化 2：如果一个 proposal(值为 v) 被 choose ，那么后面被 accept 的 proposal 的值都必须为 v

但是这样会出现矛盾的情况。假如一个 proposal 被 choose， 值为 v1。但是由于网络或者其他原因，一个 acceptor 没有参与所有的决策。这时候一个新的值为 v2 的 proposal 被提出。根据条件1， 该 acceptor 需要 accept； 但是根据条件3， 又不该 accept。为了解决这个矛盾，我们修改一下3：
> 一个 proposal 被 accept 有2种情况：seq 大于 acceptor 的 seq， 否则 v 相同

为了让 proposal 被 choose，我们就需要预测未来的 seq 或者 v。这显然不可能，所以我们将这种判断放在 acceptor 那里。

这样的情况下，我们就得到了 paxos 算法。算法共有2个阶段：
1. accept ： proposer 首先提交 seq ， acceptor 判断是否大于自己的 seq ；大于则接受，并且返回自己已经 accept 的 proposal。否则随意，爱啥啥 。如果 proposal 被大多数(即大于半数)的 acceptor accept， 那么可以进入下一阶段
2. choose ： proposer 首先检查返回的 proposal 。如果都是空的，那么赋值；否则根据上面的条件2，必须要维护现有的决定，所以选择 seq 最高的一个的 v 作为自己提交的 v，向所有的 acceptor 广播 proposal。 如果大部分的 acceptor choose 了 proposal， 则成功。

算法的伪代码如下：
- proposer：
  - 选择全局唯一的 proposal seq
  - 提交 seq
  - 如果被大多数 acceptor accept，则
    - 选择 seq 最高的 v， 没有就选自己的v
    - 提交 proposal
    - 如果被大多数 acceptor accept， 则广播 decide 消息

- acceptor ：
  - prepare：
    - 看 seq 和自己的 seq， 大于自己的就更新自己的，并且返回成功以及已经 accept 的 proposal ；否则失败
  - accept：
    - 还是看 seq 和自己的 seq， 大于等于自己的就 accept；否则失败

## 一些细节的问题
介绍完算法之后，还有一些细节性的问题(问题以及例子来源于6.824)。
- accept 之后为什么要选择 seq 最高的 v？

  这个问题本身是根据 paxos 的前提给出的，但是我们也可以给出一些例子：比如现在有3个 acceptor 1，2，3；现在3个 acceptor 的行为分别是：

  |acceptor 1| p10 | a10A | | | p12 | a12X |
  |----------| --- |------|------|------|------|------|
  |acceptor 2| p10 |  | p11 | a11B |  |
  |acceptor 3| p10 |  | p11 | a11B | p12| a12X|

  上表中的 p 表示 prepare，a 表示 accept， 数组表示 seq 大写字母表示 v 。这种情况下如果 X 不是 B 的话，系统就会 choose 两个 v。 虽然这种情况只在B占大多数的情况下，但是我们通过返回值是无法判断这种情况的。所以我们只能选择一个 proposal 。
- accept 时， acceptor 为什么要检查 seq？
  还是看例子：

  |acceptor 1| p1 | p2 | a1A | a2B |
  |----------| --- |------|------|------|
  |acceptor 2| p1 | p2 | a1A |  |
  |acceptor 3| p1 | p2 | N | a2B |

  不检查的话，就会出现这种冲突
- acceptor 挂了怎么办？
  acceptor 可以挂，但是必须可以恢复原状态。不然会出现下面的问题：

  |acceptor 1| p1 | a1A |   | p2 |  |
  |----------| --- |------|------|------|--|
  |acceptor 2| p1 | a1A | reboot |  | a2X|
  |acceptor 3| p1 | N | N  | p2 | a2X |

  如果不能恢复，一致性问题无法保证。
- 考虑这种情况：

  acceptor 1| p1 | p2 | p3
  ----------| ---|----|----
  acceptor 2| p1 | p2 | p3 

  即有2个 proposer, 循环提交 seq 这样的话，系统会陷入 live lock 的情况。解决方案就是下面的 leader

## 一些建议
1. learner 角色。当 acceptor 对 proposal 达成一致时，会通知 learner 。这样据说可以提供更高的可用性(反正我是没看出来) 对于通知的方式，如果一对一的通知的话，消息的数量会比较多。这时候可以选择只通知一个 learner， 然后由它向所有 learner 广播。如果觉得一个 learner 风险太高，可以选择多个。
2. leader 角色。一个proposal最少需要5次消息，这还是一轮确定并且 acceptor 只有一个的情况下。为了减少消息数量，可以在 proposer 中选出一个 leader ，有它负责和 acceptor 进行交流；其他 proposer 和 leader 交流。
3. 磁盘挂了。上面提到 acceptor 挂了的话，如果不能恢复，会出现问题。如果磁盘挂了怎么办？磁盘挂了分为2种情况：数据损坏或者是彻底不能用了。对于数据损坏，我们写入的时候可以加校验和，读的时候检查一下；对于彻底损坏，则当前的 acceptor 接受消息，但是不做回应，知道有 proposal 被 choose。这样可以保证 acceptor 不管怎么说都不会违背之前的行为
