title: Derivate-free optimization
tags: [optimization]
date: 2016-06-14 10:42:28
categories: math
---
其实感觉 Derivate-free optimization(DFO)的方法当中，大多数还是需要依靠导数的，尤其是在确定算法的初值的时候。嘛，不过相比于其他的方法来说，倒确实少了很多。
<!--more-->
DFO的方法往往用于处理无约束优化或者带有简单约束的优化(如边界等)。常见的做法往往是进行插值拟合，然后对拟合出的函数运用已有的优化算法。

# model-basd method
根据 Taylor theorm，函数可以展开为下面的式子：
{% math %}
m_k(x_k+p)=c+g^Tp+\frac{1}{2}p^TGp
{% endmath %}
我们可以拟合上面的函数得到原函数的近似。插值点的个数 {% math %}q=\frac{1}{2}(n+1)(n+2){% endmath %} ，因为需要估算出这么多的变量(假设 {% math %}G{% endmath %} 是对称的)。这种情况下，我们需要解 {% math %}q{% endmath %} 个等式：
{% math %}
m_k(y^l) = f(y^l)\quad l=1,2,3...q
\label{eq:sim}
{% endmath %}
其实本质上来说，这就是一个线性方程组。为了保证恒有解，我们挑选的 {% math %}y^l{% endmath %} 必须保证系数非奇异。

确定了 {% math %}m_k{% endmath %} 之后，就可以用其他方法去算更新量了。书中给的是 Trust-region，所以这里我们也以 Trust-region 为例进行说明。用 Trust-region 去计算更新量，也就是计算
{% math %}
\min_p m_k(x_k+p) \quad s.t. \|p\|_ 2\le\Delta
{% endmath %}
和 Trust-region 一样，我们以比值
{% math %}
\rho=\dfrac{f(x_k)-f(x_k^+)}{m_k(x_k)-m_k(x_k^+)}
{% endmath %}
表征本次迭代的效果({% math %}x_k^+{% endmath %} 为下一次可能的{% math %}x_k{% endmath %})。
但是和 Trust-region 不同的是，我们需要对 {% math %}m_k{% endmath %} 做更新。

## 算法
先描述下整个算法的流程。对于 {% math %}m_k{% endmath %} 更新的部分，我们在后面再说。算法的流程如下：
1. select {% math %}Y = \{y^1,y^2...y^q\}{% endmath %} satisfy condition
2. select {% math %}x_0{% endmath %} satisfy {% math %}f(x_0)\le f(y^i){% endmath %} for all {% math %}y^i\in Y{% endmath %}
3. given {% math %}\Delta_0,\ \eta\in(0,1){% endmath %}
4. repeat
    - form {% math %}m_k(x_k+p){% endmath %}
    - get {% math %}p{% endmath %} by trust-region
    - {% math %}x_k^+=x_k+p{% endmath %}
    - compute {% math %}\rho{% endmath %}
    - if {% math %}\rho > \eta{% endmath %}
      - replace an element in {% math %}Y{% endmath %} by x
      - choose {% math %}\Delta_{k+1}\ge\Delta_{k}{% endmath %}
      - {% math %}x_{k+1}=x_k^+{% endmath %}
      - continue
    - else if {% math %}Y{% endmath %} don't need improve:
      - choose {% math %}\Delta_{k+1}<\Delta_{k}{% endmath %}
      - {% math %}x_{k+1}=x_k{% endmath %}
      - continue
    - update {% math %}Y{% endmath %}
    - {% math %}\Delta_{k+1}=\Delta_{k}{% endmath %}
    - {% math %}x=\arg_y\min_{y\in Y}f(y){% endmath %}
    - {% math %}x_k^+ = x{% endmath %}, compute {% math %}\rho{% endmath %}
    - if {% math %}\rho \ge\eta{% endmath %}, {% math %}x_{k+1}=x_{k}^+{% endmath %}
    - else {% math %}x_{k+1}=x_{k}{% endmath %}

    until convergence

算法首先会判断当前迭代的效果。和 Trust-region 一样，效果好的话，扩大 {% math %}\Delta{% endmath %} 。效果不好则存在2种情况：用 {% math %}Y{% endmath %} 解出的拟合效果不好；或者是 {% math %}\Delta{% endmath %} 过大。 {% math %}Y{% endmath %} 的拟合效果不好可以理解为 \ref{eq:sim} 中的解为一个低维子空间。如果 \ref{eq:sim} 中的系数矩阵 condition number 过大，就会出现这种问题(我也不知道为什么)。在这种情况下，对 {% math %}Y{% endmath %} 进行调整即可；否则就调整 {% math %}\Delta{% endmath %} 。

