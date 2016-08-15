title: "Hbase学习"
date: 2015-09-19 19:00:04
categories: distribution
tags: [hbase]
---
Hbase 用法学习，参考书目：Hbase实战
<!--more-->
# 数据操作
## 数据写入
Hbase的数据写入默认写入2个地方：预写入日志（WAL）和MemStore.
- Memstore
	Memstore为Hbase的写入缓冲区，Memstore填满后数据会被刷写到磁盘，生成HFile。HFile和列族相对应，每个列族有多个HFile，但是一个HFile只能存储一个列族的数据。
	为了防止Memstore没有刷写入磁盘服务器崩溃导致数据丢失，HBase会先写入WAL。
- WAL
	和上面的说法一样，WAL的存在是为了防止Memstore中的数据没有刷写入磁盘。
	> WAL存在的意义是什么？如果服务器在将数据写入WAL时宕机，仍然会导致数据丢失。
## 数据读取
由于Memstore的存在，Hbase在读取数据时必须读取HFile和Memstore。在这种情况下，其使用LRU（最近最少使用算法）进行数据缓存。这种缓存也被称为BlockCache，和Memstore放在同一个JVM堆中。
BlockCache中的Block是Hbase从磁盘中完成一次读取的基本单位，建立索引的最小数据单元以及从硬盘中完成一次读取的最小数据单元。Block的默认大小是64K，可以根据不同的场景使用不同的大小。HFile的数据组织形式是Block序列及其索引。
如果需要进行随机查询，可能需要细粒度的Block索引，因此小一点的block会较好；如果经常执行顺序扫描，增大block的值意味着索引项变少，索引变小，可以节省内存。
一次数据读取的过程如下：
1. 检查MemStore中等待修改的队列
2. 检查BlockCache中该Block是否被访问
3. 访问硬盘上对应的HFile
## 数据删除
Delete不会直接删除数据，会给删除数据打上删除标记（为该记录的删除写入一条“墓碑”）。由于HFile的文件不会轻易改变，因此直到执行一次major compaction时，这些墓碑记录才会被处理，删除空间的日志才会被释放。
### 合并
合并分为major compaction和minor compaction。它们都会对HFile中的数据进行整合。
- minor compaction
	将多个小HFile合并为一个大的HFile。因为数据读取会涉及到一至多个HFile，所以HFile的文件数量对于Hbase的读性能很重要。
- major compaction
	处理给定region的一个列族的所有HFile，将其合并为一个文件。
## 数据扫描
每次scan都是一次RPC调用，会得到一批行数据。可以设置每次的道德行数据的缓存值。如果将其设为n，则每次RPC调用返回n行数据。设置合适的caching值可以很好地提高性能。
## 原子操作
Hbase提供了incrementColumnValue进行value的递增原子操作。也可以使用checkAndPut或checkAndDelete进行原子操作。
# 分布式Hbase
## 数据切分
### region和RegionServer
由于Hbase中单个表的大小可能是PB甚至TB级别，因此在单个机器上存放所有的数据基本不可能。因此表会被切分为较小的数据单位，分配到多台机器上。这些较小的数据单元被称为region。管理region的server即为RegionServer。
### region查找
上文中描述的数据切分政策导致了数据读取必须找到对应的region才可以，因此引入的region的查找策略。
Base中有2个特殊表：-ROOT-和.META.，用于查找存储各行的region。-ROOT-表永远不会被切分到超过一个region上。—ROOT-表中记录存储.META.表的region，.META.表中记录了入口地址，客户端通过入口地址找到region。整个查找过程类似于3层的查找树。
#### -ROOT-表的查找
-ROOT-表的位置由zookeeper负责记录。
#### region完整查找路径
1. 通过zookeeper找到-ROOT-表
2. 通过-ROOT-表找到存储查找行的.META.表的region
3. 到上一步的region中找到存储查找行的region
4. 到上一步的region中找到查找行数据