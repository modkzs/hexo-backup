title: large-scale unconstrained optimization

tags: [optimization]
date: 2016-06-10 16:08:07
categories: math
---
在处理一些数据量巨大的优化问题时，对于优化算法的收敛速度以及每次迭代的计算量都有较高的要求。但是纯粹的优化算法如 quasi-newton 可能无法满足这种要求。但是我们可以通过对现有算法的改进以达到这种要求。
<!--more-->
# Inexact newton method
在 newton method 中，我们需要求解 {% math %}\nabla^2f_k p_k^N = -\nabla f_k{% endmath %}。令 {% math %}r_k = \nabla^2f_k p_k^N+ \nabla f_k{% endmath %}，那么我们的目标就是 {% math %}r_k=0{% endmath %}。

不过对于 {% math %}\|r_k\|\le\eta_k\|\nabla f_k\|,\ \eta_k\in(0,1){% endmath %} 来说，如果 {% math %}x_0{% endmath %} 离 {% math %}x^*{% endmath %} 足够近而且 {% math %}\nabla^2f(x^*){% endmath %} 正定，则有
{% math %}
\|\nabla^2f(x^*)(x_{k+1}-x^*)\|\le \hat{\eta}\|\nabla^2f(x^*)(x_{k}-x^*)\|
{% endmath %}
其中 {% math %}\hat{\eta}\in(\eta,1){% endmath %} 。这也就是说，如果 {% math %}\|r_k\|\le\eta_k\|\nabla f_k\|{% endmath %} ，同样可以收敛，而且收敛的速度为 superlinear 。实际上如果 {% math %}\nabla^2 f{% endmath %} 连续，则收敛速度可以达到 quadratic。

精度要求不高的情况下，我们可以用 conjugate gradient(CG) 的方法去计算近似解。但是使用的方法和 CG 有少许的不同。
## Line Search Newton-CG
上面提到了 {% math %}\eta_k \in (0,1){% endmath %} ，在这里我们取 {% math %}\eta_k=\min(0.5, \sqrt{\|\nabla f_k\|}){% endmath %}
1. given {% math %}x_0{% endmath %}
2. repeat
    - {% math %}\epsilon_k=\min(0.5, \sqrt{\|\nabla f_k\|})\|\nabla f_k\|{% endmath %}
    - {% math %}z_0=0,r_0=\nabla f_k, d_0=-r_0=-\nabla f_k{% endmath %}
    - repeat j = 0,1,2....
        - if {% math %}d_j^T B_kd_j\le0{% endmath %}
            - if j = 0  return {% math %}p_k=-\nabla f{% endmath %}
            - else return {% math %}p_k=z_j{% endmath %}
        - {% math %}\alpha_j=\dfrac{r^T_jr_j}{d^T_jBd_j}{% endmath %}
        - {% math %}z_{j+1} = z_j+\alpha_jd_j{% endmath %}
        - {% math %}r_{j+1} = r_j+\alpha_jB_kd_j{% endmath %}
        - if {% math %}\|r_{j+1}\| < \epsilon_k{% endmath %} return {% math %}p_k=z_{j+1}{% endmath %}
        - {% math %}\beta_{j+1}=\dfrac{r^T_{j+1}r_{j+1}}{r^T_jr_j}{% endmath %}
        - {% math %}d_{j+1}=-r_{j+1}+\beta_{j+1}d_j{% endmath %}

    - compute {% math %}\alpha_k{% endmath %} by Wolfe, Goldstein or Armjio
    - compute {% math %}x_{k+1} = x_k+\alpha_kp_k{% endmath %}

    until convergence

上面算法中第一个if是为了保证 {% math %}p_k{% endmath %} 恒为下降方向(我觉得这种情况下 {% math %}B_k{% endmath %} 不正定，可能无解，所以单独考虑)。稍微观察下上面的算法就会发现，上面的算法并没有要求我们计算 Hessian 矩阵，我们只需要提供 {% math %}B_kd{% endmath %} 。这种情况下我们可以用下式近似 {% math %}B_kd{% endmath %}：
{% math %}
B_kd\approx \dfrac{\nabla f(x_k+hd)-\nabla f(x_k)}{h}
{% endmath %}

