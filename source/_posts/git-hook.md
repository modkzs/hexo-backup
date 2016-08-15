title: "git hook"
date: 2015-05-16 11:24:39
categories: git
tags: [git,program]
---

# git hook
公司的项目需要实现一个模块需要执行用户上传文件中的代码，因此需要用户上传代码并在执行之前检测文件是否存在。每次都做IO的话时间开销太大，因为本来就准备搭个git server的，所以就用git hook来做了。以前没有听过git hook，在此做个记录。
<!--more-->
## git hook
git hook是git提供的一个回调机制，具体来说就是每一个git对应的大部分操作在执行之前和之后都会触发git hook。git hook的本质上来说就是linux下的shell脚本，存放在git项目目录的.git/hooks下面。当git项目初始化之后，hooks下面会有部分hook的例子，都是以.sample结尾的。如果需要什么hook，去掉对应的.sample或者直接touch对应的hook名字就行了。
git hook分为两种，客户端和服务器端的hook
### 客户端
可供客户端调用的git hook种类非常多。commit，pull，checkout，rebase等等操作都有对应的hook。由于项目中不需要客户端的操作，因此没有详细的了解过。有希望了解的童鞋可以去看下[官网的说明][2]
### 服务器端
相对于客户端，服务器端可以调用的hook就少得多，只有3种：
#### pre-receive
在处理用户的push命令之前调用.该脚本没有参数，可以从标准输入读取文本。读取到的文本参数如下：
\<ref中原本Object名\> \<ref中老的Object名\> \<ref的全名\>\n
#### post-receive
和pre-receive相似，只是是在用户push命令执行之后才被调用。
#### update
与pre-receive相似，但是如果用户对多个branch进行push的话，update这个hook会被多次调用。hook脚本接受3个参数：将要被update的ref名，ref中老object的名字，将要存储的ref的新名字

[2]:	http://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks