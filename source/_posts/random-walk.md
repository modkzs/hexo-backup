title: random walk
tags: [stochastic process]
date: 2016-03-20 10:03:20
categories: math
---
随机过程最后一部分的内容了=。=主要讲随机游走
<!--more-->
# 介绍
随机游走感觉其实就是markov process。它的数学定义是 {% math %}X_i{% endmath %} 是IID的rv， {% math %}S_n = X_1 + X_2 +...+X_n{% endmath %} 。将integer-time process {% math %}S_n{% endmath %} 成为随机游走，或者说是基于 {% math %}X_i{% endmath %} 的一维随机游走。

随机游走有2个重要的应用领域：queue delay和detection problem。

## queue delay
还是考虑一个G/G/1 queue如下图：
![](http://ww4.sinaimg.cn/large/9dec4451jw1f235xy8atnj20ry0c2ab4.jpg)
令 {% math %}U_n = Y_{n-1}-X_n{% endmath %} 。则
{% math %}
\begin{aligned}
W_n &= max[W_{n-1}+Y_{n-1}-X_n, 0]\\
&= max[W_{n-1}+U_n, 0]\\
&= max[max[W_{n-2}+U_{n-1}, 0] + U_n, 0]\\
&= max[(W_{n-2}+U_{n-1}+U_n), U_n, 0]\\
&= max[(W_{n-3}+U_{n-2}+U_{n-1}), (U_n+U_{n-1}), U_n,0]\\
&= ...\\
&= max[(U_1+U_2+..+U_n),(U_2+..+U_n),...,U_n]
\end{aligned}
{% endmath %}
令 {% math %}Z_i^n = U_n+U_{n-1}+...+U_{n-i+1}{% endmath %} ，则
{% math %}
W_n = max[0,Z_1^n, Z_2^n,...,Z_n^n]\\
Pr\left\{W_n \ge \alpha\right\} = Pr\left\{max[0,Z_1^n, Z_2^n,...,Z_n^n] \ge \alpha\right\}
{% endmath %}

根据随机游走的定义，可知 {% math %}Z_i^n{% endmath %} 就是一种随机游走。而 {% math %}W_n \ge \alpha{% endmath %} 即 随机游走在第n次trial之前大于thresold {% math %}\alpha{% endmath %}

## detection problem
和ml里面的贝叶斯判别差别不大，只不过是在随机过程中换了个名字，叫hypothesis testing。我们在这里只考虑H有2种取值。对于每一个假说H都有2种可能的取值，0和1，其PMF分别为 {% math %}p_H(0) = p_0, p_H(1) = p_1 = 1-p_0{% endmath %}

令 {% math %}Y=(Y_1, Y_2, ... Y_n){% endmath %} 表示n个观测，都是基于 {% math %}H=0\text{或}1{% endmath %} 产生的并且其联合概率分布{% math %}f_{Y|H}(y|0),f_{Y|H}(y|1){% endmath %} 均大于0. 联合概率分布的定义为 {% math %}f_{Y|H}(y|l) = \prod_{i=1}^n f_{Y|H}(y_i|l){% endmath %}

所以根据贝爷的定律，有：
{% math %}
Pr\left\{H=0|y\right\} = \dfrac{p_0f_{Y|H}(y|0)}{p_1f_{Y|H}(y|0) + p_0f_{Y|H}(y|0)}\\

\dfrac{Pr\left\{H=0|y\right\}}{Pr\left\{H=1|y\right\}} = \dfrac{p_0f_{Y|H}(y|0)}{p_1f_{Y|H}(y|1)}
{% endmath %}

当上面的比值大于1时，我们认为 {% math %}\hat{h} = 0{% endmath %} ；小于1时认为 {% math %}\hat{h} = 1{% endmath %} ；等于1时就都一样了。这种选法被称为MAP(Maximum a posteriori probability)

定义 {% math %}\Lambda(y) = \dfrac{f_{Y|H}(y|0)}{f_{Y|H}(y|1)}{% endmath %} ，则我们可以将MAP表示为：
{% math %}
\Lambda(y) =
  \begin{cases}
    >p_1/p_0& \text{select}\hat{h} = 0\\

    \le p_1/p_0& \text{select}\hat{h} = 1  
  \end{cases}
{% endmath %}

令 {% math %}z_i = \ln\dfrac{f_{Y|H}(y_i|0)}{f_{Y|H}(y_i|1)}{% endmath %} ，MAP可以表示为：
{% math %}
\sum_{i=1}^n z_i =
  \begin{cases}
    >p_1/p_0& \text{select}\hat{h} = 0\\

    \le p_1/p_0& \text{select}\hat{h} = 1  
  \end{cases}
{% endmath %}

如果我们令 {% math %}\eta = p_1/p_0{% endmath %} ，则MAP就是一个threshold test。

当然，我们也可以根据错误进行。我们可以让 {% math %}Pr\left\{e|H=1\right\}{% endmath %} 和 {% math %}Pr\left\{e|H=0\right\}{% endmath %} 低于某个上界 {% math %}\alpha{% endmath %} 。这被称为Neyman-Pearson rule。

对于一个test，我们定义 A 为由hypothesis 1产生的观测，则错误率为：
{% math %}
q_0(A) = Pr\left\{Y\in A|H=0\right\};q_1(A) = Pr\left\{Y\in A^c|H=1\right\}
{% endmath %}
所以错误的概率 {% math %}Pr\left\{e(A)\right\} = p_0q_0(A) + p_1q_1(A){% endmath %}

如果test是threshold test，则 {% math %}A = \left\{y:\dfrac{f_{Y|H}(y|0)}{f_{Y|H}(y|1)}\le\eta\right\}{% endmath %} 。对于一个threshold test来说， {% math %}\eta{% endmath %} 至关重要。所以我们用 {% math %}\eta{% endmath %} 表示threshold test。

对于任意一个test A和threshold test {% math %}0<\eta<\infty{% endmath %} ， {% math %}(q_1(A), q_0(A)){% endmath %} 必在直线 {% math %}y = -\eta x + q_0(\eta)+\eta q_1(\eta){% endmath %} 上方(如下图所示)
![](http://ww3.sinaimg.cn/large/9dec4451jw1f24d4az2eej20vo0cy401.jpg)
令 {% math %}u(\alpha) = \sup_{0\le \eta < \infty} q_0(\eta)+\eta(q_1(\eta)-\alpha){% endmath %} ，则如下图所示：
![](http://ww1.sinaimg.cn/large/9dec4451jw1f24dbceukuj20ti0ck3zs.jpg)

Neyman-Pearson test是在 {% math %}q_0(A){% endmath %} 的一些限制下，选择A以最小化 {% math %}q_1(A){% endmath %} 。这也是一个threshold test。
## 一个小例子
最简单的例子：只有观测只有一个维度的数据，不同hypothesis产生观测的概率为：
{% math %}
p_{Y|H}(0|0)=p_{Y|H}(1|1) = \frac{2}{3}; p_{Y|H}(1|0)=p_{Y|H}(1|0) = \frac{1}{3}
{% endmath %}

根据MAP的判断条件，可知： 当 {% math %}p_1 < 1/3{% endmath %} 时，必有 {% math %}\hat{h} = 0{% endmath %} ；当  {% math %}p_1 \ge 2/3{% endmath %} 时，必有 {% math %}\hat{h} = 1{% endmath %} 。只有在两者之间时，才需要进行判断；对于 {% math %}\eta{% endmath %} 来说，是一样的。所以对于这种情况，图就变成了：
![](http://ww1.sinaimg.cn/large/9dec4451jw1f24kacf0kuj20ic0b60td.jpg)

# 随机游走中的threshold crossing问题
令 {% math %}X_i{% endmath %} 表示IID的rv，{% math %}S_n=X_1+X_2+...+X_n{% endmath %} 表示随机游走， {% math %}g_X(r) = E[e^{rX}]{% endmath %} 为MGF， {% math %}r_-, r_+{% endmath %} 表示 {% math %}g_X(r){% endmath %} finite的下界和上界。threshold crossing考虑的问题为 {% math %}Pr\left\{\bigcup_{n=1}^\infty S_n\ge \alpha\right\}{% endmath %}
即随机游走的值大于threshold {% math %}\alpha{% endmath %} 的概率。

我们在这里假设 {% math %}\bar{X} < 0{% endmath %} ，但是{% math %}X{% endmath %} 取正取负的概率均大于0
## Chernoff bound
在[前面](http://modkzs.github.io/2016/02/28/%E6%BC%AB%E8%B0%88%E5%A4%A7%E6%95%B0%E5%AE%9A%E5%BE%8B/)曾经讨论过Chernoff bound：
{% math %}
Pr\left\{S_n \ge na\right\}\le \exp(n[\gamma_X(r)-ra])
{% endmath %}
其中 {% math %}\gamma_X(r) = \ln g_X(r){% endmath %}
tightest bound为
{% math %}
Pr\left\{S_n \ge na\right\}\le \exp(n\mu_X(a))\quad \mu_X(a) = \inf_{r\in(0, r_+)} \gamma_X(r)-ra
{% endmath %}
可以发现 {% math %}\gamma_X''(r)>0{% endmath %} ，故可将图像表示为：
![](http://ww1.sinaimg.cn/large/9dec4451jw1f24mxrjs98j20rs0860th.jpg)
所以 {% math %}Pr\left\{S_n \ge na\right\}\le \exp(n[\gamma(r_0)-r_0\gamma'(r_0)]), \gamma'(r_0)=a{% endmath %}

作进一步的替换可以得到
{% math %}
\begin{equation}
\label{eq:basic1}
Pr\left\{S_n \ge n\gamma'(r)\right\}\le \exp(n[\gamma(r)-r\gamma'(r)])
\end{equation}
{% endmath %}

## Tilted probabilities
和上面一样， {% math %}X_n{% endmath %} 为IID的rv， {% math %}g_X(r){% endmath %} 在 {% math %}(r_-,r_+){% endmath %} 范围内finite。在 {% math %}r\in(r_-,r_+){% endmath %} ，定义 {% math %}X{% endmath %} 的tilted PMF为
{% math %}
q_{X,r(x)} = p_X(x)\exp[rx-\gamma(r)]
{% endmath %}
易知： {% math %}q_{X,r(x)} \ge 0{% endmath %} 且 {% math %}\sum_x q_{X,r(x)} = \sum_x p_X(x)e^{rx}/E[e^{rx}] = 1{% endmath %} ，这是满足定义的。
所以有
{% math %}
q_{X^n,r(x_1,...,x_n)} = p_{X^n}(x_1,...,x_n)\exp(\sum_{i=1}^n[rx_i-\gamma(r)])
{% endmath %}
而 {% math %}S_n = \sum_{i=1}^n x_n{% endmath %} ，故
{% math %}
q_{S_n, r(S_n)} = p_{S_n}(S_n)\exp[rs_n-n\gamma(r)]
{% endmath %}
将tilted PMF下的期望记为 {% math %}E_r[X]{% endmath %} 。则
{% math %}
\begin{aligned}
E_r[X] &= \sum_x xq_{X,r(x)} = \sum_x xp_X(x)\exp[rx-\gamma(r)]\\
&= \frac{1}{g_X(r)}\sum_x\frac{d}{dr} p_X(x)\exp[rx]\\
&= \frac{g_X'(r)}{g_X(r)} = \gamma'(r)
\end{aligned}
{% endmath %}
根据WLLN( {% math %}\lim_{n\to\infty}Pr\left\{|\frac{S_n}{n}-\bar{X}|>\epsilon\right\} = 0{% endmath %} )，有
{% math %}
\begin{aligned}
1-\delta &\le \sum_{(\gamma'(r)-\epsilon)n \le s_n \le (\gamma'(r)-\epsilon)n} q_{S_n, r(s_n)}\\
& = \sum_{(\gamma'(r)-\epsilon)n \le s_n \le (\gamma'(r)-\epsilon)n} p_{S_n}(s_n) \exp[rs_n-n\gamma(r)]\\
& \le \sum_{(\gamma'(r)-\epsilon)n \le s_n \le (\gamma'(r)-\epsilon)n} p_{S_n}(s_n) \exp[n(r\gamma'(r)+r\epsilon-\gamma(r))]\\
& \le \sum_{(\gamma'(r)-\epsilon)n \le s_n} p_{S_n}(s_n)\exp[n(r\gamma'(r)+r\epsilon-\gamma(r))]\\
& = \exp[n(r\gamma'(r)+r\epsilon-\gamma(r))]Pr\left\{S_n \ge n(\gamma'(r)-\epsilon)\right\}
\end{aligned}
{% endmath %}
故
{% math %}
Pr\left\{S_n \ge n(\gamma'(r)-\epsilon)\right\}\ge(1-\delta)\exp[n(\gamma(r) - r\gamma'(r) - r\epsilon)]
{% endmath %}

## 回到threshold crossing
我们取 {% math %}r_0{% endmath %} 使得 {% math %}\gamma'(r_o) = \alpha/n{% endmath %} 。在此情况下，有：
{% math %}
\begin{equation}
\label{eq:basic2}
Pr\left\{S_n\ge \alpha\right\}\le \exp\left\{\alpha \Bigg[\frac{\gamma(r_o)}{\gamma'(r_o)}-r_o\Bigg]\right\}
\end{equation}
{% endmath %}
下图给出了其几何解释：
![](http://ww3.sinaimg.cn/large/9dec4451jw1f25r8d9wcnj20ss08waaz.jpg)
我们可以看到当 {% math %}n{% endmath %} 很大时，slope很小，所以 {% math %}r_o{% endmath %} 很小，水平的截断很大；当 {% math %}n{% endmath %} 开始减小时， {% math %}r_o{% endmath %} 开始增加，水平截断开始减小直到 {% math %}r_o = r^*{% endmath %} ；在这之后， {% math %}r_o{% endmath %} 继续增加，但是水平截断此时也开始增加。

从上面的描述可以发现：{% math %}r^*{% endmath %} 是水平截断最小时 {% math %}r{% endmath %} 的取值。所以有
{% math %}
Pr\left\{S_n\ge \alpha\right\} \le \exp(-r^* \alpha) \quad \text{for }\alpha > 0, n\ge 1
{% endmath %}
现在我们讨论 {% math %}r_+<\infty{% endmath %} 的情况。这时我们需要考虑2种情况： {% math %}\gamma(r_+){% endmath %} 是否为 finite。对于 {% math %}\gamma(r_+)=\infty{% endmath %} 的情况，当 {% math %}r\to r_+{% endmath %} 时， {% math %}\gamma(r)\to\infty{% endmath %} 。故 {% math %}r^*{% endmath %} 必然存在；对于 {% math %}\gamma(r_+)<\infty{% endmath %} ，如下图所示，如果 {% math %}r_o<r_+{% endmath %}，则 \ref{eq:basic1} 和 \ref{eq:basic2} 仍然成立。如果对于所有的 {% math %}r<r_+{% endmath %} 都有 {% math %}\alpha/n > \gamma'(r){% endmath %} ，则我们可以进一步优化不等式为：
{% math %}
Pr\left\{S_n \ge \alpha\right\}\le\exp\left\{n[\gamma(r_+)-r_+\alpha/n]\right\} = \exp\left\{\alpha[\gamma(r_+)n/\alpha-r_+]\right\}
{% endmath %}
![](http://ww1.sinaimg.cn/large/9dec4451jw1f25u1i1tb1j20qm09gmxw.jpg)
如果我们将 {% math %}r^*{% endmath %} 的定义修改为 {% math %}\sup_{r>0}\gamma(r)<0{% endmath %} ，这样两个式子就得到了统一。这样的情况下就可以计算 thresold crossing的问题了。不过这么算很麻烦，不够优雅(°д°) 接下来介绍一种优雅的方法

# Wald’s identity
我们在这里定义2个 thresold {% math %}\alpha>0, \beta<0{% endmath %} , thresold crossing问题在这里变成了 crossing其中任意一个 thresold 的问题(如下图)。
![](http://ww1.sinaimg.cn/large/9dec4451jw1f25x25be5dj20w40cy0tk.jpg)

令 {% math %}X_i{% endmath %} 为 IID 的 rv ，但是不全为0(不太能理解不全为0不就不是 IID 了么(・・))，{% math %}S_n = X_1+X_2+...+X_n{% endmath %} ，{% math %}\alpha>0,\beta <0{% endmath %} ，{% math %}J{% endmath %} 是最小的使得 {% math %}S_n\ge\alpha{% endmath %} 或 {% math %}S_n\le\beta{% endmath %} 的 {% math %}n{% endmath %} .则 {% math %}J{% endmath %} 是 rv (即 {% math %}\lim_{m\to\infty}Pr\left\{J \ge m\right\} = 0{% endmath %}),且各阶矩均为 finite.

这个的证明比较 trike.由于 {% math %}X{% endmath %} 不全为0,故必存在一些 {% math %}n{% endmath %} 使得 {% math %}Pr\left\{S_n \le -\alpha+\beta\right\} > 0,\  Pr\left\{S_n \le \alpha-\beta\right\} > 0{% endmath %} .在这种情况下,我们定义 {% math %}\epsilon = \max[Pr\left\{S_n \le -\alpha+\beta\right\}, Pr\left\{S_n \le \alpha-\beta\right\}]{% endmath %}

对于任何一个 {% math %}k\ge 1{% endmath %}, 假设 {% math %}J>n(k-1),\ S_{n(k-1)}\in(\beta, \alpha){% endmath %} ,则有:
{% math %}
Pr\left\{J>nk|J>n(k-1)\right\} \le 1-\epsilon\\
\Rightarrow Pr\left\{J>nk\right\}\le (1-\epsilon)^k
{% endmath %}
故 {% math %}J{% endmath %} 为 rv,且 {% math %}g_J(r){% endmath %} 在 {% math %}r=0{% endmath %} 时连续,故各阶矩均存在
## Wald’s identity
有了前面的定义后,我们在来谈本节的主角:Wald’s identity.定理表述如下:

令 {% math %}X_i{% endmath %} 为 IID 的 rv, {% math %}\gamma(r)=\ln\left\{E[e^{rX}]\right\}{% endmath %} ,且在 {% math %}r_-<0<r_+{% endmath %} 范围内 finite. 令 {% math %}S_n = X_1+X_2+...+X_n, \ \alpha>0,\ \beta<0,\ J{% endmath %} 为最小的令  {% math %}S_n\ge\alpha{% endmath %} 或 {% math %}S_n\le\beta{% endmath %} 的 {% math %}n{% endmath %} .对于所有的 {% math %}r \in (r_-,r_+){% endmath %}, 都有
{% math %}
E[\exp(rS_J-J\gamma(r))]=1
{% endmath %}
证明:我们使用前面提到过的 tilted PMF, 令 {% math %}X^n = (X_1, X_2,...,X_n)，\ s_n = \sum_{i=1}^n x_i{% endmath %} .则：
{% math %}
q_{X^n, r(x^n)} = p_{X^n}(x^n)\exp[rs_n-n\gamma(r)]
{% endmath %}
令 {% math %}\mathcal{T}_n{% endmath %} 表示 {% math %}X_1,X_2,...,X_n{% endmath %} 满足情况 {% math %}\beta<S_i<\alpha \text{ for }1\le i<n{% endmath %} 且 {% math %}S_n\ge\alpha{% endmath %} 或 {% math %}S_n\le\beta{% endmath %} 。所以 stopping trial {% math %}J{% endmath %} 的 tilted PMF 为
{% math %}
\begin{aligned}
q_{J,r(n)} &= \sum_{x^n\in\mathcal{T}_n} q_{X^n,r(x^n)} = \sum_{x^n\in\mathcal{T}_n} p_{X^n}(x^n)\exp[rs_n-n\gamma(r)]\\
&= E[\exp[rS_n-n\gamma(r)|J=n]]Pr\left\{J=n\right\}
\end{aligned}
{% endmath %}
等式两边对 {% math %}n{% endmath %} 求和即可
### 与 Wald’s equality 的关系
我们在 renewal process 中提到了Wald’s equality( {% math %}E[S_J] = \bar{X}E[J]{% endmath %} ).我们对 Wald’s identity 两边求导，可得：
{% math %}
E[S_J - J\gamma'(r)]\exp \left\{rS_J-J\gamma(r)\right\}= 0
{% endmath %}
令 {% math %}r=0{% endmath %} ，即可得到 Wald’s equality。如果我们取2阶导，可得：
{% math %}
E[(S_J-J\gamma'(r))^2-J\gamma''(r)]\exp \left\{rS_J-J\gamma(r)\right\}= 0
{% endmath %}
同样令 {% math %}r=0{% endmath %} ，可得：
{% math %}
E[S_J^2 - 2JS_J\bar{X} + J^2\bar{X}^2] = \sigma^2_XE[J]\\
{% endmath %}
当 {% math %}\bar{X}=0{% endmath %} 时，原式可以简化为 {% math %}E[S^2_J] = \sigma^2_XE[J]{% endmath %}

## 来考虑一个特殊情况
上面我们为了简化结果，假设 {% math %}\bar{X}=0{% endmath %} 。对于随机游走，我们也考虑这种情况，假设 {% math %}Pr\left\{X=1\right\}=1/2,\ Pr\left\{X=-1\right\}=1/2{% endmath %} 且 thresold {% math %}\alpha,\ \beta{% endmath %} 均为整数。故 {% math %}S_n{% endmath %} 在 crossing thresold之前，必然先是 thresold 。因此我们可以将 stopping trial 定义为 {% math %}S_J = \alpha{% endmath %} 或 {% math %}S_J = \beta{% endmath %} 。令 {% math %}q_\alpha = Pr\left\{S_J=\alpha\right\}{% endmath %} ，则 {% math %}S_J{% endmath %} 的期望为 {% math %}\alpha q_\alpha + \beta(1-q_\alpha){% endmath %} 。根据 Wald’sequality, {% math %}E[S_J] = 0{% endmath %} 。故有：
{% math %}
q_\alpha = \dfrac{-\beta}{\alpha-\beta}\quad 1-q_\alpha = \dfrac{\alpha}{\alpha-\beta}\\
\Rightarrow \sigma^2_XE[J] = E[S_J^2] = \alpha^2q_\alpha + \beta^2(1-q_\alpha)\\
\Rightarrow E[J] = -\beta\alpha/\delta^2_X = -\beta\alpha
{% endmath %}

## thresold crossing 的指数边界
在满足 Wald’s identity 的基础上，如果 {% math %}\bar{X}<0{% endmath %} 且对于 {% math %}r^* > 0{% endmath %} 有 {% math %}\gamma(r^* ) = 0{% endmath %} ，则有：
{% math %}
Pr\left\{S_J\ge\alpha\right\}\le\exp(-r^* \alpha)
{% endmath %}
证明：既然要满足 Wald’s identity，那么自然是要用的。我们令 {% math %}r = r^*{% endmath %} ，则Wald’s identity可以化为 {% math %}E[\exp(r^* S_J)]=1{% endmath %} 。而该式可以被表示为：
{% math %}
Pr\left\{S_J\ge\alpha\right\}E[\exp(r^* S_J)|S_J\ge\alpha] + Pr\left\{S_J\le\beta\right\}E[\exp(r^* S_J)|S_J\le\beta] = 1\\
\Rightarrow Pr\left\{S_J\ge\alpha\right\}E[\exp(r^* S_J)|S_J\ge\alpha]\le 1\\
\Rightarrow Pr\left\{S_J\ge\alpha\right\}\exp(r^* \alpha)\le 1
{% endmath %}
我们同样可以推导得到 {% math %}\beta{% endmath %} 的不等式

将上面的理论运用到 G/G/1 queue中，我们可以得到Kingman Bound：

令 {% math %}X_i, Y_i{% endmath %} 分别表示到达间隔和服务时间，队列初始为空，用户在0时刻到达。令 {% math %}U_i = Y_{i-1}-X_i, \gamma(r) = \ln\left\{E[e^{Ur}]\right\}{% endmath %} 。假设存在 {% math %}r^* >0{% endmath %} 使得 {% math %}\gamma(r) = 0{% endmath %} 。令 {% math %}W_n{% endmath %} 表示第 n 个顾客达到时队列的 queue delay。则：
{% math %}
Pr\left\{W_n\ge \alpha\right\}\le Pr\left\{W\ge \alpha\right\}\le\exp(-r^* \alpha)
{% endmath %}

对于 {% math %}\bar{X}>0{% endmath %} 我们可以通过交换符号的方式来处理 {% math %}S_J<\beta{% endmath %} 的情况。但是 {% math %}\bar{X}=0{% endmath %} 就不好做了。考虑 {% math %}Pr\left\{S_J\le \beta\right\} = 1-Pr\left\{S_J\ge \alpha\right\}{% endmath %} 。则可以解出
{% math %}
Pr\left\{S_J\ge \alpha\right\} = \dfrac{1-E[\exp(r^* S_J)|S_J\le\beta] }{E[\exp(r^* S_J)|S_J\ge\alpha] -E[\exp(r^* S_J)|S_J\le\beta] }
{% endmath %}
由于 {% math %}\alpha,\beta{% endmath %} 均为整数，故有 {% math %}E[\exp(r^* S_J)| S_J\le\beta] = \exp(r^* \beta),\ E[\exp(r^* S_J)| S_J\ge\alpha] = \exp(r^* \alpha){% endmath %} 。故
{% math %}
Pr\left\{S_J\ge \alpha\right\} = \dfrac{\exp(-r^* \alpha)[1-\exp(r^* \beta)] }{1 -\exp[-r^* (\alpha-\beta)] }
{% endmath %}

## binary hypothesis test
我们在前面讨论过 hypothesis test ，在这里主要讨论如何基于已有观测进行决策以及什么时间应该停止观测。首先回忆一下我们前面的定义：
{% math %}p_H(0) = p_0,\ p_H(1) = p_1{% endmath %} 。给定 {% math %}n{% endmath %} 个观测 {% math %}y_1, y_2, ...,y_n{% endmath %} ，有 likelihood ratio
{% math %}
\Lambda_n(y) = \prod_{i=1}^n \dfrac{f_{Y|H}(y_n|0)}{f_{Y|H}(y_n|1)}
{% endmath %}
在此基础上，我们定义 log-likelihood-ratio:
{% math %}
s_n = \sum_{i=1}^n z_n;\quad z_n =\ln\dfrac{f_{Y|H}(y_n|0)}{f_{Y|H}(y_n|1)}
{% endmath %}
我们给出选择标准：
{% math %}
s_n
\begin{cases}

> \ln(p_1/p_0) & \hat{h} = 0\\
\le \ln(p_1/p_0) & \hat{h} = 1

\end{cases}
{% endmath %}
这就又成了 thresold crossing 的问题。即， {% math %}Pr\left\{e|H=1\right\} = Pr\left\{S_n \ge \ln(p_1/p_0)|H=1\right\}{% endmath %} 。在此情况下，{% math %}\gamma_1(r)\text{ of } Z \text{ given }H=1{% endmath %} 可以表示为：
{% math %}
\begin{aligned}
\gamma_1(r) &= \ln\int_y f_{Y|H}(y|1)\exp\left\{r\Bigg[\ln \dfrac{f_{Y|H}(y|0)}{f_{Y|H}(y|1)}\Bigg]\right\}dy\\
&= \ln\int_y [f_{Y|H}(y|1)]^{1-r}[f_{Y|H}(y|0)]^r dy
\end{aligned}
{% endmath %}
可以发现 {% math %}\gamma_1(1) \ln\int_yf_{Y|H}(y|0)dy=0{% endmath %} ，即 {% math %}r^* = 1{% endmath %} 。用Chernoff bound可得：
{% math %}
Pr\left\{e|H=1\right\}\le\exp\left\{n(\min_r\gamma_1(r)-ra)\right\}\quad a = \dfrac{1}{n}\ln(p_1/p_0)
{% endmath %}
上面不等式可以用下图表示：
![](http://ww1.sinaimg.cn/large/9dec4451jw1f26tjqe74nj20x0098gmu.jpg)
同样的，我们可以找到 {% math %}Pr\left\{e|H=0\right\}{% endmath %} 。首先
{% math %}
\gamma_0(r)= \ln\int_y [f_{Y|H}(y|1)]^{-r}[f_{Y|H}(y|0)]^{1+r} dy
{% endmath %}
可以发现 {% math %}\gamma_0(r)=\gamma_1(r-1){% endmath %} 。故
{% math %}
Pr\left\{e|H=0\right\}\le\exp\left\{n[\min_r\gamma_1(r)+(1-r)a]\right\}
{% endmath %}

再一次观测结束之后，我们可以有3种选择：接受 hypothesis 1, 接受 hypothesis 2或者继续实验。我们在前面研究了前两个选项，我们在这里研究第三个选项。这显然是一个 stopping trial。

我们假设当 stopping 发生时， {% math %}\hat{h} = 0 \text{ if } S_J>\alpha{% endmath %} ，{% math %}\hat{h} = 1 \text{ if } S_J<\beta{% endmath %} 。则错误判断的概率分别为：
{% math %}
Pr\left\{e|H=1\right\} = Pr\left\{S_J\ge \alpha|H=1\right\} \le \exp-\alpha\\
Pr\left\{e|H=0\right\} = Pr\left\{S_J\le \beta|H=0\right\} \le \exp\beta
{% endmath %}
随着我们增加 {% math %}\alpha,\beta{% endmath %} ，错误率会越来越低。
根据 Wald’s equality ，有：
{% math %}
E[J|H=0] = \dfrac{E[S_J|H=0]}{E[Z|H=0]} \approx\dfrac{\alpha + E[overshoot]}{E[Z|H=0]}
{% endmath %}
上式种我们忽视了 crossing thresold {% math %}\beta{% endmath %} 的概率，因为 {% math %}\alpha{% endmath %} 和 {% math %}\beta{% endmath %} 很大的情况下，这种概率很小。

## crossing time 以及 barrier 的联合分布
最后我们考察 {% math %}Pr\left\{J\ge n, S_J \ge \alpha\right\}{% endmath %} 。同样假设 {% math %}\bar{X}<0{% endmath %} ，对于部分 {% math %}r^* > 0{% endmath %} ，有 {% math %}\gamma(r)\le 0{% endmath %} 。对于 $0\le r\le r^* ,J
\ge n{% math %} ，有 {% endmath %}-J\gamma(r)\ge -n\gamma(r)$ 根据 Wald identity，有
{% math %}
\begin{aligned}
1 &\ge E[\exp[rS_J-J\gamma(r)]|J\ge n, S_J \ge \alpha] Pr\left\{J\ge n, S_J \ge \alpha\right\}
&\ge \exp[r\alpha-n \gamma(r)]Pr\left\{J\ge n, S_J \ge \alpha\right\}
\end{aligned}
{% endmath %}
{% math %}
\Rightarrow Pr\left\{J\ge n, S_J \ge \alpha\right\} \le \exp[n \gamma(r) - r\alpha]
{% endmath %}
因为 {% math %}r\in(0, r^* ]{% endmath %} ，我们可以获得上式的 tightest bound。 定义 {% math %}n^* = \alpha/\gamma'(r^* ){% endmath %} ，则：
{% math %}
Pr\left\{J\ge n, S_J \ge \alpha\right\} \le
\begin{cases}
\exp[n\gamma(r_o) -r_o\alpha] & \text{for }n> n^* , \alpha/n = \gamma'(r_o)\\
\exp[-r^* \alpha] & n \le n^*
\end{cases}
{% endmath %}

# Martingales
Martingales 是一种 integer-time 随机过程，定义为 {% math %}Z_n{% endmath %} ，满足 {% math %}E[|Z_n|] < \infty{% endmath %} 且
{% math %}
E[Z_n|Z_{n-1},Z_{n-2},...,Z_1] = Z_{n-1}
{% endmath %}
对于上面的定义，一般有两种解读的视角：第一种就是直接来看， {% math %}E[Z_n|Z_{n-1}=z_{n-1},Z_{n-2}=z_{n-2},...,Z_1=z_1] = z_{n-1}{% endmath %} ；第二种将 {% math %}E[Z_n|Z_{n-1},Z_{n-2},...,Z_1]{% endmath %} 看做一个函数。第二种看法更加复杂，必然也更加强大。

Martingales 和 markov 很像，不过前者是期望，后者是概率。

## 一些例子
Martingales 可能是我目前看到的随机过程里面最抽象的一个了。所以举几个例子加深一下印象
### Random walk
martingale 的例子之一就是0期望的随机游走。这一点很容易看到：
{% math %}
\begin{aligned}
E[Z_n|Z_{n-1}, Z_{n-2},...,Z_1] &= E[X_n+Z_{n-1}|Z_{n-1}, Z_{n-2},...,Z_1]
&= E[X_n]+Z_{n-1} = Z_{n-1}
\end{aligned}
{% endmath %}
当然，对于任意的 rv {% math %}X{% endmath %} 来说，令 {% math %}Z_n = S_n-n\bar{X}{% endmath %} 也可以做到这一点。
### Sums of dependent zero-mean variables
令 {% math %}X_i{% endmath %} 为相关的 rv 且满足 {% math %}E[X_i|X_{i-1},...,X_1] = 0{% endmath %} ，{% math %}Z_n = X_1+X_2+...+X_n{% endmath %} 。则：
{% math %}
\begin{aligned}
E[Z_n|Z_{n-1},...,Z_1] &= E[X_n+Z_{n-1}|Z_{n-1},...,Z_1]\\
&= E[X_n|Z_{n-1},...,Z_1] + E[Z_{n-1}|Z_{n-1},...,Z_1]
&= Z_{n-1}
\end{aligned}
{% endmath %}
### Product-form martingales
和上面的差不多，不过是把加法换成了乘法，即 {% math %}Z_n=X_1X_2...X_n{% endmath %} 如果 {% math %}X_i{% endmath %} 的均值为1，则：
{% math %}
\begin{aligned}
E[Z_n|Z_{n-1},...,Z_1] &= E[X_nZ_{n-1}|Z_{n-1},...,Z_1]\\
&=E[X_n]E[Z_{n-1}|Z_{n-1},...,Z_1] = Z_{n-1}
\end{aligned}
{% endmath %}
乘法的 martingale 有一个很重要应用。 我们假设 {% math %}X_i{% endmath %} 为 IID ，{% math %}S_n = X_1+X_2+...+X_n{% endmath %} 为随机游走， {% math %}\gamma(r) = \ln\left\{E[\exp(rX)]\right\}{% endmath %} 。定义 {% math %}Z_n{% endmath %} 为
{% math %}
\begin{aligned}
Z_n &= \exp\left\{rS_n-n\gamma(r)\right\}\\
&= \exp\left\{rX_n-\gamma(r)\right\}\exp\left\{rS_{n-1}-(n-1)\gamma(r)\right\}\\
&=\exp\left\{rX_n-\gamma(r)\right\} Z_{n-1}
\end{aligned}
{% endmath %}
故
{% math %}
E[Z_n|Z_{n-1},...,Z_1] = E[\exp\left\{rX_n-\gamma(r)\right\}]E[Z_{n-1}|Z_{n-1},...,Z_1] = Z_{n-1}
{% endmath %}

### branching process
我们[之前](http://modkzs.github.io/2016/03/12/countable-state-markov-chain/#Branching_process)曾经讨论过branching process。branching process可以抽象为两个变量，其中 {% math %}Y_{i,n}{% endmath %} 为 IID， {% math %}X_{n+1} = \sum_{i=1}^{X_n}Y_{i,n}{% endmath %} 。

令 {% math %}\bar{Y}=E[Y_{i,n}]{% endmath %} ，则 {% math %}E[X_n|X_{n-1}]=\bar{Y}X_{n-1}{% endmath %} 。我们定义 {% math %}Z_n=X_n/\bar{Y}^n{% endmath %} ，则：
{% math %}
E[Z_n|Z_{n-1},...,Z_1] = E[\dfrac{X_n}{\bar{Y}^n}|X_{n-1},...,X_1]= \dfrac{\bar{Y}X_{n-1}}{\bar{Y}^n} = Z_{n-1}
{% endmath %}

可以看到，{% math %}Z_n{% endmath %} 也是 martingale

## 过去和未来的 partial isolation
令 {% math %}Z_n{% endmath %} 为 martingale 对于任意的 {% math %}1\le i <n{% endmath %} ，有
{% math %}
E[Z_n|Z_i, Z_{i-1},...,Z_1] = Z_i
{% endmath %}

证明：对于 {% math %}n=i+1{% endmath %} ，有 {% math %}E[Z_{i+1}|Z_i,...,Z_1] = Z_i{% endmath %} 。我们可以用下面的方法计算 {% math %}E[Z_{i+2}|Z_i,...,Z_1]{% endmath %} :
{% math %}
\begin{aligned}
E[Z_{i+2}|Z_i,...,Z_1] &= E[E[Z_{i+2}|Z_{i+1},...,Z_1]|Z_i,...,Z_1] \\
&= E[Z_{i+1}|Z_i,...,Z_1] = Z_i
\end{aligned}
{% endmath %}
同样的方法可以用来计算 {% math %}E[Z_{i+3}|Z_i,...,Z_1]{% endmath %} 等等。当然最后我们有：
{% math %}
E[Z_n] = E[Z_1]
{% endmath %}

用在前面乘法的例子种，可以得到：
{% math %}
\begin{aligned}
E[\exp(rS_n-n\gamma(r))] &= E[\exp(rX-\gamma(r))]\\
&= E[\exp(rX)]/g(r) = 1
\end{aligned}
{% endmath %}

## submartingale 以及 supermartingale
submartingale 和 supermartingale都是martingale最简单的泛化。具体的定义如下：

同样对于integer-time随机过程 {% math %}Z_n{% endmath %} 满足 {% math %}E[|Z_n|]<\infty{% endmath %} ，如果满足 {% math %}E[Z_n|Z_{n-1}, Z_{n-2},...,Z_1] \ge Z_{n-1}{% endmath %} ，则是submartingale；如果满足 {% math %}E[Z_n|Z_{n-1}, Z_{n-2},...,Z_1] \le Z_{n-1}{% endmath %} ，则是supermartingale。

注意到martingale同时满足两个定义，所以它既是 submartingale ，也是 supermartingale 。如果 {% math %}Z_n{% endmath %} 为submartingale ，则 {% math %}-Z_n{% endmath %} 为 supermartingale。

对于partial isolation，修改如下：

令 {% math %}1\le i < n{% endmath %} ，对于submartingale有 {% math %}E[Z_n|Z_i,...Z_1]\ge Z_i{% endmath %} ；对于supermartingale有 {% math %}E[Z_n|Z_i,...Z_1]\le Z_i{% endmath %} 。

随机游走 S_n 是 submartingale, martingale, supermartingale 分别对应 {% math %}\bar{X}\ge 0, \bar{X}= 0, \bar{X}\le 0{% endmath %} ；同样如果存在semi- invariant moment generating function {% math %}\gamma(r){% endmath %} ，定义 {% math %}Z_n = \exp(rS_n){% endmath %} ，{% math %}Z_n{% endmath %} 为 submartingale, martingale, supermartingale 分别对应 {% math %}\gamma(r) \ge 0,\gamma(r) = 0 ,\gamma(r) \le 0  {% endmath %}

如果 {% math %}h(x){% endmath %} 为凸函数，对于 submartingale 或者 martingale {% math %}Z_n{% endmath %} ，{% math %}h(Z_n){% endmath %} 也是 submartingale 。证明很简单，直接用Jensen不等式就行了。

# stopped processes and stopping trials
在 renewal process 中我们讨论过 [stopping trial](http://modkzs.github.io/2016/03/09/renewal-process/#stopping_trial) 。如果 {% math %}J{% endmath %} 是一个defective rv，那么将 {% math %}J{% endmath %} 称为defective stopping trial(即该过程必然终止)。如果没有说明，我们将 {% math %}J{% endmath %} 称为possibly-defective stopping trial 。

对于 possibly-defective stopping trial {% math %}J{% endmath %} 我们定义 stopped process {% math %}Z_n^* = Z_n{% endmath %} 如果 {% math %}J\ge n{% endmath %} 否则 {% math %}Z_n^* = Z_J{% endmath %} 。
对于 {% math %}Z_n^*{% endmath %} 和 {% math %}Z_n{% endmath %} 来说，如果 {% math %}Z_n{% endmath %} 为 submartingale，{% math %}Z_n^*{% endmath %} 也是 submartingale 。对于其他两种情况也一样。

给定一个随机过程 {% math %}Z_n{% endmath %}, possibly-defective stopping trial  {% math %}J{% endmath %} ，则我们可以找到对应的 {% math %}Z_n^*{% endmath %} 。其与 {% math %}Z_n{% endmath %} 的关系如下：
{% math %}
E[Z_1] \le E[Z_n^*] \le E[Z_n] \quad \text{(submartingale)} \\
E[Z_1] = E[Z_n^*] = E[Z_n] \quad \text{(martingale)} \\
E[Z_1] \ge E[Z_n^*] \ge E[Z_n] \quad \text{(supermartingale)} \\
{% endmath %}

令 {% math %}J{% endmath %} 为 martingale {% math %}Z_n{% endmath %} 的 stopping trial ，则 {% math %}E[Z_n] = E[Z_1]{% endmath %} 当且仅当
{% math %}
\lim_{n\to\infty}E[Z_n|J>n]Pr\left\{J>n\right\} = 0,\ E[|Z_J|] < \infty
{% endmath %}

# The Kolmogorov inequalities
Kolmogorov’s submartingale inequalities 表述如下：

{% math %}Z_n{% endmath %} 为非负的 submartingale，对于所有的正整数 {% math %}m{% endmath %} 以及正数 {% math %}a{% endmath %} ,都有
{% math %}
Pr\left\{\max_{1\le i \le m} Z_i\ge a\right\} \le \dfrac{E[Z_m]}{a}
{% endmath %}
证明： 对于一个非负的 martingale {% math %}Z_n{% endmath %} ，给定正数 {% math %}a{% endmath %} 和正整数 {% math %}m{% endmath %} ，我们定义 stopping trial {% math %}J{% endmath %} 为 最早的 {% math %}n\le m{% endmath %} 满足 {% math %}Z_n\ge a{% endmath %} 。如果对于所有的 {% math %}n\le m,\ Z_n<a{% endmath %} 则 {% math %}n=m{% endmath %} 。所以 {% math %}J{% endmath %} 必然会在 {% math %}m{% endmath %} 停止。故：
{% math %}
Pr\left\{\max_{1\le i \le m}Z_i\ge a\right\} = Pr{Z_J\ge a}\le \dfrac{E[Z_J]}{a}
{% endmath %}
由于 {% math %}J{% endmath %} 必在 {% math %}m{% endmath %} 停止，故 {% math %}Z_J = Z_m^*{% endmath %} 。而 {% math %}E[Z_m^*]\le E[Z_m]{% endmath %} 带入原式即得证。

从这个不等式出发，我们可以推导出一系列不等式。

## 一些衍生的不等式
### Nonnegative martingale inequality
令 {% math %}Z_n{% endmath %} 为非负的martingale， {% math %}a>0{% endmath %} 则：
{% math %}
Pr\left\{\sup_{n \ge 1} Z_n\ge a\right\} \le \dfrac{E[Z_1]}{a}
{% endmath %}

### Kolmogorov’s martingale inequality
令 {% math %}Z_n{% endmath %} 为 martingale 满足 {% math %}E[Z_n^2]<\infty{% endmath %}， {% math %}b>0,m >1{% endmath %} 故
{% math %}
Pr\left\{\max_{1\le n \le m} |Z_n|\ge b\right\} \le \dfrac{E[Z_m^2]}{b^2}
{% endmath %}

### Kolmogorov’s random walk inequality
{% math %}X_i{% endmath %} 为 IID 的 rv，均值为 {% math %}\bar{X}{% endmath %} ，方差为 {% math %}\sigma^2{% endmath %} ，{% math %}S_n=X_1+X_2+...+X_n{% endmath %} 。对于任意正整数 {% math %}m{% endmath %} 和正数 {% math %}\epsilon{% endmath %} ，有：
{% math %}
Pr\left\{\max_{1\le n \le m} |S_n-n\bar{X}|\ge m\epsilon\right\}\le \dfrac{\sigma^2}{m\epsilon^2}
{% endmath %}

### 还有2个没名字的
{% math %}S_n=X_1+X_2+...+X_n{% endmath %} 为随机游走， {% math %}X_i{% endmath %} 有均值 {% math %}\bar{X}{% endmath %} 和 semi-invariant moment generating function {% math %}\gamma(x){% endmath %} 。对于任意一个 {% math %}r>0{% endmath %} 满足 {% math %}0<\gamma(r)<\infty{% endmath %} ， {% math %}a>0{% endmath %} ，有：
{% math %}
Pr\left\{\max_{1\le n \le m}S_i\ge\alpha\right\}\le \exp\left\{-r\alpha + n\gamma(r)\right\}
{% endmath %}

令 {% math %}Z_n{% endmath %} 为非负的 submartingale，对于任意的正整数 {% math %}m{% endmath %} 和 {% math %}a>0{% endmath %} ，都有
{% math %}
Pr\left\{\bigcup_{i\ge m}\left\{Z_i\ge a\right\}\right\}\le \dfrac{E[Z_m]}{a}
{% endmath %}

## SLLN
[之前](http://modkzs.github.io/2016/03/09/renewal-process/#WP1)曾经证明过4阶矩存在时的SLLN，这里我们们削弱一下条件，证明二阶矩存在即可。

首先还是说明下SLLN。令 {% math %}X_i{% endmath %} 为 IID 的 rv，均值为 {% math %}\bar{X}{% endmath %} ，方差为 {% math %}\sigma^2<\infty{% endmath %} ，令 {% math %}S_n = X_1+X_2+...+X_n{% endmath %} 。则对于任意的 {% math %}\epsilon > 0{% endmath %} 都有
{% math %}
Pr\left\{\lim_{n\to\infty}\dfrac{S_n}{n}=\bar{X}\right\} = 1\\
\lim_{n\to\infty}Pr\left\{\bigcup_{m > n}\bigg|\dfrac{S_m}{m}-\bar{X}\bigg|>\epsilon\right\} = 0
{% endmath %}
当然了，这两个式子是等价的，所以我们只要证明后一个就好了
{% math %}
\begin{aligned}
Pr\left\{\bigcup_{m > 2^k}\bigg|\dfrac{S_m}{m}-\bar{X}\bigg|>\epsilon\right\} &= Pr\left\{\bigcup_{j=k}^\infty\bigcup_{m=2^j+1}^{2^{j+1}}\bigg|\dfrac{S_m}{m}-\bar{X}\bigg|>\epsilon\right\}\\
&\le \sum_{j=k}^\infty Pr\left\{\bigcup_{m=2^j+1}^{2^{j+1}}\bigg|\dfrac{S_m}{m}-\bar{X}\bigg|>\epsilon\right\}\\
&= \sum_{j=k}^\infty Pr\left\{\bigcup_{m=2^j+1}^{2^{j+1}}|S_m-m\bar{X}|>\epsilon m\right\}\\
&\le \sum_{j=k}^\infty Pr\left\{\bigcup_{m=2^j+1}^{2^{j+1}}|S_m-m\bar{X}|>\epsilon 2^j\right\}\\
&= \sum_{j=k}^\infty Pr\left\{\max_{2^j+1\le m \le 2^{j+1}}|S_m-m\bar{X}|>\epsilon 2^j\right\}\\
&\le \sum_{j=k}^\infty Pr\left\{\max_{1\le m \le 2^{j+1}}|S_m-m\bar{X}|>\epsilon 2^j\right\}\\
&\le \sum_{j=k}^\infty \dfrac{2^{j+1}\sigma^2}{\epsilon^22^{2j}} = \dfrac{2^{-k+2}\sigma^2}{\epsilon^2}
\end{aligned}
{% endmath %}

## martingale convergence theorem
由Kolmogorov submartingale inequalit可以推出的非常重要的结论，表述如下：

{% math %}Z_i{% endmath %} 为 martingale 且存在 {% math %}M<\infty{% endmath %} 使得 {% math %}E[Z_n^2]\ge M{% endmath %} 。则存在一个 rv {% math %}Z{% endmath %} 使得 {% math %}\lim_{n\to\infty}Z_n=Z{% endmath %}

证明：易知，{% math %}Z_i{% endmath %} 也是 submartingale 。因此 {% math %}E[Z_n^2]{% endmath %} 在 {% math %}n{% endmath %} 上递增。由于 {% math %}E[Z_n^2]\ge M{% endmath %} 故必有 {% math %}\lim_{n\to\infty}E[Z_n^2] = M'{% endmath %} 。由于对于任意正整数{% math %}k{% endmath %} {% math %}Y_n = Z_{k+n}-Z_k{% endmath %} 是均值为0的martingale，因此
{% math %}
Pr\left\{\max_{1\le n \le m}|Z_{k+n}-Z_k|\ge b\right\}\le \dfrac{E[(Z_{k+m}-Z_k)^2]}{b^2}
{% endmath %}
由 {% math %}E[Z_{k+m}Z_k|Z_k = z_k, Z_{k-1}=z_{k-1},...,Z_1=z_1] = z_k^2{% endmath %} 故 {% math %}E[(Z_{k+m}-Z_k)^2] = E[Z_{k+m}^2]-E[Z_{k}^2]\le M'-E[Z_{k}^2]{% endmath %} 。故
{% math %}
Pr\left\{\sup_{n \ge 1}|Z_{k+n}-Z_k|\ge b\right\}\le \dfrac{M'-E[Z_k^2]}{b^2} = 0
{% endmath %}

故
{% math %}
Pr\left\{\sup_{n \ge 1}|Z_{k+n}-Z_k|\ge b\right\} = 0
{% endmath %}
