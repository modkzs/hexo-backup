title: python印象(三)
date: 2015-03-19 11:21:33
categories: language
tags: [python]
---
继续上一篇
<!--more-->
#Class
##namespace and scope
python中的namespace共有三个:

1. 函数所有的局部命名空间
2. 模块所有的全局命名空间
3. 所有模块可以访问的内置命名空间

搜索时从上往下搜索.嵌套函数在1之后还有需要搜索父函数的命名空间

###nolocal和global
global声明的变量会添加到当前模块的全局命名空间(如果变量不存在)
nonlocal会在1和2中进行搜索(不包括3).

##variables
和function一样,变量的默认值会被所有实例化该类的变量共享.还是举个栗子:
```
class Dog:

    tricks = []

    def __init__(self, name):
        self.name = name

    def add_trick(self, trick):
        self.tricks.append(trick)

d = Dog('Fido')
e = Dog('Buddy')
d.add_trick('roll over')
e.add_trick('play dead')
print(d.tricks)
```
会输出['roll over', 'play dead']

##Inheritance
没啥好说的,就是注意一点:若A继承B,A初始化时不会调用B的初始化函数
###multiple inheritance
主要是变量名重复的问题.python不会检查变量名是否重复因为它定义了一个搜索顺序:
`class DerivedClassName(Base1, Base2, Base3, ..., Basen)`
按照从左到右的顺序进行搜索,即先搜索Base1及其父类及其父类的父类......直到搜到object,找不到就对Base2重复同样的过程.....直到Basen或者找到.对于重复的类,不会检查.如Base1,Base2都继承了Base,则Base类只会在Base1搜索过程中被检查,不会出现在Base2的搜索过程.

##private variable
所有的variable和function前面加上__就是private的了
## Odds and Ends
我实在不知道该怎么评价这种东西╮(￣▽￣")╭ 上栗子:
```
class Employee:
    pass

john = Employee() # Create an empty employee record

# Fill the fields of the record
john.name = 'John Doe'
john.dept = 'computer lab'
john.salary = 1000
```
然后你就可以访问john的三个属性了.........这TM都是什么鬼啊!!!!
##Iterators
对于任何一个类,提供了__next__和__iter__方法之后就可以在for中使用了.
###genetor
上面Iterator的实现比较繁琐,需要实现自己对id的控制.因此python引入了yield关键字,函数中使用了yield的一律会生成Iterator.如:
```
def fab(max):
    n, a, b = 0, 0, 1
    while n < max:
        yield b
        # print b
        a, b = b, a + b
        n = n + 1
```
函数可以这样调用:`for n in fab(5)`
