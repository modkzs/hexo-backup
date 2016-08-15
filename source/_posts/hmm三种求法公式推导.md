title: hmm三种求法公式推导
tags: [math, ml]
date: 2016-01-10 15:56:34
categories: ml
---
网上关于hmm 3个问题的求法基本已经烂大街了（等完事了我也烂一次大街嗯o(\*￣▽￣\*)o，但是对于3种求法的公式推导倒是基本没有，自己推了一天才推完3个公式，记下来以防以后忘了
<!--more-->
1. 前向公式
{% math %}
\begin{aligned}
\alpha_j(t)&=P(o_1...o_t,x_t=i|\mu)\\
\alpha_j(t+1)&=P(o_1...o_{t+1},x_{t+1}=j|\mu)\\
&=P(o_1...o_{t+1}|x_{t+1}=j,\mu)P(x_{t+1}=j|\mu)\\
&=P(o_1...o_t|x_{t+1}=j,\mu)P(o_{t+1}|x_{t+1}=j,\mu)P(x_{t+1}=j|\mu)\\
&=P(o_1...o_t,x_{t+1}=j|\mu)P(o_{t+1}|x_{t+1}=j,\mu)\\
&=\sum_{i=1...N}P(o_1...o_t,x_t=i,x_{t+1}=j|\mu)P(o_{t+1}|x_{t+1}=j,\mu)\\
&=\sum_{i=1...N}P(o_1...o_t,x_{t+1}=j|x_t=i,\mu)P(x_t=i|\mu)P(o_{t+1}|x_{t+1}=j,\mu)\\
&=\sum_{i=1...N}P(o_1...o_t,x_t=i,\mu)P(x_{t+1}=j|x_t=i,\mu)P(o_{t+1}|x_{t+1}=j,\mu)\\
&=\sum_{i=1...N}\alpha_i(t)a_{ij}b_{jo_{t+1}}
\end{aligned}
{% endmath %}
2. 后向公式
{% math %}
\begin{aligned}
\beta_t(i)&=P(o_{t+1}...o_T|x_t=i,\mu)\\
\beta_{t+1}(j)&=P(o_{t+2}...o_T|x_{t+1}=j,\mu)
\end{aligned}
{% endmath %}
  由此，可得：
  {% math %}
  \begin{aligned}
  \sum_{i=1...N}\beta_{t+1}(j)P(x_{t+1}=j|\mu)&=P(o_{t+2}...o_T|\mu)\\
  \sum_{i=1...N}\beta_t(i)P(x_t=i|\mu)&=P(o_{t+1}...o_T|\mu)\\
  &=P(o_{t+1}|\mu)P(o_{t+2}...o_T|\mu)\\
  &=P(o_{t+1}|\mu)\sum_{j=1...N}\beta_{t+1}(j)P(x_{t+1}=j|\mu)\\
  &=\sum_{j=1...N}\beta_{t+1}(j)P(x_{t+1}=j|\mu)b_{jo_{t+1}}\\
  &=\sum_{j=1...N}\beta_{t+1}(j)\sum_{i=1...N}P(x_{t}=i|\mu)P(x_{t+1}=j|x_{t}=i,\mu)b_{jo_{t+1}}\\
  &=\sum_{i=1...N}\sum_{j=1...N}\beta_{t+1}(j)P(x_{t}=i|\mu)P(x_{t+1}=j|x_{t}=i,\mu)b_{jo_{t+1}}\\
  &=\sum_{i=1...N}P(x_{t}=i|\mu)\sum_{j=1...N}\beta_{t+1}(j)P(x_{t+1}=j|x_{t}=i,\mu)b_{jo_{t+1}}
  \end{aligned}
  {% endmath %}
  易知，若上式恒成立，则：
  {% math %}
  \begin{aligned}
  \beta_t(i)&=\sum_{j=1...N}\beta_{t+1}(j)P(x_{t+1}=j|x_{t}=i,\mu)b_{jo_{t+1}}\\
  &=\sum_{j=1...N}\beta_{t+1}(j)a_{ji}b_{jo_{t+1}}
  \end{aligned}
  {% endmath %}

3. 前向后向公式
{% math %}
\begin{aligned}
\alpha_t(i)\beta_t(i)&=P(o_1...o_t,x_t=i|\mu)P(o_{t+1}...o_T|x_t=i,\mu)\\
&=P(o_1...o_t|x_t=i,\mu)P(o_{t+1}...o_T|x_t=i,\mu)P(x_t=i|\mu)\\
&=P(o_1...o_t,o_{t+1}...o_T|x_t=i,\mu)P(x_t=i|\mu)\\
&=P(o_1...o_T,x_t=i|\mu)\\
\alpha_t(i)a_{ij}b_{jo_{t+1}}\beta_{t+1}(j)&=P(o_1...o_t,x_t=i|\mu)a_{ij}b_{jo_{t+1}}P(o_{t+2}...o_T|x_{t+1}=j,\mu)\\
&=P(o_1...o_t,x_t=i,\mu)P(x_{t+1}=j|x_t=i,\mu)P(o_{t+1}|x_{t+1}=j,\mu)P(o_{t+2}...o_T|x_{t+1}=j,\mu)\\
&=P(o_1...o_t,x_{t+1}=j|x_t=i,\mu)P(x_t=i|\mu)P(o_{t+1}|x_{t+1}=j,\mu)P(o_{t+2}...o_T|x_{t+1}=j,\mu)\\
&=P(o_1...o_t,x_t=i,x_{t+1}=j|\mu)P(o_{t+1}|x_{t+1}=j,\mu)P(o_{t+2}...o_T|x_{t+1}=j,\mu)\\
&=P(o_1...o_t,x_t=i,x_{t+1}=j|\mu)P(o_{t+1}...o_T|x_{t+1}=j,\mu)\\
&=P(x_t=i,x_{t+1}=j,O|\mu)\\
P(x_t=i,x_{t+1}=j|O,\mu)&=\frac{P(x_t=i,x_{t+1}=j,O|\mu)}{P(O|\mu)}\\
&=\frac{\alpha_t(i)a_{ij}b_{jo_{t+1}}\beta_{t+1}(j)}{\sum_{i=1}^N\sum_{j=1}^N\alpha_t(i)a_{ij}b_{jo_{t+1}}\beta_{t+1}(j)}
\end{aligned}
{% endmath %}
