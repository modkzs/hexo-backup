title: Quasi-newton method
tags: [optimization]
date: 2016-06-07 18:07:51
categories: math
---
Quasi-newton method 是为了避免 newton method 中二阶导的大量计算而引入的方法。
<!--more-->
# newton method
正如上面所言，Quasi-newton method 是基于对 newton method 的改进，所以在介绍 Quasi-newton method 之前，有必要对 newton method 进行一下简单的介绍。

假设我们的单次迭代的优化目标为
{% math %}
\min f(x_k+p_k)
{% endmath %}
那么根据 Taylor theorm， {% math %}f(x_k+p_k) \approx f(x_k)+\nabla f(x_k)^Tp_k+p^T_k\nabla^2 f(x_k)p{% endmath %} 。这种情况下我们将其当做二次函数处理，最小值为 {% math %}\nabla^2 f(x_k)^{-1}\nabla f(x_k){% endmath %} 。

newton method 对于条件数较高的情况也能很好的处理，但是函数二阶导的计算需要大量的计算量，所以实际过程中并不常用。为了避免这种问题，我们需要对 {% math %}\nabla^2 f(x_k){% endmath %} 进行近似。这就是 Quasi-newton method 的思想。

# Quasi-newton method
在这里，我们介绍3种近似算法及其变体。我们将近似的 Hessian 矩阵记为 {% math %}B{% endmath %} 。根据我们前面的描述，令
{% math %}
m_k(p)=f(x_k)+\nabla f_k^Tp_k+p^T_kB_kp_k
{% endmath %}
则
{% math %}
\nabla m_{k+1}(-\alpha_kp_k) = \nabla f_{k+1}-\alpha_kB_{k+1}p_k=\nabla f_{k}
{% endmath %}
我们令 {% math %}s_k = x_{k+1}-x_k=\alpha_kp_k,\ y_k=\nabla f_{k+1}-\nabla f_{k}{% endmath %} 整理一下，就可以得到
{% math %}
B_{k+1}s_k=y_k
{% endmath %}
我们将其称为 secant equation。如果{% math %}B_k{% endmath %} 正定，所以从这个条件很容易推出
{% math %}
s_k^Ty_k > 0
{% endmath %}
该条件被称为 curvature condition。不过这只对凸函数成立。当我们需要处理非凸函数时，就无法处理这种问题。不过如果利用 Wolfe condition 的话，那么可以推出上面的函数是必然会满足的。

在这种情况下我们可以专注于 {% math %}B_k{% endmath %} 的求解了。显然我们无法直接通过上面的等式算出 {% math %}B_{k+1}{% endmath %} ，所以我们将问题转化为下面的问题：
{% math %}
\min_B \|B-B_k\| \quad s.t. B=B^T,\ Bs_k=y_k
{% endmath %}
不同的范数的使用往往会导致不同的算法。

## BFGS method
BFGS中，我们将使用的范式定义为 {% math %}\|A\|_ W=\|W^{1/2}AW^{1/2}\|_ F{% endmath %}，而 {% math %}\|C\|_ F = \sum_{i=1}^n\sum_{j=1}^nc_{ij}^2{% endmath %} 。在这里我们使用 average Hessian 矩阵
{% math %}
\bar{G}_k=\int_0^1\nabla^2f(x_k+\tau\alpha_kp_k)d\tau
{% endmath %}
作为矩阵 {% math %}W{% endmath %}。这样情况下我们可以解出
{% math %}
B_{k+1}=(I-\rho_ky_ks_k^T)B_k(I-\rho_ky_ks_k^T)+\rho_ky_ky_k^T
{% endmath %}
其中 {% math %}\rho_k = \dfrac{1}{y^T_ks_k}{% endmath %} (其实我也不知道这是怎么解出来的。。。。。)利用 Sherman-Morrison-Woodbury formula，可以推出
{% math %}
H_{k+1} = B_{k+1}^{-1} = H_k-\dfrac{H_ky_ky_k^TH_k^T}{y_k^TH_ky_k}+\dfrac{s_ks_k^T}{s_k^Ty_k}
{% endmath %}
上面的更新规则被称为DFP。相对于DFP来说，BFGS更进一步，直接对 {% math %}H_k{% endmath %} 进行求解：
{% math %}
\min_H \|H-H_k\|\quad s.t.H=H^T,\ Hy_k=s_k
{% endmath %}
解出 {% math %}H_{k+1}=(I-\rho_ky_ks_k^T)H_k(I-\rho_ky_ks_k^T)+\rho_ks_ks_k^T{% endmath %} 其中 {% math %}\rho_k{% endmath %} 的定义没有产生变化。显然BFGS的计算量小于DFP。