但是上面的方法还是存在问题。当 Hessian 矩阵接近于奇异矩阵时，这种方法会跑的很慢。不过可以对最后生成的向量进行 normalization，但是这样情况下普通情况的表现会比较差。

## CG-steihaug
除了 Line search 之外，还有 trust-region中也有类似的过程。在 trust-region 中，我们需要求解
{% math %}
\min_{p\in R^n} m_k(p) = f_k+\nabla f_k^Tp + \frac{1}{2}p^T B_kp\quad s.t.\ \|p\|\le\Delta_k
{% endmath %}
我们同样可以用上面的思路去求解。CG-steihaug 就是这样的算法。算法的整体流程如下(符号同Line Search没有太大区别)：
1. given {% math %}\epsilon_k>0,z_0=0,r_0=\nabla f_k, d_0=-r_0=-\nabla f_k{% endmath %}
2. if {% math %}\|r_0\|<\epsilon_k{% endmath %} return {% math %}p_0=z_0{% endmath %}
3. repeat j = 0,1,2....
    - if {% math %}d_j^TB_kd_j\le0{% endmath %} find {% math %}p_k=z_j+\tau d_j{% endmath %} min {% math %}m_k(p_k){% endmath %} and {% math %}\|m_k(p_k)\|=\Delta_k{% endmath %}, return
    - {% math %}\alpha_j=\dfrac{r^T_jr_j}{d^T_jBd_j}{% endmath %}
    - {% math %}z_{j+1} = z_j+\alpha_jd_j{% endmath %}
    - if {% math %}\|z_{j+1}\|\ge\Delta_k{% endmath %} find {% math %}\|p_k\|=\|z_j+\tau d_j\| = \Delta_k{% endmath %}, return
    - {% math %}r_{j+1} = r_j+\alpha_jB_kd_j{% endmath %}
    - if {% math %}\|r_{j+1}\| < \epsilon_k{% endmath %} return {% math %}p_k=z_{j+1}{% endmath %}
    - {% math %}\beta_{j+1}=\dfrac{r^T_{j+1}r_{j+1}}{r^T_jr_j}{% endmath %}
    - {% math %}d_{j+1}=-r_{j+1}+\beta_{j+1}d_j{% endmath %}

  until convergence

可以看到，整体流程和上面的 Line Search Newton-CG 相差不大。初始条件中的 {% math %}z_0=0{% endmath %} 保证了算法求得的 {% math %}p_k{% endmath %} 满足 {% math %}m_k(p_k)\le m_k(p_k^c){% endmath %}， {% math %}p_k^c{% endmath %} 为 cauchy point。这保证了整体算法的收敛性。 {% math %}z_0=0{% endmath %} 还带来了一条重要的性质：
{% math %}
\|z_0\|_ 2<\|z_1\|_ 2...<\|z_j\|_ 2<...<\|p_k\|_ 2 \le \Delta_k
{% endmath %}

### precoditioning
很多算法在condition number不佳的情况下都可以使用 precoditioning 进行处理。 Trust-region 的处理方法已经有过介绍，直接修改约束条件为 {% math %}\|Dp\|\le\Delta_k{% endmath %} 即可。

不过在这里介绍一种 {% math %}D{% endmath %} 的计算方法：
1. compute {% math %}T=diag(\|Be_1\|,\|Be_2\|...\|Be_n\|){% endmath %} {% math %}e_i{% endmath %} is coordinate vector
2. {% math %}\bar{B} = T^{-\frac{1}{2}}BT^{\frac{1}{2}}, \beta=\|\bar{B}\|{% endmath %}
3. if {% math %}\min_i b_{ii}>0{% endmath %}, {% math %}\alpha_0=0{% endmath %}; else {% math %}\alpha_0=\dfrac{\beta}{2}{% endmath %}
4. for k = 1,2...n
    - try factorization {% math %}LL^T=\bar{B}+\alpha_k I{% endmath %}
    - if success, return {% math %}L{% endmath %} else {% math %}\alpha_{k+1}=\max(2\alpha_k,\beta/2){% endmath %}

