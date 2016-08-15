title: 神经网络 二 从感知机到BP
tags: [Neural Network]
date: 2016-01-22 12:42:30
categories: [ml]
---
脑洞大开的机器学习江湖史——一代天才感知机不敌VC维，BP横空出世惜败梯度消失
<!--more-->
#感知机模型
话说1943年神经网络横空出世，作为机器学习的小门小派，一直无人问津。直到57年一代天才感知机（(￣＂￣;)）拜入神经网络门下，此门派才突然名声大振。
## 模型
感知机本身的模型比较简单，分类函数为
{% math %}
f(x)=sign(wx+b)\\
sign(x)=\begin{cases}
  0& \text{x≥0}\\
  1& \text{x>0}
  \end{cases}
{% endmath %}
## 损失函数
根据上面的损失函数，我们可以发现对于正确分类的样本来说{% math %}y_i(wx_i+b)\ge0{% endmath %}对于错误分类样本来说，有{% math %}y_i(wx_i+b)<0{% endmath %}与SVM过程类似，可以将误分点到分类面的距离定义如下为 {% math %}d_i=-\dfrac{y_i(wx_i+b)}{\|w\|}{% endmath %} 。我们的目标就是对所有的误分点进行优化，使得  {% math %}\sum_{x \in M} d_i{% endmath %} 最小化。固定{% math %}\|w\|{% endmath %}化简后的目标函数为
{% math %}
l(w,b) = -\sum_{x \in M} y_i(wx_i+b)
{% endmath %}
##更新规则
还是求不出闭式解的老一套：梯度下降。对{% math %}w,b{% endmath %}分别求导，得：
{% math %}
\dfrac{\partial l(w,b)}{\partial w} = y_ix_i\\
\dfrac{\partial l(w,b)}{\partial b} = y_i
{% endmath %}
因此更新规则如下：
{% math %}
w = w + \alpha y_ix_i\\
b = b + \alpha x_i
{% endmath %}
## 收敛性证明
唯一一个感觉能证出来收敛的梯度下降。。。。

设存在参数{% math %}w^*,\|w^*\|=1{% endmath %}，存在 {% math %}\gamma > 0{% endmath %}使得下式成立

{% math %}
\begin{aligned}
y_i(w^*x_i)\ge 0
\end{aligned}
{% endmath %}

同时我们认为所有的样本均满足{% math %}\|x\|\le R{% endmath %}。我们定义{% math %}w^k{% endmath %}为第k轮迭代时{% math %}w{% endmath %}的值，同时令{% math %}w^1=0{% endmath %}
对于第k轮的第i个样本，我们有下式成立：
{% math %}
\begin{aligned}
w^{k+1}w^* &= {(w^k+y_ix_i)}^Tw^*\\
           &= {w^k}^Tw^*+y_ix_i^Tw^*\\
           &\ge {w^k}^Tw^* + \gamma
\end{aligned}
{% endmath %}

所以我们通过k次迭代，我们可以得到{% math %}{w^{k+1}}^Tw^*\ge k \gamma{% endmath %} 。故有 {% math %}\|w^{k+1}\|\|w^*\|\ge {w^{k+1}}^T w^* \ge k \gamma{% endmath %}，由前面的假设知{% math %}\|w^*\|=1{% endmath %}故有{% math %}\|w^{k+1}\|\ge k \gamma{% endmath %}

同时，对于错误分类的样本t，我们有下式成立：
{% math %}
\begin{aligned}
{\|w^{k+1}\|}^2 &= {\|w^k\|+y_tx_t}^2\\
&={\|w^k\|}^2 + {y_t}^2{\|x_t\|}^2 + 2y_tx_t^Tw^k\\
&\le {\|w^k\|}^2 + R^2 + 2y_tx_t^Tw^k\\
&\le {\|w^k\|}^2 + R^2
\end{aligned}
{% endmath %}
经过k轮迭代后，可知{% math %}{\|w^{k+1}\|}^2 \le kR^2{% endmath %}
故我们有
{% math %}
\begin{aligned}
  k^2\gamma^2 \le \|w^{k+1}\| \le k R^2
\end{aligned}
{% endmath %}
故 {% math %}k \le \dfrac{R^2}{\gamma^2}{% endmath %}


##问题
作为在上个世纪60年代大红大紫的模型，当年好像有人已经用感知机做出了很简单的手写识别。但是感知机的主要问题是只能处理可以完全二分的样本，也就是其VC维是1。作为一个连异或都做不了的模型，要你何用！╭∩╮(︶︿︶）╭∩╮所以感知机就这么被甩了。。。。一代天骄惨死于VC维啊。。。。

#BP神经网络
在感知机被VC维戳中死穴之后，作为小门小派后继无人，神经网络这一派迅速衰败。直到近20年后，乡土少年闰土，啊，不，BP拜入神经网络门下，该门派才再度兴起，又掀起了江湖的一番腥风血雨。。。。。。

##一些基础定义
hexo放图太麻烦了，所以就不放图了，简单说一下= =
- 神经元

  每个神经元都有多个输入和一个输出，输入为上一层的节点的输出，其使用激活函数根据输入计算输出
- 激活函数

  如上文所说，一个多维数据到一维数据的映射函数，但是需要满足导数在0-1之间。后面会说具体原因

## 一些奇怪的符号
终于到了要定义符号的高度了٩(๑ᵒ̷͈᷄ᗨᵒ̷͈᷅)و
- $x,y,z$ 样本，神经网络的输出，label
- $w_{ih}$ 输入层到隐层的权重
- $w_{ho}$ 隐层到输出层的权重
- $x_h$ 隐层的输入
- $J$ 损失函数
- $f$ 激活函数
- $net$ 每个神经元激活函数的输入，即$net=w^Tx+b$


##BP算法
BP就是个一说你就觉得这么SB的办法谁想不出来的东西= =虽然说是误差的反向传导，也就一个链式求导而已啊。。。。
简单写下链式求导法则吧
{% math %}
\begin{aligned}
\frac{\partial J}{\partial w_{ho}} = \frac{\partial J}{\partial y} \frac{\partial y}{\partial f}\frac{\partial f}{\partial net_{ho}}\frac{\partial net_{ho}}{\partial w_{ho}}=J'f'x_h\\
\frac{\partial J}{\partial w_{ih}} = \frac{\partial J}{\partial net_{ho}} \frac{\partial net_{ho}}{\partial x_h}\sum\frac{\partial x_h}{\partial net_{ih}}\frac{\partial net_{ih}}{\partial x}=J'f'\sum w_{ho}f'x
\end{aligned}
{% endmath %}

求和存在的原因是隐层所有的 {% math %}x_h{% endmath %} 都有对 {% math %}w_{ih}{% endmath %} 的导数。对于不同的 {% math %}J,f{% endmath %} ，直接套上去就好了。
我们可以看到层数越高，{% math %}f'{% endmath %} 指数越高。因此如果 {% math %}f'{% endmath %} 大于1，那么底层的指数就爆炸了，这个网络根本无法更新，所以只能在0到1之间。这样导致了梯度随层数指数级下降，导致了梯度消失的情况出现，使得神经网络难以训练。虽然是难以，总比无法好。所以后面针对于神经网络的训练问题，各种正常的，奇葩的东西开始纷纷出现。。。。
