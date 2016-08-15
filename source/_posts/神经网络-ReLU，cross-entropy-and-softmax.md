title: 神经网络 ReLU，cross entropy and softmax
tags: [Neural Network]
date: 2016-01-23 16:50:02
categories: [ml]
---
神经网络的外功改进——ReLU，cross entropy以及softmax。
话说BP虽然横空出世，但是还是留下了梯度消失这种绝世难题。死穴放在那，怎么能行走于机器学习的江湖？内功不好改，我们先从外功入手。
<!--more-->
#ReLU
ReLU（Rectified Linear Units）是一种激活函数，也可以说是一种神经元。在2015年，可以说是大红大紫。

ReLU分为2种：
{% math %}
f(x) = max(0,x+N(0,1))\\
f(x) = log(1+e^x)
{% endmath %}
准确的来说，前一种才叫ReLU，后一种被叫做softplus function。softplus被认为是ReLU的一种平滑模拟。大部分提到ReLU的paper都会提到这两种形式，因此在实际使用中真正使用的到底是哪一类并不清楚。不过感觉softplus更好求导一点。
##由来
ReLU本身是由真正的研究神经的生物学家提出来的，但是softplus是由搞神经网络的那批人搞出来的。一开始为了解决RBM中visible节点的值是实数而不是0-1提出了softplus，后来被大规模的使用。
在 Rectified Linear Units Improve Restricted Boltzmann Machines 里面提到了softplus的来历：
{% math %}
\sum_{i=1}^N \sigma(x-i+0.5)\approx log(1+e^x)
{% endmath %}
其中 $\sigma$ 就是sigmoid函数。这也被叫做stepped sigmoid units（SSU）
##优势
ReLU作为激活函数主要的优势在于可以极大的削弱梯度消失的情况。其梯度只有2种情况：0或者1。但是这带来了另一个问题是当导数中存在1一个0时，整个网络基本都无法训练，因此在使用时可能需要对初始权重的设置进行处理（=。=纯属个人猜测，没有看到相关论文）。当然，softplus也具有这种特性。

使用这种激活函数还会会导致神经网络权重的稀疏性，这会带来很大的优点。关于网络的稀疏性，以后会有专门的描述，所以现在暂且不说
#cross entropy
损失函数的一种。交叉熵本身是信息论里面的东西，在logistic回归中有用到，其函数为：
{% math %}
f(y,t)=(1-y)log(1-t)+ylog(t)
{% endmath %}
y和t是样本本身的label和神经网络的输出。对该函数+sigmoid激活函数求导会发现第一层的导数中比使用平方损失少了一个数量级。当然，这只对浅层神经网络有用，深度的仍然没啥用。虽然这样，交叉熵还是被广泛的使用。
#softmax
交叉熵的升级版。对神经网络使用交叉熵损失函数本质上来说类似于对神经网络最后一层使用logistic回归。但是这种损失函数只适用于二值分类，为了解决多值分类问题，softmax被引入了最后一层。

softmax本身也是一种分类模型，网上一搜一大把，就不介绍了。在神经网络中使用softmax主要是将神经网络的最后一层整个替换为softmax回归。