对于 {% math %}Y{% endmath %} 的初值来说，选择单纯形每条边的中点即可。

可以看到每次迭代我们需要对 {% math %}m_k{% endmath %} 进行拟合。对于二次函数来说，拟合的计算代价过大。我们可以将二次函数切换为线性函数，减小计算量。

## 插值模拟
对于插值拟合来说，我们需要解决
{% math %}
m_k(y^l) = f(y^l)
{% endmath %}
而
{% math %}
m_k(x_k+p) = f(x_k) + g^Tp + \sum_{i<j}G_{ij}p_ip_j + \frac{1}{2}\sum_{i}G_{ii}p_i^2
{% endmath %}
令
{% math %}
\begin{align}
\hat{g} &= (g^T,\{G_{ij}\}_{i<j}，\{\frac{1}{\sqrt{2}}G_{ii}\})^T\\
\hat{p} &= (p^T,\{p_ip_j\}_{i<j}，\{\frac{1}{\sqrt{2}}p_{i}^2\})^T
\end{align}
{% endmath %}
则 {% math %}m_k(x_k) = f(x_k)+\hat{g}^T\hat{p}{% endmath %}。直接求解等式即可。当然，我们也可以假设
{% math %}
m_k(x) = \sum_{i=1}^q\alpha_i\phi_i(x)
{% endmath %}
可以求解出 {% math %}\alpha{% endmath %} 当
{% math %}
\delta(Y) = det\begin{pmatrix}\phi_1(y^1)&\cdot\cdot\cdot & \phi_1(y^q)\\\cdot& & \cdot\\\cdot& & \cdot\\\cdot& & \cdot\\\phi_q(y^1)&\cdot\cdot\cdot & \phi_q(y^q)\end{pmatrix}
{% endmath %}
非奇异。但是随着迭代次数的增加， {% math %}\delta(Y){% endmath %} 会越来越小，最后趋向于0。我们需要通过 {% math %}Y{% endmath %} 的更新来解决这个问题。

## {% math %}Y{% endmath %} 的更新
为了解决上面的问题，我们需要保证在每轮迭代时 {% math %}\delta(Y){% endmath %} 不会下降。定义 {% math %}L(\cdot,y){% endmath %} 对于 {% math %}Y{% endmath %} 中的所有点 {% math %}y, \bar{y}{% endmath %} 满足如下条件：
{% math %}
L(\bar{y}, y) = \begin{cases}0 &\bar{y}=y\\1&\bar{y}\neq y\end{cases}
{% endmath %}
则有
{% math %}
\|\delta(Y^+)\| \le \|L(y_+,y_-)\|\|\delta(Y)\|
{% endmath %}
其中 {% math %}y_-{% endmath %} 是要被替换的点， {% math %}y_+{% endmath %} 是替换 {% math %}y_-{% endmath %} 的点，{% math %}Y{% endmath %} 是原来的集合， {% math %}Y^+{% endmath %} 是替换后的集合。

再回到上面的算法。在第一个条件满足({% math %}\rho\ge\eta{% endmath %})时，我们直接让 {% math %}y_+ = x^+{% endmath %} ，然后去求 {% math %}y_-{% endmath %}：
{% math %}
y_- = \arg\min_{y\in Y}|L(x^+,y)|
{% endmath %}

该条件不满足的情况下，首先需要判断是不是 {% math %}Y{% endmath %} 的问题。如果对于所有的 {% math %}y^i\in Y{% endmath %} 的情况下都有 {% math %}\|x_k-y^i\|\le\Delta{% endmath %} 。这样的情况下我们需要更新 {% math %}\Delta{% endmath %} 。否则我们需要找到一个可以增加 {% math %}\delta(Y){% endmath %} 的 {% math %}y_+{% endmath %} 。对于每一个 {% math %}y^i\in Y{% endmath %} ，都可以找到对应的 {% math %}y^+_ i{% endmath %} ：
{% math %}
y^+_ i = \arg\max_{\|y-x_k\|\le\Delta} |L(y,y^i)|
{% endmath %}
我们需要找到 {% math %}\max|L(y^+_ i, y^i)|{% endmath %} 的 {% math %}y^i{% endmath %} 作为 {% math %}y_-{% endmath %}。

