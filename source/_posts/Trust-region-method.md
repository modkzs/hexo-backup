title: Trust-region method
tags: [optimization]
date: 2016-06-06 09:32:09
categories: math
---
另一类搜索算法，先确定步长，再根据步长确定方向
<!--more-->
# 算法框架
首先引入一些记号：步长为 {% math %}\Delta_k{% endmath %} ,导数 {% math %}g_k=\nabla f_k{% endmath %} , {% math %}m_k(p) = f(x_k+p) = f_k+g_k^Tp+\frac{1}{2}p^T\nabla^2 f(x_k+tp)p{% endmath %}

就像上面所说的一样，该算法先确定步长，再确定方向。所以我们可以大致表示为：先找到步长，再确定方向，最后根据本次结果更新。

步长的寻找可以用一种启发式过程：首先我们根据给定的步长进行搜索，然后评价搜索效果。如果效果好，说明可以增加步长；效果差，则说明我们需要缩小步长。但是这样的话问题在于我们评价机制是什么？

在这里我们引入 {% math %}\rho_k=\dfrac{f(x_k)-f(x_k+p)}{m_k(0)-m_k(p)}{% endmath %} 。分子被称为 actual reduction， 分母被称为 predict reduction。显而易见， {% math %}\rho_k{% endmath %} 越大，{% math %}m_k{% endmath %} 拟合的效果越好。这种情况下我们就可以增加步长；如果 {% math %}\rho_k{% endmath %} 不是很大，我们考虑维持步长不变；如果 {% math %}\rho_k{% endmath %} 很小甚至是负数，那么很显然我们需要减小步长。

根据上面的描述，我们将 Trust-region 的搜索算法表述如下：

given {% math %}\hat{\Delta}>0, \Delta\in(0,\hat{\Delta}), \eta\in(0, \frac{1}{4}){% endmath %}, repeat:
  1. get {% math %}p_k{% endmath %} , evaluate {% math %}\rho_k{% endmath %}
  2. if {% math %}\rho_k<\frac{1}{4}{% endmath %}，{% math %}\Delta_{k+1}=\frac{1}{4}\Delta_k{% endmath %}
  3. else if {% math %}\rho_k>\frac{3}{4}{% endmath %}，{% math %}\Delta_{k+1}=\min(2\Delta_k, \hat{\Delta}){% endmath %}
  4. else {% math %}\Delta_{k+1}=\Delta_k{% endmath %}
  5. if {% math %}\rho_k>\eta， x_{k+1}=x_{k}+p_k{% endmath %}；else {% math %}x_{k+1}=x_{k}{% endmath %}

until convergence

# 子问题
在上面的算法描述中，我们留下了一个问题：如何拿到 {% math %}p_k{% endmath %} 。在确定了步长 {% math %}\Delta_k{% endmath %} 之后， {% math %}p_k{% endmath %} 的计算就成了一个优化问题：
{% math %}
\min f(x_k+p) = f_k+g_k^Tp+\frac{1}{2}p^T\nabla^2 f(x_k+tp)p\quad s.t. \|p\|\le\Delta_k
{% endmath %}
当然了， Hessian 矩阵很难求，所以我们可以用一些对称矩阵 {% math %}B_k{% endmath %} 去模拟 Hessian。 对于 {% math %}B_k{% endmath %} 的求法，会在newton method 中详细说明。

那么我们可以将上面的优化问题记为：
{% math %}
\min m(p) = f+g^Tp+\frac{1}{2}p^TBp\quad s.t. \|p\|\le\Delta
{% endmath %}
根据KKT条件，可以得到最优解 {% math %}p^*{% endmath %} 需要满足的条件：
{% math %}
(B+\lambda I)p^* = -g\\
\lambda(\Delta-\|p^* \|) = 0\\
B+\lambda I \succeq  0
{% endmath %}

## 求解算法
### Cauchy point
Cauchy point 的求解思路类似于 line search 。首先将目标函数近似为线性函数，求解
{% math %}
p_k^s = \arg\min_{p\in R^n} f_k+g_k^Tp \quad s.t. \|p\| \le \Delta_k
{% endmath %}
上面的问题可以直接求出闭式解 {% math %}p_k^s=-\dfrac{\Delta_k}{\|g_k\|}g_k{% endmath %}
然后计算
{% math %}
\tau_k = \arg\min_{\tau\ge0} m_k(\tau p_k^s)\quad s.t.\|\tau p_k^s\| \le\Delta_k
{% endmath %}
同样可以直接求出 {% math %}\tau_k=\begin{cases}1& \text{if } g_k^TB_kg_k\le0\\\min(1, \|g\|^3/(\Delta_kg_k^TB_kg_k))& \text{else}\end{cases}{% endmath %}

最后令 {% math %}p_k^c = \tau p_k^s{% endmath %}

cauchy point的计算量很低，可以保证全局收敛。而且对于任何一个 {% math %}p_k{% endmath %} ，只要其对 {% math %}m_k{% endmath %} 产生的减小量为 {% math %}p_k^s{% endmath %} 的某个固定整数倍，就可以保证全局收敛。

上面一句话听着是不是很像baseline？既然是整数倍就能收敛，cauchy point 计算量又很小，所以留下一些潜在的提升空间，所以就有了我们下面的 improvement。

#### Dogleg
我一直不知道为什么这个方法要叫 Dogleg，翻译过来难道叫狗腿法么。。。。

dogleg中我们的解是2个向量的组合：
- 无约束的 steepest descent direction {% math %}p^U=-\dfrac{g^Tg}{g^TBg}g{% endmath %}
- 原问题的解 {% math %}p^B=B^{-1}g{% endmath %}(所以我们必须要B正定)

