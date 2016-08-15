title: markov process
tags: [stochastic process]
date: 2016-03-14 12:00:28
categories: math
---
markov process是markov chain的泛化版本。它描绘了markov chain中访问的每个state以及interval
<!--more-->
# 介绍
和前面说的一样，markov过程由 {% math %}X_0, X_1, .. X_{n-1}{% endmath %} 和 {% math %}U_1, U_2,...U_n{% endmath %} 组成， {% math %}X_n{% endmath %} 表示访问的state, {% math %}U_n{% endmath %} 表示holding time，即经过 {% math %}U_n{% endmath %} 时间后，系统由state {% math %}X_{n-1}{% endmath %} 进入state {% math %}X_n{% endmath %} 。由于 {% math %}X_n{% endmath %} 就是一个markov chain的sample path，所以也被叫做embedded Markov chain。 {% math %}U_n{% endmath %} 服从参数为 {% math %}v_l{% endmath %}的指数分布，即
{% math %}
Pr\left\{U_n\le u| X_{n-1} = l\right\} = 1-exp(-v_l u)
{% endmath %}

若令 {% math %}S_n = \sum_{m=1}^n U_m{% endmath %} ，则markov process 可以表示为：
{% math %}
X(t) = X_n\text{ for } S_n\le t<S_{n+1}\\
{% endmath %}

在这里我们假设 {% math %}P_{ii} = 0{% endmath %} ，即不存在self transition。因为在当前的场景下，self transition难以被检测到

由于指数分布memoryless的特性，会有
{% math %}
Pr\left\{X(t) = j | X(\tau) = i,\left\{X(s)=x(s);s<\tau \right\}\right\} = Pr\left\{X(t-\tau) = j | X(0)\right\}
{% endmath %}

例如一个 M/M/1 queue 可以用下图表示：
![](http://ww1.sinaimg.cn/large/9dec4451gw1f1wiuhqzpmj20ow03m757.jpg)
{% math %}\lambda + \mu{% endmath %} 可以看做2个poisson过程(arrive and departure)的合并, {% math %}\lambda/(\lambda + \mu){% endmath %} 可以看做两个过程合并后的分裂。

显而易见这就是一个birth-death chain。所以我们可以直接计算 steady-state 的概率：
{% math %}
\pi_0 = \dfrac{1-\rho}{2}\
\pi_n = \dfrac{1-\rho^n}{2}\rho^{n-1}\ \rho = \lambda/\mu
{% endmath %}

所以我们可以从三个角度去看一个markov process：
- 第一个视角也就是我们上面的视角；
- 可以将这个过程看成是poisson process，rate为 {% math %}v_i{% endmath %} ，poisson的arrival就是markov的transition
- 将每个transition视为 {% math %}n-1{% endmath %} 个poisson process的复合， {% math %}n{% endmath %} 为状态数量。在state i到state j的rate为{% math %}v_iP_{ij}{% endmath %} 。这些poisson process中，最先达到的即为下一个transition

## sample-time 近似
我们可以将holding time分割成多个时间单元，每个时间单元为 {% math %}\delta{% endmath %} 。如果我们假设每次转移只发生在 {% math %}\delta{% endmath %} 的整数倍时间，那么这个过程就可以被视为markov chain，其中
{% math %}P_{ij} = q_{ij}\delta\\ P_{ii} = 1-\sum_{j\neq i} P_{ij} = 1- v_i\delta{% endmath %}
当然，{% math %}\delta{% endmath %} 必须满足 {% math %}1- v_i\delta \ge 0{% endmath %}

# irreducible Markov processes
我们将embedded Markov chain为irreducible的MP称为 irreducible MP。

下面我们将证明，对于markov process来说，其steady-state概率 {% math %}p_j = \dfrac{\pi_j/v_j}{\sum_k\pi_k/v_k}{% endmath %}

首先我们证明一条引理：对于一个开始于state i 的markov process，有 {% math %}\lim_{t\to\infty}M_i(t)=\infty{% endmath %} 。
{% math %}
\begin{aligned}
Pr\left\{U_n > u\right\} &= \lim_{k\to\infty} \sum_{j=1}^k P_{ij}^{n-1}\exp(-v_j u)\\
& \le \sum_{j=1}^k P_{ij}^{n-1}\exp(-v_j u) + \sum_{j=k+1}^\infty P_{ij}^{n+1} \quad \text{for every }k
\end{aligned}
{% endmath %}
易知：当 {% math %}k{% endmath %} 增加或 {% math %}u\to\infty{% endmath %} ， {% math %}Pr\left\{U_n > u\right\} \to 0{% endmath %} 。所以 {% math %}U_n{% endmath %} 为rv。故 {% math %}S_n{% endmath %} 必然也是rv。则 {% math %}\lim_{t\to\infty} Pr\left\{S_n \le t\right\} = 1{% endmath %} 。而 {% math %}\left\{S_n\le t\right\}=\left\{M_i(t)\ge n\right\}{% endmath %} 。故 对于任意 {% math %}n{% endmath %} 都有 {% math %}\lim_{t\to\infty} Pr\left\{M_i(t)\ge n\right\} = 1{% endmath %} 。所以 {% math %}\lim_{t\to\infty}M_i(t,w) = \infty\ \text{WP1}{% endmath %}

令 {% math %}M_{ij}(t){% endmath %} 表示 {% math %}X_0 = i{% endmath %} 时，在（0, t]内到达state j的次数。下面证明 {% math %}M_{ij}(t){% endmath %} 为delay renewal process(i = j时则是renewal process)。

