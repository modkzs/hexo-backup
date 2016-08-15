title: renewal process
tags: [stochastic process]
date: 2016-03-09 16:04:40
categories: math
---
renewal process，poisson process的泛化版本。并不知道有什么用=。=但是在markov process中大量结论的获得都需要借助renewal process，所以课上给了一定篇幅介绍。
<!--more-->
# 再来看看大数定律
## WP1
前面说到过WP1的定义：
{% math %}
Pr\left\{w\in\Omega:\lim_{n\to\infty}Z_n(w)=Z(w)\right\}
{% endmath %}
如果我们令 {% math %}Y_n(w)=Z_n(w)-Z(w){% endmath %}，则根据上面的定义可知，{% math %}Y_n(w){% endmath %} 会收敛于0。可以证明，只要 {% math %}Y_n(w){% endmath %} 期望finite，且 {% math %}\sum_{n=1}^\infty E[|Y_n|]<\infty{% endmath %} ， {% math %}Y_n(w){% endmath %} 均收敛于0。

证明过程如下：
由markov inequality知：
{% math %}
Pr\left\{\sum_{n=1}^m|Y_n|>\alpha\right\}\le \dfrac{E[\sum_{n=1}^m|Y_n|]}{\alpha} = \dfrac{\sum_{n=1}^mE[|Y_n|]}{\alpha}\le\dfrac{\sum_{n=1}^\infty E[|Y_n|]}{\alpha}
{% endmath %}
令 {% math %}A_m=\left\{w:\sum^m_{n=1}|Y_n(w)|>\alpha\right\}{% endmath %} ，则 {% math %}lim_{m\to\infty}Pr\left\{\sum_{n=1}^m|Y_n|>\alpha\right\} = Pr\left\{\bigcup_{m=1}^\infty A_m\right\}=Pr\left\{w:\sum_{n=1}^\infty |Y_n(w)|>\alpha\right\}{% endmath %}
所以有
{% math %}
Pr\left\{w:\sum_{n=1}^\infty |Y_n(w)|>\alpha\right\} \le \dfrac{\sum_{n=1}^\infty E[|Y_n|]}{\alpha}\\
\Rightarrow Pr\left\{w:\sum_{n=1}^\infty |Y_n(w)|\le\alpha\right\} \ge 1-\dfrac{\sum_{n=1}^\infty E[|Y_n|]}{\alpha}\\
\Rightarrow Pr\left\{\lim_{n\to\infty} |Y_n(w)|=0\right\} \ge 1-\dfrac{\sum_{n=1}^\infty E[|Y_n|]}{\alpha}
{% endmath %}
由于上述结论对任意 {% math %}\alpha{% endmath %} 均成立，故 {% math %}Pr\left\{\lim_{n\to\infty} |Y_n(w)|=0\right\}=1{% endmath %}

下面我们证明大数定律，即：
{% math %}
Pr\left\{w:\lim_{n\to\infty}\dfrac{S_n(w)}{n}\right\} \quad \text{Xs are IID and }E[|X|]<\infty
{% endmath %}
=。=不过只证明 {% math %}\bar{X}=0,E[X^4]<\infty{% endmath %} 。令 {% math %}E[X^4] = \gamma{% endmath %}
{% math %}
\begin{aligned}
E[S_n^4]&=E[(X_1+...+X_n)(X_1+...+X_n)(X_1+...+X_n)]\\
&=\sum_{i=1}^n\sum_{j=1}^n\sum_{k=1}^n\sum_{l=1}^n E[X_iX_jX_kX_l]\\
&= n\gamma +3n(n-1)\sigma^4
\end{aligned}
{% endmath %}
故可得：
{% math %}
\sum_{n=1}^\infty E\bigg[\bigg|\dfrac{S_n^4}{n^4}\bigg|\bigg]= \sum_{n=1}^\infty \dfrac{n\gamma +3n(n-1)\sigma^4}{n^4}<\infty\\
\Rightarrow\lim_{n\to\infty}|S_n/n| = 0
{% endmath %}

当然了，对于期望不为0的变量(只要是finite)，可以直接减掉期望就行了

## SLLN for Renewal Process
{% math %}
\lim_{t\to\infty} N(t)/t = 1/\bar{X}
{% endmath %}

