title: countable-state markov chain
tags: [stochastic process]
date: 2016-03-12 15:12:42
categories: math
---
对于为什么叫 countable-state，我一直不理解。。。。明明state是infinite的=。=不过一旦在infinite的情况下，很多东西就要改变了。
<!--more-->
# 还是从state说起
在markov chain中，我们对每个state都分成了2类：recurrent和transient，并且证明了如果markov chain为ergodic，必然会收敛。这个简单的东西放在这里就不简单了。
还是以掷硬币为例，正面的1分，反面扣1分。这个过程用markov chain描绘的话如下：
![](http://ww2.sinaimg.cn/large/9dec4451gw1f1v0e2rq8hj20xi038q3m.jpg)
我们可以直观的看到，当 {% math %}p\neq1-p{% endmath %} 时，整个链条要不向左，要不向右无限扩展。但是这个markov chain的period为2，我们做个截断，让他变成1：
![](http://ww3.sinaimg.cn/large/9dec4451gw1f1v0f959pcj20m602ggm1.jpg)
但是如果 {% math %}p>\dfrac{1}{2}{% endmath %} 的话，整个链条仍然会无限扩展，依然没有稳定状态。而 {% math %}p=\dfrac{1}{2}{% endmath %} 时，停留在每个state的概率都趋向于0。这是一个很特殊的状态，被称为 null-recurrent。

为了对countable-state markov chain的state进行定义，我们引入以前提过的first-passage-time probability的概念，其定义为 {% math %}f_{ij}(n)=Pr\left\{X_n=j,X_{n-1}\neq j,X_{n-2}\neq j...X_1\neq j | X_0 = i\right\}{% endmath %} 。当然了 {% math %}i=j{% endmath %} 是允许的。

在first-passage-time的基础上，引入 {% math %}F_{ij}(n) = \sum_{m=1}^n f_{ij}(m){% endmath %}

我们可以定义 rv {% math %}T_{ij}{% endmath %} 为从state i出发，第一次到达state j。 则 {% math %}f_{ij}{% endmath %} 可以视为 {% math %}T_{ij}{% endmath %} 的PMF，而 {% math %}F_{ij}{% endmath %} 可以视为 {% math %}T_{ij}{% endmath %} 的分布函数。

在此基础上，我们可以对state进行定义：state j is recurrent if {% math %}F_{jj}(\infty) = 1{% endmath %} ；is transient if {% math %}F_{jj}(\infty) < 1{% endmath %}

根据 {% math %}F_{ij}(n){% endmath %} 的定义，可知
{% math %}
F_{ij}(n) = P_{ij} + \sum_{k\neq j}P_{ik}F_{kj}(n-1)
{% endmath %}

当 {% math %}n\to\infty{% endmath %} 时，等式依然成立，因此我们联立多个方程就可以求解。当然，理论上来说，无论如何 {% math %}F_{ij}(n)=1{% endmath %} 都是可行解。但是当state为transient时，还存在一组“非1解”(+ _ +) 。

我们令 {% math %}N_{jj}(t){% endmath %} 表示从state j出发，在t时间内到达 state j的次数。则下面四个描述是等价的：
- state j is recurrent
- {% math %}\lim_{t\to\infty} N_{jj}(t) = \infty{% endmath %} WP1
- {% math %}\lim_{t\to\infty} E[N_{jj}(t)] = \infty{% endmath %}
- {% math %}\lim_{t\to\infty} \sum_{1\le n\le t} P_{jj}^n = \infty{% endmath %}

有了上面的结论，很容易证明当state i和j互相可达，state j为recurrent时，state i也是recurrent ({% math %}\sum_{n=1}^\infty P_{ii}^n \ge \sum_{n=1}^\infty P_{ii}^{m+n+k}\ge P_{ik}^mP_{kj}^k\sum_{n=1}^\infty P_{kk}^n{% endmath %})。
所以对于 countable-state markov chain 来说，一个class中所有的state都是transient或者recurrent的。

对于同处于一个recurrent class的state i和j来说， {% math %}F_{ij}(\infty) = 1{% endmath %} 。

证明：令 {% math %}\alpha{% endmath %} 表示从 i到j的概率。则从state i 出发第一次回到state i 而不经过state j的概率必不大于 {% math %}1-\alpha{% endmath %} ；第二次必不大于 {% math %}(1-\alpha)^2{% endmath %} ... 第n次 必不大于 {% math %}(1-\alpha)^n{% endmath %} 。当 {% math %}n\to\infty{% endmath %} 时，必有 {% math %}F_{ij}(\infty) = 1{% endmath %}

对于处于同一个recurrent class的state i和j，若 {% math %}i\neq j{% endmath %} ，则 {% math %}N_{ij}(t){% endmath %} 为delay renewal process。我们令 {% math %}\bar{T}_{ij}{% endmath %} 表示state i到j的first-passage time的期望。则 {% math %}\bar{T}_{ij} = 1 + \sum_{i=1}^\infty (1-F_{ij}(n)){% endmath %} 。直观上看，如果 {% math %}F_{ij}(\infty)=1{% endmath %} ，{% math %}\bar{T}_{ij}{% endmath %} 必然为finite。但是在讨论birth-death markov chain时，我们会发现存在 {% math %}F_{ij}(\infty)=1{% endmath %} 而 {% math %}\bar{T}_{ij} = \infty{% endmath %} 的情况。因此recurrent state有必要进行分类。

我们将 {% math %}F_{jj}(\infty)=1, \bar{T}_{jj} < \infty{% endmath %} 的state j称为 positive-recurrent；{% math %}F_{jj}(\infty)=1, \bar{T}_{jj} = \infty{% endmath %} 的state j称为 null-recurrent。

我们可以看到 {% math %}T_{jj}{% endmath %} 是IID rv，所以 {% math %}N_{jj}(T){% endmath %} 可以视为renewal process。根据renewal process的性质，可知：
{% math %}
\lim_{t\to\infty} \dfrac{N_{jj}(t)}{t} = \dfrac{1}{\bar{T}_{jj}}\\
\lim_{t\to\infty} E\Big[\dfrac{N_{jj}(t)}{t}\Big] = \dfrac{1}{\bar{T}_{jj}}
{% endmath %}

根据Blackwell’s theorem，有
{% math %}
\lim_{n\to\infty} Pr\left\{X_{n\lambda} = j | X_0 = j\right\} = \dfrac{\lambda}{\bar{T}_{jj}}
{% endmath %}
而在markov chain中， {% math %}\lambda{% endmath %} 就是period。

上面的结论对于 {% math %}N_{ij}{% endmath %} 同样成立

在markov chain中，同一个class中所有的state都是一样的，即都是positive-recurrent,null-recurrent或者transient。前面我能已经证明了recurrent和transient的情况，因此这里我们只需要证明positive-recurrent和null-recurrent。

首先证明positive-recurrent的情况。令 {% math %}R(t) =1{% endmath %} 当t时刻在state i。根据renewal-reward process，有
{% math %}
\dfrac{1}{\bar{T}_{ii}} = \lim_{t\to\infty}\dfrac{1}{t}\int^t_0R(\tau)d\tau = \dfrac{E[R_n]}{\bar {T}_{jj}}
{% endmath %}
第一个等号成立是因为我们可以将 {% math %}\lim_{t\to\infty}\dfrac{1}{t}\int^t_0R(\tau)d\tau{% endmath %} 视为停留在state i的时间占总时间的比值，而我们在前面计算出了这个比值。显而易见，当state j为positive-recurrent时，{% math %}T_{jj} < \infty{% endmath %}，故 {% math %}T_{ii} < \infty{% endmath %} 。反之也成立。

对于停留时间的比例这种东西，敏感的人可能会将它和 {% math %}\pi_j{% endmath %} 对应。对于 irreducible的markov chain来说，确实如此。irreducible markov chain就是所有的state都在同一个recurrent class里面。

证明：令 {% math %}\pi_j{% endmath %} 为markov chain的初始概率分布，{% math %}\tilde{N}(t){% endmath %} 为在时间1到t之间出现在state j的次数。则
{% math %}
(1/t)E[\tilde{N}(t)] = (1/t)\sum_{1\le n\le t} Pr\left\{X_n=j\right\} = \pi_j\\
\pi_j = (1/t)E[\tilde{N}_j(t)] = \sum_i \pi_iE[N_{ij}(t)]\ge \sum_{i\le M} \pi_iE[N_{ij}(t)]\\
E[N_{ij}(t)] \le E[N_{ij}(T_{ij}+t)] = 1+E[N_{jj}]\\
\Rightarrow \pi_j \le 1/t + E[N_{jj}(t)/t]\\
\Rightarrow \lim_{t\to\infty}\pi_j = \pi_j \le \lim_{t\to\infty} (1/t + E[N_{jj}(t)/t])=1/\bar{T}_{jj}\\
\lim_{t\to\infty}\pi_j = \pi_j \ge \lim_{t\to\infty}\sum_{i\le M} \pi_iE[N_{ij}(t)] = \sum_{i\le M} \pi_i/T_{jj} \ge 1/T_{jj}\\
\Rightarrow \pi_j = 1/T_{jj}
{% endmath %}

## Age of renewal process
我们用下图的markov chain 描绘renewal的interval
![](http://ww3.sinaimg.cn/large/9dec4451gw1f1v8md6pfrj20w805ejsd.jpg)
其中 {% math %}P_{n,n+1} = Pr\left\{W>n+1\right\}/Pr\left\{W>n\right\}{% endmath %} ，{% math %}Pr\left\{W>n\right\}{% endmath %} 表示interval大于n个时间单元， {% math %}Pr\left\{W>0\right\} =1{% endmath %}

故
{% math %}
\begin{aligned}
\pi_n &= \pi_{n-1}P_{n-1, n} = \pi_{n-2}P_{n-2,n-1}P_{n-1, n}= \pi_0P_{0,1}...P_{n-1, n}\\
&= \pi_0\dfrac{Pr\left\{W>1\right\}Pr\left\{W>2\right\}...Pr\left\{W>n\right\}}{Pr\left\{W>0\right\}Pr\left\{W>1\right\}...Pr\left\{W>n-1\right\}} = \pi_0Pr\left\{W>n\right\}
\end{aligned}
{% endmath %}

故
{% math %}
\pi_0 = \dfrac{1}{\sum_{n=0}^\infty Pr\left\{W>n\right\}} = \dfrac{1}{E[W]}\\
\pi_n = \dfrac{Pr\left\{W>n\right\}}{E[W]}
{% endmath %}

# birth-death markov chain
birth-death markov chain如下图所示：
![](http://ww2.sinaimg.cn/large/9dec4451gw1f1v9cotwxjj20vw048wfj.jpg)
从state i转移到 state i+1的次数可以表示为 {% math %}\pi_ip_i{% endmath %} ，其中 {% math %}\pi_i{% endmath %} 为系统稳定时在state i的概率。类似的，将state i+1转移到 state i的次数表示为 {% math %}\pi_{i+1}q_i{% endmath %} 。若系统存在稳定状态，则 {% math %}\pi_ip_i = \pi_{i+1}q_i{% endmath %}

令 {% math %}\rho_i=p_i/q_{i+1}{% endmath %} ，则有 {% math %}\pi_j = \rho_i\pi_i{% endmath %} 。故
{% math %}
\pi_i = \pi_0\prod_{j=0}^{i-1}\rho_i\\
\pi_0 = \dfrac{1}{1+\sum_i^{\infty}\prod_{j=0}^{i-1}\rho_i}
{% endmath %}

# Reversible markov chain
根据markov chain的定义有：
{% math %}
Pr\left\{X_{n+1}|X_n,X_{n-1}...X_0\right\} = Pr\left\{X_{n+1}|X_n\right\}\\
Pr\left\{X_{n+k}, X_{n+k-1}, ...X_{n+1}|X_n,X_{n-1}...X_0\right\} = Pr\left\{X_{n+k}, X_{n+k-1}, ...X_{n+1}|X_n\right\}
{% endmath %}
令 {% math %}A^+{% endmath %} 表示 state {% math %}X_{n+1}{% endmath %} 到 {% math %}X_{n+k}{% endmath %} 的任意事件； {% math %}A^-{% endmath %} 表示 state {% math %}X_{1}{% endmath %} 到 {% math %}X_{n-1}{% endmath %} 的任意事件。则：
{% math %}
Pr\left\{A^+|X_n, A^-\right\} = Pr\left\{A^+|X_n\right\}\\
Pr\left\{A^+, A^-|X_n\right\} = Pr\left\{A^+|X_n\right\}Pr\left\{A^-|X_n\right\}\\
Pr\left\{A^-|X_n, A^+\right\} = Pr\left\{A^+|X_n\right\}\\
\Rightarrow Pr\left\{X_{n-1}|X_n\right\} = \dfrac{Pr\left\{X_n|X_{n-1}\right\}Pr\left\{X_{n-1}\right\}}{Pr\left\{X_n\right\}}
{% endmath %}
很容易发现， {% math %}Pr\left\{X_{n-1}|X_n\right\}{% endmath %} 是随 {% math %}n{% endmath %} 而改变的。因此backward markov chain不一定为homogeneous(即满足 {% math %}Pr\left\{X_{n+1}|X_n\right\}=Pr\left\{X_1|X_0\right\}{% endmath %})。对于steady-state来说， {% math %}Pr\left\{X_{n+1}=j\right\} = Pr\left\{X_n=j\right\} = \pi_j{% endmath %} 。此时，
{% math %}
Pr\left\{X_{n-1} = j|X_n = i\right\} = P_{ji}\pi_j/\pi_i
{% endmath %}
如果我们令 {% math %}P_{ij}^*{% endmath %} 表示backward markov chain的转移概率，则有 {% math %}\pi_i P_{ij}^* = \pi_j P_{ji}{% endmath %} 。而对于steady-state markov chain来说，必有 {% math %}\pi_i P_{ij} = \pi_j P_{ji}{% endmath %} 。故我们可以推出 {% math %}P_{ij}^* = P_{ij}{% endmath %}

对于irreducible markov chain来说，如果对于所有的 {% math %}i,j{% endmath %} 都有 {% math %}\pi_i P_{ij} = \pi_j P_{ji}{% endmath %} 则 {% math %}\pi_i{% endmath %} 就是其steady-state的分布；而它本身则是reversible。
假设irreducible markov chain的转移概率为 {% math %}P_{ij}{% endmath %} ，{% math %}\pi_i{% endmath %} 是和为1的正数集合，{% math %}P_{ij}^*{% endmath %} 是转移概率，如果有
{% math %}
\pi_iP_{ij} = \pi_jP_{ji}^*
{% endmath %}
则 {% math %}\pi_i{% endmath %} 是steady-state分布， {% math %}P_{ij}^* {}{% endmath %} 是backward chain的转移概率。

# M/M/1 queue
现用 markov chain 建模M/M/1 queue。假设 arrival rate为 {% math %}\lambda{% endmath %} ，departure rate 为 {% math %}\mu{% endmath %} 。还是将时间划分多个无穷小的等分，每等分的时间为 {% math %}\delta{% endmath %} 。则M/M/1 queue可以表示为：
![](http://ww2.sinaimg.cn/large/9dec4451gw1f1vcw9zxkdj20u404ajsd.jpg)
这被称为M/M/1 sample-time Markov chain

根据上节的描述，则有：
{% math %}
\rho = \lambda / \mu < 1\\
\pi_i = \pi_0 \rho ^i \\
\Rightarrow \pi_i = (1-\rho) \rho^i
{% endmath %}

而这个chain本身就是birth-death chain。当 {% math %}\rho <1{% endmath %} 时，它是reversible。左移和右移的过程有一些相似点：
1. 都可以被视为 M/M/1 chain
2. 左移的arrival可以被视为右移的departure

由此我们可以总结出：
- departure也是 Bernoulli
- {% math %}n\delta{% endmath %} 时刻的状态 {% math %}X_n{% endmath %} 与之前的departure没有关系。

这被称为Burke’s theorem。Burke’s theorem并不需要 {% math %}\mu{% endmath %} 对于所有的state保持一致，因此对于任何birth-death chain来说，只要arrival和当前的state无关(比如G/G/m queue)，就可以使用。

#Branching process
Branching process是一种特殊的markov chain，其 {% math %}X_{n+1},X_n{% endmath %} 的关系为：
{% math %}
\begin{equation}
\label{eq:branch}
X_{n+1} = \sum_{k=1}^{X_n} Y_{k,n}
\end{equation}
{% endmath %}
其中 {% math %}Y_{k,n}{% endmath %} 为rv ， {% math %}p_j = Pr\left\{Y_{k,n}= j\right\}{% endmath %} ， {% math %}P_{ij} = Pr\left\{X_{n+1}= j|X_{n}= i\right\} = Pr\left\{\sum_{k=1}^iY(k,n) = j\right\}{% endmath %}

看上去很复杂，其实过程很简单。假设有一种生物只能活一年，每年可以自交(ˉ▽ˉ；)产生后代。我们在第一年养一只，然后每年统计种群的个数。在这个问题中，每个个体产生后代的数量就是 {% math %}Y_{k,n}{% endmath %} ，{% math %}k,\ n{% endmath %}分别表示个体的标号以及时间。 而我们最关注的问题就是这个种群会不会灭绝，也就是 {% math %}X_n=0{% endmath %}

在前面我们将 {% math %}F_{ij}(n){% endmath %} 定义为 {% math %}X_0=i{% endmath %} 在n时刻前访问state j的概率。因此我们的问题可以形式化为 {% math %}F_{i0}(n){% endmath %} 。每个个体时候产生后代是独立的，因此有 {% math %}F_{i0}(n) = {F_{10}(n)}^i{% endmath %} 。所以显然，我们需要计算出 {% math %}F_{10}(n){% endmath %} 。
{% math %}
F_{10}(n)= P_{10} + \sum_{k=1}^\infty P_{1k}[F_{10}(n-1)]^k = \sum_{k=0}^\infty P_{1k}[F_{10}(n-1)]^k
{% endmath %}
令 {% math %}h(z) = \sum_k P_{1k}z^k{% endmath %} ，则 {% math %}F_{10}(n) = h(F_{10}(n-1)){% endmath %} 。通过函数，我们可以找到 {% math %}h(z){% endmath %} 的一些性质：
- {% math %}h(z) = z{% endmath %} 必有解 {% math %}z = 1{% endmath %}
- {% math %}h'(1) = \sum_k kP_{1k} = \bar{Y}{% endmath %}
- {% math %}h''(z) \ge 0 \text{ for } 0\le z\le 1{% endmath %}
- {% math %}h(0) = P_{10} = p_0{% endmath %}

通过上面的结论，可以发现 {% math %}h(z){% endmath %} 为凸函数，所以我们可以画出其图像：
![](http://ww1.sinaimg.cn/large/9dec4451gw1f1vid68w0aj20pi0akjt0.jpg)
我们可以看到当 {% math %}\bar{Y} < 1{% endmath %} 时， {% math %}F_{10}(\infty) = 1{% endmath %}

由 \ref{eq:branch} 可知：
{% math %}
E[X_n] = \bar{Y}E[X_{n-1}] = {\bar{Y}}^nE[X_0]
{% endmath %}
通过期望，我们可以看到上面的结论。但是需要注意的是，通过这种方式并不能真实的反映出 {% math %}E[X_n]{% endmath %} 。对于 {% math %}\bar{Y} = 1, X_0=1{% endmath %} 来说， {% math %}E[X_n]=1{% endmath %} 但是 {% math %}h(\infty){% endmath %} 是无限趋向于1的。在这种情况下，种群内个体数量极少的可能性极大，但是通过期望，我们看不到这一点。

# Round-robin and process sharing
在排队过程中，如果我们优先处理服务时间较短的客户，那么整体的delay(即renewald的 {% math %}U(t){% endmath %} )就会下降。实际场景往往不允许这种事情发生。计算机系统中也面临这种问题，而通常的处理方法是Round-robin，即处理A一会，然后处理B。。。轮流一圈之后继续处理A。而每个任务的处理时间 {% math %}\delta{% endmath %} 都是一样的，即处理A {% math %}\delta{% endmath %} 之后处理B。。。。

process sharing也是一样的，不过其 {% math %}\delta = 1/m{% endmath %} ，{% math %}m{% endmath %} 为任务数量。

下面我们证明通过Round-robin可以降低队伍的平均delay。令 {% math %}W_i{% endmath %} 表示第 {% math %}i{% endmath %} 个任务所需的服务时间， {% math %}f(j) = Pr\left\{W_j = j\delta\right\}, \bar{F}(j)= Pr\left\{W_j > j\delta\right\}{% endmath %} ，则用户在j次服务之后还需要一次服务的概率 {% math %}g(j) = f(j+1)/\bar{F}(j){% endmath %} 。

这里还需要 state s。我们将s定义为 {% math %}s = (m, z_1, z_2...z_m){% endmath %} ，其中m为用户数， {% math %}z_i\delta{% endmath %} 是第 {% math %}i{% endmath %} 个用户的总服务时间。

我们在已知state {% math %}X_n{% endmath %} 的情况下，可能会发现下面几种情况：
1. 来了新用户(概率为 {% math %}\lambda\delta{% endmath %})，被首先处理
2. 队首用户接受服务，时长为 {% math %}\delta{% endmath %}
3. 该用户可能离开
4. 该用户不离开，转到队尾。

总结一下，就是4种情况：
1. 没人来没人走， 概率记为 {% math %}P_{s,r(s)}{% endmath %}
2. 有人来没人走， 概率记为 {% math %}P_{s,a(s)}{% endmath %}
3. 没人来有人走， 概率记为 {% math %}P_{s,d(s)}{% endmath %}
4. 有人来了就走， 概率记为 {% math %}P_{s,s}{% endmath %}

则有：
{% math %}
\begin{aligned}
P_{s,r(s)} &= (1-\lambda\delta)[1-g(z_1)] \quad r(s)=(m,z_2...z_m,z_1+1)\\
P_{s,d(s)} &= (1-\lambda\delta)g(z_1)\quad d(s)=(m-1, z_2...z_m,1)\\
P_{s,a(s)} &= \lambda\delta[1-f(1)]\quad a(s)=(m+1,z_1, z_2...z_m,1)\\
P_{s,s} &= \lambda\delta f(1)
\end{aligned}
{% endmath %}

现在我们通过backward chain找到steady-state的分布。backward的过程中，有几点需要注意：
- 原来的队尾成了队首
- {% math %}z_i\delta{% endmath %} 是第 {% math %}i{% endmath %} 个用户还需要的服务时间

通过这种转换，我们可以求出{% math %}P^*{% endmath %}
{% math %}
P_{r(s),s}^* = 1-\lambda\delta \\
P_{a(s),s}^* = 1-\lambda\delta \\
P_{d(s),s}^* = \lambda\delta f(z_1+1) \\
P_{s,s}^* = 1-\lambda\delta f(1) \\
{% endmath %}
通过 {% math %}\pi_iP_{ij} = \pi_j P^*_{ji}{% endmath %} ，带入上式( {% math %}d(s){% endmath %} 的式子 )，可以求出：
{% math %}
\pi_s = \dfrac{\lambda\delta}{1-\lambda\delta} \bar{F}(z_1)\pi_{d(s)}
{% endmath %}
注意到我们可以通过 {% math %}\pi_{d(s)}, \pi_{d(d(s))}{% endmath %} 的递推关系，得到：
{% math %}
\pi_s = \Big(\dfrac{\lambda\delta}{1-\lambda\delta}\Big)^2 \bar{F}(z_1)\bar{F}(z_2)\pi_{d(d(s))} = ... =\Big(\dfrac{\lambda\delta}{1-\lambda\delta}\Big)^m \Big(\prod_{j=1}^m\bar{F}(z_j)\Big)\pi_{\emptyset}
{% endmath %}
当然，如果你不嫌麻烦，可以带到上面剩下的3个式子里面一一验证，应该是可以通过的。
我们定义 {% math %}P_m = \sum_{z1, z_2...z_m}\pi(m, z_1, z_2,...,z_m){% endmath %} 为系统中存在m个用户的概率。则
{% math %}
P_m = \Big(\dfrac{\lambda\delta}{1-\lambda\delta}\Big)^m \Big(\prod_{j=1}^m\sum_{i=1}^\infty\bar{F}(i)\Big)\pi_{\emptyset}
{% endmath %}
又因为 {% math %}\delta \sum_{i=1}^\infty\bar{F}(i) = E[W]-\delta{% endmath %} 故 {% math %}P_m = \Big(\dfrac{\lambda}{1-\lambda\delta}\Big)^m \Big(E[W]-\delta\Big)^m\pi_{\emptyset}{% endmath %} 。令 {% math %}\rho = \Big(\dfrac{\lambda}{1-\lambda\delta}\Big) \Big(E[W]-\delta\Big){% endmath %} ，则 {% math %}\pi_{\emptyset} = 1-\rho, P_m = \rho^m(1-\rho){% endmath %}
除了 {% math %}\rho{% endmath %} 的值不一样外，这和 M/M/1 queue 是一样的，得证

对于process sharing的过程来说，过程是一样的，只是 {% math %}\delta\to\infty{% endmath %} 而已。
