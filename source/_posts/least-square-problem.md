title: least-square problem
tags: [optimization]
date: 2016-06-28 14:45:26
categories: math
---
机器学习中最常见的损失函数就是最小平方误差，所以我们来看看 LSE 有什么高效的解法。
<!--more-->
LSE中，我们的优化目标常常是
{% math %}
f(x) = \frac{1}{2}\sum_{j=1}^mr^2_j(x)
{% endmath %}
令 {% math %}r(x) = (r_1(x),r_2(x),...,r_m(x))^T{% endmath %}，则上面的函数可以简写为 {% math %}f(x) = \|r(x)\|^2{% endmath %} 。令
{% math %}
J(x) = \begin{bmatrix}\nabla r_1(x)^T\\\nabla r_2(x)^T\\.\\.\\.\\\nabla r_m(x)^T\end{bmatrix}
{% endmath %}
则
{% math %}
\begin{align}
\nabla f(x) &= \sum_{j=1}^m r_j(x)\nabla r_j(x) = J(x)^Tr(x)\\
\nabla^2 f(x) &= \sum_{j=1}^m \nabla r_j(x)\nabla r_j(x)^T + \sum_{j=1}^m r_j(x)\nabla^2 r_j(x)\\
&= J(x)^TJ(x) + \sum_{j=1}^m r_j(x)\nabla^2 r_j(x)
\end{align}
{% endmath %}
当我们的解接近最优解时，{% math %}r_j(x){% endmath %} 或 {% math %}\nabla^2 r_j(x){% endmath %} 很小，这时第二项可以基本忽略。

# Linear Least-square
首先看一个简单的情况，我们要拟合的函数也是线性函数。这种情况下目标函数可以写成
{% math %}
f(x) = \frac{1}{2} \|Jx-y\|^2
{% endmath %}
此时一阶导和二阶导分别为：
{% math %}
\nabla f(x) = J^T(Jx-y)
\nabla^2 f(x) = J^TJ
{% endmath %}
求解其实只要计算 {% math %}J^TJx^* = J^Ty{% endmath %} 。主要的问题在于如何计算。下面介绍3种方法计算。

## Cholesky factorization
思路非常清晰：
1. 计算 {% math %}J^TJ{% endmath %} 和 {% math %}J^Ty{% endmath %}
2. 对 {% math %}J^TJ{% endmath %} 进行 Cholesky factorization
3. 求解 {% math %}J^TX = J^Ty, Jx^* = X{% endmath %} 得到 {% math %}x^*{% endmath %}

但是如果 {% math %}J{% endmath %} 的条件数非常大，{% math %}J^TJ{% endmath %} 会将其进一步放大。这种情况下 Cholesky factorization 的效果会很差，但是在 m 远大于 n 的情况下，该算法会有较好的效果

## QR factorization
易知， 当 {% math %}Q{% endmath %}正交时， {% math %}\|Jx-y\| = \|Q(Jx-y)\|{% endmath %} 根据 QR分解，有
{% math %}
J\Pi = Q\begin{bmatrix}R\\0\end{bmatrix} = \begin{bmatrix}Q_1&Q_2\end{bmatrix}\begin{bmatrix}R\\0\end{bmatrix} = Q_1R
{% endmath %}
其中， {% math %}\Pi{% endmath %} 为 n* n 维的 permutation 矩阵；{% math %}Q{% endmath %} 为正交矩阵； {% math %}Q_1{% endmath %} 是 {% math %}Q{% endmath %} 的前 n 列，{% math %}Q_2{% endmath %} 是 {% math %}Q{% endmath %} 的剩下的 m-n 列； {% math %}R{% endmath %} 为 n*n 的正定上三角矩阵。所以
{% math %}
\begin{align}
\|Jx-y\|_ 2^2 &= \Bigg\|\begin{bmatrix}Q_1^T\\Q_2^T\end{bmatrix}(J\Pi\Pi^Tx-y)\Bigg\|\\
& =\Bigg\|\begin{bmatrix}R\\0\end{bmatrix}\Pi^Tx - \begin{bmatrix}Q_1^Ty\\Q_2^Tys\end{bmatrix}\Bigg\|\\
& =\|R(\Pi^Tx) - Q_1^Ty\|^2_2 + \|Q^T_2y\|^2_2
\end{align}
{% endmath %}
最后我们需要解 {% math %}x^* = \Pi R^{-1}Q_1^Ty{% endmath %} 。实际一般解 {% math %}Rz = Q_1^Ty{% endmath %} ，然后令 {% math %}x^* = \Pi z{% endmath %} 。它的优点在于避开了 Cholesky factorization 中的坑，{% math %}J{% endmath %} 的条件数很大时能拿到相对较好的结果。
## SVD
当我们需要更为健壮的结果时，就要用到SVD了。对 {% math %}J{% endmath %} 做SVD分解，可得：
{% math %}
J = U\begin{bmatrix}S\\0\end{bmatrix}V^T = \begin{bmatrix}U_1&U_2\end{bmatrix}\begin{bmatrix}S\\0\end{bmatrix}V^T = U_1SV^T
{% endmath %}
这种情况下
{% math %}
\begin{align}
\|Jx-y\| &= \Bigg\|\begin{bmatrix}S\\0\end{bmatrix}(V^Tx)-\begin{bmatrix}U_1^T\\U_2^T\end{bmatrix}y\Bigg\|^2\\
& = \|S(V^Tx)-U_1^Ty\|^2 + \|U_2^Ty\|^2
\end{align}
{% endmath %}
可以得到 {% math %}x^* = VS^{-1}U_1^Ty = \sum_{i=1}^n\dfrac{u_i^Ty}{\sigma_i}v_i{% endmath %} 。当然，有些 {% math %}\sigma_i{% endmath %} 可能是0， 这时候可以将公式改写为 {% math %}x^* = \sum_{\sigma_i\neq0}\dfrac{u_i^Ty}{\sigma_i}v_i + \sum_{\sigma_i=0}{\tau_i}v_i{% endmath %} ，一般令 {% math %}\tau_i=0{% endmath %} 。这是3个方法中最为健壮的。毕竟SVD分解的计算量摆在那，不好谁用啊。

