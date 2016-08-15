title: 数值优化：Overview
tags: [optimization]
date: 2016-06-04 20:15:35
categories: math
---
数学的最后一个大块：数值优化，课本是 numerical optimization. 感觉相对于凸优化来说，这本书对于读者的数学基础要求比较高，很多基础的数学概念都没有介绍，所以啃起来感觉很困难。而且整本书各个章节之间联系比较少，所以看完前面基本就忘完了，所以有必要记录一下。
<!--more-->
第一章基本没讲什么，所以从第二章开始。第二章主要是一些基础性的知识。包括 global minimizer, local minimizer, strict local minimizer, stationary point(其实我感觉没啥大区别)，介绍了一下 Taylor's theorm( {% math %}f(x+p)=f(x)+\nabla f(x+tp)^Tp{% endmath %} ) 以及2个非常重要的算法框架：line search 和 trust region，用于搜索更新方向以及距离。

2个算法的核心区别就是 line search 是先定方向再定距离； trust region 是先定距离再定方向。在后面会详细说明2个算法。

额，开坑就这样吧，没啥可多说的了。