## 基于 mininum-change 的更新
书中简单的提到了这种方法。在这种方法中，我们最小只需要维持 {% math %}n+1{% endmath %} 个点，每轮迭代的优化目标为：
{% math %}
\min_{f,g,G} \|G-G_k\|_ F\\
s.t.\quad G^T=G\\
m(y^l) = f(y^l)\quad l=1,2,...\hat{q}
{% endmath %}
其中 {% math %}\|\cdot\|_ F{% endmath %} 为 Frobenius 范式，即矩阵每个元素的平方和。为了保证 {% math %}G{% endmath %} 和 {% math %}G_k{% endmath %} 不一样，{% math %}\hat{q}{% endmath %} 至少得大于 {% math %}n+1{% endmath %}；推荐为 {% math %}2n+1{% endmath %} ，同时还需要保证 {% math %}y^i{% endmath %} 不共面。

不过这种方法应该是最近提出的，所以介绍不多。

# coordinate
坐标梯度下降，一种很简单的方法，每次下降的方向都是一个基坐标向量。在遍历完所有的下降方向之后，再从头开始。坐标梯度下降的主要问题在于收敛的判断条件。在这种情况下我们不可能用 {% math %}\|\nabla f\| <\epsilon{% endmath %} 所以很难判断什么时候收敛。

# Pattern-search
Pattern-search 类似于一种泛化的坐标梯度下降，每次迭代时从一个备选集中选出当前的迭代方向，在这个方向上下降。我们将这个备选集定义为 {% math %}D_k{% endmath %} ，算法的具体过程如下：
1. given {% math %}\gamma_{tol},\ \theta_{max}{% endmath %} , decrease function {% math %}\rho(t){% endmath %} that {% math %}\lim_{t\to 0} \dfrac{\rho(t)}{t}=0{% endmath %}
2. choose {% math %}x_0,\ \gamma_0>\gamma_{tol},\ D_0{% endmath %}
3. repeat
    - if {% math %}\gamma_k<\gamma_{tol}{% endmath %} break
    - if {% math %}f(x_k+\gamma_kp_k)<f(x_k) - \rho(\gamma_k){% endmath %} for some {% math %}p_k\in D_k{% endmath %}
      - {% math %}x_{k+1} = x_k+\gamma_kp_k{% endmath %}
      - {% math %}\gamma_{k+1} = \phi_k\gamma_k{% endmath %} for {% math %}\phi_k>1{% endmath %}
    - else
      - {% math %}x_{k+1}=x_k{% endmath %}
      - {% math %}\gamma_{k+1} = \theta_k\gamma_{k},\  0<\theta_k\le \theta_{max}{% endmath %}

## {% math %}D{% endmath %}的选择
{% math %}D{% endmath %} 在这个算法中的重要性自然不用说。所以 {% math %}D_k{% endmath %} 中方向的选择就成了一个重要的问题。我们需要建立一些基础条件。在 Line search 中，每次迭代时都有 {% math %}\cos\theta=\dfrac{-\nabla f_k^Tp}{\|\nabla f_k\|\|p\|}\ge\delta{% endmath %} 。所以对于 {% math %}D_k{% endmath %} 中的任何一个方向 {% math %}p{% endmath %} 来说，都要满足上面的条件。我们将上面的条件描述为：
{% math %}
k(D_k) = \min_{v\in R^n}\max_{p\in D_k} \dfrac{v^Tp}{\|v\|\|p\|}\ge \delta
{% endmath %}
我们还需要让 {% math %}D_k{% endmath %} 中的每个向量的长度保持在一定范围内。这样的话，不同向量的选择不会导致步长的变化过大。也就是说
{% math %}
\beta_{min} \le \|p\|\le\beta_{max}
{% endmath %}
结合上面两个条件，可以得到
{% math %}
-\nabla f_k^T p \ge k(D_k)\|\nabla f_k\|\|p\|\ge\delta\beta_{min}\|\nabla f_k\|
{% endmath %}
有一些满足简单的满足条件的 {% math %}D{% endmath %} 的例子：
- {% math %}\{e_1,e_2,...e_n,-e_1,-e_2,...-e_n\}{% endmath %}
- 令 {% math %}e = (1,1,...,1)^T{% endmath %}，则 {% math %}p_i=\frac{1}{2n}e-e_i, i=1,2,..,n;\ p_{n+1} = \frac{1}{2n}e{% endmath %}也是一组满足条件集合

