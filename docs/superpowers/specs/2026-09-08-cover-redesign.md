# 封面重设计 spec —— 2026-09-08

## 背景与目标

当前 PDF 封面是 ori 0.2.5 默认标题页(居中 `subject/title/author` 纯文本),过于单调。
本次仅重做**封面页**:参考 ai-agent-book 的 PDF 封面(白底 + 上下出血细色带 + 居中大标题 + 中央细线稿徽标 + 底部作者/版本行)与 xyznote 包封面(大留白 + 几何色块点缀)的设计语言,结合用户选择:方案 A 版式(上下色带徽标式)、navy `#1E3A6B` 单点缀色、保留中文副题、RL 主题装饰图形 + 版本日期行。
目录页与正文版式**零改动**。

## 设计定稿(已获用户确认,对应精修预览稿 /tmp/cprev/final.pdf)

A4 全出血(`margin: 0pt` region):

- 顶部色带 `0.9cm`、底部色带 `0.5cm`,填 navy `#1E3A6B`,贴纸边。
- 大标题 "Reinforcement Learning":39pt,IBM Plex Serif **Bold**,居中。
- 中文副题「强化学习的数学原理」:16.5pt,Medium,navy。
- RL 状态转移徽标:4 个描边状态圆($s_0..s_3$,圆直径 1.045cm,1pt navy 描边,下标 8pt)+ 3 段数学箭头($arrow.r$,9pt navy)+ 箭头上方动作标注($a_0..a_2$,7pt navy);整体居中,scale 0.95。
- 底部:作者 "Jiaxin Liu" 15.5pt;版本行 "2026 秋 · 版本 YYYY-MM-DD",9.5pt,`luma(45%)` 灰,日期 = 编译当日。
- 徽标细节:4 状态圆之间 3 箭头,首尾间距由固定 seg/gap 参数控制(实现见下)。

## 实现方案(main.typ 单文件改动)

1. `main.typ` 顶部(ori import 之后)定义常量,单一数据源:
   `cover-title = "Reinforcement Learning"`、`cover-subtitle = "强化学习的数学原理"`、`cover-author = "Jiaxin Liu"`、`cover-accent = rgb("#1E3A6B")`;ori.with 的 `title:`/`author:` 改传同名常量。
2. 在 `#show: ori.with(...)` **之前**插入封面内容块(该区域不受 ori show 影响):
   - 块内 `#set page(paper: "a4", margin: 0pt)`(独立 page region);
   - 封面内容为一个 `box(height: 100%, width: 100%, clip: true)[...]`:
     色带 → `v(2.1cm)` → 大标题 → `v(0.35cm)` → 中文副题 → `v(1.8cm)` → 徽标 → `v(1fr)` → 作者 → `v(0.4cm)` → 版本行 → `v(0.4cm)` → 底部色带;
   - 结尾 `#pagebreak()`。
3. `ori.with` 参数:原 `maketitle: true` 改为 **`maketitle: false`**(ori 不再生成旧标题页),`makeoutline: true` 保持 → 文档顺序变为:自定义封面 → ori 目录页 → 正文。
4. 封面本地函数 `cover-band`、`cover-motif`(motif 循环 4 节点 3 箭头,参数 accent/scale),日期辅助 `cover-pad2`。

### 集成注意(已核对 ori 源码 lib.typ)

- ori 内部 `counter(page).update(1)` 与 header/footer 只作用于其 body 输出,封面区不受影响;封面物理上为第 1 页但无页码(无 ori 页眉页脚作用于该 region)。
- 封面块在 `#show: ori.with` 之前 → 不被 ori 的 show 规则包裹;正文页的 set page/header 均在其后由 ori 重设,无泄漏。
- 数学下标/箭头用 New Computer Modern Math(typst 内嵌字体),三端(本地/CI/typst.app)可用,不新增字体。
- 版本行日期与 ori 的 `date: datetime.today()` 同为编译当日,不会跨天漂移不一致。

## 不做的事(YAGNI)

- 不改目录页、不改正文页眉页脚、不加封底、不引入新字体/图片资产、不动 refs.bib。

## 验收

- `typst compile --font-path fonts --ignore-system-fonts main.typ RL-Notes.pdf` 零警告零错误;
- PDF 第 1 页为设计稿所示封面;第 2 页为目录(原 ori 目录样式);
- 渲染第 1-2 页目检(用 open/预览),与 /tmp/cprev/final.pdf 视觉一致;
- 内嵌字体清单确认无新增未知字体警告。

## 后续可选项(非本次范围)

- 封底页、目录页版头装饰、徽标线稿换成更复杂的 agent-八臂式图形。
