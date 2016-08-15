title: possion process
tags: [stochastic process]
date: 2016-03-01 22:41:20
categories: math
---
arrival process中重要的成员，泊松过程(虽然不知道英文发音是posong为啥汉语是bosong)。
<!--more-->
# 概念
## arrival process 三要素
一个arrival process最重要的元素是什么呢？窝们来看发工资的例子。假设公司每次发放的工资数量是固定的，那么我们就只能考虑三个问题：
- 什么时候发工资？
- 隔多久发一次？
- 一个月能发几次？
当然了你会说这3问题有冗余啊！我只要2个就够了。当然了，不同的场景我们会需要不同的问题。而这三个问题就构成了一个arrival process的3个核心rv：{% math %}S_n,X,N(t){% endmath %}

{% math %}S_n{% endmath %} 表示第n个到达事件发生的时间(第n次发工资的时间)，被称为arrival epoch；{% math %}X{% endmath %} 表示2个相邻到达事件的发生间隔； {% math %}N(t){% endmath %} 表示t个单位时间内到达事件发生的次数(t个月发了多少次工资)，被称为counting process

三者的关系可以用下图表示：
![](http://ww2.sinaimg.cn/large/9dec4451jw1f1hr9u473tj20r008uq3s.jpg)

我们可以从定义中直观的推导出：
{% math %}
\begin{equation}
\left\{N(t) \ge n\right\} = \left\{S_n \le t\right\}\\
\left\{N(t) < n\right\} = \left\{S_n > t\right\}
\label{eq:basic}
\end{equation}
{% endmath %}

## poisson process
poisson process是 {% math %}X{% endmath %} 为IID且服从指数分布的arrival process，即 {% math %}f_X(x)=\lambda \exp(-\lambda x){% endmath %}

# poisson的一些性质
## memoryless
我们称rv {% math %}X{% endmath %} 为memoryless当对于任何的 {% math %}x>0,t>0{% endmath %} 都有 {% math %}Pr\left\{X>t+x\right\}=Pr\left\{X>t\right\}Pr\left\{X>x\right\}{% endmath %} 且 {% math %}Pr\left\{X>0\right\}=1{% endmath %}

从数学上可以证明，满足上面要求的rv必服从指数族分布（取ln然后证明对数为线性）。

如果我们将当前时间与下一次到达事件发生时间的间隔定义为rv Z(简单的说就是从现在开始还有多久发工资)。用下图可以直观的说明Z到底是啥：
![](http://ww4.sinaimg.cn/large/9dec4451gw1f1i9tyfveyj20o406uaaa.jpg)

通过memoryless，我们可以证明：{% math %}F_Z(z) = 1-e^{-\lambda z}{% endmath %} ：
首先证明上图，也就是 {% math %}N(t)=0{% endmath %}
{% math %}
\begin{aligned}
Pr\left\{Z>z|N(t)=0\right\} &= Pr\left\{X_1>z+t|N(t)=0\right\}\\
&=Pr\left\{X_1>z+t|X_1>t\right\}\\
&=Pr\left\{X_1>z\right\} = e^{-\lambda z}
\end{aligned}
{% endmath %}
最后一步的推导用了memoryless进行分解后得到的。
然后证明在 {% math %}N(t)=n,S_n=\tau{% endmath %} 的情况。可以发现，在这种情况下，必有 {% math %}X_{n+1} > t-\tau{% endmath %}
{% math %}
\begin{aligned}
Pr\left\{Z>z|N(t)=n,S_n=\tau\right\} &= Pr\left\{X_{n+1}>z+t-\tau|N(t)=n,S_n=\tau\right\}\\
&=Pr\left\{X_{n+1}>z+t-\tau|X_{n+1} > t-\tau,S_n=\tau\right\}\\
&=Pr\left\{X_{n+1}>z+t-\tau|X_{n+1} > t-\tau\right\}\\
&=Pr\left\{X_{n+1}>z\right\} = e^{-\lambda z}

\end{aligned}
{% endmath %}
上面不等式对于 {% math %}S_1,S_2...S_{n-1}{% endmath %} 均成立。所以有 {% math %}Pr\left\{Z>z|\left\{N(\tau),0<\tau\le t\right\}\right\} = e^{-\lambda z}{% endmath %}

## stationary and independent increment
这两个性质都是针对counting process的
### stationary increment
一个counting process满足stationary increment 当对任意 {% math %}t'>t>0{% endmath %} ，{% math %}N(t'-t){% endmath %} 和 {% math %}N(t')-N(t){% endmath %} 同分布
### independent increment
一个counting process满足stationary increment 当对任意正整数 {% math %}k{% endmath %} ，以及 {% math %}k{% endmath %} 维的时间 {% math %}0<t_1<t_2<...<t_k{% endmath %} ，都有 {% math %}N(t_1), \tilde{N}(t_1, t_2),..., \tilde{N}(t_{k-1}, t_k){% endmath %} 独立，其中 {% math %}\tilde{N}(t_1, t_2) = N(t_2)-N(t_1){% endmath %}

poisson process 同时具有上面两个性质

## PDF for {% math %}S_n{% endmath %}
{% math %}
f_{S_n}(t) = \dfrac{\lambda^nt^{n-1}exp(-\lambda t)}{(n-1)!}
{% endmath %}

### 证明
{% math %}
\begin{aligned}
f_{X_1S_2}(x_1,s_2)&=f_{X_1}(x_1)f_{X_2}(s_2-x_1)\\
&=\lambda^2\exp(-\lambda x_1)\exp(-\lambda(s_2-x_1))\\
&=\lambda^2\exp(-\lambda s_2)\\
\end{aligned}
{% endmath %}

逐个递推，可得：
{% math %}
f_{X_1...X_{n-1}S_n}(x_1,...x_{n-1},s_n) =\lambda^n\exp(-\lambda s_n)
{% endmath %}

由于 {% math %}x_1, x_2...x_{n-1}{% endmath %} 有 {% math %}(n-1)!{% endmath %} 种排列方式，所以除一下就行了。
## PMF for {% math %}N(t){% endmath %}
{% math %}
\begin{equation}
p_{N(t)}(n) = \dfrac{(\lambda t)^n\exp(-\lambda t)}{n!}
\label{eq:pmf}
\end{equation}
{% endmath %}

### 证明
这有2种求法，这里先说第一种。

如果要求{% math %}Pr\left\{t<S_{n+1}\le t+\sigma \right\}{% endmath %}，其中 {% math %}\sigma{% endmath %} 无限趋向于0，可以有下面两种求法。
{% math %}
Pr\left\{t<S_{n+1}\le t+\sigma \right\} = \int_t^{t+\sigma} f_{S_{n+1}}(\tau) d\tau = f_{S_{n+1}}(t)(\sigma+o(\sigma))\\
Pr\left\{t<S_{n+1}\le t+\sigma \right\} = p_{N(t)}(\lambda \sigma + o(\sigma))+o(\sigma)
{% endmath %}
第一种就是根据上面 {% math %}S_n{% endmath %} 的式子求。然后 {% math %}t<S_{n+1}\le t+\sigma{% endmath %}等价于在时间t来了n次，然后在t到 {% math %}t+\sigma{% endmath %} 来了一次。{% math %}p_{\tilde{N}(t, t+\sigma)}{% endmath %} 仍然可以用 {% math %}S_n{% endmath %} 的PDF进行计算，即

{% math %}
p_{\tilde{N}(t, t+\sigma)} = p_{\tilde{N}(\sigma)} = \int_0^\sigma f_{S_1(t)} dt = \lambda \sigma + o(\sigma )
{% endmath %}

联立两式，即可求得{% math %}p_{N(t)}(n){% endmath %}。

第二种证明方法使用了前面说的基础不等式 \ref{eq:basic}

计算两者的概率，可得： {% math %}\sum_{i=n}^\infty p_{N(t)}(i) = \int_0^tf_{S_n}(\tau)d\tau{% endmath %}

我们将前面 {% math %}p_{N(t)}(i){% endmath %} 和 {% math %}f_{S_n}(\tau){% endmath %} 公式带入，两边同时对 {% math %}t{% endmath %} 求导，可以发现两者相等，得证。

## poisson 的另外2种定义
在最开始我们给出了poisson的基础定义。根据前面给出的性质，我们可以给出poisson的另外2个定义：
### 定义二
一个 poisson counting process 是一个有independent and stationary increment 且有poisson PMF(即\ref{eq:pmf}) 的counting process
### 定义三
一个 poisson counting process 是一个有independent and stationary increment 且满足下面等式的counting process
{% math %}
Pr\left\{\tilde{N}(t,t+\delta)=0\right\}=e^{-\lambda\delta}=1-\lambda\delta + o(\delta)\\
Pr\left\{\tilde{N}(t,t+\delta)=1\right\}=\lambda \delta e^{-\lambda\delta}\approx\lambda \delta+o(\delta)\\
Pr\left\{\tilde{N}(t,t+\delta)=2\right\}\approx o(\delta)\\
{% endmath %}

很容易证明，三个定义是等价的。

# poisson的分裂和合并
## 分裂
假设我们将 {% math %}N(t){% endmath %} 分裂为2个随机过程 {% math %}N_1(t), N_2(t){% endmath %} 。我们将每次到达事件的发生视为一个二项分布：到达事件为第一个过程产生的概率为 {% math %}p{% endmath %} ，为第二个过程产生的概率为 {% math %}1-p{% endmath %} 。我们考虑一个很短的时间间隔 {% math %}(t, t+\delta]{% endmath %} ，根据前面的说明，在这段时间内产生一个达到事件的概率为 {% math %}\lambda \delta{% endmath %} 。则易知，到达事件为第一个过程产生的概率为 {% math %}p\lambda \delta{% endmath %} ，为第二个过程产生的概率为 {% math %}(1-p)\lambda \delta{% endmath %} 。现在我们需要证明 {% math %}N_1(t), N_2(t){% endmath %} 独立。
{% math %}
\begin{aligned}
Pr\left\{N_1(t)=m,N_2(t)=k\right\} &= Pr\left\{N_1(t)=m,N_2(t)=k|N(t)=m+k\right\}Pr\left\{N(t)=m+k\right\}\\
&=\dfrac{(m+k)!}{m!k!}p^m(1-p)^k\dfrac{(\lambda t)^{m+k}e^{-\lambda t}}{(m+k)!}\\
&=\dfrac{(p\lambda t)^me^{-p\lambda t}}{m!}\dfrac{[(1-p)\lambda  t]^ke^{-\lambda(1-p)t}}{k!}\\
&=Pr\left\{N_1(t)=m\right\}Pr\left\{N_2(t)=k\right\}
\end{aligned}
{% endmath %}

故{% math %}N_1(t), N_2(t){% endmath %} 独立，rate 分别为 {% math %}p\lambda, (1-p)\lambda{% endmath %}

## 合并
{% math %}N_1(t), N_2(t){% endmath %} 是两个独立的poisson process， rate分别为 {% math %}\lambda_1, \lambda_2{% endmath %} 。如果我们将这两个到达视为一个过程 {% math %}N(t){% endmath %} ，通过定义三，我们可以得到新的poisson process的rate {% math %}\lambda = \lambda_1 + \lambda_2{% endmath %}

# Non_homogeneous poisson process
与正常poisson process不同的是，non_homogeneous poisson process的 {% math %}\lambda{% endmath %} 是随时间变化的。也就是说non_homogeneous poisson process不再满足stationary increment。定义三中的等式也要换成下面的形式：
{% math %}
Pr\left\{\tilde{N}(t,t+\delta)=0\right\} = 1-\delta\lambda(t) + o(\delta)\\
Pr\left\{\tilde{N}(t,t+\delta)=1\right\} = \delta\lambda(t) + o(\delta)\\
Pr\left\{\tilde{N}(t,t+\delta)\ge2\right\} = o(\delta)
{% endmath %}

对于 non_homogeneous poisson process，{% math %}\tilde{N}(t,t+\delta){% endmath %} 的PMF
{% math %}
Pr\left\{\tilde{N}(t,t+\delta)=n\right\} = \dfrac{[\tilde{m}(t, \tau)]^n\exp[\tilde{m}(t, \tau)]}{n!} \quad \tilde{m}(t, \tau)=\int_t^\tau \lambda(u)du
{% endmath %}

# conditional arrival
令 {% math %}S^{(n)}=S_1,S_2,...,S_n;0<S_1<S_2<...<S_n<t{% endmath %} ，则：
{% math %}
f_{S^{(n)}|N(t)}(s^{(n)}|n) = \dfrac{n!}{t^n}
{% endmath %}

## 证明
该概率同样存在2种证明方法。
### 方法一
首先用贝叶斯计算 {% math %}S^{(n+1)}|N(t){% endmath %} :
{% math %}
f_{S^{(n+1)}|N(t)}(s^{(n+1)}|n)p_{N(t)}(n) = f_{N(t)|S^{(n+1)}}(n|s^{(n+1)})p_{S^{(n+1)}}(s^{(n+1)})
{% endmath %}

由于 {% math %}N(t)=n{% endmath %} 已经暗示了 {% math %}S_n\le t, S_{n+1}\ge t{% endmath %} 。在此情况下， {% math %}f_{N(t)|S^{(n+1)}}(n|s^{(n+1)})=1{% endmath %} 。这种情况下我们可以求得：
{% math %}
\begin{aligned}
f_{S^{(n+1)}|N(t)}(s^{(n+1)}|n)&=\dfrac{p_{S^{(n+1)}}(s^{(n+1)})}{p_{N(t)}(n)}\\
&=\dfrac{\lambda^{n+1}\exp(-\lambda s_{n+1})}{(\lambda t)^n\exp(-\lambda t)/n!}\\
&=\dfrac{n!\lambda \exp(-\lambda(s_{n+1}-t))}{t^n}
\end{aligned}
{% endmath %}

又由
{% math %}
f_{S^{(n+1)}|N(t)}(s^{(n+1)}|n)=f_{S^{(n)}|N(t)}(s^{(n)}|n)f_{S_{n+1}|N(t)}(s_{n+1}|s^{(n)},n)\\
f_{S_{n+1}|N(t)}(s_{n+1}|s^{(n)},n) = \lambda \exp(-\lambda(s_{n+1}-t))
{% endmath %}

除一下就行了
### 方法二
这种方法稍显复杂。它认为每次到达都发生在一个很短的时间间隔 {% math %}\delta{% endmath %} 之内(如下图所示)。
![](http://ww2.sinaimg.cn/large/9dec4451gw1f1iv9gpjx4j20lw048t8s.jpg)

我们用 {% math %}A(\delta){% endmath %} 描绘这一过程。则：
{% math %}
\begin{aligned}
Pr\left\{A(\delta)\right\}&=p_{N(s_1)}(0)p_{\tilde{N}(s_1, s_1+\delta)}(1)p_{\tilde{N}( s_1+\delta, s_2)}(0)...p_{\tilde{N}( s_n+\delta, t)}(0)\\
 &= (\lambda \delta)^n\exp(-\lambda t) + \delta^{n-1}o(\delta)\\

 f_{S^{(n)}|N(t)}(s^{(n)}|n) = \lim_{\delta\to 0}\dfrac{Pr\left\{A(\delta)\right\}}{\delta^np_{N(t)}(n)}
\end{aligned}
{% endmath %}

最后系数中的 {% math %}\delta^n{% endmath %} 可以认为是人工将在一个点的时间拉长到了 {% math %}\delta{% endmath %} 。教授在课上的说法是需要get density.

当然了，你可以将每一个到达的过程视为unit process。在这种情况下也可以推导出最后的公式。但是poisson process并没有暗示这一点。
