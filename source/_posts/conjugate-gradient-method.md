title: conjugate gradient method
tags: [optimization]
date: 2016-06-06 20:01:48
categories: math
---
Conjugate gradient method， 类似于坐标梯度下降，2次下降的方向不会相互干扰。
<!--more-->
# 线性函数
线性函数的 conjugate gradient method 很容易理解，所以我们从线性函数开始讲起。假设我们的优化目标是
{% math %}
\min\phi(x) = \frac{1}{2}x^TAx-b^Tx
{% endmath %}
那么我们必然需要求解 {% math %}\nabla\phi(x)=Ax-b{% endmath %} 。令 {% math %}r_k = Ax_k-b{% endmath %}

## 先讲讲 conjugacy
要理解 conjugate gradient method，自然先得理解 conjugacy 是什么。对于一组向量来说，我们说其关于对称矩阵 {% math %}A{% endmath %} conjugate 如果 {% math %}p_i^TAp_j=0\quad i\neq j{% endmath %} 。很容易发现这些向量必然也是线性独立的。

对于这样一组n维向量 {% math %}\{p_1,p_2...p_n\}{% endmath %} ，如果我们令 {% math %}x_{k+1}=x_k+\alpha_kp_k{% endmath %}，那么 {% math %}x_n{% endmath %} 可以表征整个n维向量空间。

令 {% math %}\alpha_k=-\dfrac{r^T_kp_k}{p^T_kAp_k}{% endmath %}(就steepest descent中的步长) ，那么上面的方法在n步后必然可以收敛到最优解。

## CG算法
那么现在的问题是，我们如何构建出这样一套向量？我们介绍CG算法用于产生向量。CG算法如下：
1. given {% math %}x_0{% endmath %}, set {% math %}r_0=Ax_0,p_0=-r_0{% endmath %}
2. while {% math %}r_k\neq0{% endmath %}
    - {% math %}\alpha_k=\dfrac{r_k^Tr_k}{p_k^TAp_k}{% endmath %}
    - {% math %}x_{k+1}=x_k+\alpha_kp_k{% endmath %}
    - {% math %}r_{k+1} = r_k+\alpha_kAp_k{% endmath %}
    - {% math %}\beta_{k+1}=\dfrac{r_{k+1}^Tr_{k+1}}{r_k^Tr_k}{% endmath %}
    - {% math %}p_{k+1}=-r_{k+1}+\beta_{k+1}p_k{% endmath %}

## 收敛速度
如果 {% math %}A{% endmath %} 有r个独立的特征根，可以证明CG算法可以在r步内收敛。其收敛速度为 linear， 但是收敛速度仍然和 condition number 密切相关。

### preconditioning
因为收敛速度和 condition number 密切相关，所以仍然可以通过 乘以 {% math %}C{% endmath %} 去改变 condition number， numerical optimization中将这个过程称为 preconditioning

# 非线性函数
## Fletcher-Reeve method
1. given {% math %}x_0{% endmath %}, {% math %}f_0=f(x_0), \nabla f_0=\nabla f(x_0), p_0=-\nabla f_0{% endmath %}
2. while {% math %}\nabla f_0\neq 0{% endmath %}
    - compute {% math %}\alpha_k{% endmath %}， {% math %}x_{k+1}=x_k+\alpha_kp_k{% endmath %}
    - {% math %}\beta^{FR}_{k+1} = \dfrac{\nabla^T f_{k+1}\nabla f_{k+1}}{\nabla^T f_{k}\nabla f_{k}}{% endmath %}
    - {% math %}p_{k+1}=-\nabla f_{k+1}+\beta^{FR}_{k+1}p_k{% endmath %}

在这里，为了保证会产生下降的方向，{% math %}\alpha{% endmath %} 必须满足 strict Wolfe condition ，即
{% math %}
f(x_k+\alpha p_k)\le f(x_k)+c_1\alpha\nabla f_k^Tp_k\\
|\nabla f(x_k+\alpha_kp_k)^Tp_k|\le c_2|\nabla f_kp_k|
{% endmath %}
不过 {% math %}0<c_1<c_2<\frac{1}{2}{% endmath %} 。

