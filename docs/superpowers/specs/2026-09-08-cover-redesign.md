# 封面加日期 spec —— 2026-09-08(方向变更:放弃大幅重设计)

## 背景

曾计划全面重设计封面(方案 A 上下色带徽标式等,预览稿在 /tmp/cprev/ 留存)。用户评估后
决定**保持 ori 默认封面原样**,仅在其下方追加一行日期。本 spec 描述最终最小改动。

## 设计定稿

- 封面仍为 ori 原 maketitle 版式(居中:v(20%) → 22pt Medium 大标题 "Reinforcement Learning" → 2em 间距 → 作者 "Jiaxin Liu")。
- 作者下方 `v(1.2em)` 处加一行小字日期:`YYYY-MM-DD`,10pt,`luma(45%)` 灰,取编译当日(`datetime.today()`,月/日补零)。

## 实现方案(main.typ)

1. 定义常量:`cover-title = "Reinforcement Learning"`、`cover-author = "Jiaxin Liu"`,并让
   `ori.with(title:, author:)` 引用同常量(单一数据源)。
2. `ori.with` 设 `maketitle: false`;在 `#show: ori.with(...)` 之前插入与 ori 原标题页
   同构的自定义封面块(默认页边距区域,不与 ori show 规则冲突):
   `align(center + top)[ v(20%) → 标题(2em,500) → v(2em, weak) → 作者 → v(1.2em) → 日期 ]`,
   结尾 `#pagebreak()`。
3. 日期补零辅助函数 `cover-pad2`;`makeoutline` 等其余 ori 参数不变 → 文档顺序:
   封面(物理第 1 页)→ ori 目录页 → 正文,页数与原来一致。

## 不做的事

- 不引入色带/徽标/装饰/新字体/图片;不改目录页与正文;不加封底。

## 验收

- `typst compile --font-path fonts --ignore-system-fonts main.typ RL-Notes.pdf` 零警告零错误;
- 第 1 页视觉与原先封面一致,仅作者下方多一行日期;页数不变(封面+目录+正文同前)。
