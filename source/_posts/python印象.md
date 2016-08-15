title: python印象(一)
date: 2015-03-10 20:26:19
categories: language
tags: [python]
---
好吧，在Go还没看完的时候又开始看python了。因为4月份要准备实习面试，所以其他的东西先放一边，专心python好了。教程为[python tutorial](https://docs.python.org/3/tutorial/introduction.html).与Go相同,对于和c,c++,java中相同的东西不会介绍.
<!--more-->
#Informal Introduction
python中可以用a, b = 0, 1的方式为2个以上的变量赋值
python中**表示阶乘
##String
python中表示字符串的一共有3中方式：单引号,双引号和三引号（=。=这是什么鬼）单引号和双引号其实并没有什么区别.

引入单引号和双引号的主要目的是可以避免使用转义字符(/).如print("he's good")会输出he's good,而如果使用单引号,则必须写成print('he\'s good').该点对单引号也成立.

三引号会直接输出",'和句子中的换行,但是转义字符仍然有用.另外,三引号是三个单引号,不是一个双引号和一个单引号(= =|| 一开始是这么以为的.....)

另外,在句子外加个r会无视转义字符,该点对三种引号都适用.如print(r"he\'s good")会输出he\'s good.

python中的String都是类似list,可以选择单个字符或slice

##list
使用[]表示,2个list可以使用+进行连接]
**list中的元素不需要是同一类型,如int和string可以在同一个list中**
顺便说下list的顺序问题.python中list的选择有2种表示方式

| 0 | 1 | 2 | 3 | 4 |
| - | - | - | - | - |
|-5 | -4| -3| -2| -1|

如上表,list[0]和list[-5]是表示一个值如果list中有5个元素的话.
可以使用list[begin:end]进行切片,begin和end都可以省略,会自动变成0/len(list)

#Control Flow
##if
没有括号,用:表示结束
用and, or, not 表示&&, ||, !
##for
for w in words 类似java中的for(w : words)
for i in range(begin, end) 类似java中的for(int i = begin; i < end; i++), begin可以省略,默认从0开始
不过range输出的并不是list,想print的话需要list(range(5))
else 在循环正常退出时进入(即非break中断循环)

###for当中为循环变量赋值没有意义!
>The for-loop makes assignments to the variables(s) in the target list. This overwrites all previous assignments to those variables including those made in the suite of the for-loop:

如下例:
```
for i in range(10):
    print(i)
    i = 5
```
输出依然是0-9,而不是0之后无限5

###for循环中改变list内容
for循环中python会记录当前item的index,每次加一.这意味着如果删除list中的一个元素(如第5个)则下一个元素会是原list中第7个元素,第6个会被跳过.如果添加元素的话,当前元素会被再处理一次
>An internal counter is used to keep track of which item is used next, and this is incremented on each iteration. When this counter has reached the length of the sequence the loop terminates. This means that if the suite deletes the current (or a previous) item from the sequence, the next item will be skipped (since it gets the index of the current item which has already been treated). Likewise, if the suite inserts an item in the sequence before the current item, the current item will be treated again the next time through the loop.

##pass
无用.不知道怎么描述作用,直接引用原文好了:
>It can be used when a statement is required syntactically but the program requires no action.

##function
用def定义,如def fib(n):
function body的第一行可以是string(可选),称为docstring
###变量寻找过程
the local symbol table->the local symbol tables of enclosing functions->the global symbol table->the table of built-in names.
###传值和传址的问题
c和c++中的老问题.python的类型与变量的概念和c或者c++,java都不相同.
==python中类型是属于对象的，而不是变量。==
如:
a = 1 #一个指向int数据类型的a
b = [1] #一个指向list类型的b,list中包含1
现将a = 2
由于python中strings, tuples, 和numbers不可变更(unmutable),所以内存中新建一个int变量,大小为2,将a指向该变量
将 b = [2]
由于list可变,list中的第一变量和上面相似,指向一个新变量,而list本身没有改变

所以从本质来说,我觉得可以将python中的所有变量都看做void*指针,对于不可变更的类型,赋值会malloc新的,其他变量则直接改变.
所以在传递变量的时候,当传递不可变更类型时,类似于传值,函数中的变更不会影响函数外变量的值;可变更类型则类似传址,函数中的变更会影响函数变量的值
###default argument values
python支持参数缺省值,但是**所有的参数缺省值只会被执行一次!!!!**所以对于可变类型,可能会出现如下问题:
```
def f(a, L=[]):
    L.append(a)
    return L

print(f(1))
print(f(2))
print(f(3))
```
上面代码的输出为
[1]
[1, 2]
[1, 2, 3]
避免上述情况可以使用如下方法:
def f(a, L=None):
    if L is None:
        L = []
    L.append(a)
    return L

print(f(1))
print(f(2))
print(f(3))
###Keyword Arguments
形参中有**name之类的参数时,需要传入dictionary.此时keyword argument用法如下:
```
def cheeseshop(kind, *arguments, **keywords):
    print("-- Do you have any", kind, "?")
    print("-- I'm sorry, we're all out of", kind)
    for arg in arguments:
        print(arg)
    print("-" * 40)
    keys = sorted(keywords.keys())
    for kw in keys:
        print(kw, ":", keywords[kw])

cheeseshop("Limburger", "It's very runny, sir.",
           "It's really very, VERY runny, sir.",
           shopkeeper="Michael Palin",
           client="John Cleese",
           sketch="Cheese Shop Sketch")
```
会输出
```
-- Do you have any Limburger ?
-- I'm sorry, we're all out of Limburger
It's very runny, sir.
It's really very, VERY runny, sir.
----------------------------------------
client : John Cleese
shopkeeper : Michael Palin
sketch : Cheese Shop Sketch
```
### Arbitrary Argument Lists
用tuple实现可变参数列表.如:
```
def concat(*args, sep="/"):
    return sep.join(args)
```
###lambda
类似java中的匿名函数,貌似java8也支持lambda表达式
###docstring和annotation
```
def my_function()-> "this is annotation": 
     """this is docstring
     """
     pass
```
可以使用__annotations__和__doc__访问annotation和lambda