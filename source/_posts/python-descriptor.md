title: "python descriptor"
date: 2015-06-01 19:23:03
categories: language
tags: [python]
---
没有看到过中文翻译，不知道对应的中文译名是什么。descriptor是指python中一个实现了\_\_get\_\_, \_\_set\_\_, \_\_delete\_\_方法的类.
<!--more-->
# descriptor protocol
虽然不知道为什么这种东西还是protocol,但是官网就是这么给的.三个函数的原型如下:
	descr.__get__(self, obj, type=None) --> value
	descr.__set__(self, obj, value) --> None
	descr.__delete__(self, obj) --> None
对于定义的\_\_get\_\_和\_\_set\_\_的类被称为data descriptor, 只定义了\_\_get\_\_的被称为non-data descriptor.这两种descriptor的主要区别在于查找变量时的优先度不同.关于优先度的问题,会在后面详细描述.
如果需要read-only data descriptor的话,定义\_\_set\_\_方法为抛出异常就好了.
# 查找链
## attr取值
1. attr为python自动产生的,找到
2. 查找obj.\_\_class\_\_.\_\_dict\_\_.若attr存在而且是data descriptor,返回其\_\_get\_\_的结果;没有,就在obj.\_\_class\_\_的父类以及祖先类中寻找data descriptor
3. 在obj.\_\_dict\_\_中寻找.如果obj是一个普通实例,找到就返回.如果obj是一个类,则在obj,其父类以及祖先类的\_\_dict\_\_中查找,找到descriptor 返回其\_\_get\_\_的结果,找到普通attr则直接返回结果.
4. 在obj.\_\_class\_\_.\_\_dict\_\_中查找,找到了descriptor(必定是non-data descriptor),调用其\_\_get\_\_方法,返回结果.否则下一步
5. 抛出异常-\_-|||
## attr 赋值
1. 查找obj.\_\_class\_\_.\_\_dict\_\_.若attr存在而且是data descriptor,调用其\_\_set\_\_方法; 没有,就在obj.\_\_class\_\_的父类以及祖先类中寻找data descriptor
2. 直接在obj.\_\_dict\_\_中加入obj.\_\_dict\_\_[‘attr’]=value
### 问题
在attr赋值的过程中,我们发现没有non-data descriptor的查找过程.也就是说如果我们对一个non-data descriptor赋值的话,会将其覆盖.
# 简单地例子
	class RevealAccess(object):
	    """A data descriptor that sets and returns values
	       normally and prints a message logging their access.
	    """

	    def __init__(self, initval=None, name='var'):
	        self.val = initval
	        self.name = name

	    def __get__(self, obj, objtype):
	        print 'Retrieving', self.name
	        return self.val

	    def __set__(self, obj, val):
	        print 'Updating', self.name
	        self.val = val

	class MyClass(object):
	    x = RevealAccess(10, 'var "x"')
	    y = 5

	m = MyClass()
	m.x
	m.x = 20
	m.y
在python终端执行上述代码,输出为
Retrieving var "x"
10
Updating var "x"
5
# property
一种简单的实现descriptor的方法.property是python定义的函数,原型如下:
	property(fget=None, fset=None, fdel=None, doc=None) -> property attribute
利用该函数可以简单的定义一个descriptor
# function and method
## 区别
function就是c中的function,在类的外面定义,可以被随时调用;method是一种特殊的function,和java中的method概念基本相同,是在类中定义的function.
## 实现
在obj.\_\_dict\_\_中将method以function的形式进行存储.为了支持函数调用,所用的函数都实现了\_\_get\_\_方法.也就是说,所有的函数都是non-data descriptor
对于下面的例子
	class D(object):
	     def f(self, x):
	          return x
	d = D()
	d.__dict__['f']
	D.f
	d.f
输出分别是:
<function f at 0x00C45070>
<unbound method D.f>
<bound method D.f of <\_\_main\_\_.D object at 0x00B18C90>>

## static method 以及 class method
正如前文所说,method在class中是以descriptor的形式存在的.因此我们所定义的函数和其真正调用的形式是不一样的.
static method类似于java中的static方法,在调用时不会将类本身作为参数传入;而class method会将类本身作为参数传入()

 Transformation | Called from an Object | Called from a Class |
 ———————————————| ———————————————-————— | ——————————————-———  |
  function      |    f(obj,\*args)       |      f(\*args)     |
  static method |    f(\*args)       |      f(\*args)     |
  static method |    f((type(obj))\*args) |   f(klass,\*args)  |