那么现在我们就差一个初值了！可惜没有什么适用于各个情况的选择方案。一般可以选择 Hessian 矩阵的逆或者直接用单位矩阵作为初值。

现在我们可以给出BFGS的过程了：
1. compute {% math %}H_0{% endmath %}
2. repeat
    - {% math %}p_k = -H_k\nabla f_k{% endmath %}
    - compute {% math %}\alpha_k{% endmath %} to satisfy Wolfe condition
    - {% math %}s_k=x_{k+1}-x_k,\ y_k=\nabla f_{k+1}-\nabla f_{k}{% endmath %}
    - compute {% math %}H_{k+1}{% endmath %}

    until convergence


### 一些其他的讨论
#### 一个奇怪的变种
通过Sherman-Morrison-Woodbury formula， 我们同样可以计算出
{% math %}
B_{k+1}=B_k-\dfrac{B_ks_ks_k^TB_k^T}{s_k^TBs_k}+\dfrac{y_ky_k^T}{y_k^Ts_k}
{% endmath %}
然后通过求解 {% math %}B_kp_k =-\nabla f_k{% endmath %} 得到 {% math %}p_k{% endmath %} 。但是这种方法需要更大的计算量。实际使用中，一般对 {% math %}B_k{% endmath %} 进行 Cholesky factorization，即 {% math %}B_k = L_kD_kL_k{% endmath %}。和上面的算法相比，两者的计算量相差不大，但是我们可以修改 {% math %}D_k{% endmath %} 增加整体的稳定性。不过书中还是建议使用原始的BFGS算法。

当然，上面的算法存在基础是BFGS给出的 {% math %}H_k{% endmath %} 是正定的。在BFGS中，我们没有用到这一点，不过可以证明 {% math %}H_k{% endmath %} 是正定的。

#### 稳定性问题
对于算法的稳定性，还是有一些问题。例如当 {% math %}y_k^Ts_k{% endmath %} 很小时，{% math %}H_k{% endmath %} 的元素很大；或者一些其他情况下， {% math %}H_k{% endmath %} 的近似效果较差时，算法是否仍然可以保持较高的收敛速度？对于 BFGS 来说，答案是肯定的。在 {% math %}B_k{% endmath %} 的模拟效果较差时，BFGS似乎可以在几步内恢复到较高的水平，但是 DFP 相对来说就要差一些。

#### 初值的选择
前面提到，对于 {% math %}H_0{% endmath %} 的选择，是没有什么普适的方法的。前面也提到过可以设为单位矩阵。其实可以设为单位矩阵的整数倍：
{% math %}
H_0 = \dfrac{y_k^Ts_k}{y_k^Ty_k} I
{% endmath %}
这可以视为对 {% math %}\nabla^2 f^{-1}{% endmath %} 的一种粗略近似。

对于 {% math %}\alpha{% endmath %} 来说，可以将初值设为1，因为对于 newton method 来说，{% math %}\alpha=1{% endmath %} 基本是可以接受的。

#### 收敛速度
BFGS 的收敛速度为 superlinear

