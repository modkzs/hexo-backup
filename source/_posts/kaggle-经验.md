title: kaggle 经验
tags: [ml]
date: 2016-09-28 12:37:30
categories: kaggle
---
kaggle 经验
<!--more-->
1. CV 注意数据独立性
2. 对于类别feature， 可以如果类别太多，可以将所有只有1个样本的类别归为一类
3. 稀疏性（one-hot）可能提高性能
4. 卡方检验可以有效判断feature的重要性
5. rule 来自重要的feature， 可能产生途径： 平均，topK；可能按照其他feature做聚类(如时间)
6. model 也可以参考 K-means, 对feature进行聚类
8. stacking 很重要
9. 类别信息可以加以组合，得到新的 feature
10. 空值的处理可以简单粗暴
11. 类别feature太多，可以不考虑 one-hot
12. xgboost 可以得到预测的叶节点