最后的向量 {% math %}p(\tau)=\begin{cases}\tau p^U & 0\le\tau\le1\\p^U+(\tau-1)(p^B-p^U) &1\le\tau\le2\end{cases}{% endmath %}

可以证明，{% math %}\|p(\tau)\|{% endmath %} 是单调递增的，而 {% math %}m(p(\tau)){% endmath %} 是单调递减的。所以我们解出 {% math %}\|p(\tau)\| = \Delta{% endmath %} 的解即可。当然，对于 {% math %}\|p^B\|<\Delta{% endmath %} 的情况，直接将最优解设为 {% math %}p^B{% endmath %} 即可。

#### Two-dimensional subspace minization
Dogleg 人工规定了 {% math %}p^U{% endmath %} 和 {% math %}p^B{% endmath %} 的组合方法。如果我们直接对这两个变量的向量空间做优化，就是 two-dimensional subspace minization 。形式化的表达即求解下面的优化：
{% math %}
\min_p m(p) = f + g^Tp + \frac{1}{2}p^TBp \quad s.t.\|p\|\le\Delta,p\in span[g,B^{-1}g]
{% endmath %}
对于非正定的矩阵 {% math %}B{% endmath %}，可以令 {% math %}B=(B+\alpha I)\ \alpha\in(-\lambda_1, -2\lambda_1]{% endmath %} 求解。当然，上面的问题应该是有闭式解的，不过懒得求了。

## Iterative solution
上面的方法虽然可以得到解，但是毕竟不够严谨。我们根据原问题的KKT条件进行求解。对于 {% math %}B{% endmath %} 来说，当 {% math %}\lambda{% endmath %} 足够大时，其必然是正定的。所以根据KKT条件，我们的目标是找到 {% math %}\lambda{% endmath %}，使得 {% math %}p(\lambda)=\|-(B+\lambda I)^{-1}g\| = \Delta{% endmath %}。

由于{% math %}B{% endmath %} 正定，所以可以被分解为 {% math %}B=Q\Lambda Q^T{% endmath %} 其中
{% math %}
\Lambda = diag(\lambda_1,\lambda_2...\lambda_n)
{% endmath %}
{% math %}\lambda_1\le\lambda_2...\le\lambda_n{% endmath %} 为 {% math %}B{% endmath %} 的特征根。故
{% math %}
p(\lambda) = -Q(\Lambda+\lambda I)^{-1}Q^Tg=-\sum_{j=1}^n\dfrac{q^T_jg}{\lambda_j+\lambda}q_j\\
\|p(\lambda)\|^2 = -Q(\Lambda+\lambda I)^{-1}Q^Tg=-\sum_{j=1}^n\dfrac{(q^T_jg)^2}{(\lambda_j+\lambda)^2}
{% endmath %}
如果{% math %}q^T_1g>0{% endmath %} 可以发现函数图像是长这样的：
![](http://ww4.sinaimg.cn/large/9dec4451jw1f4ljwl3em9j20rk0jy75c.jpg)
所以必然存在一个 {% math %}\lambda > \lambda_1{% endmath %} ，使得 {% math %}\phi_1(x)=\|p(\lambda)\|-\Delta = 0{% endmath %} 。我们可以将其近似为 {% math %}\phi_1(x)=\dfrac{C_1}{\lambda+\lambda_1}+C_2{% endmath %}。但是该函数不是线性的，用牛顿求根法会很慢，或者很难求解。所以我们坐下变形，令
{% math %}
\phi_2(x) = \dfrac{1}{\Delta}-\dfrac{1}{\|p(\lambda)\|}
{% endmath %}
再将 {% math %}\phi_1(x){% endmath %} 带入，就有 {% math %}\phi_2(x) = \dfrac{1}{\Delta}-\dfrac{\lambda+\lambda_1}{C_3}{% endmath %}。在此情况下，我们可以用牛顿法求解。具体的求根算法如下：

repeat
  1. factor {% math %}B+\lambda^{(l)} I=R^TR{% endmath %}
  2. solve {% math %}R^TRp_l=-g, R^Tq_l=p_l{% endmath %}
  3. set {% math %}\lambda^{(l+1)}=\lambda^{(l)}+\Bigg(\dfrac{\|p_l\|}{\|q_l\|}\Bigg)^2\Bigg(\dfrac{\|p_l\|-\Delta}{\Delta}\Bigg){% endmath %}

until convergence

### hard case
上面的条件是我们假设{% math %}q^T_1g>0{% endmath %} 得到的。如果该条件不成立，那么就很难求解。且易知 {% math %}B+\lambda_1I{% endmath %} 必然奇异。这种情况下我们只能令 {% math %}\lambda=\lambda_1{% endmath %}。于是我们令
{% math %}
p=-\sum_{j:\lambda_j\neq\lambda_1}\dfrac{q^T_jg}{\lambda_j+\lambda}q_j
{% endmath %}
但是显然 {% math %}\|p\|<\Delta{% endmath %} 。我们令 {% math %}z{% endmath %} 为满足 {% math %}(B-\lambda_1I)z=0{% endmath %} 的解。则
{% math %}
p=-\sum_{j:\lambda_j\neq\lambda_1}\dfrac{q^T_jg}{\lambda_j+\lambda}q_j+\tau z
{% endmath %}
必然是满足KKT条件的。所以我们可以通过 {% math %}\|p\|=\Delta{% endmath %} 解出 {% math %}\tau{% endmath %}
# 一些enhancement
- 对于 condition number 较高的函数来说，收敛速度低是不可避免的。这种情况下我们可以进行 scaling，即将约束改为 {% math %}\|Dp\|\le\Delta{% endmath %}
- 我们在上面使用都是2范式，也可以使用其他范式进行计算
