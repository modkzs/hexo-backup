title: line search method
tags: [optimization]
date: 2016-06-04 20:35:51
categories: math
---
数值优化的基础算法 line search， 很多后续的算法都有基于该方法的版本。
<!--more-->
# 算法框架
就像前面说的一样， line search 是先找方向，再找距离。这样的话，算法的框架就很简单(目标函数记为 {% math %}f(x){% endmath %})：
1. 找到方向(记为 {% math %}p{% endmath %} )
2. 初始化距离(例如等于10, 记为 {% math %}\alpha{% endmath %})
3. 判断是否符合条件，符合返回；否则缩小距离，继续判断，直到返回。

这个算法在凸优化中也有介绍，不过相对来说说的比较简单。一般来说，我们令 {% math %}p=-\nabla f_k{% endmath %}

在这里我们主要讨论是判断条件。当然会少量涉及距离以及方向的部分。

# 判断条件
## Wolfe Condition
### Armijo condition
{% math %}
f(x_k+\alpha p_k)\le f(x_k)+c_1\alpha\nabla f_k^Tp_k
{% endmath %}
其中 {% math %}c_1\in(0,1){% endmath %} ，不过实际过程通常用一个很小的值({% math %}c_1=10^{-4}{% endmath %})。

如果我们选择的方向可以保证 {% math %}\nabla f_k^Tp_k\le0{% endmath %} ，那么我们每次迭代都能取得更好的效果。但是该条件只能保证每次都下降，不能保证下降到最优值。例如 {% math %}f(x) = (x+1)^2,\ x_k=5/k{% endmath %} 可以看到 {% math %}x{% endmath %} 是从无穷大处逼近于0，所以每次迭代的值都会下降，但是永远达不到最优点。
### curvature condition
为了防止上面的情况，我们引入了 curvature condition：
{% math %}
\nabla f(x_k+\alpha_kp_k)^Tp_k\ge c_2\nabla f_kp_k
{% endmath %}
注意式中左右项均为负值。其中 {% math %}c_2\in(c_1, 0){% endmath %} ，这保证了每次迭代时前进步长不会太低。

将上面的条件组合，我们就拿到了 Wolfe Condition：
{% math %}
f(x_k+\alpha p_k)\le f(x_k)+c_1\alpha\nabla f_k^Tp_k\\
\nabla f(x_k+\alpha_kp_k)^Tp_k\ge c_2\nabla f_kp_k
{% endmath %}
其中 {% math %}0<c_1<c_2<1{% endmath %}

当然，这个条件有时候会过于宽松，所以有 strict Wolfe Condition:
{% math %}
f(x_k+\alpha p_k)\le f(x_k)+c_1\alpha\nabla f_k^Tp_k\\
|\nabla f(x_k+\alpha_kp_k)^Tp_k|\le c_2|\nabla f_kp_k|
{% endmath %}
其中 {% math %}0<c_1<c_2<1{% endmath %} 加上绝对值之后，防止了 {% math %}\nabla f(x_k+\alpha_kp_k){% endmath %} 太大的情况。

对于每个平滑、有下界的函数来说，满足 Wolfe Condition 的step总是存在的。

## Goldstein condition
和 Wolfe condition 类似，Goldstein condition 的思想也是控制每次迭代均为下降方向，同时保证每次迭代的步长不会过短。条件如下：
{% math %}
f(x_k) + (1-c)\alpha_k\nabla f_kp_k\le f(x_k+\alpha_kp_k)\le f(x_k) + c\alpha_k\nabla f_kp_k
{% endmath %}
其中 {% math %}c_2\in(0,0.5){% endmath %} 。该 condition 的缺点之一就是可能排除掉 {% math %}\alpha{% endmath %} 的最优解

# {% math %}\alpha{% endmath %} 的更新
在算法框架中，在 {% math %}\alpha{% endmath %} 不满足条件时，我们需要对 {% math %}\alpha{% endmath %} 进行更新。当然，我们可以选择最简单的办法: {% math %}\alpha=\rho\alpha{% endmath %}。当然，这是一种非常低效的更新方法，因为它没有使用任何一阶导甚至二阶导的信息。所以我们需要一些更高效的方法。

令 {% math %}\phi(\alpha)=f(x_k+\alpha p_k){% endmath %} 。则我们的目标是
{% math %}
\phi(\alpha_k)\le\phi(0)+c_1\alpha_0\phi'(\alpha_k)
{% endmath %}

