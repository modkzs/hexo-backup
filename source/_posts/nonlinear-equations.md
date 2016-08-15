title: nonlinear equations
tags: [optimization]
date: 2016-07-02 10:14:10
categories: math
---
求解非线性等式的方法
<!--more-->
线性等式的求解方法已经非常成熟，但是非线性不等式的求解仍然很复杂。比如 $\sin x - x + 0.3 = 0$ 这种方程的求解仍然需要迭代式的方法。但是我们初高中时学到的牛顿法在有些情况下并不能很快的收敛甚至无法收敛。

在介绍方法之前，首先引入一些记号。令 $r(x)$ 表示残差， $J(x)$ 表示 Jacobian 矩阵。 当最优解 $x^*$ 满足 $J(x^*)$ 奇异时被称为 degenerate solution，否则被称为 nondegenerate solution

# 牛顿法
上面既然说了牛顿法，那么就从牛顿法开始说起。根据 Taylor therom
$$
r(x+p) = r(x)+\int_0^1 J(x+tp)p\ dt
$$
我们需要去近似 $r(x+p)$，也就是上面的式子。牛顿法所用的近似是
$$
M_k(p) = r(x_k) + J(x_k)p
$$
过程不详细说了，大家都知道。说下牛顿法的问题：
- 初始点选的不好，算法的表现就不稳定。要是 $J(x_k)$ 奇异，那更惨，可能直接挂了
- $J(x)$ 可能不太好计算，或者计算量较大
- 维度高了，解线性等式的计算量太大
- 要是 degenerate solution，可能求不出来了

就收敛速度而言，当 $x_k$ 距离 $x_*$ 足够近时，可以达到 Q-superlinear；当 r 为 Lipschiz contiunously differentiable 时，可以达到 Q-quadratic。

