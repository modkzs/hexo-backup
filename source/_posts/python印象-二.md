title: python印象(二)
date: 2015-03-14 10:35:18
categories: language
tags: [python]
---
继续上一篇
<!--more-->
#Data Structures
##List
###List Comperhension
感觉是python里面为list赋值的很有意思的方法.可以通过在[]中加入类似lambda表达式的方式进行赋值.如`[(x, x**2) for x in range(6)]`会输出`[(0, 0), (1, 1), (2, 4), (3, 9), (4, 16), (5, 25)]`
##Tuple
###Sequence unpacking
实在不知道该怎么描述-____-'' 举个栗子好了
`x, y, z = (1, 2, 3)`
上述语句使得x=1,y=2,z=3
##Set
**空Set要用set(), 不能用{}**
支持所有数学集合的操作(这点觉得好吊)
##Dictionaries
没啥好说的,用{}初始化空值
##Looping Techniques
用.item()遍历dictionary, enumerate()遍历list, zip()遍历2个及以上的list, reversed()倒序遍历list
#Compound statements
##try catch
python的try块中也有else,当control flow正常结束时执行.control flow正常执行不包括抛出异常或return,break,continue执行
###final语句
如果final语句中抛出异常,则前面的异常会被替代;若final中使用了return,break和continue,则异常会被抛弃.(貌似由于编译器的一些bug,continue无法在final中使用)
##with(下面内容来自[博客](http://zhoutall.com/archives/325))
感觉python中比较奇怪的一个语法.当然这种与法提出必然有其使用情景.
先举一个栗子.
```
try:
    f = open('xxx')
    do something
except:
    do something
finally:
    f.close()
```
上面是一段文件打开的代码,但是正确的写法应该是下面的写法:
```
try:
    f = open('xxx')
except:
    print 'fail to open'
    exit(-1)
try:
    do something
except:
    do something
finally:
    f.close()
```
因为如果open()抛出异常,f是null,是无法close()的.
但是每次都这么写很麻烦.我们把它封装一下,就变成这样:
```
def controlled_execution(callback):
    set things up
    try:
        callback(thing)
    finally:
        tear things down

def my_function(thing):
    do something

controlled_execution(my_function)
```
但是这样难免会遇到一些局部,全局变量啊等等乱七八糟的问题.python的解决方案如下:
```
class controlled_execution:
    def __enter__(self):
        set things up
        return thing
    def __exit__(self, type, value, traceback):
        tear things down

with controlled_execution() as thing:
        do something
```
在这里，python使用了with-as的语法。当python执行这一句时，会调用__enter__函数，然后把该函数return的值传给as后指定的变量。之后，python会执行下面do something的语句块。最后不论在该语句块出现了什么异常，都会在离开时执行__exit__。
之后，我们如果要打开文件并保证最后关闭他，只需要这么做：
```
with open("x.txt") as f:
    data = f.read()
    do something with data
```
##function
###function decorator
看了一个多小时总算是搞懂了decorator到底是个啥.感觉这种东西纯粹装逼,意义不大,直接举个栗子说明吧:
```
def tags(tag_name):
    def tags_decorator(func):
        def func_wrapper(name):
            return "{0}{1}{0}".format(tag_name, func(name))
        return func_wrapper
    return tags_decorator

@tags("ab")
def get_text(name):
    return "Hello "+name

print get_text("John")
```
上述代码的执行结果是abHello Johnab
也就是说decorator的函数的返回值必须是一个函数,该函数接受的输入必须与function的输出相同.
如下面的函数:
```
@f1(arg)
@f2
def func(): pass
```
实际上等于func = f1(arg)(f2(func))
也就说func的返回值被f2调用, 最后被f1调用.

**f1和f2会在函数定义时被调用,而在函数执行时不会被调用**

感觉搞了这么复杂就是为了简化这一点东西不太值得,而且这可读性......我能说我到现在还绕不过来么!!!┻━┻︵╰(‵□′)╯︵┻━┻

##Class
###Class decorator
和function一样,class也有decorator,不再具体说明,只举一个栗子
```
@f1(arg)
@f2
class Foo: pass
```
等于
```
class Foo: pass
Foo = f1(arg)(f2(Foo))
```