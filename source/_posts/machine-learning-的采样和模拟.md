title: machine learning 的模拟和采样
tags: [math, PGM]
date: 2016-03-24 11:49:15
categories: ml
---
最开始接触到随机采样是在RBM里面求解的时候，不过都忘完了。最近的课上提到了随机采样，没去上课而那个SB老师又删了部分PPT，只好自己找paper看了，也算复习和补充。本文的算法都来自paper An Introduction to MCMC for Machine Learning。
<!--more-->
# 先看下这货能干啥
以前也看到过一些介绍随机模拟的文章，但是当时我的内心是机器不屑的，我可是学ml的，你们那些模拟XXX的，都一边去！后来发现还是too naive= =
在machine learning中，MCMC主要用于解决高维空间中的积分和优化问题。下面说一些简单的用处。

## 常见的高维积分场景
### bayesian inference and learning
当存在一些未知的 {% math %}x\in\mathcal{X}, y\in\mathcal{Y}{% endmath %} ，积分就比较困难。关键是贝爷的东西基本都是要积分的，所以只能用模拟来做积分。贝爷的积分主要有下面几种：
1. normalisation
{% math %}
p(x|y) = \dfrac{p(y|x)p(x)}{\int_\mathcal{X}(y|x')p(x')dx'}
{% endmath %}
2. marginalisation
{% math %}
p(x|y) = \int_\mathcal{Z}p(x,z|y)dz
{% endmath %}
3. expectation
{% math %}
\mathbb{E}_{p(x|y)}(f(x)) = \int_\mathcal{X}f(x)p(x|y)dx
{% endmath %}



### statistical mechanics
计算一个系统中的 partition function，如Boltzmann machine里面的 {% math %}Z=\sum_s\exp\big[-\dfrac{E(s)}{kT}\big]{% endmath %} 。直接积分太困难，所以用模拟。
### optimisation
目标很明确，就是从可行解中找到最优解。在计算代价太高的情况下可以用一些模拟的方法
### penalised likelihood model selection
模型选择的方法。通常被分为2步，首先找到每个模型的最大似然，然后找到惩罚项(如MDL，AIC等等)选择模型。但是问题在于潜在的model太多，大部分都不是我们想要的。

## Monte Carlo principle
好了，说完场景，那么高维积分这东西怎么搞呐？搞定这东西主要是靠Monte Carlo simulation 。而这个simulation就是我们要去采样的主要原因。不多说废话，先来看看 Monte Carlo simulation 到底是啥。

首先我们拿到了某个分布产生的数据 {% math %}\left\{x^{(i)}\right\}_{i=1}^N{% endmath %} ，现在我们想计算 {% math %}p(x){% endmath %} 。那么很简单的思路就是拿这批数据过来直接算下有多少个点在 {% math %}x{% endmath %} 上么。抽象的表达就是：
{% math %}
p_N(x) = \dfrac{1}{N}\sum_{i=1}^N \delta_{x^{(i)} }(x)
{% endmath %}
其中 {% math %}\delta_{x^{(i)} }(x){% endmath %} 叫做delta-Dirac mass。有兴趣的可以自行[Wikipedia](https://en.wikipedia.org/wiki/Dirac_delta_function) 反正上面的式子就是这个意思。那我们可以算出来概率，积分什么的不就轻轻松松了么！

对于积分 {% math %}I(f) = \inf_\mathcal{X}f(x)p(x)dx{% endmath %} 来说，我们可以用 {% math %}I_N(f) = \dfrac{1}{N}\sum_{i=1}^Nf(x^{(i)}){% endmath %} 来模拟。SLLN保证了当 {% math %}N{% endmath %} 趋向于无穷大时，它一定会收敛到积分。如果方差 {% math %}\sigma_f^2 = \mathbb{E}_{p(x)}(f^2(x))-I^2(f) < \infty{% endmath %} ，收敛速度服从高斯分布。这一块感兴趣的可以去看[大数定律](http://modkzs.github.io/2016/02/28/%E6%BC%AB%E8%B0%88%E5%A4%A7%E6%95%B0%E5%AE%9A%E5%BE%8B/)

对于前面说的优化问题，这种方法也是可以求解的：
{% math %}
\hat{x} = {\arg\max}_{x^{(i)};i=1,2,...,N} p(x^{(i)})
{% endmath %}

当然了，结果和真实结果之间当然是有误差的。理想不减肥，我有什么办法！找到解法之后，问题就简化为采样问题了。这就引出了我们今天的话题：已知分布，如何采样？

# 常见的采样
## rejection sampling
假设我们要从分布 {% math %}p(x){% endmath %} 采样，但是 {% math %}p(x){% endmath %} 很难直接采样。我们找到一个易于采样的分布 {% math %}q(x){% endmath %} 满足 {% math %}p(x)\le Mq(x),\ M<\infty{% endmath %} 。在此基础上我们进行下面的accept/reject procedure：
![](http://ww2.sinaimg.cn/large/9dec4451jw1f280o9fg1xj20no07yq3l.jpg)
下图直观的描述了一次 accept/reject ：
![](http://ww2.sinaimg.cn/large/9dec4451jw1f280pcz96zj20oc0bi0tn.jpg)
方法很简单，但是随之而来的缺陷也很明显。首先是在整个样本空间上很难找到一个有效的 {% math %}M{% endmath %} ；就算找到了，如果 {% math %}M{% endmath %} 太大，那么acceptance的概率 {% math %}Pr\left\{x\text{ accepted}\right\} = Pr\left\{u < \dfrac{p(x)}{Mq(x)}\right\} = \dfrac{1}{M}{% endmath %} 就很小，在高维空间下就更小了，所以高维空间的话这货就很难吃得动。
## importance sampling
和前面一样，我们还是引入一个实际进行采样的分布 {% math %}q(x){% endmath %} 。我们可以将前面的积分改写成：
{% math %}
I(f) = \int f(x)w(x)q(x)dx
{% endmath %}
其中 {% math %}w(x)= \frac{p(x)}{q(x)}{% endmath %} ，被称为importance weight。所以如果我们可以通过 {% math %}q(x){% endmath %} 采样出 {% math %}\left\{x^{(i)}\right\}_{i=1}^N{% endmath %} 并且得到 {% math %}w(x^{(i)}){% endmath %} ，就可以计算 {% math %}I(f){% endmath %} 了：
{% math %}
\hat{I}_N(f) = \sum_{i=1}^N f(x^{(i)})w(x^{(i)})
{% endmath %}
换个角度，也可以这么理解：我们可以通过 importance weight 去计算 {% math %}\hat{p}_N(x) = \sum_{i=1}^N w(x^{(i)})\delta_{x^{(i)} }(x){% endmath %} ，{% math %}f(x){% endmath %} 对 {% math %}\hat{p}_N(x){% endmath %} 积分。

在importance sampling中，有一些选择 {% math %}q(x){% endmath %} 的标准。很容易发现，我们选择的 {% math %}q(x){% endmath %} 应使得 {% math %}\hat{I}_N(f){% endmath %} 的方差尽可能小。 我们可以计算出 {% math %}f(x)w(x){% endmath %} 相对于 {% math %}q(x){% endmath %} 的方差：
{% math %}
\text{var}_{q(x)}(f(x)w(x)) = \mathbb{E}_{q(x)}(f^2(x)w^2(x)) - I^2(f)
{% endmath %}
第二项不会随 {% math %}q(x){% endmath %} 的改变而改变。所以我们只需要考虑第一项的变化。由 Jensen不等式，可得：
{% math %}
\mathbb{E}_{q(x)}(f^2(x)w^2(x)) \ge (\mathbb{E}_{q(x)}(|f(x)|w(x)))^2 = (\int|f(x)|p(x)dx)^2
{% endmath %}
当 {% math %}q^* (x) = \dfrac{|f(x)|p(x)}{\int |f(x)|p(x)dx}{% endmath %} 时，等号成立。可惜这个结果一点用都没有(￣▽￣") 本来 {% math %}p(x){% endmath %} 就不好采样，现在你在 {% math %}q(x){% endmath %} 里面插个 {% math %}p(x){% endmath %} ，要 {% math %}q(x){% endmath %} 有毛线用啊！

嘛，话也不能这么说(虽然是实话)。这个结果暗示了 importance sampling 是非常高效(super-efficient)的，只要我们找到了 {% math %}q(x){% endmath %} ，而且通过 Monte Carlo method 找到这种 {% math %}q(x){% endmath %} 是有可能的。当然了，在某些特殊情况下，我们只关注概率分布的某一部分(比如长尾效应的采样)时，用这种方法进行建模就很好。
### 高维问题
高维永远都是问题=。=这里的问题和上面的acceptance sampling一样，进入高维的世界之后，很难找到合适的 {% math %}q(x){% endmath %} 。不过这里发展出了Adaptive importance sampling 用于高维的采样。改进后方法的核心是计算下面的导数：
{% math %}
D(\theta) = \mathbb{E}_{q(x,\theta)}(f^2(x)w(x,\theta)\dfrac{\partial w(x, \theta)}{\partial \theta})
{% endmath %}
然后用下面的规则更新 {% math %}\theta{% endmath %}
{% math %}
\theta_{t+1} = \theta_t - \alpha\dfrac{1}{N}\sum_{i=1}^Nf^2(x^{(i)})w(x^{(i)},\theta_t)\dfrac{\partial w(x^{(i)}, \theta_t)}{\partial \theta_t}
{% endmath %}
其中 {% math %}\alpha{% endmath %} 为学习率， {% math %}x^{(i)}\sim q(x, \theta){% endmath %} 。当然你用牛顿法什么的去解也是可以的。

但是这样求出来的 {% math %}p(x) = w(x)q(x){% endmath %} 是没有做normalising的，也就是说对x积分可能不为1。因此重写 {% math %}I(f){% endmath %} ：
{% math %}
I(f) = \dfrac{\int f(x)w(x)q(x)dx}{\int w(x)q(x)dx}
{% endmath %}

对应到采样之后的计算，即为：
{% math %}
\tilde{I}_N(f) = \dfrac{\frac{1}{N}\sum_{i=1}^N f(x^{(i)})w(x^{(i)})}{\frac{1}{N}\sum_{i=1}^N w(x^{(i)})} = \sum_{i=1}^N f(x^{(i)})\tilde{w}(x^{(i)})
{% endmath %}
我们可以将 {% math %}\tilde{w}{% endmath %} 称为 normalised importance weight 。某些paper证明在平方损失下会有 {% math %}\tilde{I}_N(f){% endmath %} 效果好于 {% math %}\hat{I}_N(f){% endmath %}

如果需要得到 {% math %}M{% endmath %} 个 IID 的样本，可以考虑sampling importance resampling(SIR)。

你应该也能感受到，这种用概率分布区模拟采样的办法总是无法得到很好的效果(要不然优化来优化去优化个毛线啊！(╯‵□′)╯︵┻━┻)，所以我们才会在importance sampling当中费尽心机去取得较好的效果。因此下面我们介绍杀手级的随机采样方法——MCMC
# MCMC
MCMC是Markov chain Monte Carlo的缩写。所以 markov chain自然是基础。对于[markov chain](http://modkzs.github.io/2016/03/02/finite-state-markov-chain/) 和 [markov process](http://modkzs.github.io/2016/03/14/markov-process/)，我都有过介绍，有兴趣出门右转，这里不详细说明。这里只说下需要用到的性质，不做证明。
## markov chain的简单介绍
markov chain的核心就是
{% math %}
p(x^{(i)}|x^{(i-1)}, x^{(i-2)},...,x^{(1)}) = p(x^{(i)}|x^{(i-1)})
{% endmath %}
在这里会延伸出2种情况： {% math %}p(x^{(i)}|x^{(i-1)}) = p(x^{(1)}|x^{(0)}) = T(x^{(i)}|x^{(i-1)}){% endmath %} ，这被称为 homogeneous 。

markov chain的收敛需要满足两个条件：
- Irreducibility 任何 state 访问其他 state 的概率都大于0
- Aperiodicity 每个 state 的访问周期为1。

detailed balance，即 {% math %}p(x^{(i)})T(x^{(i-1)}|x^{(i)}) = p(x^{(i-1)})T(x^{(i)}|x^{(i-1)}){% endmath %}， 也可以推导出markov chain的收敛，但是只是必要非充分条件。

在MCMC算法当中，我们利用上面3个条件，就可以构造出满足要求的markov chain(即最后收敛的概率和我们所要采样的概率相同)。但是我们需要更快的收敛速度。从markov chain的条件我们知道，它的所有特征根均小于等于1。所以其收敛速度取决于最大的小于1的特征根。

除了用特征根求解之外，还可以用 {% math %}\sum_{x^{(i+1)} }p(x^{(i)})T(x^{(i+1)}|x^{(i)}) = p(x^{(i+1)}){% endmath %} 。在MCMC中，我们将上面的形式稍加改进，使用下面的方法：
{% math %}
\int p(x^{(i)})K(x^{(i+1)}|x^{(i)})dx^{(i)} = p(x^{(i+1)})
{% endmath %}

下面我们介绍以该思路为核心构建的一系列采样算法
##  Metropolis-Hastings algorithm
Metropolis-Hasting(简写为MH)是目前最流行的MCMC算法。大部分实际使用的MCMC算法都可以被推导出是该算法的特殊情况或者扩展。

MH算法需要 proposal 分布 {% math %}q(x^* | x){% endmath %} 。每次根据当前的 {% math %}x{% endmath %} ，利用 {% math %}q(x^* | x){% endmath %} 采样出 {% math %}x^* {}{% endmath %} ，然后按照 acceptance 概率进行移动。
{% math %}
A(x, x^* ) = \min\left\{1, \frac{p(x^*)q(x|x^*)}{p(x)q(x^* |x)}\right\}
{% endmath %}
整个算法的思路可以表示为下面的伪代码：
![](http://ww3.sinaimg.cn/large/9dec4451jw1f28wy9nru9j20gs0b6q3k.jpg)
### {% math %}\mathcal{A}{% endmath %} 到底是怎么来的？
paper里面直接给出了公式，但是没有给出来历。

我们还是从上面的detailed balance出发。将 {% math %}q(x^{(i)}|x^{(j)}){% endmath %} 即为从state {% math %}x^{(i)}{% endmath %} 转移到 state {% math %}x^{(j)}{% endmath %} 的概率，那么一般情况下来说，detailed balance必然是不成立的(不废话么，成立还有什么好说的)。所以我们改造一下，引入 {% math %}\alpha(x^{(i)},x^{(j)}){% endmath %} ，使得：
{% math %}
p(x^{(i)})q(x^{(j)}|x^{(i)})\alpha(x^{(j)}|x^{(i)}) = p(x^{(j)})q(x^{(i)}|x^{(j)})\alpha(x^{(i)}|x^{(j)})
{% endmath %}
然后的任务就是解出 {% math %}\alpha(x^{(j)}|x^{(i)}){% endmath %} 了。最SB的解法就是：
{% math %}
\alpha(x^{(j)}|x^{(i)}) = p(x^{(j)})q(x^{(i)}|x^{(j)})
{% endmath %}
这样我们就有了一个最简单的保证收敛的markov chain。我们只要把上面伪代码里面的 {% math %}\mathcal{A}(x^{(i)}, x^* ){% endmath %} 换成 {% math %}\alpha (x^* |x^{(i)}){% endmath %} 。

但是这样就带来了一个问题：要是 {% math %}\alpha (x^* |x^{(i)}){% endmath %} 太小，那不就又跟 rejection sampling一样了么，还是没法用啊。观察detailed balance ，可以发现如果用 {% math %}\hat{\alpha} (x^* |x^{(i)}) = k{\alpha} (x^* |x^{(i)}){% endmath %} ，原等式成立，也就是说原等式对数乘不敏感。所以我们就可以做缩放了٩(๑ᵒ̷͈᷄ᗨᵒ̷͈᷅)و 当然你缩放出来的结果大于1和1没啥区别啊，所以取个 {% math %}\min{% endmath %} 做截断。这样就跑出来了那个 {% math %}\mathcal{A}{% endmath %} 。至于分母，可能是拍脑袋？嘛，反正就是这样了Σ(⊙▽⊙"...



paper中还给出了实验的效果，感觉还挺不错的。我们令 {% math %}q(x^* | x)=\mathcal{N}(x^{(i)}, 100),p(x)\propto 0.3\exp(-0.2x^2)+0.7\exp(-0.2(x-10)^2){% endmath %} ，采样的效果如下图所示：
![](http://ww2.sinaimg.cn/large/9dec4451jw1f28x00th2ej20qk0l476v.jpg)
方法很简单，但是 {% math %}q(x^* |x){% endmath %} 的构造比较麻烦。很多 MCMC的改进都是在这一块进行的。 MH的transition kernel 为
{% math %}
K_{MH}(x^{(i+1)}|x^{(i)}) = q(x^{(i+1)}|x^{(i)})\mathcal{A}(x^{(i)}, x^{(i+1)}) + \delta_{x^{(i)}}(x^{(i+1)})r(x^{(i)})\\
r(x^{(i)}) = \int_\mathcal{X}q(x^* | x^{(i)})(1-\mathcal{A}(x^{(i)}, x^* ))dx^*
{% endmath %}
你可以把这个式子带到 {% math %}p(x^{(i)})K_{MH}(x^{(i+1)}|x^{(i)}) = p(x^{(i+1)})K_{MH}(x^{(i)}|x^{(i+1)}){% endmath %} 里面验证一下，两个式子是相等的。

按照上面的式子进行采样，最后我们得到的就是上面的采样算法(上式的左边理解为选择 {% math %}q(x^* |x){% endmath %} 采样的概率，右边是不接受其采样，保持原有位置的概率)。

对于这个算法，我们还剩下一项工作：证明在这种 transition kernel 下面有markov chain收敛。首先由于 rejection 的存在，因此整个系统必然是 aperiodic 的。其次是 irreducibility，感觉比较明显，但是并没有办法给出严谨的证明。原paper中也没有给出证明，不过提到了一些可以用来证明的东西：minorisation condition、Foster-Lyapunov drift condition(反正我都没听过= =)

前面说过的importance sampling也可以看做MH(也不是完全一样)。我们令
{% math %}
q(x^* |x^{(i)}) = q(x^* )\\
\mathcal{A}(x^{(i)}, x^* ) = \min\left\{1, \dfrac{p(x^*)q(x^{(i)})}{p(x^{(i)})q(x^*)}\right\} = \min \left\{1, \dfrac{w(x^* )}{w(x^{(i)})}\right\}
{% endmath %}
当然了，里面是有一个比值的，所以其实不是完全一样。

### 最后说一点
在MH算法当中，有3点需要注意：首先，对于目标分布的normalising并不是必须的要求。这一点很容易看到，在 {% math %}\mathcal{A}{% endmath %} 中其实只是求了一个比例而已；其二，我们前面的算法描述中只描述单个markov process，实际过程中可以多个并行，加速采样；最后就是 {% math %}q(x^* |x){% endmath %} 的选择至关重要。下图描述的仍然是我们上面说的那个例子，但是高斯的方差不同，我们可以看到最后的效果大相径庭
![](http://ww3.sinaimg.cn/large/9dec4451jw1f29d9b3qw5j20qc0o8gne.jpg)

## Simulated annealing for global optimization
就像我们一开始说的，模拟采样除了用来模拟积分之外，还可以用来处理极值的情况。但是对于这种任务，很显然如果用上面的采样，我们会花费大量的时间在一些无用点的计算上。所以 simulated annealing(似乎是模拟退火？) 我们在上面用的 markov chain 都是 homogeneous 的，simulated annealing使用的是 non-homogeneous 。其概率分布为：
{% math %}
p_i(x) \propto p^{1/T_i}(x)
{% endmath %}
其中 {% math %}T_i{% endmath %} 是随 {% math %}i{% endmath %} 递减的变量且 {% math %}\lim_{i\to\infty}T_i = 0{% endmath %} 。在此情况下，我们就有下面的算法：
![](http://ww2.sinaimg.cn/large/9dec4451jw1f2akmisg14j20ig0cswfh.jpg)
我们可以看到在这种情况下，随着迭代次数的增加，初始概率越小的点下降速度越快，这样的情况下最高概率的点收敛速度最慢，最后概率会趋向于1。这一点在下图尤其清楚：
![](http://ww2.sinaimg.cn/large/9dec4451jw1f2aksw8lzsj20qw0l0q53.jpg)
对该算法的研究主要集中于对 {% math %}q(x^* | x){% endmath %} 以及cooling schedule的选择上。paper当中概述了一些其他人的结果，这里不详细说了。
## mixtures and cycles of MCMC kernels
MCMC最重要的特征之一就是其可以组合多个采样过程成为一个混合的采样过程。显而易见，当我们有 transition kernel {% math %}K_1, K_2{% endmath %} 时， {% math %}vK_1 + (1-v)K_2{% endmath %} 仍然是 transition kernel(叫做mixture hybrid kernel) ；我们还可以换着用2个 kernel (叫做cycle hybrid kernel)

mixture 的方法当然不可能只有那一种。我们可以用 global proposal 去遍历状态空间的 regions ，同时用 local proposals 发现一些 finer 的细节。原文中给了大量的例子，然而貌似都不是machine learning 相关的((￣ ‘i ￣;)不知道为何论文标题会有ml)，所以并不理解这到底能干啥。这种 mixture 的算法如下：
![](http://ww4.sinaimg.cn/large/9dec4451jw1f2alvxv3s0j20ki096aan.jpg)

cycle的方法有一点很重要：允许我们对目标矩阵分块，每一块可以单独更新。而如果我们把高相关度的维度分在相同的块中，我们会得到更快的收敛速度。我们将 {% math %}b_j{% endmath %} 记做第 {% math %}j{% endmath %} 个块， {% math %}n_b{% endmath %} 表示总的块数， {% math %}x^{(i+1)}_{-[b_j]} = \{x^{(i+1)}_{-[b_1]}, x^{(i+1)}_{-[b_2]},...,x^{(i+1)}_{-[b_{n_b}]}\}{% endmath %} 。我们将 transition kernel 改造成如下的形式：
{% math %}
K_{\text{MH-Cycle} }(X^{(i+1)}|X^{(i)}) = \prod_{j=1}^{n_b}K_{MH(j)} (x_{b_j}^{(i+1)}| x_{b_j}^{(i)}, x_{-[b_j]}^{(i+1)})
{% endmath %}
其中 {% math %}K_{MH(j)}{% endmath %} 表示第 {% math %}j{% endmath %} 次迭代使用的MH算法，也就是transition kernel 。该算法的伪代码表述如下：
![](http://ww2.sinaimg.cn/large/9dec4451jw1f2am2ax89uj20m20hqdhy.jpg)
在这里，对块大小的选择会有一些trade-off。如果你一次只更新一个维度的数据，那么你得花很长时间才能收敛，尤其是有很多维度相互之间高度相关的时候；如果你一次更新全部维度，那么 acceptance 概率又不高，还是得花很长时间。

这种类型的算法当中最有名的莫过于下面的Gibbs sampler了，保证 acceptance 概率为1的强悍算法。
## Gibbs sampler
我们假设给定一个 {% math %}n{% endmath %} 维向量 {% math %}x{% endmath %} 并且已知 {% math %}p(x_j | x_1,...,x_{j-1},x_{j+1},...,x_n){% endmath %} 。如果我们令 proposal distribution 为：
{% math %}
q(x^* | x^{(i)}) =
\begin{cases}
  p(x_j^* | x^{(i)}_{-j})& \text{If } x_{-j}^* = x^{(i)}_{-j}\\
  0 & \text{Otherwise}
\end{cases}
{% endmath %}
在此情况下，我们的 acceptance 概率就变成了
{% math %}
\begin{aligned}
\mathcal{A}(x^{(i)},x^* ) &= \min\left\{1, \dfrac{p(x^* )q(x^{(i)}|x^* )}{p(x^{(i)})p(x^* |x^{(i)} )}\right\}\\
&= \min\left\{1, \dfrac{p(x^* )q(x^{(i)}|x^{(i)}_{-j} )}{p(x^{(i)})p(x^* |x^{* }_{-j} )}\right\}\\
&= \min\left\{1, \dfrac{p(x^* )}{p(x^* |x^{* }_{-j} )}\dfrac{q(x^{(i)}|x^{(i)}_{-j} )}{p(x^{(i)})}\right\}\\
&= \min\left\{\dfrac{q(x^{* }_{-j} )}{q(x^{(i)}_{-j})}\right\} = 1
\end{aligned}
{% endmath %}
没有看错，就TM是1！！！所以Gibbs sampler的伪代码如下：
![](http://ww2.sinaimg.cn/large/9dec4451jw1f2b6deijlhj20ju0c0ab0.jpg)

### 补充一下来历
关于如此狂拽炫酷吊炸天的 proposal 分布，我们当然要看看是怎么来的了！首先从一个基础的概率公式开始：
{% math %}
p(x_1, y_1) p(y_2|x_1) = p(y_1|x_1)p(x_1)p(y_2|x_1)\\
p(x_1, y_2) p(y_1|x_1) = p(y_2|x_1)p(x_1)p(y_1|x_1)\\
\Rightarrow p(x_1, y_1) p(y_2|x_1) = p(x_1, y_2) p(y_1|x_1)
{% endmath %}
如果将 {% math %}p(x,y){% endmath %} 表示为在坐标点 {% math %}(x,y){% endmath %} 的概率，将 {% math %}p(y|x){% endmath %} 作为 transition 概率，则平行于坐标轴的转化 acceptance 的概率都为1=。=这也就是下面这个大名鼎鼎的图的来历:
![](http://ww2.sinaimg.cn/large/9dec4451jw1f2b6p1xh6hj20gk0e074q.jpg)

这是二维的情况，如果扩展到多维，就是上面的算法，而且我们也证明了多维情况下 acceptance 的概率确实为1

## Monte Carlo EM
EM算法可以用于处理隐藏变量存在的最大化问题。假设 {% math %}\mathcal{X}{% endmath %} 包含一些隐藏以及可见状态 {% math %}x=\{x_v,x_h\}{% endmath %} ，我们需要最大化 {% math %}p(x_v|\theta){% endmath %} ，不过 {% math %}\theta{% endmath %} 为隐藏变量。通过不断迭代下面两步计算：
1. E step 计算 {% math %}Q(\theta^{(i)}) = \int_{\mathcal{X}_h} \log(p(x_h, x_v | \theta^{(i)}))p(x_h|x_v, \theta^{(i)}) dx_h{% endmath %}
2. M step 计算 {% math %}\theta^{(i+1)} = \arg\max_{\theta^{(i)}}Q(\theta^{(i)}){% endmath %}

这当然不可能是MCMC了。MCMC主要用于计算 E step a中的积分问题。所以 Monte Carlo EM 算法的伪代码如下(其实就是EM之前套个MH)：
![](http://ww4.sinaimg.cn/large/9dec4451jw1f2b78r64wsj20ng0gsgnl.jpg)

## auxiliary variable samplers
据说从 {% math %}p(x,u){% endmath %} 采样会比 {% math %}p(x){% endmath %} 采样简单(反正人家就是这么讲的，为什么嘛我也不知道) 。这样的话我们采出了 {% math %}(x^{(i)}, u^{(i)}){% endmath %} 之后抹掉 {% math %}u^{(i)}{% endmath %} 就好了。貌似这种方法在物理里面很常用(丝毫不明白这和ml有什么关系)。在这种思路下，有2个非常著名的算法：hybrid Monte Carlo 、 slice sampling.
### hybrid Monte Carlo
这过程没啥好说的，直接上伪代码就行了：
![](http://ww1.sinaimg.cn/large/9dec4451jw1f2b7rlyw2vj20k80gmabd.jpg)
其中 {% math %}\Delta(x_0){% endmath %} 就是 {% math %}\log p(x){% endmath %} 的导数，用的extended target distribution为：
{% math %}
p(x,u) = p(x)\mathcal{N}(u;0,I_{n_x})
{% endmath %}
如果让 {% math %}L=1{% endmath %} 这就是 Langevin 算法(虽然我也不知道这TM是啥)

最后说一下 {% math %}L, \rho{% endmath %} 的选择问题。 {% math %}L{% endmath %} 很大的话，我们一次可以产生大量的候选集，但是计算量也很大； {% math %}\rho{% endmath %} 很大会降低 acceptance 的概率，但是很小的话导致在两个 state 之间的移动会需要很多 leapfrog step(就是伪代码里面像sgd的那一段(￣▽￣")不明白歪果仁的起名字的想法)
### slice sampling
Gibbs sampler 的泛化版本(我觉得并不是泛化啊=。=)。首先说一下他的extended target distribution：
{% math %}
p^* (x,u)=
\begin{cases}
1 &\text{if } 0\le u\le p(x)
0 &\text{otherwise}
\end{cases}
{% endmath %}

然后采样过程是这样的：
{% math %}
p(u|x) = \mathcal{U}_{[0,p(x)]}(u)\\
p(x|u) = \mathcal{U}_A(x) \quad A=\{x;p(x)\ge u\}
{% endmath %}
如果我们可以计算 {% math %}A(x){% endmath %} ，那就没啥好说的了。不过 {% math %}A(x){% endmath %} 似乎很难定义。例如当 {% math %}p(x) \propto \prod_{l=1}^L f_l(x){% endmath %} 的时候，我们得积分才能算出来 {% math %}p(x){% endmath %} = =

这时候引入extended target distribution(当然只是上面的例子而已)：
{% math %}p^* (x,u_1,...,u_L)\propto\prod_{l=1}^L\mathbb{I}_{[0,f_l(x)]}(u_l){% endmath %}
可以积分去check一下：
{% math %}
\int p^* (x,u_1,...,u_L)du_1...du_L \propto \int \prod_{l=1}^L\mathbb{I}_{[0,f_l(x)]}(u_l)du_1...du_L = \prod_{l=1}^L f_l(x)
{% endmath %}

所以我们就可以用下面的伪代码求解：
![](http://ww1.sinaimg.cn/large/9dec4451jw1f2b8748q4dj20lu0660t3.jpg)

## Reversible jump MCMC
原paper最后提到了Reversible jump MCMC，该方法可用于model selection，也就是参数选择。但是说的不是很清楚(主要是我没看懂(￣▽￣"))感觉实际过程中可能也没有太大的用处。以后有时间在找原peper看看好了。