## Inexact newton method
类似于[前面](http://modkzs.github.io/2016/06/10/large-scale-unconstrained-optimization/#Inexact_newton_method)提过的 quasi-newton 的 inexact，这里也可以采用类似的思路：
$$
\|r_k+J_kp_k\| \le \eta_k\|r_k\|
$$
所以算法变成了下面这样：
1. given $x_0, \eta_0$
2. repeat
    - choose $\eta_k\in[0,\eta]$
    - comput $p_k$
    - $x_{k+1} = x_k+p_k$

对于不等式的求解，可能由于收敛速度和求解方法无关，因此书中并没有给出详细的方法。

收敛速度方面，如果 $x$ 距离最优解足够近而且最优解为 nondegenerate solution，且 $\eta$ 很小，则收敛速度为 Q-linear；如果 $\eta_k$ 趋向于0，那么收敛速度为 Q-superlinear。

## Broyden's method
和 quasi-newton 一样，我们用 $B_k$ 去近似 $J(x_k)$ 。令 $s_k = x_{k+1}-x_k,\ y_k = r(x_{k+1})-r(x_k)$ 则
$$
y_k = \int_0^1J(x_k+ts_k)s_k\ dt \approx J(x_k+1)s_k + o(\|s_k\|)
$$
我们的 $B_k$ 需要满足的条件就是
$$
y_k = B_{k+1}s_k
$$
这和 BFGS 中的条件一模一样。所以我们可以直接套过来更新规则：
$$
B_{k+1} = B_k + \dfrac{(y_k-B_ks_k)s_k^T}{s_k^Ts_k}
$$
算法如下
1. choose $x_0, B_0$
2. repeat
    - compute $B_kp_k = -r(x_k)$
    - choose $\alpha_k$
    - $x_{k+1} = x_k + \alpha_kx_k$
    - $s_k = x_{k+1} - x_k$
    - $y_k = r(x_{k+1})-r(x_k)$
    - update $B_{k+1}$

    until convergence

收敛速度方面，如果能找到正数 $\delta,\epsilon$ 使得
$$
\|x_0 - x^* \|\le \delta\quad \|B_0-J(x^* )\|\le\epsilon
$$
算法的收敛速度为 Q-superlinear。这个条件对算法的初值选择提出了极高的要求，显然实际情况不可能总是满足。有些实现选择 $B_0 = J(x_0)$

## tensor method
如果说 matrix 对应的是二维数组的话，那么 tensor 对应的就是三维数组。tensor 的基本思路仍然是近似，不过近似的结果为
$$
M_k(p) = r(x_k) + J(x_k)p + \frac{1}{2}T_kpp
$$
最后一个元素为tensor的乘法，定义为：
$$
(T_kuv)_ i = \sum_{j=1}^n\sum_{l=1}^n (T_k)_ {ijl}u_jv_l
$$
我们构造 $T_k$ 为 $(T_k)_ {ijk} = [\nabla^2r_i(x_k)]_ {jl}$

而 $T$ 需要满足的条件为：
$$
M_k(x_{k-j}-x_k) = r(x_{k-j})\quad j=1,2,...q
$$
可以推出
$$
\frac{1}{2} T_ks_{jk}s_{jk} = r(x_{k-j})-r(x_k)-J(x_k)s_{jk}
s_{jk} = x_{k-j}-x_k
$$
故可以推出
$$
T_kuv = \sum_{i=1}^q a_j(s_{jk}^Tu)(s_{jk}^Tv)
$$

# 用优化的角度去解
既然有大量的优化算法，为什么不利用呢？我们引入 merit function 用来评价两次迭代的效果。很显然的一个 merit function 就是平方和：
$$
f(x) = \frac{1}{2}\|r(x)\|^2
$$

这种情况下我们只需要优化 $f(x)$ 就可以了。line search, trust-region 什么的都可以用在上面。这些都是已有的方法，在使用方面也没有什么需要注意或者改进的地方，所以就不说了。

# Continuation/Homotopy method
上面的方法大都有一个问题：当解为 degenerate solution 时，都很难发挥作用。continuation method 就是用来解决上面的问题。

在 continuation method 中，我们不直接解决 $r(x) = 0$ 的问题，而是慢慢的绕过去。一种方法是引入 homotopy map
$$
H(x,\lambda) = \lambda r(x) + (1-\lambda)(x-a)
$$
当 $\lambda = 0$ 时，显而易见解为 $x=a$ ；当 $\lambda=1$ 时，解就是我们要求的解。如果我们单纯的增加 $\lambda$ 则该方法失败的可能性很大。一般情况下，我们会将$x, \lambda$ 化成两个关于 $s$ 的函数。则初始点为 $(x(0), \lambda(0)) = (a,0)$ 。

由于 $H(x(0), \lambda(0)) \equiv 0$ 故
$$
\dfrac{\partial}{\partial x} H(x, \lambda) \dot{x}+ \dfrac{\partial}{\partial \lambda}H(x, \lambda) \dot{\lambda}= 0\quad (\dot{x}, \dot{\lambda}) = (\dfrac{dx}{ds},\dfrac{d\lambda}{ds})
$$
所以矩阵 $\Bigg[\dfrac{\partial}{\partial x} H(x, \lambda)\quad\dfrac{\partial}{\partial \lambda}H(x, \lambda)\Bigg]$ 的 null space 为向量 $(\dot{x}, \dot{\lambda})$。如果该矩阵满秩，则为了解出 $(\dot{x}, \dot{\lambda})$ ，我们还需要一个方程。所以将向量归一化：
$$
\|\dot{x}\|^2 + |\dot{\lambda}|^2 = 1
$$
联立两式，就可以求出解。当然，为了加速计算，我们可以用QR分解去做：
1. 先对矩阵做 QR 分解：
$$
Q^T\Bigg[\dfrac{\partial}{\partial x} H(x, \lambda)\quad\dfrac{\partial}{\partial \lambda}H(x, \lambda)\Bigg]\Pi = [R\quad w]
$$
2. 令 $v = \Pi\begin{bmatrix}R^{-1}w\\-1\end{bmatrix}$，则 $x = v/\|v\|$

不过上面计算出的更新量在更新后可能无法保证 $H(x,\lambda) = 0$，所以我们需要进行一些微调。这是我们选择变化幅度最大的元素，使其保持不变。也就是如下的形式进行计算：
![](http://ww3.sinaimg.cn/large/9dec4451jw1f5frse8ddnj20eg042q35.jpg)

虽然如此，在初值 $a$ 选择不当时，算法仍然有可能崩。不过要比上面的 merit function 靠谱一些。
