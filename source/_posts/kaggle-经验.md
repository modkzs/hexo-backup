title: kaggle 经验
tags: [ml]
date: 2016-09-28 12:37:30
categories: kaggle
---
kaggle 经验
<!--more-->
1. CV 注意数据独立性
2. 对于类别 feature ， 可以如果类别太多，可以将所有只有1个样本的类别归为一类
3. 稀疏性（ one-hot ）可能提高性能
4. 卡方检验(回归对应 F值)可以有效判断feature的重要性
5. rule 来自重要的feature， 可能产生途径： 平均， topK ；可能按照其他 feature 做聚类(如时间)
6. model 也可以参考 K-means, 对 feature 进行聚类
8. stacking 很重要
9. 类别信息可以加以组合，得到新的 feature
10. 空值的处理可以简单粗暴
11. 类别 feature 太多，可以不考虑 one-hot
12. xgboost 可以得到预测的叶节点
13. 单模型的stacking：不同随机数种子、不同feature、不同参数、不同样本(有意进行划分)
14. 可能的模型：xgboost(包括 sklearn 中的 tree base model), libfm, libffm, ftrl(ftrl没有较好的开源并行实现，cat feature 太多会沈曼)，nn也可以考虑
15. 树模型对 y 进行变换没有意义(因为最后就是在叶节点输出一个值)；对 x 进行变换会产生一定影响 (例如会对方差或者熵产生影响，最后影响筛选的值)
16. boxcox 变化可以让一个分布向正态分布靠拢； skew 可以考察一个分布远离正态分布的情况
17. 考察变量的相关性，相关度过高的变量可以考虑去除
18. 考察 cat feature 的不平衡性。如果 cat feature 的分布高度不均衡，可以考虑删除。
19. 注意 dummy 变量对连续模型的处理(可以用表达式表达的模型，除了树以外的模型)：0 值可能会产生影响，应该去掉