令 {% math %}N_{ij}(n){% endmath %} 表示对于embedded markov chain来说，从i出发进入state j的次数。 我们在[countable-state markov chain](http://modkzs.github.io/2016/03/12/countable-state-markov-chain/) 说明了 {% math %}N_{ij}(n){% endmath %} 为delay renewal process。 易知 {% math %}M_{ij}(t) = N_{ij}(M_i(t)){% endmath %} 故
{% math %}
\lim_{t\to\infty}M_{ij}(t) = \lim_{t\to\infty} N_{ij}(M_i(t)) = \lim_{n\to\infty} N_{ij}(n) = 0 \quad WP1
{% endmath %}
所以从state i 出发，经过一段时间后我们必然可以第一次访问state j；再过一段时间(记为 {% math %}W_1{% endmath %} )，必然可以第二次访问state j。后面访问 state j的interval和 {% math %}W_1{% endmath %} 分布相同。故 {% math %}M_{ij}(t){% endmath %} 为delay renewal process 。我们将访问state j的interval的期望记为 {% math %}\bar{W}(j){% endmath %}

根据我们前面的假设，{% math %}U_n{% endmath %} 满足指数分布，故 {% math %}E[U_n|X_{n-1}=j] = 1/v_j{% endmath %} 。我们为 {% math %}M_ij(t){% endmath %} 定义一个reward {% math %}R_{ij}(t) = \mathbb{I}_{X(t)=j}{% endmath %} (如下图所示)

![](http://ww2.sinaimg.cn/large/9dec4451jw1f225sib74ij20r806igm9.jpg)

我们令 {% math %}p_j{% endmath %} 表示停留在state j的时间比例。则根据renewal process的性质，可得：
{% math %}
p_j(i) = \lim_{t\to\infty}\dfrac{\int_0^t R_{ij}(\tau)d\tau}{t} = \dfrac{\bar{U}(j)}{\bar{W}(j)} = \dfrac{1}{v_j\bar{W}(j)}
{% endmath %}

现假设embedded chain为positive recurrent， steady-state概率为 {% math %}\pi_j{% endmath %} 且 {% math %}X_0 = i{% endmath %} 。根据renewal process的性质，我们有：
{% math %}
\lim_{t\to\infty} \dfrac{M_{ij}(t)}{t} = 1/\bar{W}(j)\quad \text{WP1}\\

\lim_{t\to\infty} \dfrac{M_{ij}(t)}{M_i(t)} = \lim_{t\to\infty} \dfrac{N_{ij}(M_i(t))}{M_i(t)} = \lim_{n\to\infty} \dfrac{N_{ij}(n)}{n} = \pi_j\quad \text{WP1}\\

\Rightarrow \dfrac{1}{\bar{W}(j)} = \lim_{t\to\infty} \dfrac{M_{ij}(t)}{t} = \lim_{t\to\infty} \dfrac{M_{ij}(t)}{M_i(t)}\dfrac{M_i(t)}{t} = \pi_j \lim_{t\to\infty}\dfrac{M_{i}(t)}{t}
{% endmath %}

下面我们证明 {% math %}\lim_{l\to\infty}\sum_{k=1}^l p_k(i)=1{% endmath %}

我们令 {% math %}R^l_{ij}(t)=\mathbb{I}_{X(t)\le l}{% endmath %} 。则有：
{% math %}
\lim_{t\to\infty}\dfrac{\int_0^t R^t_{ij}(\tau)d\tau}{t} = \sum_{k=1}^l p_k(i) = \dfrac{E[R^l_j]}{\bar{U}_j}
{% endmath %}
则易知：{% math %}\sum_{k=1}^l p_k(i){% endmath %} 随 {% math %}k{% endmath %} 的增加而增加且必须小于等于1。故 {% math %}\lim_{l\to\infty}\sum_{k=1}^l p_k(i)=1{% endmath %} 。

结合上面 {% math %}p_j(i){% endmath %} 的式子，我们可以发现 {% math %}p_j(i){% endmath %} 和 {% math %}\dfrac{\pi_j}{v_j}{% endmath %} 成正比。故 {% math %}p_j(i) = \dfrac{\pi_j/v_j}{\sum_k \pi_k/v_k}{% endmath %}

根据上式以及 {% math %}\pi_j = \sum_i \pi_i P_{ij}{% endmath %} 可得：
{% math %}
p_jv_j = \sum_i p_i q_{ij}\quad \sum_ip_i = 1
{% endmath %}
对于一个 irreducible markov process来说，假设 {% math %}p_i{% endmath %} 为上式的解，如果 {% math %}\sum_i p_iv_i < \infty{% endmath %}，则该解唯一、大于0且可得到embedded chain的steady-state 概率 {% math %}\pi_j{% endmath %} ；对于embedded chain来说，若为positive recurrent，则也可以计算出满足上式的 {% math %}p_i{% endmath %} 。

当然了，在embedded chain 为 positive recurrent时，仍然存在markov process没有steady-state的情况(下图即为例子)
![](http://ww4.sinaimg.cn/large/9dec4451jw1f225tfdwulj20na04gwey.jpg)

对于 {% math %}\sum_i p_i = 1{% endmath %} 来说，也有 {% math %}\sum_i p_iv_i = \infty{% endmath %} 的情况出现这种例子很好构造，就不举例子了。

# Kolmogorov differential equations
令 {% math %}P_{ij}(t) = P\left\{X_t = j | X_0 = i\right\}{% endmath %} 的概率，则 {% math %}\lim_{t\to\infty} P_{ij}(t)=p_j{% endmath %} 。我们可以将 {% math %}P_{ij}(t){% endmath %} 重写为：
{% math %}
\begin{aligned}
P_{ij}(t) &= \sum_k Pr\left\{X(t) = j, X(s) = k | X(0) = i\right\}\\
&=\sum_k Pr\left\{X(s) = k | X(0) = i\right\}Pr\left\{X(t) = j | X(s) = k\right\}
&= \sum_k P_{ik}(s)P_{kj}(t-s)
\end{aligned}
{% endmath %}

如果令 {% math %}t-s{% endmath %} 大于0单足够小， {% math %}P_{kj}(t-s){% endmath %} 可以被表示为 {% math %}(t-s)q_{kj}+o(t-s)\ \text{for}k\neq j{% endmath %} ； {% math %}P_{jj}(t-s){% endmath %} 可以被表示为 {% math %}1-(t-s)v_j + o(s){% endmath %} 。因此
{% math %}
P_{ij}(t) = \sum_{k\neq  j} [P_{ik}(s)(t-s)q_{kj}] + P_{ij}(s)[1-(t-s)v_j] + o(t-s)\\
\Rightarrow \dfrac{P_{ij}(t) - P_{ij}(s)}{t-s} = \sum_{k\neq j}(P_{ik}(s)q_{kj}) - P_{ij}(s)v_j + o(s)/s\\
\Rightarrow \dfrac{dP_{ij}(t)}{dt} = \sum_{k\neq j}(P_{ik}(s)q_{kj}) - P_{ij}(s)v_j
{% endmath %}
最后的式子被称为Kolmogorov forward equations

## 一个例子
考虑一个最简单的M/M/1 queue。
则有：
{% math %}
\dfrac{dP_{01}(t)}{dt} = P_{00}(t)q_{01} - P_{01}(t)v_1 = P_{00}\lambda - P_{01}(t)\mu = \lambda - P_{01}(t)(\mu + \lambda)\\
\Rightarrow P_{01}(t) = \dfrac{\lambda}{\mu + \lambda}[1-e^{-(\mu + \lambda)t}]
{% endmath %}
令 {% math %}[P(t)]{% endmath %} 为M*M维的矩阵， 第i行j列元素为{% math %}P_{ij}{% endmath %}；{% math %}[Q]{% endmath %} 也为M*M维的矩阵， 第i行j列元素为{% math %}q_{ij} \text{ if } i \neq j{% endmath %} 或 {% math %}-v_j \text{ if } i = j{% endmath %} ，则Kolmogorov forward equations可以写成：
{% math %}
\dfrac{d[P(t)]}{dt} = [P(t)][Q]
{% endmath %}

对于Q来说，必然存在唯一一个全部元素均大于0的左特征向量。


{% math %}
\begin{aligned}
P_{ij}(t) &= \sum_k P_{ik}(s)P_{kj}(t-s)\\
&= \sum_{k\neq i}sq_{ik}P_{kj}(t-s) + (1-sv_i)P_{ij}(t-s) + o(s)
\end{aligned}
{% endmath %}

{% math %}
\Rightarrow \dfrac{P_{ij}(t) - P_{ij}(t-s)}{s} = \sum_{k\neq i}q_{ik}P_{kj}(t-s) + v_iP_{ij}(t-s) + o(s)/s\\
\Rightarrow \dfrac{dP_{ij}(t)}{dt} = \sum_{k\neq i}q_{ik}P_{kj}(t-s) + v_iP_{ij}(t-s)\\
\Rightarrow \dfrac{d[P(t)]}{dt} = [Q][P(t)]
{% endmath %}

这被称为Komogorov backward equation

# birth-death process
其实和birth-death chain差不多。

为了保证steady state的存在，有 {% math %}p_i \lambda_i=p_{i+1}\mu_{i+1}{% endmath %} 。令 {% math %}\rho_i = \dfrac{\lambda_i}{\mu_{i+1}}{% endmath %} ， 则
{% math %}
p_i = p_0 \prod_{j=0}^{i-1}\rho_j
\Rightarrow p_0 = \dfrac{1}{1+\sum_{i=1}^\infty \prod_{j=0}^{i-1}\rho_j}
{% endmath %}
对于 M/M/1 queue来说，可以简化为 {% math %}p_i = (1-\rho)\rho^i{% endmath %}

t时刻队伍中顾客数量的期望 {% math %}E[X(t)] = \sum_{i=1}^\infty Pr\left\{X(t)\ge i\right\} = \dfrac{\rho}{1-\rho}{% endmath %}

根据Little’s formula，顾客在队伍中花费的平均时间 {% math %}E[system time] = \dfrac{E[X(t)]}{\lambda} = \dfrac{\rho}{\lambda(1-\rho)} = \dfrac{1}{\mu - \lambda}{% endmath %}

顾客在队伍中花费的平均等待时间 {% math %}E[Queueing time] = \dfrac{1}{\mu - \lambda} - \dfrac{1}{\mu} = \dfrac{\rho}{\mu - \lambda}{% endmath %}

还可以用Little’s formula计算出队列中顾客数量的期望{% math %}E[Number in queue] = \dfrac{\lambda\rho}{\mu - \lambda}{% endmath %}

birth-death process可以建模大多数的queue，不过可能比 M/M/1要复杂很多。

# Reversibility
在markov process中，对于backward transition来说，其概率 {% math %}P_{ij}^*{% endmath %} 满足 {% math %}\pi_iP_{ij}^* = \pi_jP_{ji}{% endmath %} 。对于markov process来说，该结论同样成立。而且显而易见backward transition本身也是markov process。我们同样定义 {% math %}q_{ij}^*{% endmath %} ，则 {% math %}q_{ij}^* = v_jP_{ij}^* = \dfrac{v_i\pi_jP_{ji}}{\pi_i} = \dfrac{v_i\pi_jq_{ji}}{\pi_iv_j} = p_jq_{ji}/p_i{% endmath %} 。所以我们可以得到相似的结论：
{% math %}
p_iq_{ij}^* = p_jq_{ji}
{% endmath %}

所以当{% math %}q_{ij}^* = q_{ij}{% endmath %} 时，markov process 就是 reversible。对于markov process与embedded chain在reversibility上的关系如下：

对于 steady state 存在的irreducible markov process，若embedded chain为reversible，则markov process也是reversible

## 一些性质
对于irreducible markov process，如果 {% math %}p_i{% endmath %} 大于0、和为1、满足 {% math %}\sum_ip_iv_i < \infty{% endmath %}  以及 {% math %}p_iq_{ij} = p_jq_{ji} \text{ for all}i, j{% endmath %} ，则 {% math %}p_i{% endmath %} 是对应的markov process的steady-state 概率(所以肯定大于0喽)，process是reversible，embedded chain是positive recurrent。

证明：对 {% math %}p_iq_{ij} = p_jq_{ji}{% endmath %} 同时取和，得：
{% math %}
\sum_i p_iq_{ij} = p_jv_j \text{ for all j}
{% endmath %}
上面的方程加上 {% math %}\sum_i p_i = 1{% endmath %} 可以解出process的steady-state概率。结合{% math %}p_iq_{ij}^* = p_jq_{ji}{% endmath %} ，就可以证明了。

对于irreducible markov process， 如果有 {% math %}p_i{% endmath %} 满足 {% math %}\sum_i p_i = 1, \sum_i p_iv_i < \infty{% endmath %} ，还有一组 {% math %}q_{ij}^*{% endmath %} 恰好满足
{% math %}
\sum_j q_{ij} = \sum_j q_{ij}^* \\
p_iq_{ij} = p_jq_{ji}^*
{% endmath %}
那么 {% math %}p_i{% endmath %} 就是steady-state概率，embedded chain为positive recurrent， {% math %}q_{ij}^* {}{% endmath %} 为backward transition的概率。
证明和上面的思路基本一样，就不证了

对于birth-death process来说，如果 {% math %}p_i\lambda_i = p_{i+1}\mu_{i+1}{% endmath %} 有解且满足 {% math %}\sum_i p_i = 1， \sum_i p_iv_i<\infty{% endmath %} 则process为irreducible且embedded chain为positive recurrent, reversible

对于 M/M/1 queue( {% math %}\lambda < \mu{% endmath %} )来说，有：
1. departure process也是poisson，rate为 {% math %}\lambda{% endmath %} (我觉得这是backward)
2. state {% math %}X(t){% endmath %} 和t之前的departure无关
3. 对于FCFS来说，假设有顾客在t时间离开，则该顾客的到达时间和t之间的departure没有关系
这是Burke’s theorem的MP版