当然，对于大数据量来说，还是CG什么的迭代式的更好点。

# NonLinear Least-square
讲完线性的，现在来看非线性的。
## Gauss-Newton method
我们可以用 {% math %}J_k^TJ_k{% endmath %} 来近似二阶导，然后和牛顿法类似，解
{% math %}
J_k^TJ_kp_k^{GN} = -J_k^Tr_k
{% endmath %}
得到下降方向 {% math %}p_k^{GN}{% endmath %} 。

当 {% math %}J{% endmath %} 满秩， {% math %}\nabla f{% endmath %} 不为0时，有
{% math %}
(p_k^{GN})^T\nabla f = (p_k^{GN})^TJ_k^Tr_k = -(p_k^{GN})^TJ_kJ_k^Tp_k^{GN} = -\|J_k^Tp_k^{GN}\|^2\le0
{% endmath %}
所以这必然是下降方向；而且很多情况下都可以认为 {% math %}B_k\approx J_k^TJ_k{% endmath %} 。而且这和上面讲的线性方程的函数类似，所以上面的方法可以直接用到这里来。

当然这是 {% math %}J{% endmath %} 满秩的情况。 {% math %}J{% endmath %} 不满秩就比较麻烦了。这时 {% math %}p_k^{GN}{% endmath %} 会有无穷多个解，上面的条件可能不再满足，因此算法的收敛性可能无法得到保证。

收敛速度方面，可以推出
{% math %}
\|x_k+p_k^{GN}-x^* \| \approx \|[J^TJ(x^* )]^{-1}H(x^* )\|\|x_k-x^* \| + O(\|x_k-x^* \|^2)
{% endmath %}
所以收敛速度方面是很快的。

