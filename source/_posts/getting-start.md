title: getting start
date: 2015-01-31 22:06:31
categories: 日记
tags: [diary,plan]
---

#第一篇日志
花了一个多小时用heox+pacman搭好了github的日志,以后终于可以用markdown+github这种高大上方式写日志了～(￣▽￣～)(～￣▽￣)～这篇日志居然不是hello world真的科学么?
<!--more-->
##搭建方法
这种方法网上已经一搜一大把了("▔□▔) 就不详细说了,说一下简单的步骤吧
###安装node.js, hexo, 建立github项目
下个安装包,npm一下就好了.hexo的theme导入直接git clone到theme目录就可以了,感觉好简单啊o(*≧▽≦)ツgithub项目名称是username.github.io有些写的是.com,那是gitpage的老版本了现在已经用不了.还是给个[链接](https://pages.github.com)在这吧防止以后又改了ㄟ( ▔, ▔ )ㄏgithub的官方似乎更支持Jekyll,貌似使用ruby写的,用惯node.js的还是用hexo好了
###配置
主要在hexo根目录下和theme/....(你的theme)下的两个config文件,感觉注释挺全的,自己随便改下看下效果什么的就可以了.**改完之后千万不要git pull!!!!**w(ﾟДﾟ)w**我tm按网上教程git pull之后发现根本就不行啊!!!!**"o((>ω< ))o"然后颜色神马的看[jacman的说明](http://yangjian.me/pacman/hello/introducing-pacman-theme/)就好啦!写好之后`hexo g`然后再`hexo d`一下就好了.如果是第一次的话,在`hexo g`之前要先`npm install`一下把用的其他npm包按上去
###hexo常用命令
其实网上也有很多了,还是写一下吧,自己以后也要用
`hexo g` hexo generate的简写,产生可用于push的静态网页代码
`hexo d` hexo deploy的简写,部署产生的静态网页到github,和上面这货一起用╭(′▽\`)╭(′▽\`)╯记得要部署根目录下面得deploy能用(貌似还支持heroku,神马时候去试试看o(*￣▽￣*)o )
`hexo server` 一个实时效果的预览,可以在本地浏览器(表告诉我你还用IE7什么的)直接看到效果
`hexo new "name"` 产生新文章模板,文章名字是name,文章模板在/scaffolds/post.md(不是theme下面的目录,是hexo的根目录下面不要记错了啊)
`hexo new page "about"` 产生新页面,页面名字是about.source下面会有about目录,里面有个index.md,直接修改就好了(感觉这命令我只用来建立about页面了@o@" )
其他的感觉用不上了啊........就不介绍了,自己去[hexo的doc](http://hexo.io/docs/)里面看好了
###关于域名
额,现在还没有买域名的计划.银行卡刚掉还没补办也没钱买("▔□▔) 等以后有时间做了之后再更新吧
##简单的计划
虽然搭建过程简单,没花什么时间,还是定个这半年的计划比较好.去年过的太散漫了凸(゜皿゜メ)
###源代码部分
####titan 
看了那么多titan的代码,而且貌似网上也没有什么源码分析的,以后应该开坑写一下索引(其实只看了索引)吧.....
####node.js
恩,争取5月份之前看完吧,先在这开个坑好了,要不然又看不下去了
####leanote
Go语言的博客系统,纯粹为了熟练Go语言的.有时间就看吧
###语言技能部分
####leetcode || oj
刷题,嗯~ o(*￣▽￣*)o ,没啥好说的,顺便看下算法导论好了
####Go && python
Go是个人兴趣,python为了5月份的实习看看
###一些有的没的
####机器学习
NG的公开课,个人不太感兴趣,实验室感觉研究生做这个概率也不大,但是实在太火,有时间看看吧.又想起了被自动化所拒的黑历史......(╯‵□′)╯︵┻━┻
####Go编译器
听说要用Go重写一遍了,如果重写了就看看好了
##最后
第一篇日志么,感觉写了好多啊+_+也不知道能不能做完啊!!!就这样吧,不管了