## SR1 method
BFGS和DFP的更新矩阵都是秩为2的矩阵，不过 SR1 更简单，其更新矩阵是一个秩1矩阵(所以叫做 Symmetric-Rank-1 method)。这样的话，我们可以将其更新规则表示为
{% math %}
B_{k+1}=B_k+\sigma vv^T
{% endmath %}
根据上文可知， {% math %}B_{k+1}{% endmath %} 也要满足 {% math %}B_{k+1}s_k=y_k{% endmath %} 的规定。在这种情况下，我们可以推出：
{% math %}
y_k = B_ks_k+\sigma vv^Ts_k = B_ks_k+(\sigma v^Ts_k)v
{% endmath %}
可以假设 {% math %}|\sigma|=1{% endmath %} 。由上式可知，{% math %}v{% endmath %} 必和 {% math %}y_k-B_ks_k{% endmath %} 同向。假设 {% math %}v = \delta(y_k-B_ks_k){% endmath %} ，则上式可化为
{% math %}
(y_k-B_ks_k) = \sigma\delta^2[s^T(y_k-B_ks_k)](y_k-B_ks_k)
{% endmath %}
这样我们可以推出更新的公式：
{% math %}
B_{k+1} = B_k + \dfrac{(y_k-B_ks_k)(y_k-B_ks_k)^T}{(y_k-B_ks_k)^Ts_k}
{% endmath %}
同样求出 {% math %}H_{k+1}{% endmath %} :
{% math %}
H_{k+1} = H_k + \dfrac{(s_k-B_ky_k)(s_k-B_ky_k)^T}{(s_k-B_ky_k)^Ty_k}
{% endmath %}

对于BFGS来说，我们可以证明如果 {% math %}H_k{% endmath %} 正定，必有 {% math %}H_{k+1}{% endmath %} 正定。但是对于 SR1 来说，这个性质不再满足。不过书中说这个缺点在 Trust-region 中似乎很有用，但是没有发现哪里有用了。

矩阵不可逆不是 SR1 的主要问题。毕竟 quasi-newton 中基本没有用到逆。但是有一个情况就比较麻烦了： {% math %}(s_k-B_ky_k)^Ty_k = 0{% endmath %} 即使是凸函数，这种情况似乎也不可避免。所以我们需要讨论这种情况的处理。 {% math %}(s_k-B_ky_k)^Ty_k = 0{% endmath %} 可以被分成2种情况：
1. {% math %}s_k-B_ky_k=0{% endmath %} 这倒是没什么问题，直接让 {% math %}B_{k+1}=B_k{% endmath %}
2. {% math %}s_k-B_ky_k\neq0,\ (s_k-B_ky_k)^Ty_k = 0{% endmath %} 。这种情况就很尴尬了，只能退出。

当然了，对于SR1来说，
{% math %}
|s_k^T(y_k-B_ks_k)|\ge r\|s_k\|\|y_k-B_ks_k\|
{% endmath %}
{% math %}r\in(0,1){% endmath %} ，一般取 {% math %}10^{-8}{% endmath %} 可以防止大多数上面这种尴尬的情况。

当然了，SR1本身有很多的优点。它本身是对 Hessian 的一种很好的近似，通常比 BFGS 的结果好很多；而某些问题中 BFGS 的要求(curvature condition) 似乎不会满足，所以 BFGS 并不是我们的第一选择。

## Broyden method
Broyden method 的更新规则如下：
{% math %}
\begin{aligned}
B_{k+1} &= B_k - \dfrac{B_ky_ky_k^TB_k^T}{y_k^TB_ky_k}+\dfrac{y_ky_k^T}{y_k^Ts_k} + \phi_k(s^T_kB_ks_k)v_kv_k^T\\
v &= \dfrac{y_k}{y_k^Ts_k}-\dfrac{B_ks_k}{s_k^TB_ks_k}
\end{aligned}
{% endmath %}
如果我们令 {% math %}\phi_k=0{% endmath %}，这就是BFGS；{% math %}\phi_k=1{% endmath %}，这就是DFP。如果 {% math %}\phi_k\in[0,1]{% endmath %} ，这就叫 restricted Broyden method。