在遇到大数据量的情况下，可以用 [inexact newton method](http://modkzs.github.io/2016/06/10/large-scale-unconstrained-optimization/) ，不过需要把 {% math %}B_k{% endmath %} 的计算替换为 {% math %}J_k^TJ_k{% endmath %}

## The Levenberg-marquardt method
和上面的方法类似，Levenberg-marquardt 也用了一样的方法去近似 Hessian 矩阵，但是用的搜索是 trust-region 。这样避免了 {% math %}J{% endmath %} 的条件数过高带来的问题。

每次迭代，我们需要求解
{% math %}
\min_p \frac{1}{2}\|J_kp+r_k\|^2\quad s.t. \|p\|\le\Delta_k
{% endmath %}
如果 Gauss-Newton 解出的 {% math %}p^{GN}_k{% endmath %} 满足 {% math %}p^{GN}_k \le \Delta_k{% endmath %} ，直接用就可以了。否则根据KKT条件，需要求解
{% math %}
(J^TJ+\lambda I)p=-J^Tr\\
p = \Delta
{% endmath %}

可以用 trust-region 中解决子问题所用的[迭代式算法](http://modkzs.github.io/2016/06/06/Trust-region-method/)去解。不过在这种场景中有更高效的 Cholesky factorization 的方法。

令 {% math %}Q_\lambda, R_\lambda{% endmath %} 为正交矩阵和上三角矩阵，其中 {% math %}R_\lambda^TR_\lambda = (J^J+\lambda I){% endmath %} ，且
{% math %}
\label{eq}
\begin{bmatrix}R_\lambda\\0\end{bmatrix} = Q_\lambda \begin{bmatrix}J\\\sqrt{\lambda} I\end{bmatrix}
{% endmath %}

为了减小计算量，我们先对 {% math %}J{% endmath %} 做QR分解：
{% math %}
J = Q\begin{bmatrix}R\\0\end{bmatrix}
{% endmath %}
对上式做一点变形，可得:
{% math %}
\begin{bmatrix}R\\0\\\sqrt{\lambda}I\end{bmatrix} = \begin{bmatrix}Q^T&\\&I\end{bmatrix} \begin{bmatrix}J\\\sqrt{\lambda} I\end{bmatrix}
{% endmath %}
对上式的左边做行变换，使其变为上三角矩阵：
{% math %}
\bar{Q}_\lambda^T\begin{bmatrix}R\\0\\\sqrt{\lambda}I\end{bmatrix} = \begin{bmatrix}R_\lambda\\0\\0\end{bmatrix}
{% endmath %}
令 {% math %}Q_\lambda = \begin{bmatrix}Q^T&\\&I\end{bmatrix}\bar{Q}_\lambda^T{% endmath %}
然后带到\ref{eq}就可以了。当然，对于条件数太高的情况，可以进行 scaling，这和 trust-region 基本一样，就不多说了。

大数据量和上面一样，上CG

## Large-residual problem
在这种问题中，由于残差很大，所以用 {% math %}J_k^TJ_k{% endmath %} 近似二阶导的效果很差，收敛速度大概为 linear，远远差于 quasi-newton 方法。但是在早期迭代时，上面方法的速度又优于 quasi-newton 法。
这种情况下我们有2种处理办法。

一是用启发式的方法确定是否使用 quasi-newton 还是 Gauss-Newton。 如果使用 Gauss-Newton 带来的损失函数减少量较大(例如减少10%)，就使用 Gauss-Newton ，并令 {% math %}B_k=J^T_kJ_k{% endmath %} ，否则继续使用 {% math %}B_k{% endmath %} 。但是更新 {% math %}B_k{% endmath %} 时需要用类似 BFGS 的方法

二是令 {% math %}B_k = J^T_kJ_k + S_k{% endmath %} 每次迭代时更新 {% math %}S_k{% endmath %}，更新规则为：
{% math %}
S_{k+1} = S_k + \dfrac{(\hat{y}-S_ks)y^T + y(\hat{y}-S_ks)^T}{y^Ts} - \dfrac{(\hat{y}-S_ks)^Ts}{(y^Ts)^2}yy^T
{% endmath %}
其中 {% math %}s = x_{k+1}-x_k, y = J_{k+1}^Tr_{k+1}-J_{k}^Tr_{k}, \hat{y} = J_{k+1}^Tr_{k+1}-J_{k}^Tr_{k+1}{% endmath %}

但是该算法不保证在 {% math %}S_k{% endmath %} 会趋向于0。所以可以在 {% math %}S_k{% endmath %} 之前乘上一个系数 {% math %}\tau_k = \min(1, \dfrac{|S^T\hat{y}|}{|S^TS_kS|}){% endmath %}

# Orthogonal distance regression
在上面的问题中，我们的假设都是 t 是精确的，而 y 是不精确的。但是如果 x 也不精确，该如何处理？

这种情况下我们假设 {% math %}\epsilon_k ,\delta_k{% endmath %} 分别表示 t 和 y 的误差。则实际的函数可以表示为
{% math %}
y_j = \phi(x;t_j+\delta_j)+\epsilon_j
{% endmath %}
则我们的目标为
{% math %}
\min_{x,\epsilon_j,\delta_j} \frac{1}{2}\sum_{j=1}^m w_j^2\epsilon^2_j + d_j^2\delta_j^2
{% endmath %}
上式可以重写为
{% math %}
\min_{x,\delta} \frac{1}{2} \sum_{j=1}^m w_j^2[y_j-\phi(x;t_i+\delta_j)]^2 + d_j^2\delta_j^2
{% endmath %}
令
{% math %}
r_j(x,\delta) = \begin{cases}w_j^2[y_j-\phi(x;t_i+\delta_j)]^2&j=1,2...m\\d_{j-m}^2\delta_{j-m}^2&j=m+1,m+2...2m\end{cases}
{% endmath %}
则可以化简为
{% math %}
\frac{1}{2}\sum_{j=1}^{2m}r_j^2(x,\delta)
{% endmath %}
但是上式的 Jacobian 矩阵很特殊：
{% math %}
J(x,\delta) = \begin{bmatrix}\hat{J}&V\\0&D\end{bmatrix}
{% endmath %}
对上面的式子用 Levenberg-marquardt method 方法求解即可。
