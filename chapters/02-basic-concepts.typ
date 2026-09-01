#import "@preview/ori:0.2.5": *

= Basic Concepts

== Markov Decision Process (MDP)

#figure(
  image("/assets/interaction.png"),
  caption: [智能体与环境的交互过程]
)<interact>

马尔可夫决策过程（MDP）是强化学习问题的数学框架。强化学习的基本交互过程如#ref(<interact>) 所示：智能体根据当前状态 $s_t$ 选择动作 $a_t$ ，环境据此反馈奖励 $r_(t+1)$ 并转移到新的状态 $s_(t+1)$ ，如此循环往复，从而生成一段轨迹（trajectory），如 ${s_0, a_0, r_1, s_1, a_1, r_2, dots}$ 。整个交互过程构成了一个 MDP。

#definition[Markov Decision Process][
  马尔可夫决策过程可以表示为五元组

  $
    cal(M) = (cal(S), cal(A), P, R, gamma)
  $

  其中：

  - $cal(S)$：状态空间；
  - $cal(A)$：动作空间；
  - $P(s' | s, a)$：状态转移概率；
  - $R(s, a)$：奖励函数；
  - $gamma in [0, 1)$：折扣因子。
]

MDP 由三部分组成：

- *M — Markov Property（马尔科夫性质）*

  马尔科夫性质又称“无记忆性”：未来只与当前状态$s_t$和动作$a_t$有关，与历史无关，即

  $ p(s_(t+1) | a_t, s_t, dots, a_0, s_0) = p(s_(t+1) | a_t, s_t) $

  $ p(r_(t+1) | a_t, s_t, dots, a_0, s_0) = p(r_(t+1) | a_t, s_t) $

  也就是说，下一时刻的状态和奖励只取决于最近的状态 $s_t$ 与动作 $a_t$，更早的历史数据可以丢弃——状态 $s_t$ 已包含决策所需的全部信息。这正是五元组中状态转移概率写作 $P(s' | s, a)$ 的原因。

- *D — Policy（策略）*

  策略是智能体的行为准则：在状态 $s$ 下选择动作 $a$ 的概率为 $pi(a | s)$，满足归一化条件 $sum_a pi(a | s) = 1$。若某一动作的概率为 1，则退化为确定性策略（deterministic policy）。

- *P — Sets & Probability Distributions（状态集合与概率分布）*

  *状态集合（Sets）*

  - #strong[State 状态]：$s in cal(S)$，对环境的描述，是决策的依据。
  - #strong[Action 动作]：$a in cal(A)$，智能体可以采取的行为。
  - #strong[Reward 奖励]：$r in cal(R)$，环境给出的标量反馈，衡量动作的好坏。

  *概率分布（Probability Distributions）*

  - #strong[状态转移概率]：$P(s' | s, a)$，在状态 $s$ 下采取动作 $a$ 后，转移到新状态 $s'$ 的概率。
  - #strong[奖励概率]：$p(r | s, a)$，在状态 $s$ 下采取动作 $a$ 后，获得奖励 $r$ 的概率。若奖励是确定的，则记为五元组中的奖励函数 $R(s, a)$。

综上，五元组 $(cal(S), cal(A), P, R, gamma)$ 中：$cal(S)$、$cal(A)$、$P$、$R$ 描述了环境（P），折扣因子 $gamma$ 权衡即时与未来奖励，策略 $pi$ 是智能体的决策准则（D），马尔科夫性质（M）则是整个过程成立的前提假设。