最后将返回的 {% math %}L{% endmath %} 设为 {% math %}D{% endmath %} 即可。

### Trust-region newton-lanczos method
上面的算法还有一个问题：在negative curvature(这个概念可以参见  [Curvature of surfaces](http://www.geom.uiuc.edu/docs/education/institute91/handouts/node21.html))时，{% math %}p_k{% endmath %} 可以是任何方向，即使该方向基本没有对目标函数产生什么改变。

有很多方案可以改善这个问题，例如Trust-region 中的 iterative solution。在 iterative solution 中，{% math %}\nabla f{% endmath %} 最小特征值对应的特征向量在更新方向中占了很大的比重。这可以让算法快速逃离局部最优解(我也不知道为什么可以)

这种情况下我们可以使用 Lanczos method 去计算 {% math %}B_kp=-\nabla f_k{% endmath %} 的近似解。Lanczos method 的第 j 步需要通过求解 {% math %}Q_j^TBQ_j=T_j{% endmath %} 计算一个 n*j 维的矩阵 {% math %}Q_j{% endmath %}，其中 {% math %}T_j{% endmath %} 为 tridiagonal。这种情况下我们求出的矩阵 Krylov subspace(即 span {% math %}\{r_0, B_kr_0,...,B_k^kr_0\}{% endmath %}) 正交。令 {% math %}e_1=(1,0,...,0)^T{% endmath %}，我们需要求解
{% math %}
\min_{w\in R^j} f_k+e_1^TQ_j(\nabla f_k)e_1^Tw+\frac{1}{2} w^TT_jw
{% endmath %}
最后的解 {% math %}p_k=Q_jw{% endmath %}
# Limited-Memory Quasi-newton method
当 Hessian 矩阵不是稀疏矩阵或者是计算量过大时，我们需要一些简单的方法。
## L-BFGS
在 Quasi-newton method 中，我们需要的往往是 {% math %}H_k\nabla f{% endmath %} ，我们可以通过迭代式的方法直接求出 {% math %}H_k\nabla f{% endmath %}

BFGS 中 {% math %}H_{k+1}{% endmath %} 的更新可以表示为 {% math %}H_{k+1} = V_k^TH_kV_k+\rho_ks_ks^T_k{% endmath %}，进一步可以表示为：
{% math %}
\begin{align}
H_k &= (V_{k-1}^T...V_{k-m}^T)H_k^0(V_{k-m}...V_{k-1})\\
&+\rho_{k-m}(V_{k-1}^T...V_{k-m+1}^T)s_{k-m}s_{k-m}^T(V_{k-m+1}...V_{k-1})\\
&+\rho_{k-m-1}(V_{k-1}^T...V_{k-m+2}^T)s_{k-m+1}s_{k-m+1}^T(V_{k-m+2}...V_{k-1})\\
&+...\\
&+\rho_{k-1}s_{k-1}s_{k-1}^T\\
\end{align}
{% endmath %}
利用上面的式子，我们可以迭代计算出 {% math %}H_k\nabla f{% endmath %} 。该算法被称为 L-BFGS：
1. {% math %}q=\nabla f{% endmath %}
2. for i = k-1,k-2,...,k-m
    - {% math %}\alpha_i=\rho_is_i^Tq{% endmath %}
    - {% math %}q=q-\alpha_iy_i{% endmath %}
3. {% math %}r=H_k^0q{% endmath %}
4. for i = k-m, k-m+1,...,k-1
    - {% math %}\beta = \rho_iy_i^Tr{% endmath %}
    - {% math %}r=r+s_i(\alpha_i-\beta){% endmath %}

{% math %}r{% endmath %} 即为 {% math %}H_k\nabla f{% endmath %}

对于 {% math %}m{% endmath %} 的选择问题，同样没有什么一般性的方法。 {% math %}m{% endmath %} 较小时，算法不够健壮；在 {% math %}m{% endmath %} 过大时，则需要更大的计算量。

## compact representation
以 BFGS 为例，说明 compact representation。BFGS的更新过程可以表述为下面的矩阵形式：
{% math %}
\begin{align}
S_k &= [s_0,...,s_k]\\
Y_k &= [y_0,...,y_k]\\
(L_k)_ {i,j} &= \begin{cases}
                  s^T_{i-1}y_{j-1}& \text{if } i>j\\
                  0&\text{otherwise}
                \end{cases}\\
D_k&=diag[s_0^Ty_0,...,s_{k-1}^Ty_{k-1}]\\
B_K&=B_0-\begin{bmatrix}B_0S_k & Y_k\end{bmatrix}\begin{bmatrix}S_K^TB_0S_k & L_k\\L^T_k &-D_k\end{bmatrix}^{-1}\begin{bmatrix}S_k^TB_0 \\ Y_k^T\end{bmatrix}
\end{align}
{% endmath %}
如果我们令 {% math %}\delta_k = \dfrac{y_{k-1}^Ty_{k-1}}{s_{k-1}^Ty_{k-1}}，  B_0^{(k)} = \delta_kI{% endmath %}，同时对 {% math %}S_k, Y_k{% endmath %} 做一些简化，可得：
{% math %}
\begin{align}
S_k &= [s_{k-m-1},...,s_{k-1}]\\
Y_k &= [y_{k-m-1},...,y_{k-1}]\\
(L_k)_ {i,j} &= \begin{cases}
                  s^T_{k-m+i-1}y_{k-m+j-1}& \text{if } i>j\\
                  0&\text{otherwise}
                \end{cases}\\
D_k&=diag[s_{k-m}^Ty_{k-m},...,s_{k-1}^Ty_{k-1}]\\
B_K&=\delta_kI-\begin{bmatrix}\delta_kS_k & Y_k\end{bmatrix}\begin{bmatrix}\delta_kS_K^TS_k & L_k\\L^T_k &-D_k\end{bmatrix}^{-1}\begin{bmatrix}\delta_kS_k^T \\ Y_k^T\end{bmatrix}
\end{align}
{% endmath %}
矩阵的更新以及最后的求解所需要的计算量相对来说不是很高。这种算法还是有其可取之处。

当然，用同样的方法还可以推导出 SR1 的 compact representation。将 SR1 中的 B,s,y 直接替换成 H,y,s 就可以得到 {% math %}H_k{% endmath %} 的更新

### unrolling the update
与上面的方法相比，这是一种相对低效，但是更加简单的方式。我们可以将 BFGS 表示为下面的形式：
{% math %}
\begin{align}
a_k &= \frac{B_ks_k}{(s_k^TB_ks_k)^{1/2}}\\
b_k &= \frac{y_k}{(y_k^Ts_k)^{1/2}}\\
B_{k+1} &= B_k-a_ka_k^T+b_kb_k^T\\
&= B_k^0 + \sum_{i=k-m}^{k-1}(b_ib_i^T-a_ia_i^T)
\end{align}
{% endmath %}

所以我们的更新算法可以表示为：

for i = k-m, k-m+1,...,k-1
1. {% math %}b_i=y_i/(y_i^Ts_i)^{1/2}{% endmath %}
2. {% math %}a_i=B_k^0s_i+\sum_{j=k-m}^{i-1}[(b_j^Ts_j)b_j - (a_j^Ts_j)a_j]{% endmath %}
3. {% math %}a_i=a_i/(s_k^Ta_i)^{1/2}{% endmath %}

#Partially Separable Function
当我们要处理的函数是多维变量的时候，虽然不常见，但是可能会有下面的形式：
{% math %}
f(x) = f(x_1,x_2) + f(x_3,x_4)
{% endmath %}
这就是 separable function。更常见的情况是下面的这种：
{% math %}
f(x) = \sum_{i=1}^{ne} f_i(x)
{% endmath %}
这种情况下可以很明显的发现，{% math %}f(x){% endmath %} 的 hessian 矩阵是所有 {% math %}f_i(x){% endmath %} 的 hessian 矩阵之和。这种情况下我们可以用 quasi-newton 的方法求出每个子函数的 hessian 矩阵，然后相加。当然了，这时候 {% math %}y^T_ks_k{% endmath %} 显然不可能恒大于0，所以更推荐使用SR1
