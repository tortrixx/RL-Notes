#import "@preview/ori:0.2.5": *

= Bellman Equation

== State Value

考虑如下多步轨迹：

$
  S_t
  arrow.r.long^(A_t)
  (R_(t+1), S_(t+1))
  arrow.r.long^(A_(t+1))
  (R_(t+2), S_(t+2))
  arrow.r.long^(A_(t+2))
  (R_(t+3), dots)
$

首先需要提出一个概念：*Discounted Return*，即从当前时刻 $t$ 开始，未来所有奖励的折扣和：

#definition[Discounted Return][
	$
		G_t
		= R_(t+1)
		+ gamma R_(t+2)
		+ gamma^2 R_(t+3)
		+ dots
	$

	- $gamma in [0, 1]$ 称为*折扣因子（Discount Factor）*。
	- $G_t$ 也是一个随机变量，因为 $R_(t+1), R_(t+2), dots$ 都是随机变量。
	- 随着奖励距离当前时刻越来越远，其权重会按照
		$1, gamma, gamma^2, dots$ 逐渐衰减。

]

沿着一个 trajectory ，其中每个状态 $S_t$ 都对应一个折扣回报 $G_t$，如#ref(<return>) 所示。

#figure(
	image("/assets/return.pdf"),
	caption: [Discounted Return $G_t$ in a trajectory]
)<return>


#definition[State Value][
	*State Value* 定义为在状态 $s$ 下，按照策略 $pi$ 进行决策所得到的折扣回报 $G_t$ 的期望值，即

	$
		v_pi(s)
		= bb(E)[G_t | S_t = s]
	$

	- 它是关于状态 $s$ 的函数。它是一个*条件期望（Conditional Expectation）*，条件是系统从状态 $s$ 出发。
	- 它依赖于*策略（Policy）*。对于不同的策略，状态价值（State Value）可能不同。
	- 它表示一个状态的“*价值*”（Value）。状态价值越大，意味着从该状态出发能够获得的*累积奖励（Cumulative Rewards）*越大，因此对应的策略通常越好。

]

=== 区分 Discounted Return 和 State Value

- *Discounted Return*：在状态 $s$ 下，按照单个确定轨迹得到的 $G_t$ 值。
- *State Value*：在状态 $s$ 下，如果存在多个可能的轨迹，则为这些轨迹对应 Discounted Return 的期望值。

== Derivation of the Bellman Equation

首先把折扣回报 $G_t$ 拆成当前奖励与折扣的后续回报两部分：

$ G_t = R_(t+1) + gamma G_(t+1) $

代入 State Value 的定义，利用期望的线性性质：

$
	v_pi(s)
	&= bb(E)[G_t | S_t = s] \
	&= bb(E)[R_(t+1) | S_t = s] + gamma bb(E)[G_(t+1) | S_t = s]
$

下面分别计算两项。

=== 第一项：当前奖励的期望

从状态 $s$ 出发，按策略 $pi$ 选择动作，当前奖励的期望为

$ bb(E)[R_(t+1) | S_t = s] = sum_a pi(a | s) r(s, a) $

其中 $r(s, a) = bb(E)[R_(t+1) | S_t = s, A_t = a]$ 是采取动作 $a$ 后的平均奖励（若奖励是确定的，则直接取奖励值）。

=== 第二项：未来回报的期望

由马尔科夫性质，$G_(t+1)$ 只与下一时刻的状态 $S_(t+1)$ 有关，而与 $S_t$ 无关，因此

$
	bb(E)[G_(t+1) | S_t = s]
	&= sum_a pi(a | s) sum_(s') p(s' | s, a) bb(E)[G_(t+1) | S_(t+1) = s'] \
	&= sum_a pi(a | s) sum_(s') p(s' | s, a) v_pi(s')
$

其中最后一步用到了 State Value 的定义 $v_pi(s') = bb(E)[G_(t+1) | S_(t+1) = s']$。

=== Bellman 方程

将两项代入，合并即得：

#theorem[Bellman 方程][
	对任意状态 $s$，状态价值 $v_pi(s)$ 满足

	$ v_pi(s) = sum_a pi(a | s) [r(s, a) + gamma sum_(s') p(s' | s, a) v_pi(s')] $ <bellman-eq>
]

它是一个*自洽方程*（self-consistent equation）：未知量 $v_pi$ 同时出现在等式两侧，状态 $s$ 的价值被表示为后续状态价值的加权组合。这正是动态规划"由后往前递推"思想的体现。

=== Matrix-Vector Form（矩阵-向量形式）

将所有状态的 Bellman 方程写在一起，即得如下推论：

#corollary[矩阵形式（Matrix-Vector Form）][
	Bellman 方程可以写为紧凑的矩阵形式

	$ v_pi = r_pi + gamma P_pi v_pi $ <bellman-matrix>

	其中：

	- $v_pi = [v_pi(s_1), dots, v_pi(s_n)]^T$ 为状态价值向量；
	- $r_pi = [r_pi(s_1), dots, r_pi(s_n)]^T$ 为一步奖励期望向量，$r_pi(s) = sum_a pi(a | s) r(s, a)$；
	- $P_pi$ 为状态转移矩阵，$[P_pi]_(i,j) = sum_a pi(a | s_i) p(s_j | s_i, a)$。
]

当状态数有限时，可以解析求解：

$ v_pi = (bb(I) - gamma P_pi)^(-1) r_pi $

当状态数很多时矩阵求逆不可行，需要用迭代法求解，这将在后续章节介绍。

#image("../assets/DQN.pdf")