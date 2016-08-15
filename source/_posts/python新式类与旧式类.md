title: "python新式类与旧式类"
date: 2015-06-01 19:16:37
categories: language
tags: [python]
---
python中新式类与旧式类，python2才有的问题,python3中所有的类均为新式类.
<!--more-->
python2中定义新式类需要继承自object或者其他新式类(因为python3中的所有类都隐式继承自object,所以自然没有这种问题).新式类提供了大量老式类所没有的特性,比如上面的super继承和下’马上要说的\_\_new\_\_.同时新式类的\_\_class\_\_和type(b)返回值完全相同(如ClassB, 都为class ‘\_\_main\_\_.ClassB’),而老式类的type(b)返回值为\<type 'instance’\>.
## \_\_new\_\_
如上面所说,这是新式类中所有的特性,在构造方法调用之前调用.如下例:
	class Foo(object):
	  def __init__(self, *args, **kwargs):
	     ...
	  def __new__(cls, *args, **kwargs):
	     return object.__new__(cls, *args, **kwargs)
	# 上面一句调用等同于 return object.__new__(Foo, *args, **kwargs)
在\_\_init\_\_调用之前,\_\_new\_\_会首先调用.参数中的cls为当前正在实例化的类.可以再\_\_new\_\_中选择任意新式类的\_\_new\_\_方法进行调用.但是不能调用自身的\_\_new\_\_方法,这样会陷入无限递归.同样道理,也不能调用有继承关系类的\_\_new\_\_方法.
如果\_\_new\_\_方法没有返回当前类的实例,则\_\_init\_\_方法不会被调用.如下面的代码:
	class Foo(object):
	    def __init__(self, *args, **kwargs):
	        ...
	    def __new__(cls, *args, **kwargs):
	        return object.__new__(Stranger, *args, **kwargs)  
	
	class Stranger(object):
	    ...
	
	foo = Foo()
foo实际上是Stranger的实例.