title: "super继承"
date: 2015-06-01 19:13:01
categories: language
tags: [python]
---
python的super继承
<!--more-->
super继承是指当函数中需要父函数的函数时，使用super()函数进行调用.如:
	class A:
	   def __init__(self):
	      print "enter A"
	      print "leave A"
	 
	class B(A):
	   def __init__(self):
	      print "enter B"
	      A.__init__(self)
	      print "leave B"
在这种情况下,如果B的父类产生变化,就必须遍历整个类去修改.为了避免这种情况,可以使用如下代码:
	class B(A):
	  def __init__(self):
	     print "enter B"
	     super(B, self).__init__()
	     print "leave B"
这样可以大量降低代码维护量.不过这样会执行所有父类的该方法.因此在多重继承中,也会使用第一种方法.
super继承的最大优势在于如果继承关系复杂的话,super继承可以保证所有父类的方法只会执行一次,而非super继承执行的话可能会有部分父类的函数被执行多次.