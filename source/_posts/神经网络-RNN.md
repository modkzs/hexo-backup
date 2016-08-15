title: 神经网络-RNN
tags: [Neural Network]
date: 2016-02-20 13:24:14
categories: ml
---
RNN是神经网络中处理时序数据的重要model。所谓时序数据，就是数据集中每个样本不是独立的，会与前面数个或者后面数个样本产生联系。自然语言以及音频都是典型的时序数据。
<!--more-->
# 模型简介
RNN的基础模型比较简单。将基础的BP适用于时序数据，很自然的想法就是把前面的数据输入到当前层。RNN就是采用这种方式去处理数据。
一个很简单的RNN如下：
![](http://ww3.sinaimg.cn/mw690/9dec4451gw1f17yys8pguj20m308vaap.jpg)
其中 {% math %}x_t{% endmath %} 就是每个样本，如nlp中的每个字符等等， {% math %}s_t{% endmath %} 就是隐层的输出。和BPNN唯一的不同就是在处理t时刻的数据时，隐层不仅接受 {% math %}x_t{% endmath %} 作为输入，还将 {% math %}s_{t-1}{% endmath %} 作为输入（当然是采用t-1还是t-2什么的可以随意设，采用多个时刻的当然也是可以的）。

所以RNN的计算可以被总结为下面的公式：
{% math %}
s_t=f(U^Tx_t + W^Ts_{t-1})\\
o_t=f(V^Ts_t)
{% endmath %}
当然了， {% math %}o_t{% endmath %} 的计算不仅限于这种方式，你也可以用softmax等，这里只是说明一下RNN的计算流程。

# BPTT
对BPNN进行了这种结构的修改后，原有的BP显然无法使用于现在的模型求导。当时我们仍然可以通过误差的反向传导计算导数。新的求解算法被称为BPTT(Backpropagation Through Time)。其结果以及推导过程如下：
{% math %}
\begin{aligned}
\dfrac{\partial J}{\partial V} &= \dfrac{\partial J}{\partial o}\dfrac{\partial o}{\partial V}=J'f's_t\\
\dfrac{\partial J}{\partial U} &= \dfrac{\partial J}{\partial s_t}\dfrac{\partial s_t}{\partial x_t}=\dfrac{\partial J}{\partial o}\dfrac{\partial o}{\partial s_t}\dfrac{\partial s_t}{\partial x_t}=J'f'V^Tf'x_t\\
\dfrac{\partial J}{\partial W} &= \dfrac{\partial J}{\partial s_t}\sum_{k=1}^{t-1}\dfrac{\partial s_t}{\partial s_k}\dfrac{\partial s_k}{\partial W}\\
&= J'f'V^T\sum_{k=1}^{t-1}\prod_{i=k}^{t-1}f's_i
\end{aligned}
{% endmath %}
前面说BP的时候，就提到了梯度下降的问题。这个问题在RNN里面更加明显。你只要看下W的公式就能明显的看出来，随便来个几十万的样本，这梯度就能玩出花来。所以写RNN时，会有一个truncate表示时序网络中误差反向传导的层数。也就是说，在W公式中的连乘最多只做truncate次，不然算个RNN真的要算爆了。。。。。
