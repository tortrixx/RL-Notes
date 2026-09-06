#import "@preview/ori:0.2.5": *

= Policy Gradient

强化学习的目标无非就是_在给定环境中得到一个最好的策略（对应最高的价值）_。之前章节的核心算法是值函数方法（Value-based Method）：
+ 先进行 Policy Evaluation，即学习状态价值函数 $v_pi (s)$ 或动作价值函数 $q_pi (s, a)$。
+ 然后再进行 Policy Improvement，比如使用贪心策略或梯度上升法来更新策略参数。
+ 不断重复上述两个步骤，直到策略收敛。

学习价值函数网络（如DQN）可以处理离散空间、高维图像状态的强化学习问题，但对于连续动作空间的强化学习问题，值函数方法就显得力不从心了。因为在连续动作空间中，动作的数量是无限的，无法像离散动作空间那样直接对每个动作进行价值评估，$max_(a') Q(s', a'; theta^-)$ 无法计算。尽管可以通过对连续空间进行离散化或改变网络结构来“解决”这个问题，但实际效果并不理想。

那么，是否可以直接跳过值函数的计算，直接优化策略 $pi(a|s)$ 呢？答案是肯定的，这就是策略梯度方法（Policy Gradient Method）的核心思想。

== Algorithm

什么是优化策略？在强化学习中，策略是一个映射函数，它将状态映射到动作的概率分布。优化策略的目标是找到一个最优策略，使得在给定环境下，智能体能够最大化其累积奖励。

- 当策略 $pi$ 采用表格形式表示时，如果它能够最大化*每一个状态价值*，
  则该策略是最优策略。

- 当策略 $pi$ 采用函数形式表示时，如果它能够最大化某个*标量评价指标*
  （scalar metric），则该策略是最优策略。

我们使用第二种函数形式 $pi_theta (a|s)$ 来表示策略，其中 $theta$ 是策略的参数。这样有更好的泛化能力，能够处理连续状态空间和连续动作空间的问题。接下来就可以使用经典的机器学习思想来优化策略参数 $theta$，从而得到最优策略。

算法思路：

+ 定义一个标量评价指标 $J(theta)$，它是策略 $pi_theta$ 的函数。
+ 计算该指标的梯度 $nabla_theta J(theta)$。
+ 通过梯度上升法来优化策略参数 $theta$：$ theta_(t+1) = theta_t + alpha nabla_theta J(theta_t) $

== Metrics to define optimal policies

评价指标 $J(theta)$ 可以是状态价值函数的期望值，也可以是动作价值函数的期望值，或者其他与策略性能相关的指标。论文中常用的评价指标有两种：

- average state value: $ J(theta) &= bb(E)_(s~d_pi)[v_pi (s)] \ &= bb(E)[sum_(t=0)^infinity gamma^t R_(t+1)] $ <avg-state-value>

表示在策略 $pi$ 下，智能体访问每个状态的概率分布为 $d_pi$，而 $v_pi (s)$ 是状态 $s$ 的价值函数。该指标衡量了在策略 $pi$ 下，智能体在所有可能状态中获得的平均价值。

- average one-step reward: $ J(theta) &= bb(E)_(s~d_pi)[r_pi (s)] \ &= lim_(n -> oo) 1/n bb(E)[sum_(k=1)^n R_(t+k)] $ <avg-one-step-reward>

表示在策略 $pi$ 下，智能体访问每个状态的概率分布为 $d_pi$，而 $ r_pi (s)
  = sum_(a in cal(A)) pi(a | s) r(s, a)
  = sum_(a in cal(A)) sum_r pi(a | s) dot r dot p(r | s, a) $

是状态 $s$ 下，智能体在采取动作 $a$ 后获得的即时奖励的期望值。该指标衡量了在策略 $pi$ 下，智能体在所有可能状态中获得的平均即时奖励。

直觉上 @avg-state-value 和 @avg-one-step-reward 关注的方面不同：@avg-state-value 关注的是长期累积奖励，而 @avg-one-step-reward 关注的是即时奖励。但是二者在数学上是*等价的*。因为长期累积奖励可以通过即时奖励的期望值来计算，而即时奖励的期望值也可以通过长期累积奖励来推导。因此，在实际应用中，可以根据具体问题的需求选择合适的评价指标。

== Gradients of the metrics

指标 $J(theta)$ 对 $theta$ 的依赖来自两个层次：策略 $pi_theta (a | s)$ 直接依赖于 $theta$，而状态分布 $d_pi$ 由策略*隐式*决定——策略一变，状态的访问分布也随之改变。后者是平稳方程 $d_pi = d_pi P_pi$ 的解，对 $theta$ 的依赖难以显式表达，直接对 $J(theta)$ 求导会遇到“如何求 $nabla_theta d_pi$”的困难。

能否避开 $nabla_theta d_pi$，只对策略本身求导？答案是可以，关键是下面的对数导数技巧（log-derivative trick）。由链式法则：

$ nabla_theta ln pi_theta (a | s) = (nabla_theta pi_theta (a | s)) / (pi_theta (a | s)) $

即 $nabla_theta pi_theta (a | s) = pi_theta (a | s) nabla_theta ln pi_theta (a | s)$。这个等式看似平凡，却是整个策略梯度方法的基石：

- 它要求概率 $pi_theta (a | s) > 0$ 恒成立。离散动作空间常用 softmax 输出层：

  $ pi_theta (a | s) = exp(h(s, a, theta)) / (sum_(a') exp(h(s, a', theta))) $

  其中 $h(s, a, theta)$ 为网络给出的 logit；连续动作空间可用高斯策略（均值、方差由网络输出）。两者都保证概率恒正。