首先证明 {% math %}\lim_{t\to\infty}N(t)=\infty\quad WP1{% endmath %} 。由  {% math %}\lim_{t\to\infty}Pr\left\{N(t)<n\right\}=\lim_{t\to\infty}Pr\left\{S_n>t\right\}=1-\lim_{t\to\infty}Pr\left\{S_n\ge t\right\}{% endmath %} 且{% math %}S_n{% endmath %} 为defective rv，因此 {% math %}\lim_{t\to\infty}Pr\left\{S_n\ge t\right\} = 0{% endmath %} ，故 {% math %}\lim_{t\to\infty}Pr\left\{N(t)<n\right\} = 0{% endmath %} 故 {% math %}\lim_{t\to\infty}N(t)=\infty, \lim_{t\to\infty}E[N(t)]=\infty{% endmath %}

因为 {% math %}\lim \dfrac{S_n}{n} = \bar{X}{% endmath %}，故 {% math %}\lim_{n\to\infty} \dfrac{n}{S_n} = \dfrac{1}{\bar{X} }{% endmath %} 。又由下图知：
![](http://ww1.sinaimg.cn/large/9dec4451gw1f1qw6rxjivj20lc07g3zk.jpg)
{% math %}
\dfrac{N(t)}{S_{N(t)+1} } \le \dfrac{N(t)}{t} \le \dfrac{N(t)}{S_{N(t)} }
{% endmath %}
所以 {% math %}\lim_{t\to\infty}\dfrac{N(t)}{S_{N(t)+1} }=\lim_{t\to\infty}\dfrac{n}{S_{n+1} }=\lim_{t\to\infty}\dfrac{n+1}{S_{n+1} }\dfrac{n}{n+1}=\dfrac{1}{\bar{X} }{% endmath %}

同理，{% math %}\lim_{t\to\infty}\dfrac{N(t)}{S_{N(t)} } = \dfrac{1}{\bar{X} }{% endmath %} 。得证

## CLT for Renewal process
{% math %}
\lim_{t\to\infty}Pr\left\{\dfrac{N(t)-t/\bar{X} }{\sigma\bar{X}^{-3/2}\sqrt{t} } < \alpha\right\} = \Phi(\alpha)
{% endmath %}

# Renewal-reward process
和markov chain一样，我们也给renewal process加上reward。在renewal process中，变化的是时间，因此reward自然也和时间有关。
## 三个重要的例子：residual life、age、duration
### residual life
poisson process中也定义过这个变量，即从时间t开始下一次到达还需要同时。可以用 {% math %}S_{N(t)+1}-t{% endmath %} 表示。我们用 {% math %}Y(t){% endmath %} 表示residual life。则
{% math %}
\int_{\tau=0}^tY(\tau)d\tau = \frac{1}{2}\sum_{n=1}^{N(t)}X^2_n+\int_{\tau=S_{N(t)} }^tY(\tau)d\tau
{% endmath %}
由上市可以推出 {% math %}\dfrac{1}{2t}\sum_{n=1}^{N(t)}X^2_n\le\dfrac{1}{t}\int_{\tau=0}^tY(\tau)d\tau\le\dfrac{1}{2t}\sum_{n=1}^{N(t)+1}X^2_n{% endmath %}

由 {% math %}\lim_{t\to\infty}\dfrac{\sum_{n=1}^{N(t)}X_n^2}{2t} = \lim_{t\to\infty}\dfrac{\sum_{n=1}^{N(t)}X_n^2}{N(t)}\dfrac{N(t)}{2t}=\dfrac{E[X^2]}{E[X]}{% endmath %} ，{% math %}\lim_{t\to\infty}\dfrac{\sum_{n=1}^{N(t)+1}X_n^2}{2t}=\lim_{t\to\infty}\dfrac{\sum_{n=1}^{N(t)+1}X_n^2}{N(t)+1}\dfrac{N(t)+1}{N(t)}\dfrac{N(t)}{2t} = \dfrac{E[X^2]}{E[X]}{% endmath %} 知：
{% math %}
\lim_{t\to\infty}\int_{\tau=0}^tY(\tau)d\tau = \dfrac{E[X^2]}{2E[X]}
{% endmath %}

### age
和residual life正好相反，age表示t时刻与上次到达的间隔，即 {% math %}t-S_{N(t)}{% endmath %} ，记做 {% math %}Z(t){% endmath %} 。 与residual life的过程类似，我们可以求出 {% math %}\lim_{t\to\infty}\int_{\tau=0}^tZ(\tau)d\tau = \dfrac{E[X^2]}{2E[X]}{% endmath %}

### duration
duration 表示t时刻所在的interval长度，记做 {% math %}\tilde{X}(t) = X_{N(t)+1} = S_{N(t)+1}-S_{N(t)}=Z(t)+Y(t){% endmath %} 。易知 {% math %}\lim_{t\to\infty}\int_{\tau=0}^t\tilde{X}(\tau)d\tau = \dfrac{E[X^2]}{E[X]}{% endmath %}

## 泛化的定义
从前面的三个例子，很容易发现：只要我们掌握了 {% math %}Y(t),Z(t),\tilde{X}(t){% endmath %} 中的任意两个，就掌握了一个interval。因此泛化的reward被定义为： {% math %}R(Z(t),\tilde{X}(t)){% endmath %} 。当然了，这并不意味着 {% math %}R(t){% endmath %} 一定和 {% math %}Z(t),\tilde{X}(t){% endmath %} 都有关。 我们将 {% math %}R_n{% endmath %} 定义为第n个interval的accumulated reward，即
{% math %}
R_n = \int^{S_n}_{S_{n-1} }R(\tau)d\tau = \int^{S_n}_{S_{n-1} }R(Z(t),\tilde{X}(t))dt
\int^{S_n}_{S_{n-1} }R(t-S_{n-1},\tilde{X}(t))dt=\int^{x_n}_0R(z,\tilde{X}(t))dz
{% endmath %}

如果 {% math %}\left\{R(t);t>0\right\}\ge 0, \bar{X}<\infty, E[R(t)]<\infty{% endmath %} ，则有
{% math %}
\begin{equation}
\label{eq:R_n}
\lim_{t\to\infty}\dfrac{1}{t}\int_0^tR(\tau)d\tau=\dfrac{E[R_n]}{\bar{X} }
\end{equation}
{% endmath %}
证明：因为 {% math %}\int_0^tR(\tau)d\tau = \int_0^{S_1}R(\tau)d\tau+...+\int^t_{S_{N(t)} }R(\tau)d\tau = \sum_0^{N(t)}R_n + \int^t_{S_{N(t)} }R(\tau)d\tau{% endmath %}
故 {% math %}\dfrac{\sum_{n=1}^{N(t)}R_n}{t} \le \dfrac{\int_0^tR(\tau)d\tau}{t} \le \dfrac{\sum_{n=1}^{N(t)+1}R_n}{t}{% endmath %}

接下来和residual life的证明基本一样。

# stopping trial
定义：对于rv {% math %}X_1,X_2...X_n{% endmath %} ，stopping trial 是非负的indicator rv {% math %}\mathbb{I}_{J=n}{% endmath %} ，n是关于{% math %}X_1,X_2...X_n{% endmath %} 的函数。

这么说太形式化了。简单地说，假如你在赌博，如果你赚100块就不赌了。在这个例子中，赌博就是随机过程，赚到100就不赌就是stopping trial。

## Wald's equality
{% math %}{X_n;n\ge1}{% endmath %} 为 IID rv， 期望为 {% math %}\bar{X}{% endmath %} ；{% math %}J{% endmath %}为 {% math %}X_n{% endmath %} 的stopping trial，{% math %}S_J=X_1+...+X_J{% endmath %}则：{% math %}E[S_J]=\bar{X}E[J]{% endmath %}

证明：由{% math %}S_J=\sum_{n=1}^JX_n=\sum_{n=1}^\infty X_n\mathbb{I}_{\left\{J\ge n\right\} }{% endmath %}，可以推出
{% math %}
E[S_J]=E\bigg[\sum_{n=1}^\infty X_n\mathbb{I}_{\left\{J\ge n\right\} }\bigg]=E\bigg[\bar{X}\sum_{n=1}^\infty \mathbb{I}_{\left\{J\ge n\right\} }\bigg]=\bar{X}E[J]
{% endmath %}

### 一个例子
感觉还是太抽象了一点，举个例子说明一下好了。以抛硬币为例子，当然还是泛化一点，正面概率为 {% math %}p{% endmath %} ，反面概率为 {% math %}1-p{% endmath %} 。抛到正面得一分，反面扣一分；得分为1时停止游戏。

令 {% math %}\theta = Pr\left\{J<\infty\right\}{% endmath %} 。则我们得一分有两种情况：第一次抛到正面；第一次抛到反面，然后抛数次得分再次为-1，然后抛到2次正面。在这个过程中，最终从-1到0与从0到1的概率是一样的，都是 {% math %}\theta{% endmath %} 。所以有下面的式子成立：
{% math %}
\theta = p + (1-p)\theta^2
{% endmath %}
对于 {% math %}p\le 0.5{% endmath %} 我们可以解出 {% math %}\theta=p/(1-p){% endmath %} 对于 {% math %}p>0.5{% endmath %} 算出来都大于1了，当然不成立。对于这种情况，和上面计算一样，我们可以得到
{% math %}
E[J] = p + (1-p)(1+2E[J]) \Rightarrow E[J]=\dfrac{1}{2p-1}
{% endmath %}
由 {% math %}J=1,E[J]=1{% endmath %} 可得 {% math %}\bar{X}=2p-1{% endmath %}

## 计算{% math %}E[N(t)]{% endmath %}
我们将 {% math %}S_n{% endmath %} 视为rv。但是需要注意的是，我们只有知道了 {% math %}S_{N(t)+1}{% endmath %} 才能确定 {% math %}N(t){% endmath %} ，所以stopping trial为 {% math %}N(t)+1{% endmath %} 。那么根据Wald’s equality，有：
{% math %}
E[S_{N(t)+1}] = \bar{X}E[N(t)+1]=\bar{X}[m(t)+1]\\
\Rightarrow m(t) = \dfrac{E[S_{N(t)+1}]}{\bar{X} }-1\ge\dfrac{t}{\bar{X} }-1\\
\Rightarrow \dfrac{m(t)}{t} \ge\dfrac{1}{\bar{X} }-\dfrac{1}{t}
{% endmath %}

## 泛化的版本
之前我们给出的定义中stopping trial只接受一个rv，我们可以扩展到一对rv {% math %}(X_n,V_n){% endmath %} 。{% math %}(X_n,V_n){% endmath %} 之间必须是IID的，但是 {% math %}X_n, V_n{% endmath %} 可以相关。当然了， Wald's equality仍然是成立的。

下面以G/G/1 queque为例说明。在排队论中，通常用M代表memoryless，G代表general(即IID)；一个场景的3个参数分别为：arrival的类型(M/G)，service time的类型(M/G)，以及窗口数量。例如上面的G/G/1表示arrival和service time均为IID，窗口数量为1的队列。一个队列由3个变量： {% math %}x_n,w^q_n,v_n{% endmath %} 表示。三个变量实际含义对应下图：
![](http://ww2.sinaimg.cn/large/9dec4451jw1f1rutm9k3kj20oi0a2aaz.jpg)
分别表示用户的到达间隔、等待时间、服务时间。从图中我们可以很容易的得到下面的结论：
{% math %}
W_i^q = max(W_{i-1}^q + V_{i-1}-X_i, 0)
{% endmath %}

如果我们考察第一个到达时队列为空的用户，即 {% math %}W_i^q=0{% endmath %} 这就是一个关于 {% math %}V_{i-1},X_i{% endmath %} 的stopping trial

## Little's theorem
对于一个FCFS G/G/1 queue，{% math %}\bar{X}{% endmath %} finite，队伍中平均人数={% math %}\bar{L}\quad WP1{% endmath %}，平均等待时间={% math %}\bar{W}\quad WP1{% endmath %} ，且 {% math %}\bar{L}=\lambda \bar{W}{% endmath %} ，{% math %}\lambda{% endmath %} 与poisson process一样，为arrival rate。

证明：
![](http://ww1.sinaimg.cn/large/9dec4451gw1f1s3705sssj20o6082mxq.jpg)
由上图，可知：
{% math %}
L_n = \int_{S_{n-1}^r}^{S_n^r}L(\tau)d\tau = \sum_{i=N(S_{n-1}^r)}^{N(S_{n}^r)-1} W_i\\
\Rightarrow \sum_{n=1}^{N^r(t)}L_n \le \int_{\tau=0}^tL(\tau)d\tau \le \sum_{i=0}^{N(t)} W_i \le \sum_{n=1}^{N^r(t)+1} L_n
{% endmath %}
由 \ref{eq:R_n} 可知：
{% math %}
\lim_{t\to\infty} \dfrac{\sum_{i=0}^N(t)W_i}{t} = \lim_{t\to\infty}\dfrac{\int_{\tau=0}^tL(\tau)d\tau}{t} = \dfrac{E[L_n]}{E[X^r]}
{% endmath %}
而 {% math %}\lim_{t\to\infty}\dfrac{\sum_{i=0}^{N(t)}W_i}{t} = \lim_{t\to\infty}\dfrac{\sum_{i=0}^{N(t)}W_i}{N(t)}\lim_{t\to\infty}\dfrac{ {N(t)}W_i}{t}=\lambda\bar{W}{% endmath %}

所以 {% math %}\bar{L}^q = \lambda \bar{W}^q{% endmath %}。当然对于FCFS以及有多个服务窗口的队列，该结论也成立。

对于单窗口来说，令 {% math %}\rho{% endmath %} 表示系统繁忙(即队列有人)的时间比例，{% math %}\bar{V}{% endmath %} 表示平均服务时间，则：
{% math %}
\rho = \lambda \bar{V}
{% endmath %}

## M/G/1 queue的用户平均等待时间
为了计算 M/G/1 queue，我们首先需要指定一些符号。将 {% math %}L^q(t){% endmath %} 记做队列中用户数量；{% math %}R(t){% endmath %} 为队列中当前用户完成服务的时间； {% math %}U(t){% endmath %} 为单个用户在t时刻的平均等待时间。则有：
{% math %}
U(t) = \sum_{i=0}^{L^q(t)}V_{N(t)-i}+R(t)\\
\Rightarrow E[U(t)]=E[L^q(t)]E[V]+E[R(t)]
{% endmath %}
首先求 {% math %}E[R(t)]{% endmath %} 。易知：
{% math %}
\int_0^{S^r_{N^r(t)} }R(\tau)d\tau = \sum_{i=0}^{N(S^r_{N^r(t)})-1} \dfrac{V_i^2}{2}\le \sum_{i=0}^{N(t)}\dfrac{V_i^2}{2}
{% endmath %}

{% math %}N(S^r_{N^R(t)})-1{% endmath %}的原因是{% math %}N(S^r_{N^R(t)}){% endmath %} 是新的队列(即队列中的客户数量由0变为1)开始的第一个arrival，所以需要减一。故
{% math %}
\lim_{t\to\infty}\dfrac{\int_0^tR(\tau)d\tau}{t} = \lim_{t\to\infty}\dfrac{\sum_{i=1}^{A(t)}V_i^2}{2A(t)}\dfrac{ {A(t)} }{t}=\dfrac{\lambda E[V]^2}{2}
{% endmath %}
而在上一节中，我们给出了 {% math %}E[L^q(t)]=\lambda \bar{W}{% endmath %} ，故
{% math %}
E[U(t)]=\lambda \bar{W} E[V]+\dfrac{\lambda E[V]^2}{2}
{% endmath %}
从字面上看，我们给出的 {% math %}U(t),W{% endmath %} 的定义是一样的。但是他们实际上是不同的。也不知道怎么说，直接给原文好了：
>The first is the expected unfinished work at time t, which is the queueing delay that a customer would incur by arriving at t; the second is the sample-path-average expected queueing delay.

对于poisson process来说，由于其memoryless的特性，{% math %}\lim_{t\to\infty}E[U(t)]=\bar{W}^q{% endmath %} (在前面对 {% math %}W^q{% endmath %} 的定义中我们会发现 {% math %}W^q{% endmath %} 的值依赖于{% math %}X{% endmath %} 而 {% math %}U(t){% endmath %} 不需要。所以对于poisson来说，{% math %}W^q{% endmath %} 与 {% math %}X{% endmath %} 独立，所以自然就一样样了)。在这种情况下，我们可以得到 Pollaczek-Khinchin formula：
{% math %}
\bar{W}^q=\dfrac{\lambda E[V^2]}{2(1-\lambda E[v])}
{% endmath %}
我们会发现上式表示V的方差越大，队伍平均等待时间越长。这也很好解释，所有排队是基本都碰到过这种情况：突然发现自己的队伍不动了，然后发现前面的顾客推了2大箱东西结算。这就是方差大的情况，这种情况下平均的排队时间自然会变长。

# {% math %}E[N(t)]{% endmath %}
对 {% math %}m(t)=R[N(t)]{% endmath %} 的求解是一个很trike的事情，而且会引出Blackwell’s theorem

## 求解m(t)
{% math %}
\begin{aligned}
m(t) &= E[N(t)] = \sum_{n=1}^\infty Pr\left\{N(t)\ge n\right\} = \sum_{n=1}^\infty Pr\left\{S_n\le t\right\}\\
&=\int_{x=0}^t \sum_{n=1}^\infty Pr\left\{S_n-1\le t-x\right\} dF_X(x) = F_X(t)+ \int_{x=0}^t \sum_{n=2}^\infty Pr\left\{S_n-1\le t-x\right\} dF_X(x)\\
&=F_X(t)+ \int_{x=0}^t \sum_{n=2}^\infty m(t-x) dF_X(x)
\end{aligned}
{% endmath %}
对两边都进行Laplace transform 就可以求解了。解为
{% math %}
m(t) = \dfrac{t}{\bar{X} } + \dfrac{E[X^2]}{2\bar{X}^2} + \dfrac{1}{2} + \epsilon(t) \quad t>0
{% endmath %}
其中 {% math %}\lim_{t\to\infty}\epsilon(t)=0{% endmath %}

求出上面的式子后，自然会有
{% math %}
\lim_{t\to\infty}\dfrac{E[N(t)]}{t} = \dfrac{1}{\bar{X} }
{% endmath %}
当然，不用上面的结论，对 {% math %}X{% endmath %}做截断也可以求出来上面的式子。

## Blackwell’s theorem
对于 {% math %}\lambda{% endmath %} 随时间变化的系统，很自然会有疑问：不同时间段的期望应该是不同的吧？Blackwell’s theorem 解答的就是这个问题。
首先我们需要定义arithmetic的概念。和markov chain中的period类似，如果interval有公约数(有理数、无理数都可以)的话，就成为arithmetic。比如说，如果你的到达间隔为1，{% math %}\pi{% endmath %} 的话，那你就只能是non-arithmetic了。
对于 arithmetic renewal process来说，有
{% math %}
\lim_{t\to\infty}[m(t+\lambda)-m(t)] = \dfrac{\lambda}{E[X]}
{% endmath %}

对于non-arithmetic renewal process来说，对于任意 {% math %}\delta >0{% endmath %}，都有
{% math %}
\lim_{t\to\infty}[m(t+\delta)-m(t)] = \dfrac{\delta}{E[X]}
{% endmath %}

对于{% math %}\lim_{k\to\infty}Pr\left\{Renewal at \lambda k\right\} =\lim_{k\to\infty} [m(\lambda k) - m(\lambda (k-1))] = \dfrac{\lambda}{\bar{X}}{% endmath %}

# 再挖一挖reward
## Age and duration
### arithmetic process
为了简化过程，我们假设 {% math %}\lambda = 1{% endmath %} 。很容易发现
{% math %}
p_{Z(t),\tilde{X}(t)}(i,k)=
\begin{cases}
p_X(k) & \text{for} i=t,k>t\\
q_{t-i}p_X(k) & \text{for} 0\le i<t,k>i\\
0 & \text{otherwise}
\end{cases}
{% endmath %}
其中 {% math %}q_{j}{% endmath %} 表示在j时刻有到达事件。

对 {% math %}Z(t){% endmath %} 取边缘分布，得
{% math %}
p_{Z(t)}(i)=
\begin{cases}
F^c_X(i) & \text{for} i=t\\
q_{t-i}F^c_X(i) & \text{for} 0\le i<t\\
0 & \text{otherwise}
\end{cases}
{% endmath %}

同时，{% math %}m(j)-m(j-1) =\sum_{n=0}^\infty E[Pr\left\{N(j)>n\right\}-Pr\left\{N(j-1)>n\right\}]{% endmath %} = q_j

对 {% math %}\tilde{X}(t){% endmath %} 取边缘分布，得：
{% math %}
p_{\tilde{X}(t)}(k)=
\begin{cases}
p_X(k)[m(t)-m(t-k)] & \text{for} k<t\\
p_X(k)m(t) & \text{for} k=i\\
p_X(k)[m(t)+1] & \text{for} k>t
\end{cases}
{% endmath %}

根据Blackwell’s theorem，可得
{% math %}
\lim_{t\to\infty}p_{Z(t)}(i) = \dfrac{F^c_X(i)}{\bar{X} }\\
\lim_{t\to\infty}p_{\tilde{X}(t)}(i) = \dfrac{kp_X(i)}{\bar{X} }
{% endmath %}

当然还可以计算出期望的极限
{% math %}
\begin{aligned}
\lim_{t\to\infty} E[Z(t)] &= \sum_ii\lim_{t\to\infty}p_{Z(t)}(i) = \dfrac{1}{\bar{X} }\sum_{i=1}^\infty\sum_{j=i+1}^\infty ip_X(j)\\
&=\dfrac{1}{\bar{X} }\sum_{j=2}^\infty\sum_{i=1}^{j-1} ip_X(j)=\dfrac{1}{\bar{X} }\sum_{j=2}^\infty \dfrac{j(j-1)}{2}p_X(j)\\
&=\dfrac{E[X^2]}{2\bar{X} }-\dfrac{1}{2}\\

\lim_{t\to\infty} E[\tilde{X}(t)] &= \sum_k\lim_{t\to\infty}kp_{\tilde{X}(t)}(k) = \sum_k\dfrac{k^2p_X(k)}{\bar{X} } = \sum_k\dfrac{E[X^2]}{\bar{X} }
\end{aligned}
{% endmath %}

### non-arithmetic process
对于non-arithmetic process来说，情况就要复杂的多。我们首先从联合概率分布说起。

令 {% math %}A=\left\{z\le Z(t) < z+\delta\right\}\bigcap\left\{x-\delta< \tilde{X}(t) \le x\right\}{% endmath %} (当然 {% math %}z-2\delta\le x{% endmath %})。则A可以被表示为
{% math %}
\begin{aligned}
A&=\left\{t-z-\delta< S_{N(t)} \le t-z\right\}\bigcap\left\{x-\delta< X_{N(t)+1} \le x\right\}\\
&=\bigcup_{n=1}^\infty \left\{\left\{t-z-\delta< S_n \le t-z\right\}\bigcap\left\{x-\delta< X_{n+1} \le x\right\}\right\}
\end{aligned}
{% endmath %}
而
{% math %}
Pr\left\{\left\{t-z-\delta< S_n \le t-z\right\}\bigcap\left\{x-\delta< X_{n+1} \le x\right\}\right\}\\
= Pr\left\{t-z-\delta< S_n \le t-z\right\}[F_X^c(x)-F_X^c(x-\delta)]\\
\Rightarrow Pr\left\{A\right\} = [m(t-z)-m(t-z-\delta)] [F_X^c(x)-F_X^c(x-\delta)]
{% endmath %}

现在我们继续看 {% math %}Z(t){% endmath %} 的边缘分布和期望。我们首先求{% math %}Pr\left\{z\le Z(t) < z+\delta\right\}{% endmath %}

易知：
{% math %}
Pr\left\{z\le Z(t) < z+\delta\right\} = Pr\left\{T\right\}+Pr\left\{B\right\}\\
T = \left\{z\le Z(t) < z+\delta\right\} \bigcap \left\{Z(t)< \tilde{X}(t) \le z+\delta\right\}\\
B = \left\{z\le Z(t) < z+\delta\right\} \bigcap \left\{\tilde{X}(t) > z+\delta\right\}
{% endmath %}
而由上节我们算出的联合概率分布，我们可以很容易的计算出
{% math %}
Pr\left\{B\right\}=[m(t-z)-m(t-z-\delta)]F_X^c(z+\delta)
{% endmath %}
对于 {% math %}T{% endmath %} ，我们有：
{% math %}
\begin{aligned}
T &= \left\{z\le Z(t) < z+\delta\right\} \bigcap \left\{Z(t)< \tilde{X}(t) \le z+\delta\right\}\\
&=\bigcup_{n\ge1}[\left\{t-z-\delta<S_n<t-z\right\}\bigcap\left\{t-S_n<X_{n+1}<z+\delta\right\}]\\
&\subseteq \bigcup_{n\ge1}[\left\{t-z-\delta<S_n<t-z\right\}\bigcap\left\{z<X_{n+1}<z+\delta\right\}]
\end{aligned}
{% endmath %}
{% math %}
\begin{aligned}
\Rightarrow Pr\left\{T\right\} &\le [\sum_{n\ge 1}Pr\left\{t-z-\delta<S_n<t-z\right\}][F^c_X(z)-F^c_X(z+\delta)]\\
&=[m(t-z)-m(t-z-\delta)][F^c_X(z)-F^c_X(z+\delta)]
\end{aligned}
{% endmath %}
{% math %}
\Rightarrow Pr\left\{Z(t)<z\right\} = \sum_{k=0}^{l-1}Pr\left\{k\delta\le Z(t)<k\delta+\delta\right\}\\
\Rightarrow Pr\left\{Z(t)<z\right\} \ge \sum_{k=0}^{l-1}[m(t-k\delta)-m(t-k\delta-\delta)]F^c_X(k\delta+\delta)\\
Pr\left\{Z(t)<z\right\} \le \sum_{k=0}^{l-1}[m(t-k\delta)-m(t-k\delta-\delta)]F^c_X(k\delta)\\
\Rightarrow Pr\left\{Z(t)<z\right\} = \int_{t-z}^t F^c_X(t-\tau)dm(\tau)\\
\Rightarrow F_{Z(t)}(z) = \int_{t-z}^t F^c_X(t-\tau)dm(\tau)
{% endmath %}
倒数第二步是通过让 {% math %}\delta{% endmath %} 无穷小然后做Riemann sum得到的。当然条件是积分必须存在了。

然后我们就可以求期望了。如果 {% math %}Z(t)=t{% endmath %} ，那么必然可以推出 {% math %}X_1=t{% endmath %} 。对于其他情况，我们还是将时间 {% math %}l{% endmath %}等分，每一份时间长度为 {% math %}\delta{% endmath %} 。则
{% math %}
\begin{aligned}
E[Z(t)] &\ge F_X^c(t) + \sum_{k=0}^{l-1} k\delta Pr\left\{k\delta \le Z(t)<k\delta+\delta\right\}\\
& \ge F_X^c(t) + \sum_{k=0}^{l-1} k\delta[m(t-k\delta)-m(t-k\delta-\delta)]F_X^c(k\delta+\delta)\\
E[Z(t)] &\le F_X^c(t) + \sum_{k=0}^{l-1} (k\delta+\delta) Pr\left\{k\delta \le Z(t)<k\delta+\delta\right\}\\
& \le F_X^c(t) + \sum_{k=0}^{l-1} (k\delta+\delta)[m(t-k\delta)-m(t-k\delta-\delta)]F_X^c(k\delta+\delta)
\end{aligned}
{% endmath %}
同理，做Riemann sum，可以得到
{% math %}
E[Z(t)] = F^c_X(x) + \int_0^t(t-\tau)F^c_X(t-\tau)dm(\tau)
{% endmath %}

#### 看看 {% math %}\infty{% endmath %} 如何
对上面求得的概率分布求极限，可得：
{% math %}
\lim_{t\to\infty}Pr\left\{Z(t)<z\right\} = \dfrac{1}{\bar{X} } \int_0^zF^c_X(\tau)d\tau\\
\Rightarrow \lim_{t\to\infty}f_{Z(t)}(z) = \dfrac{1}{\bar{X} } f_X(z)
{% endmath %}
对于极限，还有Key renewal theorem：
{% math %}
\lim_{t\to\infty}\int_{\tau=0}^t r(t-\tau)dm(\tau) = \dfrac{1}{\bar{X} }\int_0^\infty r(x)dx
{% endmath %}
其中{% math %}r(x){% endmath %} 为directly Riemann integrable function.对于 {% math %}\lim_{b\to\infty}\int_0^bf(x)dx = \int_0^\infty f(x)dx{% endmath %}
两种求无线积分的方式，第一种称为Riemann integrable，第二种称为directly Riemann integrable。两种积分似乎有细微的差别，有些情况下directly Riemann integrable无法成立。反正我不知道=。=

利用key theorem，可得：
{% math %}
\lim_{t\to\infty} F_{Z(t)}(z) = \int_{t-z}^t F^c_X(t-\tau)dm(\tau) = \dfrac{1}{\bar{X} }\int_0^z F_X^c(x)dx
{% endmath %}
若令 {% math %}r(x)=xF_X^c(x){% endmath %} ，则
{% math %}
\lim_{t\to\infty} E[Z(t)] = \lim_{t\to\infty}[F_X^c(t) + \int_0^t(t-\tau)F^c_X(t-\tau)dm(\tau)] = \dfrac{1}{\bar{X} }\int_0^\infty r(x)dx = \dfrac{E[X^2]}{2\bar{X} }
{% endmath %}

# Delay Renewal
我们在描述renewal是，总是默认队列在开始时有一个用户。如果没有用户，就是delay renewal。这只是把整个过程后移了t段时间，整体并没有发生太大改变。所以不进行说明了。
