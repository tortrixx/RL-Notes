= Introduction

== About this note

// 之前我的笔记记录在#link("https://zcnw5ot89yc6.feishu.cn/wiki/P5ELwwfIbiPTKwkS2vRcV4kTnab?from=from_copylink")[飞书云文档]中，主要看中其画板功能，但是它对于数学公式不友好，无法进行复杂的公式推导，所以我决定将笔记迁移到Typst中。

本笔记主要参考赵世钰老师的《强化学习的数学原理》课程#footnote[#cite(<zhao2025RLBook>, form: "full", style: "chicago-notes")]，课程视频可以在#link("https://space.bilibili.com/2044042934")[Bilibili]和#link("https://www.youtube.com/channel/UCztGtS5YYiNv8x3pj9hLVgg/playlists")[YouTube]上观看，其所有课件可以在#link("https://github.com/MathFoundationRL/Book-Mathematical-Foundation-of-Reinforcement-Learning")[GitHub仓库]中找到。

整个笔记按照#ref(<bookmap>)所示进行组织，首先给出强化学习中的基本概念和公式，然后按顺序介绍强化学习的各种算法思想，对其进行数学分析，并给出相关代码实现。

总体分为四个部分：

#let roadmap-item(num, title, content) = [
  #strong[#num #title] \
  #h(1.5em)#text(fill: luma(45%))[#content]
  #v(0.75em)
]

#roadmap-item(
  [①],
  [基础理论],
  [Basic Concepts → Bellman Equation → Bellman Optimality Equation],
)

#roadmap-item(
  [②],
  [表格型方法],
  [Dynamic Programming → Monte Carlo → Temporal-Difference],
)

#roadmap-item(
  [③],
  [函数逼近],
  [Stochastic Approximation → Value Function Approximation],
)

#roadmap-item(
  [④],
  [策略优化],
  [Policy Gradient → Actor-Critic],
)

#figure(
  image("/assets/BookMap.png", width:88%),
  caption: [Roadmap of Reinforcement Learning（图源：#link("https://github.com/MathFoundationRL/Book-Mathematical-Foundation-of-Reinforcement-Learning/blob/main/Readme_Images/BookMap.png")[BookMap.png]）]
) <bookmap>

== Other study materials

除了赵世钰老师的课程之外，还有一些我认为比较好的学习资源：

*书籍*

- #link("http://incompleteideas.net/book/RLbook2020.pdf")[
    Sutton & Barto, _Reinforcement Learning: An Introduction_
  ] \
  强化学习领域的“圣经”，内容全面，适合系统学习。

*经典课程*

- #link("https://www.davidsilver.uk/teaching/")[
    David Silver, _Reinforcement Learning_
  ] \
  强化学习领域的奠基级公开课，基于 Sutton 的经典教材。

*进阶课程*

- #link("https://www.youtube.com/playlist?list=PLKq1TCpsv3Y4")[
    CS285, _Deep Reinforcement Learning_
  ] — Sergey Levine, UC Berkeley \
  深度强化学习进阶课程，涵盖 Imitation Learning、Model-based RL、
  Offline RL 等内容，建议掌握 DQN、Policy Gradient、Actor-Critic
  等基础算法后学习。