- 由概率归一化 $sum_a pi_theta (a | s) = 1$ 对 $theta$ 求导可得

  $ sum_a nabla_theta pi_theta (a | s) = 0 $

  即“把概率质量从动作 $a$ 移走多少，就必须给其他动作补回多少”——推导中常用它消去多余项。

- 它把“对概率的梯度”改写为“概率与对数概率梯度之积”，从而可以把 $pi_theta nabla_theta ln pi_theta$ 放进对动作的期望中，得到便于用采样近似的形式。

在此基础上，策略梯度定理给出了 $J(theta)$ 梯度的简洁表达式：

#theorem[Policy Gradient Theorem（策略梯度定理）][
	对平均状态价值指标 @avg-state-value 与平均一步奖励指标 @avg-one-step-reward，当 $pi_theta (a | s)$ 对 $theta$ 可微时，梯度 $nabla_theta J(theta)$ 可统一写成

	$ nabla_theta J(theta) = sum_s d_pi (s) sum_a pi_theta (a | s) nabla_theta ln pi_theta (a | s) q_pi (s, a) $

	或等价的期望形式：

	$ nabla_theta J(theta) = bb(E)_(s ~ d_pi, a ~ pi_theta)[nabla_theta ln pi_theta (a | s) q_pi (s, a)] $

	其中 $q_pi (s, a)$ 为与所选指标对应的动作价值函数。不同指标下，梯度表达式的差别只在于 $q_pi$ 的取值形式与一个与 $theta$ 无关的常数因子（折扣情形为 $1/(1 - gamma)$），不影响梯度上升的方向。
]

这个定理的关键意义在于，等号右侧*不再出现 $nabla_theta d_pi$*——状态分布对 $theta$ 的隐式依赖在推导中被消去了。推导思想是：令 $theta$ 产生一个小扰动，把指标的一阶变化展开，再借助平稳方程 $d_pi = d_pi P_pi$ 与概率归一化恒等式，把状态分布的变化全部吸收进动作价值 $q_pi (s, a)$（细节从略）。

直观理解：对每个状态-动作对 $(s, a)$，$nabla_theta ln pi_theta (a | s)$ 给出参数空间中增大 $pi_theta (a | s)$ 的方向，梯度上升按动作价值 $q_pi (s, a)$ 给该方向加权——价值高的动作被抬高，价值低的动作被压低；外层的权重 $d_pi (s)$ 则让常访问的状态优先被优化。整体效果就是把概率质量从“差动作”移向“好动作”。

== REINFORCE

