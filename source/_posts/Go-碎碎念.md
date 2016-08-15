title: Go 碎碎念
date: 2015-02-01 18:56:17
categories: language
tags: [Go]
---
很久之前就开始关注Go了,最近才开始着手去学.本篇日志的目的不在于详述Go的语法(都能写本书了好么),也不会对Go做出评价(妈蛋连学都没学完评价个鸡毛啊),仅仅记录一些其和现有主流编程语言的区别之处.一来做个回顾,二来以后忘记了就不用看书了.
<!--more-->
##IDE
工欲善其事,必先利其器.就目前来说,Go貌似没有什么特别优秀的编译器.liteIDE的UI实在是没法直视w(ﾟДﾟ)w,连用都没用直接放弃......用sublime的话问题在于构建大型的工程的时候感觉会挺复杂,但是作为学习来说够了.以后写东西可能会考虑用eclipse配一个goclipse吧
##变量
主要是变量的定义啊,类型啊等等之类的东西
###定义
使用了`var name type`的定义方式,说是为了避免c里面`int* a, b`的问题,也提供了:=的方法(如`a:=5`)直接定义.不过话说最近c好像多了`auto`关键字,可以智能判断变量类型了啊
###类型
类型仍然是基本的几样,int,long,array和slice啊之类的.**Go里默认为reference(所有的变量都是pointer)的变共有3种:slice, map, channel**这里说一下slice.
####slice
感觉是看过的比较奇怪的一种数据类型了(貌似python里也有这种类型,不知道用法是不是一样),类似于java里的list或者c++里的vector但是又有很大不同.

slice有capacity和length两个属性.capacity表示slice现有的element个数,length表示slice所能拥有的element数量.就像slice的名字意义一样,slice本身是array的切片.其定义方式为`var slice []type = arr1[begin:end]`,如`var s []int = a[1:5]`,begin或者end都可以省略,省略则从0开始/直到结束.也可以用make来做.

因为Go当中如果函数使用array,必须指定element的个数(= =),slice在这种情况下有很多的利用场景
###package
特别为package加一节,当初为了引用package的问题忙了整整一个多小时!!!(╯‵□′)╯︵┻━┻ 
Go里有package关键字,用惯java的下意识以为是用这个唯一标识一个pack并且import的.但是Go的package只能用于标识,不能用于引用o(\` · ~ · ′。)o 坑爹啊!!!!!
举例说明下Go的pack import吧.文件结构如下
- try
	try.go
	- pack
    	pack.go

try.go是mian pack的go文件,如果其想使用pack.go,需要`import "try/pack"`
####可见性
额,其实Go的可见性很简单.每个pack里以大写字母开头的对其他pack是可见的,其他都是不可见的= =
###OO
其实我也不知道GO到底是不是一个OO的语言.Go不支持多态,struct也没有初始化函数.
不过你可以通过可见性强迫类无法被new.在pack里面将类的首字母小写使其对其他pack不可见,然后写一个函数初始化该类并返回,保证该函数对其他pack的可见性即可
####Anonymous fields,embedded structs
Go在struct定义时的一种特殊情况,可以只声明变量的type而没有name.如

    type A struct{a int}
    type B struct{A}
中,可以直接用b.a访问a(如果b是B的实例)
#####命名冲突
在这种情况下的命名冲突分为2种,同级和不同级.如上例中A和B就是不同级.如果改为
```
type B struct{
	A
    C
}
```
则A,C同级.
对于不同级的冲突,外层会覆盖内层.如B中有一个float32的a,则b.a为float32,即会覆盖a.a.不过你可以用b.A.a来访问(φ(◎ロ◎;)φ)
对于同级的冲突,必须通过b.A.a访问,直接通过b.a访问会报错
#####method定义
比较奇怪,在这里记录一下
`func (recv receiver_type) methodName(parameter_list) (return_value_list) { … }`
receiver_type和method必须在同一pack中,但是不用在同一个文件中
method可以改变recv的值如果receiver_type为指针!!!!如果receiver_type为指针,recv不是指针,仍可以调用(即receiver_type的类型只决定的传值方法,不对调用对象产生限制)
## interface和reflection
###interface
并不是传统OO语言中的interface.Go的interface真的只是一系列方法的集合,不能有任何的变量.关键是这货tm可以实例化(官方说是可以实例化,但是个人感觉和java里的差不多)!!
任意的type可以继承任意的interface(即多对多的关系).**implement不需要特别声明.只要实现了相应方法的都可以认为是implement**
Go支持多态
==在用interface调用时需要注意一点,函数声明中receiver的类型为指针时,必须与interface的类型一致.==以下面的代码为例:
```
type T interface{
	get() int
    set(a int)
}

type str struct{x int}

func (s Str) get() int{
	return s.x
}

func (s *Str) set(int x) {
	s.x = x
}

func main(){
	var s str
    var t T = str
    var tp T = &str
}
```
在上述代码中,t和tp都可以调用get,但是只有tp可以调用set.因为t实际上不是指针类型,在这种情况下Go做的自动转化无效

interface内部可以有interface,感觉就像继承一样
###interface的动态强制类型转化
v,b := interface.(structName)
v显示转化结果,成功后为interface类型;b显示转化是否成功
i.(type)会显示该实例的类型,任何变量都可以使用这种方法,即i不需要是interface的实例,可以是任何类型的变量
###interface slice
interface的slice无法直接被赋值.如以下代码无法被正确执行:
```
	var i []int = make([]int, 10);
	var iSlice []interface{} = i
```
因为interface slice的存储结构和普通slice不同.interface slice需要存储2个信息:变量的类型和值.因此需要2 word(我也不知道word是什么╮(￣▽￣")╭ ),而普通的slice只需要1 word,即值即可.必须逐个对slice里的每个元素赋值
###reflection