当然了，上面的例子往往只是 {% math %}D_k{% endmath %} 的一个子集。其他的方向可以通过启发式算法得到，但是书中没有详细说明，所以这里也没法介绍(+ _ +)
## {% math %}\rho(t){% endmath %}
在上面的算法中我们引入了一个函数 {% math %}\rho(t){% endmath %} 书中给出的建议是 {% math %}\rho(t) = Mt^{\frac{3}{2}}{% endmath %}，{% math %}M{% endmath %} 为正数

# conjugate-direction method
这里的方法和 conjugate gradient 是一样的，只是这里在求向量的时候没有用到梯度(或者说很少用？)
和 conjugate gradient 一样，我们还是从二次函数说起。假设优化目标为
{% math %}
f(x) = \frac{1}{2}x^TAx-b^Tx
{% endmath %}
假设我们的优化方向为 {% math %}l_1(\alpha) = x_1+\alpha p,\ l_2(\alpha) = x_2+\alpha p{% endmath %}，且沿着两个方向优化的最终结果为 {% math %}x_1^*,\ x_2^*{% endmath %} ，则 {% math %}x_1^*- x_2^*{% endmath %} 与 {% math %}p{% endmath %} 关于A 共轭。

将上面的结果推而广之，对于 {% math %}l{% endmath %} 个方向的集合 {% math %}\{p_1,p_2,...,p_l\}{% endmath %} 来说，
{% math %}
S_1=\{x_1+\sum^l_{i=1}\alpha_ip_i|\alpha_i\in R, i=1,2,...,l\}\\
S_2=\{x_2+\sum^l_{i=1}\alpha_ip_i|\alpha_i\in R, i=1,2,...,l\}
{% endmath %}
而 {% math %}x_1^*,\ x_2^*{% endmath %} 为沿着两个方向计算出的最小值点，则 {% math %}x_1^*- x_2^*{% endmath %} 与 {% math %}p{% endmath %} 关于A共轭。

在这个结论的基础上，我们就可以构建算法了：
1. choose {% math %}x_0,\ p_i=e_i, i=1,2,..,n{% endmath %}
2. compute {% math %}x_1{% endmath %} to min {% math %}f(x_0+\alpha p_n){% endmath %}
3. repeat
    - {% math %}z_1 = x_k{% endmath %}
    - compute {% math %}\alpha_j = \arg\min f(z_j+\alpha_jp_j){% endmath %} and {% math %}z_{j+1} = z_j+\alpha_jp_j{% endmath %} for j = 1,2,...,n
    - {% math %}p_j = p_{j+1}{% endmath %} for j = 1,2,...,n-1
    - {% math %}p_n = z_{n+1}-z_1{% endmath %}
    - compute {% math %}\alpha_n = \arg\min f(z_{n+1}+\alpha_np_n){% endmath %}
    - {% math %}x_{k+1} = z_{n+1}+\alpha_np_n{% endmath %}

    until convergence

简单解释一下上面的算法。假设 {% math %}n=3{% endmath %} ，即我们一开始有3个向量 {% math %}e_1,e_2,e_3{% endmath %}。按照算法的步骤，我们计算出了 {% math %}x_1{% endmath %} 以及 {% math %}z_4{% endmath %} 。根据上面的结论 {% math %}p_1 = z_4-x_1{% endmath %} 和 {% math %}e_1,e_2,e_3{% endmath %} 共轭，而 {% math %}x_2{% endmath %} 为 {% math %}f{% endmath %} 在 {% math %}S_1=\{y+\alpha_1e_3+\alpha_2p_1\}{% endmath %} 方向上的最小值。这种情况下我们得到了新的集合 {% math %}\{e_2,e_3,p_1\}{% endmath %}

## 非线性系统
上面的算法可以移植到任何的函数上，但是需要一些修改。我们不修改方向，只对长度做一些调整：
{% math %}
\hat{p}_i = \dfrac{p_i}{\sqrt{p_i^TAp_i}}
{% endmath %}
则如果我们最大化
{% math %}
|det(\hat{p}_1,\hat{p}_2,...,\hat{p}_n)|
{% endmath %}
那么 {% math %}p{% endmath %} 就是关于A共轭的。我们可以调整上面的算法：
1. find {% math %}m\in \{1,2,...,n\}{% endmath %} max {% math %}\psi_m=f(x_{m-1}) - f(x_m){% endmath %}
2. {% math %}f_1=f(z_1), f_2=f(z_2),f_3=f(z_3){% endmath %}
3. if {% math %}f_3\ge f_1{% endmath %} or {% math %}(f_1-2f_2+f_3)(f_1-2f_2-\psi_m)\ge \frac{1}{2}\psi_m(f_1-f_2)^2{% endmath %}
    - set {% math %}x_{k+1} = z_{n+1}{% endmath %}