## FR method 的一些变化版本
对于 FR 算法的修改大都集中于 {% math %}\beta{% endmath %} 的计算上。需要注意的是，我们只要保证当 {% math %}k>2{% endmath %} 时， {% math %}|\beta_k|<\beta^{FR}_{k}{% endmath %} 就可以保证全局收敛
### PR
{% math %}
\beta_{k+1}^{PR} = \dfrac{\nabla f_{k+1}^T(\nabla f_{k+1}-\nabla f_{k})}{\|\nabla f_k\|^2}
{% endmath %}

经验表示 PR 似乎比 FR 更高效、健壮。但是对于PR来说， Wolfe condition 并不能保证每次迭代都处于下降方向。如果我们将 {% math %}\beta{% endmath %} 的更新修改为
{% math %}
\beta_{k+1}^+ = \max\{\beta_{k+1}^{PR}, 0\}
{% endmath %}
那么对  Wolfe condition 做些微小的修改就可以保证下降的方向。我们将该算法称为 PR+
### HS
{% math %}
\beta^{HS} = \dfrac{\nabla f_{k+1}^T(\nabla f_{k+1}-\nabla f_{k})}{(\nabla f_{k+1}-\nabla f_{k})^Tp_k}
{% endmath %}
### PR-FR
{% math %}
\beta_k=\begin{cases}
    -\beta_k^{FR} & \text{if } \beta_k^{PR}<-\beta_k^{FR}\\
    \beta_k^{PR} & \text{if } |\beta_k^{PR}|\le\beta_k^{FR}\\
    \beta_k^{FR} & \text{if } \beta_k^{PR}>\beta_k^{FR}
    \end{cases}
{% endmath %}

## restart
在处理非线性问题时，我们可以每n步就将 {% math %}\beta{% endmath %} 设置为0。这被称为 restart ，相当于我们在当前步进行 steepest descent。这样的话，历史信息被抹去，相当于我们从当前开始重新做 conjugate gradient 。

对于每个函数的极值点来说，必然存在一个小的邻域，函数在该邻域内类似于二次函数。如果我们踏入邻域之后抹去历史信息，那么必然可以获得更快的迭代速度。似乎可以证明restart的收敛速度为quadratic。

当时实际过程中，如果用 restart ，那么 n 都会被设为一个相当大的值，基本不可能迭代那么多次。所以一般情况下不会为了收敛速度而进行 restart。当然，连续两次迭代的向量基本不正交的情况下可以进行 restart。 这可以通过 {% math %}\dfrac{|\nabla f_k^T\nabla f_{k-1}|}{\|\nabla f_k\|^2} \ge v{% endmath %} 进行测试。v一般取0.1

## 收敛速度
对于 PR 来说，有下面不等式成立：
{% math %}
-\dfrac{1}{1-c_2}\le\dfrac{|\nabla f_k^Tp_{k}|}{\|\nabla f_k\|^2}\le \dfrac{2c_2-1}{1-c_2}
{% endmath %}

所以
{% math %}
\cos\theta_k = \dfrac{\nabla f_k^Tp_{k}}{\|\nabla f_k\|\|p_{k}\|} \in(\dfrac{1- 2c_2}{1-c_2}\dfrac{\|\nabla f_k\|}{\|p_k\|},\dfrac{1}{1-c_2}\dfrac{\|\nabla f_k\|}{\|p_k\|})
{% endmath %}
如果 {% math %}p_k{% endmath %} 和 {% math %}\nabla f_k{% endmath %} 正交，那么我们必然无法获得好的下降方向。这种情况下， {% math %}\cos\theta_k{% endmath %} 基本为0， 故 {% math %}\|\nabla f_k\| \ll \|p_k\|，x_{k+1}\approx x_k，\nabla f_{k+1}\approx\nabla f_{k}{% endmath %}，因此 {% math %}\beta_{k+1}^{FR} \approx 1, p_{k+1}\approx p_k{% endmath %}。这种情况下 FR 很难有改进；而PR，HS就要好得多。

最后，书中对一些实际问题跑了 PR， FR， PR+，有些问题上，三者的差距并不明显。这里就不贴出来了，有兴趣的可以自己去看下
