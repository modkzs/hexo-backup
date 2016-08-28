title: QP问题
tags: [optimization]
date: 2016-08-16 08:43:53
categories: math
---
QP问题，即带线性约束的二次方程最小化问题。QP问题的一般形式为：
{% math %}
\label{origin}
\min_x\ q(x) = \frac{1}{2}x^TGx+x^Tc\\
s.t.\ a^T_ix = b_i,\quad i\in\mathcal{E}\\
a^T_ix \ge b_i,\quad i\in\mathcal{I}
{% endmath %}
对于 Hessian 矩阵 {% math %}G{% endmath %} 来说，如果是半正定的，则QP称为凸QP；否则称为非凸QP。显然，非凸QP问题更麻烦一些。不过我们这里只关注凸QP问题。
<!--more-->
# 只有等式约束的QP问题
先从等式约束开始说起。等式约束的QP问题可以表示为：
{% math %}
\min_x\ q(x) = \frac{1}{2}x^TGx+x^Tc\\
s.t.\ Ax = b
{% endmath %}
先看A满秩的情况。根据 KKT 条件，方程的解需要满足下面的条件：
{% math %}
\begin{bmatrix}G & -A^T\\A&0\end{bmatrix}\begin{bmatrix}x^* \\\lambda^* \end{bmatrix} = \begin{bmatrix}-c \\b \end{bmatrix}
{% endmath %}
我们令 {% math %}x^* = x+p{% endmath %}，对上面的等式稍加变换，就可以得到
{% math %}
\label{KKT}
\begin{bmatrix}G & A^T\\A&0\end{bmatrix}\begin{bmatrix}-p \\\lambda^* \end{bmatrix} = \begin{bmatrix}g \\h \end{bmatrix}\\
h = Ax-b\\
g = c+Gx\\
p = x^* - x
{% endmath %}
上面的矩阵被称为 KKT 矩阵。令 Z 为 A 的 null space(即 AZ = 0)，维数为 {% math %}n\times(n-m){% endmath %} 。如果 {% math %}Z^TGZ{% endmath %} 正定，则 KKT 矩阵必然非奇异，也非正定。而满足 KKT 矩阵的解必然为 QP 的解。

## KKT 系统求解
所以现在的问题就是如何求解上面的 KKT 系统。我们先来看直接求解的方法。为了方便说明，将 KKT 矩阵记为 {% math %}K{% endmath %}
### 直接求解
#### schur-complement
直接用 schur-complement 暴力求解。利用 schur-complement 可以直接拿到 {% math %}K{% endmath %} 的逆：
{% math %}
\begin{aligned}
K^{-1} &= \begin{bmatrix}C & E\\E^T&F\end{bmatrix}\\
C &= G^{-1}-G^{-1}A^T(AG^{-1}A^T)^{-1}AG^{-1}\\
E &= G^{-1}A^T(AG^{-1}A^T)^{-1}\\
F &= -(AG^{-1}A^T)^{-1}
\end{aligned}
{% endmath %}
当然了其实你用高斯消元是可以直接解出来的，和这么算的结果也太不太多。不过这么暴力真的好么= =

#### 矩阵分解
由于 KKT 矩阵非正定，无法使用 cholesky 分解，所以用 symmetric indefinite factorization。对于一个对称矩阵 {% math %}K{% endmath %}， symmetric indefinite factorization 可以表示为
{% math %}
P^TKP=LBL^T
{% endmath %}
其中 {% math %}P{% endmath %} 为 permutation 矩阵， {% math %}L{% endmath %} 为下三角矩阵，{% math %}B{% endmath %} 为 block-diagonal 矩阵， block 的大小一般为 1\*1 或者 2*2.这种情况下，可以将 \ref{KKT} 的解表示为：
{% math %}
Lz = P^T\begin{bmatrix}g \\h \end{bmatrix}\\
B\hat{z} = z\\
L^T \bar{z} = \hat{z}\\
\begin{bmatrix}-p \\\lambda^* \end{bmatrix} = P\bar{z}\\
{% endmath %}

