title: finite state markov chain
tags: [stochastic process]
date: 2016-03-02 23:10:05
categories: math
---
markov chain是markov process的基础。当然，对markov chain的了解是markov process的基础。
<!--more-->
# 好多概念- -
## markov chain
markov chain的核心都是围绕那个概率矩阵展开的。和arrival process不同的是，markov process中很多东西无法直接映射到现实，所以会有很多概念出现。
首先最重要的就是markov chain的定义了。概念的核心就一个式子：
{% math %}
Pr\left\{X_n=j|X_{n-1}=i,X_{n-2}=k,...,X_0=m\right\} = Pr\left\{X_n=j|X_{n-1}=i\right\}
{% endmath %}

举一个简单的例子吧。一个醉汉在一条直线上晃悠(别问我问啥醉汉可以在直线上晃悠)。他当前的运动方向只取决于上一时间点的运动方向。这种假设在nlp中经常出现。

在markov中，一般将 {% math %}P\left\{X_n=j|X_{n-1}=i\right\}=P_{ij}{% endmath %}

我们可以将markov chain表示为图的形式：
![](http://ww2.sinaimg.cn/large/9dec4451gw1f1jf6u3ylhj20lq09k3zp.jpg)

## state 的分类
recurrent state : 对于一个state i, 任何i可以访问的state j都可以访问state i。注意是i可访问的而不是可访问i的。
例如在上图中2是一个recurrent state，1就不是。

与recurrent对应的叫做transient state

Class:class 就是一个state的set，在这个set里面每个statee都可以相互访问。可以证明，一个class里面所有的state都是一种，要么recurrent，要么transient

现在我们引入period的概念。对于一个state i来说，period就是能再次访问到自己所花费的步数。如果period=1，则称该state为aperiodic；如果periodic大于等于2，则称为periodic

一个 recurrent 和 aperiodic class被称为 ergodic class；完全由一个ergodic class组成的markov chain被称为ergodic chain。

可以证明，对于一个ergodic M state markov chain，{% math %}P_{ij}^m>0\quad \text{for all i, j and } m\ge(M-1)^2+1{% endmath %} ，其中 {% math %}P_{ij}^m{% endmath %} 表示经过m步从i到j的概率。

证明：
[之前](http://modkzs.github.io/2016/03/03/%E4%BA%92%E8%B4%A8%E6%95%B4%E6%95%B0%E7%9A%84%E6%9C%80%E5%A4%A7%E4%B8%8D%E8%83%BD%E8%A1%A8%E7%A4%BA%E6%95%B0/)证明过两个互质整数 {% math %}a,b{% endmath %} 所不能表示数字的最大范围 {% math %}ab-a-b{% endmath %} 。

如果我们保持 {% math %}a{% endmath %} 不变，会发现这个数字随 {% math %}b{% endmath %} 的增加而增加。对于一个有M个状态的ergodic markov chain，根据前面的结果，最坏的情况就是两环的长度为M和M-1了。则第k个节点可以被访问到的周期为 {% math %}Ma+(M-1)b\quad a\ge 1,b>0{% endmath %} 而M,M-1互质，所以这两个数字所不能表示的最大数字为 {% math %}M(M-1)-M-(M-1)+M = (M-1)^2{% endmath %}

# 矩阵表示
根据定义，我们可以发现：
{% math %}
P_{ij}^2 = \sum_{k=1}^M P_{ik}P_{kj}
{% endmath %}
这和矩阵的乘法一模一样。所以我们可以用矩阵 {% math %}P{% endmath %} 来表示概率，{% math %}P^n{% endmath %} 可以直接得到概率。

## steady state
{% math %}P{% endmath %} 只是表征了节点间转移的概率， 我们用 {% math %}\pi_j{% endmath %} 表示在第j个时间点处于各个state的概率，则：
{% math %}
\pi_{j+1} = \pi_j P
{% endmath %}

当存在 {% math %}\pi{% endmath %} 使得 {% math %}\pi = \pi P{% endmath %} 时，我们称 {% math %}\pi{% endmath %} 为 steady-state vector。这只是一个线性方程，只要存在解，解出来并不是很复杂。所以问题来了，什么时候才有解呢？

为了解决这个问题，我们引入unichain的概念。简单来说，unichain就是只有一个recurrent class，但是可能包含多个transient class的markov chain。如果recurrent class 是ergodic，则称为ergodic unichain

下面将证明，只有ergodic chain才有steady-state vector.

易知：
{% math %}\max_i P_{ij}^{n+1} = \sum_kP_{ik}P_{kj}^n\le \sum_kP_{ik}\max_l P_{lj}^{n} = \max_l P_{lj}^{n}\\ \min_i P_{ij}^{n+1} = \sum_kP_{ik}P_{kj}^n\ge \sum_kP_{ik}\min_l P_{lj}^{n} = \min_l P_{lj}^{n}{% endmath %}

令 {% math %}\alpha = \min_{i,j}P_{ij}{% endmath %}。则有：
{% math %}
\begin{aligned}
P_{ij}^{n+1} &= \sum_kP_{ik}P_{kj}^n\\
&\le \sum_{k\neq l_{min}}P_{ik}\max_lP_{lj}^n + P_{il_{min}}\min_lP_{lj}^n\\
& = \max_l P_{lj}^n-P_{il_{min}}(\max_l P_{lj}^n-\min_l P_{lj}^n)\\
&\le\max_l P_{lj}^n-\alpha(\max_l P_{lj}^n-\min_l P_{lj}^n)
\end{aligned}
{% endmath %}

同理，可以推出 {% math %}P_{ij}^{n+1} \ge \min_l P_{lj}^n+\alpha(\max_l P_{lj}^n-\min_l P_{lj}^n){% endmath %}

注意到：
{% math %}
\max_i P_{ij} \le 1-\alpha \quad \min_i P_{ij} \ge \alpha
{% endmath %}

所以有：
{% math %}
\max_i P_{ij}^{n+1} - \min_i P_{ij}^{n+1} \le (1-2\alpha)(\max_l P_{lj}^n-\min_l P_{lj}^n)\\ \le ...\le (1-2\alpha)^{n}(\max_l P_{lj}-\min_l P_{lj})=(1-2\alpha)^{n+1}
{% endmath %}
故 {% math %}\lim_{n\to\infty}\max_i P_{ij}^{n} = \lim_{n\to\infty}\min_i P_{ij}^{n}{% endmath %}

令 {% math %}h=(M-1)^2-1{% endmath %} ，由前面的描述可知，当markov chain 为 ergodic 时， 对于任何 {% math %}h'>h{% endmath %} ，均有 {% math %}P_{ij}^{h'} >0{% endmath %} 成立。对于 {% math %}v\ge1{% endmath %} ，
{% math %}
\lim_{v\to\infty}\max_iP_{ij}^{h(v+1)}=\lim_{v\to\infty}\min_iP_{ij}^{h(v+1)}
{% endmath %}
所以有：
{% math %}
\lim_{n\to\infty}\max_iP_{ij}^{n}=\lim_{n\to\infty}\min_iP_{ij}^{n}
{% endmath %}

现给定向量 {% math %}u，u_j = \lim_{n\to\infty}\max_mP^n_{mj}= \lim_{n\to\infty}\min_mP^n_{mj}{% endmath %}

故 {% math %}u_j = \lim_{n\to\infty}\max_mP^n{% endmath %}

故 {% math %}\lim[P^n] = eu\quad \text{where} e = {(1,1,...,1)}^T{% endmath %}

我们假设 {% math %}\pi{% endmath %} 为前面说的steady-state vector，则
{% math %}
\pi = \pi\lim_{n\to\infty}[P^n] = \pi eu = u
{% endmath %}
故 {% math %}u{% endmath %} 为我们所求的steady-state vector

### ergodic unichain
对于ergodic unichain来说，上面的结论仍然成立，但是细节方面会有一些改变。

我们将一个矩阵 {% math %}P{% endmath %} 分成4块： {% math %}[P] = \begin{bmatrix}[P_T] & [P_{TR}]\\ [0] & [P_R]\end{bmatrix}{% endmath %}
其中 {% math %}P_T{% endmath %} 中的state均为transient state, {% math %}P_R{% endmath %} 中的state均为recurrent state。由于所有transient state最后都会变成recurrent state，所以 {% math %}P_T, P_{TR}{% endmath %} 最后均为0。对于 recurrent state，我们令 {% math %}\gamma = \max_{i\in T}\sum_{j \in T} P_{ij}^t < 1{% endmath %}
下面证明：
{% math %}
\max_{l\in T}P_{ij}^n < \gamma^{\lfloor n/t\rfloor}
{% endmath %}

{% math %}
\sum_{j \in T} P_{ij}^{(v+1)t} = \sum_{k \in T} P_{ik}^{t}\sum_{j \in T} P_{kj}^{vt} \le \sum_{k \in T}P_{ik}^{t} \max_{l \in T} \sum_{j \in T}P_{lj}^{vt} \le \gamma \max_{l \in T}\sum_{j \in T}P_{lj}^{vt}
{% endmath %}
不断向前推，我们就可以得到
{% math %}
\max_{l \in T} \sum_{j\in T} P_{lj}^{vt} \le \gamma^v
{% endmath %}

我们可以证明 {% math %}P_R{% endmath %} 会收敛
{% math %}
\begin{aligned}
|P^n_{ij} - \pi_j| &= |\sum_{k \in T}P^m_{ik}P^{n-m}_{kj} + \sum_{k \in R}P^m_{ik}P^{n-m}_{kj} - \pi_j|\\
&=|\sum_{k \in T}P^m_{ik}(P^{n-m}_{kj} - \pi_j) + \sum_{k \in R}P^m_{ik}(P^{n-m}_{kj} - \pi_j)|\\
&\le\sum_{k \in T}P^m_{ik}|P^{n-m}_{kj} - \pi_j| + \sum_{k \in R}P^m_{ik}|P^{n-m}_{kj} - \pi_j|\\
&\le\sum_{k \in T}P^m_{ik} + \sum_{k \in R}P^m_{ik}|P^{n-m}_{kj} - \pi_j|\\
&\le \gamma^{\lfloor m/t\rfloor} + (1-2\beta)^{\lfloor (n-m)/h\rfloor}
\end{aligned}
{% endmath %}

## 特征值和特征向量
markov chain的所有特征值的绝对值均不大于1.

证明：
令 {% math %}\lambda_l{% endmath %} 为第l个特征根， {% math %}\pi_i^l{% endmath %} 为对应特征向量的第 {% math %}i{% endmath %} 个元素，则：
{% math %}
\lambda_j^n \pi_j^l = \sum_i\pi_i^lP_{ij}^n\\
|\lambda_j^n| |\pi_j^l| \le \sum_i|\pi_i^l|P_{ij}^n
{% endmath %}
令 {% math %}\beta = \max_i|\pi_i^l|{% endmath %} ，则：
{% math %}
|\lambda_j^n| \beta \le \sum_i\beta P_{ij}^n \le \beta M
{% endmath %}
对任意n都成立，故 {% math %}|\lambda_j|\le1{% endmath %}

当存在k个重复的特征值时，一般存在2种情况：
- markov chain中recurrent class的period为k
- markov chain中存在k个recurrent class

# markov chain with reward
在原有的markov chain 中，我们到达state j是没有任何reward的，感觉这种东西直接建模现实世界还是太简单，就加了一个reward。

比如first-passage time，用来表示第一次到达state i所花步数的期望。
![](http://ww4.sinaimg.cn/large/9dec4451jw1f1m3qgk1x4j20b406eaae.jpg)
我们用 {% math %}v_i{% endmath %} 表示从state i到state 1的期望步数，则：
{% math %}
\begin{aligned}
v_2 &= 1+ P_{23}v_3+P_{24}v_4\\
v_3 &= 1+ P_{32}v_2+P_{33}v_3+P_{34}v_4\\
v_4 &= 1+ P_{42}v_2+P_{43}v_3
\end{aligned}
{% endmath %}
可以总结为 {% math %}v_i = 1 + \sum_{j\neq1}p_{ij}v_j{% endmath %}
如果我们令 {% math %}v_1 = 0{% endmath %} ，则上式可以抽象为{% math %}v=r+Pv{% endmath %}

看完例子之后，我们回到普遍的情况。令 {% math %}X_m{% endmath %} 为m时刻所处的state， {% math %}R_m=R(X_m){% endmath %} 表示在state m时的reward，则
{% math %}
\begin{aligned}
v_i(n) &= E[R(X_m)+R(X_{m+1})+...+R(X_{m+n-1})|X_m=i]\\
&=r_i+\sum_jP_{ij}r_j+...+\sum_jP_{ij}^{n-1}r_j
\end{aligned}
{% endmath %}
以矩阵形式表示就是：{% math %}v(n)=r+Pr+...+P^{n-1}r_j{% endmath %}
如果令 {% math %}P^0=I{% endmath %} ，则 {% math %}v(n)=\sum_{h=0}^{n-1}P^hr{% endmath %} 。因为 {% math %}\lim_{n\to\infty}P^nr=e\pi r{% endmath %} ，当{% math %}g=\pi r \neq 0{% endmath %} 时， {% math %}v(n){% endmath %} 就不会收敛。但是 {% math %}v(n)-nge = \sum_{h=0}^{n-1}(P^h-e\pi)r{% endmath %} 是是显然收敛的。我们称收敛的结果为relative-gain vector，记做 {% math %}w{% endmath %} 。也就是说， {% math %}w=\lim_{n\to\infty}\sum_{h=0}^{n-1}(P^n-e\pi)r=\lim_{n\to\infty}v(n)-nge{% endmath %}

对于一个ergodic unichain，很容易证明 {% math %}w{% endmath %} 满足下面的等式：
{% math %}
w+ge = Pw+r \quad \pi w = 0
{% endmath %}

而对于unichain来说，上式有唯一解。

## additional final reward
这么整数学家还是觉得不爽，你到终点了结束了再给你来一发好了。这就是additional final reward。用公式表示就是这样的：
{% math %}
v(n,u) = r+Pr+...+P^{n-1}r + P^nu=\sum_{h=0}^{n-1}P^hr + P^nu
{% endmath %}

对于 unichain 来说，有下式成立：
{% math %}
v(n,u) = nge + w +P^n(u-w)
{% endmath %}

证明居然是用数学归纳法证明的Σ( ° △ °|||)︴所以自己证下就好了。。。。。