策略梯度定理把梯度写成了期望形式，但仍然无法直接计算，因为其中有两个未知量：状态分布 $d_pi$（环境模型未知时不可得）与动作价值 $q_pi$（这正是值函数方法要学习的对象）。机器学习的标准对策是*随机梯度*：不求期望，而是采样一个样本、用样本梯度代替期望梯度。这一步要解决两个问题：

+ 状态与动作从哪里采？沿轨迹真实交互即可——状态按 $d_pi$ 出现、动作按 $pi_theta$ 采样，样本的分布恰好是期望里需要的 $d_pi times pi_theta$。
+ $q_pi (s_t, a_t)$ 怎么估计？从 $(s_t, a_t)$ 出发实际走一段，用得到的回报来估计。

用样本 $(s_t, a_t)$ 与其价值估计 $q_t (s_t, a_t)$ 代入，得到随机梯度上升的更新律：

$ theta_(t+1) = theta_t + alpha nabla_theta ln pi_theta (a_t | s_t) q_t (s_t, a_t) $

其中 $alpha$ 为学习率。$q_t$ 的不同估计方式，导出不同的算法：

- *蒙特卡洛（MC）*：等一个 episode 结束，用从 $(s_t, a_t)$ 出发的真实折扣回报
  $ G_t = sum_(k = 1)^(T - t) gamma^(k - 1) R_(t + k) $
  作为 $q_t (s_t, a_t)$。它是 $q_pi (s_t, a_t)$ 的无偏估计，由此得到 *REINFORCE* 算法。
- *时序差分（TD）*：用自举的方式估计 $q_t$，引出 Actor-Critic 类方法，将在后续章节介绍。

由于样本期望恰好等于真实梯度，随机梯度上升“平均而言”就是梯度上升。REINFORCE 的具体流程：

+ 初始化策略参数 $theta$。
+ 用当前策略 $pi_theta$ 从初始状态采样一条完整轨迹 $s_0, a_0, r_1, s_1, a_1, r_2, dots, s_(T-1), a_(T-1), r_T$。
+ 对 $t = 0, 1, dots, T - 1$：计算回报 $G_t$，按上式更新参数。
+ 回到第 2 步，用更新后的策略重新采样，重复直至收敛。

REINFORCE 的几个要点：

- *On-policy、整条轨迹更新*：样本必须服从当前的 $pi_theta$，轨迹随策略更新而作废，因此每一轮都要用新策略重新采样；同时 MC 回报要等整条轨迹结束才能得到，无法像 TD 那样边走边学。
- *高方差，可加基线*：$G_t$ 累积了整条轨迹的随机性，方差很大，需要较小的学习率。常用降方差手段是减去*基线（baseline）* $b(s_t)$：

  $ theta_(t+1) = theta_t + alpha nabla_theta ln pi_theta (a_t | s_t) (G_t - b(s_t)) $

  只要 $b(s_t)$ 与动作无关，减基线就不改变更新的期望：由归一化恒等式 $sum_a nabla_theta pi_theta (a | s) = 0$ 可知 $bb(E)_(a ~ pi_theta)[nabla_theta ln pi_theta (a | s) b(s)] = 0$；但合适的 $b(s)$，如状态价值 $v_pi (s)$，能显著降低方差。此时 $G_t - b(s_t)$ 是对*优势函数* $A_pi (s, a) = q_pi (s, a) - v_pi (s)$ 的蒙特卡洛估计。

- *探索与利用的自平衡*：利用 $nabla ln pi = nabla pi / pi$，更新律可改写为

  $ theta_(t+1) = theta_t + alpha (G_t) / (pi_theta (a_t | s_t)) nabla_theta pi_theta (a_t | s_t) $

  回报 $G_t$ 越大，该动作的概率被抬得越多（利用）；概率 $pi (a_t | s_t)$ 越小——动作越少被选——同样的回报带来越大的相对提升（探索）。探索与利用在更新中被自动平衡。

策略梯度方法直接在策略空间上做优化：不需要显式的策略改进操作，梯度上升本身就完成了改进；它天然支持连续动作空间，也便于利用神经网络等函数逼近。REINFORCE 是最早、最简单的策略梯度算法，它无偏但方差高。以 TD 或价值网络来估计 $q_t$、减基线降方差，就构成了后续 Actor-Critic 等更先进方法的出发点。