#### null space
\ref{KKT} 中的向量 {% math %}p{% endmath %} 其实可以被分解为2个部分：
{% math %}
p = Yp_Y + Zp_Z
{% endmath %}
其中 {% math %}Z{% endmath %} 为 n*(n-m) 的矩阵，是 {% math %}A{% endmath %} 的 null space。 Y 为 n*m 的矩阵，保证 [Y|Z] 非奇异。由于 {% math %}AZ=0{% endmath %}，所以
{% math %}
(AY)p_Y = -h\\
-GYp_Y-GZp_Z+A^T\lambda^* = g
{% endmath %}
将后一个式子乘以 {% math %}Z^T{% endmath %} 可以得到
{% math %}
(Z^TGZ)p_z = -Z^TGYp_Y-Z^Tg
{% endmath %}
{% math %}Z^TGZ{% endmath %} 是对称正定的，所以可以用 cholesky 分解。所以我们可以通过解上面的等式得到 \ref{KKT} 的解。最后
{% math %}
p = Yp_Y+Zp_Z\\
(AY)^T\lambda^* = Y^T(g+Gp)
{% endmath %}
当然 Z 的维度越小，算法跑的越快。但是如果 {% math %}AG^{-1}A^T{% endmath %} 很好算的话，还是 schur-complement 暴力硬上更快一些。
### 迭代式解法
迭代式解法主要用的是 [CG](http://modkzs.github.io/2016/06/06/conjugate-gradient-method/)。 根据前面的说明，最优解 {% math %}x^* = Yx_Y +Zx_Z{% endmath %}
这样的话，根据 {% math %}AYx_Y = b{% endmath %}，我们可以直接解出 {% math %}x_Y{% endmath %}。不过这涉及到 Y 的选择问题。

对于Y的选择，方法有很多。这里只简单列出两种：
- A为 m*n 维矩阵，如果 A 满秩，就会有 m 个线性无关组(假设 m < n)。那么就可以找到一个 permutation 矩阵 {% math %}P{% endmath %} 使得 {% math %}AP = [B|N]{% endmath %} 其中 {% math %}B{% endmath %} 为线性无关组所在的矩阵。我们可以令 {% math %}Y = \begin{bmatrix}B^{-1}\\0\end{bmatrix}{% endmath %}
- 对 {% math %}A{% endmath %} 做 QR 分解： {% math %}A^T\Pi = \begin{bmatrix}Q_1&Q_2\end{bmatrix} \begin{bmatrix}R\\0\end{bmatrix}{% endmath %}，令 {% math %}Y=Q_1{% endmath %}

这种情况下，去掉只和 {% math %}x_Y{% endmath %} 有关的部分，可以将原问题化简为
{% math %}
\min_{x_Z} \frac{1}{2}x_Z^TZ^TGZx_Z+x_Z^Tc_Z\\
c_Z = Z^TGYx_y+Z^Tc
{% endmath %}
上面的解很简单：{% math %}Z^TGZx_Z=-c_Z{% endmath %} 所以我们只要用 CG 解这个方程就行了。CG的算法如下：
1. choose initial point {% math %}x_Z{% endmath %}
2. compute {% math %}r_Z=Z^TGZx_Z,\ g_Z=W_{ZZ}^{-1}r_Z,\ d_Z=-g_Z{% endmath %}
3. repeat
     {% math %}
     \begin{aligned}
     \alpha &= r_Z^Tg_Z/d^T_ZZ^TGZd_Z\\
     x_Z &= x_Z+\alpha d_Z\\
     r_Z^+ &= r_Z+\alpha Z^TGZd_Z\\
     g_Z^+ &= W_{ZZ}^{-1}r_Z^+\\
     \beta &= (r_Z^+)^Tg_Z^+/r_Z^Tg_Z\\
     d_Z &= -g_Z^+ + \beta d_Z\\
     g_Z &= g_Z^+\\
     r_Z &= r_Z^+
     \end{aligned}
     {% endmath %}
     until convergence

和CG算法基本一致，不过进行了 precondition。 终止条件可以是 {% math %}r_Z^TW_{ZZ}^{-1}r_Z{% endmath %} 足够小或者其他表示残差小的东西。至于 preconditioner {% math %}W_{ZZ}{% endmath %} ，它本身的存在就是为了防止 {% math %}Z^TGZ{% endmath %} 的条件数过高，所以取值方面自然是要降低条件数。最极限的做法自然是令 {% math %}W_{ZZ} = Z^TGZ{% endmath %}， 一下给降到1。当然也可以用缓和点的取法，{% math %}W_{ZZ} = Z^THZ{% endmath %} 其中 {% math %}H{% endmath %} 是对称矩阵保证{% math %}W_{ZZ}{% endmath %} 正定。 {% math %}H{% endmath %} 可以取值为 {% math %}diag(|G_{ii}|){% endmath %} 或者 {% math %}I{% endmath %} 。有时也可以取值为 {% math %}G{% endmath %} 的 block diagonal submatrix.

算法中其实没有对 {% math %}Z{% endmath %} 单独做操作，所以只要能求出来 {% math %}Z^TGZ{% endmath %} 或者它和其他向量的乘法计算就可以。

但是算法上避免 {% math %}Z{% endmath %} 的计算仍然是可能的。不过我们最后求出来的直接是 {% math %}x{% endmath %} 不是 {% math %}x_Z{% endmath %} 。不过介绍算法之前，需要引入几个记号：
{% math %}
\begin{aligned}
Z^Tr&=r_Z\\
g&=Zg_Z\\
d&=Zd_Z\\
P&=Z(Z^THZ)^{-1}Z^T
\end{aligned}
{% endmath %}
算法叫做 Projected CG：
1. choose init point {% math %}x{% endmath %} satisfied {% math %}Ax=b{% endmath %}
2. compute {% math %}r=Gx+c, g=Pr, d=-g{% endmath %}
3. repeat
    {% math %}
    \begin{aligned}
      \alpha &= r^Tg/d^TGd\\
      x &= x+\alpha d\\
      r^+ &= r + \alpha Gd\\
      g^+ &= Pr^+\\
      \beta &= (r^+)^Tg^+/r^Tg\\
      d &= -g^+ + \beta d\\
      g &= g^+\\
      r &= r^+
    \end{aligned}
    {% endmath %}
    until convergence

终止条件是 {% math %}r^Tg - r^TPr{% endmath %} 很小。当然了，这么搞其实和上面一样，因为 {% math %}P{% endmath %} 的计算需要依靠 {% math %}Z{% endmath %} 。但是，{% math %}P{% endmath %} 其实可以用其他方法计算：
{% math %}
P = H^{-1}(I-A^T(AH^{-1}A^T)^{-1}AH^{-1})
{% endmath %}
这种情况下 {% math %}g^+ = Pr^+{% endmath %} 可以表示为：
{% math %}
\begin{bmatrix}H & A^T \\ A & 0\end{bmatrix}\begin{bmatrix}g^+\\ v^+\end{bmatrix} = \begin{bmatrix}r^+\\ 0\end{bmatrix}
{% endmath %}
对于这个等式，可以直接用前面的矩阵分解来求。

# 不等式约束的情况
讨论完了只有等式的部分，现在开始处理不等式的部分。我们令 {% math %}\mathcal{A}(x^* )=\{i\in \mathcal{E}\cup\mathcal{I}|a_i^Tx^* = b_i\}{% endmath %}。 那么对于 \ref{origin} 来说，利用 KKT 条件可以得到最优解满足的条件：
{% math %}
\begin{aligned}
Gx^* + c - \sum_{i \in \mathcal{A}(x^* )}\lambda_i^* a_i &= 0\\
a_i^Tx^* &= b_i \quad \text{for all } i \in \mathcal{A}(x^* )\\
a_i^Tx^* &\ge b_i\quad \text{for all } i \in \mathcal{I}\backslash \mathcal{A}(x^* )\\
\lambda_i^* &\ge 0\quad \text{for all } i \in \mathcal{I}\cap \mathcal{A}(x^* )

\end{aligned}
{% endmath %}

当 {% math %}G{% endmath %} 正定时，目标函数是凸函数，没有任何问题；但是如果不满足条件，就比较麻烦了，这时候会出现多个局部最优解。

但是麻烦远不止这一个。有时候会出现 degeracy 的情况。这种情况一般分为两种：
1. {% math %}a_i, i\in \mathcal{A}(x^* ){% endmath %} 线性相关
2. 一些 {% math %}\lambda_i^* = 0, i\in \mathcal{A}(x^* ){% endmath %}

第一点的问题主要是不正定所带来的数值问题；而第二点的问题主要是无法判断哪些条件属于 active set(即 {% math %}\mathcal{A}(x){% endmath %})

下面给出3种解法。

## active-set method
active-set method 的思想和线性规划的 simplex method 很像，都需要找到最后的 active set。

假设我们在第k步得到了 {% math %}x_k{% endmath %} 和当前的 active set {% math %}\mathcal{W}_k{% endmath %} 。首先要检查 {% math %}x_k{% endmath %} 是否是当前条件下的最小值，如果不是，则需要计算 {% math %}x{% endmath %} 的更新量 {% math %}p{% endmath %}：
{% math %}
\label{p_min}
\min_p \frac{1}{2}p^TGp + g_k^Tp\\
s.t.\ a_i^Tp = 0\quad i\in\mathcal{W}_k
{% endmath %}
如果更新后的 {% math %}x_{k+1}{% endmath %} 满足所有的不等式约束，就可以直接更新，否则我们需要缩小更新量直到所有的约束都满足(所以是有可能一次更新的更新量为0)。对于每个不等式约束来说，都需要满足：
{% math %}
a_i^T(x_k+\alpha_kp_k)\ge b_i
{% endmath %}
因此
{% math %}
\alpha_k \le \dfrac{b_i-a_i^Tx_k}{a_i^Tp_k}
{% endmath %}
对于所有的不等式约束都算一遍，就能得到最后的更新率：
{% math %}
\alpha_k = \min(1, \min_{i\notin\mathcal{W}_k,a_i^Tp_k<0}\dfrac{b_i-a_i^Tx_k}{a_i^Tp_k})
{% endmath %}
所以很显然，当 {% math %}\alpha_k{% endmath %} 小于1的时候，肯定会有不等书约束被 active 。这时我们需要更新 {% math %}\mathcal{W}_k{% endmath %}, 加上刚刚 active 的约束。显然这样一直往下加，必然会结束。要不就是约束全部 active， 要不就是找到了最小值。这种情况下的 {% math %}\hat{x}{% endmath %} 和 {% math %}\hat{\lambda}{% endmath %} 是满足 KKT 条件的，所以我们可以计算出部分的 {% math %}\hat{\lambda}{% endmath %}。如果计算的结果全部非负，那么找到最优解；如果有负值，说明负值对应的约束不在实际的 active set 中，需要去掉再进行计算。

这样我们就得到了最后的 active-set method：
1. get init point {% math %}x_0{% endmath %} and get active set {% math %}\mathcal{W}_0{% endmath %}
2. repeat
    - solve \ref{p_min} to get {% math %}p_k{% endmath %}
    - if {% math %}p_k{% endmath %} = 0
      - compute {% math %}\hat{\lambda}{% endmath %}
      - if {% math %}\hat{\lambda}_i>0{% endmath %} for all {% math %}i \in \mathcal{I}\cap \mathcal{W}_k{% endmath %}, stop
      - else
        {% math %}
        j = \arg\min_{j\in\mathcal{I}\cap \mathcal{W}_k}\hat{\lambda}_j\\
        x_{k+1} = x_k\\
        \mathcal{W}_{k+1}=\mathcal{W}_{k}\backslash\{j\}
        {% endmath %}
    - else
      - compute {% math %}\alpha_k{% endmath %}
      - {% math %}x_{k+1} = x_k+\alpha_kp_k{% endmath %}
      - if {% math %}\alpha_k < 1{% endmath %}, update {% math %}\mathcal{W}_k{% endmath %}
      - {% math %}\mathcal{W}_{k+1}{% endmath %} = {% math %}\mathcal{W}_k{% endmath %}

和 simplex 不同的是，该算法不会出现 cycling 的情况，所以必然会在固定步数内结束。

现在我们还剩下最后一步，初值。对于初值的获得，和 simplex method 一样，我们需要一个 Phase I。下面说一些 Phase I 的算法。

### Phase I
和 simplex method 一样， phase I 同样是最小化的过程。比如可以用
{% math %}
\min_{(x,z)} e^Tz\\
s.t.\ a_i^Tx + \gamma_iz_i = b_i\quad i\in \mathcal{E}\\
a_i^Tx + \gamma_iz_i \ge b_i\quad i\in \mathcal{I}\\
z \ge 0
{% endmath %}
其中 {% math %}e=(1,1,...,1)^T,\gamma_i=\begin{cases}-\text{sign}(a^T_ix-b) & i\in\mathcal{E}\\ 1 & i\in\mathcal{I}\end{cases}{% endmath %}

或者可以用 penalty(or bigM) method:
{% math %}
\min_{(x, \eta)}\ \frac{1}{2}x^TGx+x^Tc+M\eta\\
s.t. \ a_i^Tx-b_i\le\eta\quad i \in \mathcal{E}\\
-(a_i^Tx-b_i)\le\eta\quad i \in \mathcal{E}\\
b_i-a_i^Tx\le\eta\quad i \in \mathcal{I}\\
0\le\eta\\
{% endmath %}
当然这种情况下我们又面临 {% math %}M{% endmath %} 的选择问题。当然这个就简单很多。我们的最终目的是让求解的 {% math %}\eta = 0{% endmath %} 所以如果条件不满足，加大 {% math %}M{% endmath %} 就可以了。

与上面的方法类似，可以用 {% math %}l_1{% endmath %} 作为惩罚项：
{% math %}
\min_{(x,s,t,v)} \ \frac{1}{2}x^TGx + x^Tc+Me^T_{\mathcal{E}}(s+t) + Me^T_{\mathcal{I}}v\\
s.t.\ a_i^Tx-b_i+s_i-t_i = 0\quad i\in\mathcal{E}\\
a_i^Tx-b_i+v_i \ge 0\quad i\in\mathcal{I}\\
s\ge 0, t\ge 0, v\ge 0
{% endmath %}
{% math %}e_{\mathcal{E}},e_{\mathcal{I}}{% endmath %} 都是全1向量

### update 的问题
最后还有一个问题。在算法中，每次迭代我们都需要计算 {% math %}p_k{% endmath %} ，但是其实每次更新的 {% math %}\mathcal{W}_k{% endmath %} 都只是单个条件的加减而已。所以 {% math %}p_k{% endmath %} 的计算其实是可以复用的。由于 {% math %}p_k{% endmath %} 的计算也是带有等式约束的QP问题，所以可以用前面提到的方法去解。这里我们对 null space method 进行讨论。

在 null space method 中。一旦 {% math %}Y{% endmath %} 和 {% math %}Z{% endmath %} 确定，{% math %}p{% endmath %} 就可以确定。一种 {% math %}Y{% endmath %} 和 {% math %}Z{% endmath %} 的取法是对 {% math %}A{% endmath %} 做QR分解：
{% math %}
A^T\Pi = Q\begin{bmatrix}R\\0\end{bmatrix} = \begin{bmatrix}Q_1&Q_2\end{bmatrix}\begin{bmatrix}R\\0\end{bmatrix}
{% endmath %}
其中 {% math %}\Pi{% endmath %} 为 permutation 矩阵，{% math %}Q{% endmath %} 为正交矩阵，{% math %}R{% endmath %} 为非奇异的上三角矩阵。令 {% math %}Y=Q_1,\ Z=Q_2{% endmath %} 我们的更新也从这里入手。
对于增加约束的情况，将约束增加后的矩阵记为 {% math %}\bar{A}{% endmath %}, 则 {% math %}\bar{A}^T = \begin{bmatrix}A^T&a\end{bmatrix}{% endmath %} {% math %}a{% endmath %} 为行向量，使 {% math %}\bar{A}{% endmath %} 保持行满秩。则
{% math %}
\bar{A}^T\begin{bmatrix}\Pi&0\\0&1\end{bmatrix} = \begin{bmatrix}A^T\Pi&a\end{bmatrix} = Q\begin{bmatrix}R&Q_1^Ta\\0&Q_2^Ta\end{bmatrix}
{% endmath %}
现令正交矩阵 {% math %}\hat{Q}{% endmath %} 满足：
{% math %}
\hat{Q}(Q^T_2a) = \begin{bmatrix}\gamma\\0\end{bmatrix}
{% endmath %}
则
{% math %}
\bar{A}^T\begin{bmatrix}\Pi&0\\0&1\end{bmatrix} = Q\begin{bmatrix}R&0\\0&\hat{Q}^T\begin{bmatrix}\gamma\\0\end{bmatrix}\end{bmatrix} = Q\begin{bmatrix}I&0\\0&\hat{Q}^T\end{bmatrix}\begin{bmatrix}R&Q_1^Ta\\0&\gamma\\0&0\end{bmatrix}
{% endmath %}
所以
{% math %}
\bar{\Pi} = \begin{bmatrix}\Pi&0\\0&1\end{bmatrix}\\
\bar{Q} = Q\begin{bmatrix}I&0\\0&\hat{Q}^T\end{bmatrix} = \begin{bmatrix}Q_1&Q_2\hat{Q}^T\end{bmatrix}\\
\bar{R} = \begin{bmatrix}R&Q_1^Ta\\0&\gamma\end{bmatrix}
{% endmath %}
对于约束的删除来说，则是 {% math %}R{% endmath %} 中的某一行被删除。这样的话 {% math %}R{% endmath %} 直接就不是上三角矩阵了，所以我们需要一个 permutation 矩阵进行行变换以恢复 {% math %}R{% endmath %} 的上三角特征。

## gradient projection method
active-set method 在大规模的约束情况下会收敛的很慢。毕竟每次只能增删一个约束，要是碰到个2千约束的，至少都要2000次迭代。gradient projection 就不一样。

我们将 gradient projection 处理的问题描述为：
{% math %}
\min_x\ q(x) = \frac{1}{2}x^TGx+x^Tc\\
s.t.\ l\le x \le u
{% endmath %}
其中 {% math %}G{% endmath %} 是对称的，但是不需要正定。

gradient projection 的思路类似于 trust-region。算法被分为2个阶段：首先沿着导数方向进行更新，即 {% math %}g=Gx+c{% endmath %} 。当 {% math %}x{% endmath %} 到达边界时，我们将导数在约束空间内做投影。之后利用得到的约束进行再次计算。

我们将 {% math %}x{% endmath %} 在约束空间内的投影表示为
{% math %}
P(x,l,u)=\begin{cases}l_i & \text{if } x_i<l_i\\x_i& \text{if } x_i\in[l_i,u_i]\\u_i& \text{if } x_i>u_i\end{cases}
{% endmath %}
这种情况下我们得到的导数 {% math %}x(t) = P(x-tg,l,u){% endmath %} 对于每个约束，我们可以拿到的 {% math %}t{% endmath %} 值为
{% math %}
\bar{t}_i=\begin{cases}(x_i-u_i)/g_i&\text{if } g_i<0,u_i<\infty \\(x_i-l_i)/g_i&\text{if } g_i>0,l_i>-\infty\\\infty&\text{otherwise }\end{cases}
{% endmath %}
为了确定t的值，我们首先要对 {% math %}\bar{t}{% endmath %} 顺序排列，在每个间隔内进行搜索：
{% math %}
x(t) = x(t_{j-1}) + (\Delta t)p^{j-1}\\
p^{j-1}_i=\begin{cases}-g_i&\text{if } t_{j-1}<\bar{t}_i\\0&\text{else}\end{cases}
{% endmath %}
搜索目标为最小化
{% math %}
q(x(t)) = c^T(x(t))+\frac{1}{2}(x(t))^TG(x(t))
{% endmath %}
这样的情况下我们就可以得到一组 active-set。更新后的目标为：
{% math %}
\min_x \frac{1}{2}x^TGx + x^Tc\\
s.t.\ x_i=x_i^c\quad i\in\mathcal{A}(x^c)\\
      l_i\le x_i\le u_i\quad i\notin\mathcal{A}(x^c)
{% endmath %}
不过得到这个问题的解的难度和原问题基本一样= =。当然，大数据量的情况下也不会要求精确解，所以粗略的用CG什么的解下就好了