4. else
    - set {% math %}\hat{p}=z_{n+1}-z_1{% endmath %}, compute {% math %}\hat{\alpha}{% endmath %} to min {% math %}f(z_{n+1}+\hat{\alpha}\hat{p}){% endmath %}
    - {% math %}x_{k+1} = z_{n+1} + \alpha\hat{p}{% endmath %}
    - remove {% math %}p_m{% endmath %} , add {% math %}\hat{p}{% endmath %}

# Nelder-mead method
The Nelder-mead simplex-reflection method，顾名思义和单纯形有关。在每次迭代时会所有的点的 convex hull 是一个单纯形。假设我们需要优化一个 {% math %}n{% endmath %} 维函数 {% math %}f(x){% endmath %} 。易知， {% math %}n{% endmath %} 维单纯形有 {% math %}n+1{% endmath %} 个点。我们假设这 {% math %}n+1{% endmath %} 个点为 {% math %}\{x_1,x_2,...,x_{n+1}\}{% endmath %} ,其顺序满足下面的条件：
{% math %}
f(x_1)\le f(x_2)\le...f(x_{n+1})
{% endmath %}
令 {% math %}\bar{x} = \sum_{i=1}^nx_i, \bar{x}(t) = \bar{x}+t(x_{n+1}-\bar{x}){% endmath %} 。我们的算法就是用 {% math %}\bar{x}(t){% endmath %} 替代最差的 {% math %}x_{n+1}{% endmath %}。算法的一次迭代如下：

1. compute {% math %}\bar{x}(-1), f_{-1}=f(\bar{x}(-1)){% endmath %}
2. if {% math %}f(x_1)\le f_{-1}\le f(x_n){% endmath %}
    - {% math %}x_{n+1}=\bar{x}(-1){% endmath %} and continue
3. else if {% math %}f_{-1}< f(x_1){% endmath %}
    - compute {% math %}f_{-2}{% endmath %}
    - if {% math %}f_{-2} < f_{-1}{% endmath %}
      - {% math %}x_{n+1}=\bar{x}(-2){% endmath %} continue
      - {% math %}x_{n+1}=\bar{x}(-1){% endmath %} continue
4. else if {% math %}f_{-1}> f(x_n){% endmath %}
    - if {% math %}f(x_n)\le f_{-1} \le f(x_{n+1}){% endmath %}
      - compute {% math %}f_{-1/2}{% endmath %}
      - if {% math %}f_{-1/2} \le f_{-1}{% endmath %}
        - {% math %}x_{n+1}=x_{-1/2}{% endmath %} continue
    - else
      - compute {% math %}f_{1/2}{% endmath %}
      - if {% math %}f_{1/2} < f_{n+1}{% endmath %}
        - {% math %}x_{n+1}=x_{1/2}{% endmath %} continue
5. {% math %}x_i = (1/2)(x_1+x_i), i=2,3,...,n+1{% endmath %}

在算法陷入停滞时，可以进行 restar。不过对于初值点的选择方面，似乎没有什么特别优秀的方案。

# Implicit Filtering
一个非常奇怪的方法= =。算法如下：
1. choose {% math %}\epsilon_k\to 0{% endmath %}, {% math %}c,\rho \in (0,1), \alpha_{max}{% endmath %}
2. repeat
    - increment_k = false
    - repeat
      - comupte {% math %}f(x)，\nabla_{\epsilon_k}f(x){% endmath %}
      - if {% math %}\|\nabla_{\epsilon_k}f(x)\|\le \epsilon_k{% endmath %}
        - increment_k = true
      - else
        - find {% math %}m \in (0,a_{max}){% endmath %} that {% math %}f(x-\rho^m\nabla_{\epsilon_k}f(x))\le f(x)-\rho^m\|\nabla_{\epsilon_k}f(x)\|^2{% endmath %}
        - if {% math %}m{% endmath %} not exist
          - increment_k = true
        - else
          - {% math %}x = x -\rho^m\nabla_{\epsilon_k}f(x){% endmath %}

      until increment_k

    - {% math %}x_k = x{% endmath %}

   until convergence

 当然，也可以用 {% math %}\nabla_{\epsilon_k}f{% endmath %} 估计二阶导，然后用牛顿法解。