利用 {% math %}\phi'(0),\phi(\alpha_0),\phi(\alpha_1){% endmath %} ，我们可以构造一个新函数：
{% math %}
\phi_q(\alpha) = (\dfrac{\phi(\alpha_0)-\phi(0)-\alpha_0\phi'(0)}{\alpha_0^2})\alpha^2 + \phi'(0)\alpha + \phi(0)
{% endmath %}
该函数的 {% math %}\phi_q'(0),\phi_q(\alpha_0),\phi_q(\alpha_1){% endmath %} 与原函数是一致的。构造出的函数为二次函数，可以直接求出最优解：
{% math %}
\alpha_1 = -\dfrac{\phi'(0)\alpha_0}{2[\phi(\alpha_0)-\phi(0)-\alpha_0\phi'(0)]}
{% endmath %}
检查上面的最优解是否满足条件；不满足的话，我们可以构造一个三次方的函数：
{% math %}
\phi_c(\alpha) = c\alpha^3 + b\alpha^2 + \alpha\phi'(0)+ \phi(0)\\
\begin{bmatrix}a\\b\end{bmatrix} = \dfrac{1}{\alpha_0^2\alpha_1^2(\alpha_1-\alpha_0)}\begin{bmatrix}\alpha_0^2 & -\alpha_1^2\\-\alpha_0^3 & \alpha_1^3\end{bmatrix}\begin{bmatrix}\phi(\alpha_1)-\phi(0)-\alpha_1\phi'(0)\\\phi(\alpha_0)-\phi(0)-\alpha_0\phi'(0)\end{bmatrix}
{% endmath %}
继续解最优解，得到
{% math %}
\alpha_2 = \dfrac{-b+\sqrt{b^2-3a\phi'(0)}}{3a}
{% endmath %}
如果还是不满足条件(= =) 我们就不构造四次方了。直接令 {% math %}\alpha_0=\alpha_{i-2},\alpha_1=\alpha_{i-1}{% endmath %} 计算 {% math %}\alpha_i{% endmath %} ，重复迭代直到满足条件为止

现在我们介绍 wolfe condition 下的 line search 算法。我们将 line search 分为两个部分：bracketing phase 和 selection phase。前者用于找到包含步长的区间，后者找到真正的步长。

## Line Search Algorithm
在提出算法之前，先做出一些说明。如果 {% math %}\alpha\in(\alpha_{i-1}, \alpha_i){% endmath %}，则存在3种情况：
- {% math %}\alpha_i{% endmath %} 违背了更新目标
- {% math %}\phi(\alpha_i)>\phi(\alpha_{i-1}){% endmath %}
- {% math %}\phi'(\alpha_i)\ge0{% endmath %}

所以根据上面的说明，算法如下

1.  {% math %}\alpha_0=0,\ \alpha_{max}>0,\ \alpha_1\in(0,\alpha_{max}){% endmath %}
2. if {% math %}\phi(\alpha_i)>\phi(0)+c_1\alpha\phi'(0){% endmath %} or {% math %}\phi(\alpha_i)\ge\phi(\alpha_{i-1}){% endmath %}

    {% math %}\alpha_*=zoom(\alpha_{i-1}, \alpha_i){% endmath %}

    return
3. if {% math %}|\phi'(\alpha_i)|\le-c_2\phi'(0){% endmath %}

    {% math %}\alpha_*=\alpha_i{% endmath %}

    return
4. if {% math %}\phi'(\alpha_i)\ge0{% endmath %}

    {% math %}\alpha_*=zoom(\alpha_i,\alpha_{i-1}){% endmath %}

    return
5. select {% math %}\alpha_{i+1}\in(\alpha_i, \alpha_{max}){% endmath %} ,go to 2

## zoom
我们在上面使用了 zoom 进行范围的调整，zoom算法如下：
1. compute {% math %}\alpha_j\in(\alpha_{lo},\alpha_{hi}){% endmath %}
2. if {% math %}\phi(\alpha_j)>\phi(0)+c_1\alpha\phi'(0){% endmath %} or {% math %}\phi(\alpha_i)\ge\phi(\alpha_{i-1}){% endmath %}

    {% math %}\alpha_{hi}= \alpha_j{% endmath %}

3. else:
    - if {% math %}|\phi'(\alpha_j)|\le-c_2\phi'(0){% endmath %}

      {% math %}\alpha_*=\alpha_j{% endmath %}
      return
    - if {% math %}\phi'(\alpha_j)(\alpha_{hi}-\alpha_{lo})\ge 0{% endmath %}

      {% math %}\alpha_{hi}=\alpha_{lo}{% endmath %}

    {% math %}\alpha_{lo} = \alpha_j{% endmath %}

    go to 1


# 收敛性以及收敛速度
## 收敛性
收敛性方面，对于 {% math %}\nabla f{% endmath %} 为 Lipschitz continuous(即 {% math %}\|\nabla f(x) - \nabla f(y)\|_2 \le L\|x-y\|_ 2{% endmath %} ) {% math %}f{% endmath %} 连续可倒且有下界，则有
{% math %}
\sum_{k\ge0}\cos^2\theta_k\|\nabla f(x)\|^2 \le \infty\\
\cos\theta_k = \dfrac{\nabla f_k^Tp_k}{\|\nabla f_k\|\|p_k\|}
{% endmath %}
根据上面的结论，可以证明 {% math %}\nabla f(x){% endmath %} 趋向于0

## 收敛速度
- steepest descent method:linear rate(和条件数密切相关)
- newton's method:quadratic rate
- Quasi-newton method:superlinearly

对于 newton's method 以及 Quasi-newton method，后面会详细说明。
