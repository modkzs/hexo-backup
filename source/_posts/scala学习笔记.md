title: "scala学习笔记"
date: 2015-05-18 09:00:31
categories: language
tags: [scala]
---
scala学习笔记
<!--more-->
# 基础概念
scala中的变量分为var和val两种，其中var变量值可以改变，val不可以改变
scala中的函数如果只有一个参数，调用时可以省略括号。如Integer.+(Integer)方法可以用如下两种方式调用：(1).+(2)或者1 + 2
对于函数而言，所有传入的参数都是val类型。
scala的函数如果定义了返回值类型但是没有写return的话，会返回最近被方法计算的变量
> In the absence of any explicit return statement, a Scala method returns the last value computed by the method. 

# 类
val的类对象不可以被改变，但是类中的变量可以被改变。例如：
\`\`\`val s = new Student
\`\`\`\`s = new Student
\`会报错，因为s为val。但是
`s.name="hyx"`
则不会报错
## singleton object
scala类没有static成员。取而代之的是singleton对象。singleton对象的其他部分和普通对象相同，只是定义的时候用的是object而不是class。singleton对象可以和普通对象享有一样的名字，这样的情况下2个对象可以访问彼此的private成员。那个普通对象被称为singleton的companion class。
# 基础类型与和操作符
## 操作符
由于scala中函数的特殊用法，因此所有的操作符本质上来说都是方法。但是可以用作前缀操作符的函数只有四个：+、-、！、\~。这些函数在定义时都需要加上unary\_前缀，如unary\_!。
## 类型转化
scala可以自定义隐式类型转换函数.如有一个类Rational和int类型，如下函数可以实现int到Rational的隐式类型转换.
	implicit def intToRational(x:Int)=new Rational(x)
# 基础控制流
scala中没有continue和break.如果需要使用break，则要引入相应的包
# 控制流抽象
scala中语言自带的控制流
## exists
文如其意，判断集合中是否存在某一类元素.用法如下:
	def containOdd(nums:List[Int]) = num.exsits(_%2 == 1)
	containOdd([1, 2, 3])
输出结果为true