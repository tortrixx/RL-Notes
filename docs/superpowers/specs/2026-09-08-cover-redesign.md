# 封面底部加日期 spec —— 2026-09-08(最终版)

## 背景

曾计划全面重设计封面(方案 A/B/C 预览稿),用户评估后改为**保持 ori maketitle 原版布局不动**,
仅在页面底部追加一行编译日期。本 spec 记录最终落地形态(历经多轮微调,commit `10d4370`
`73da3dd` `08eb078` 后的状态)。

## 设计定稿

- 封面主体 = ori 0.2.5 `maketitle` 原版布局逐字沿用:页顶 v(20%) → 22pt Medium
  大标题 "Reinforcement Learning"(2em, weight 500)→ weak 间距 → 作者 "Jiaxin Liu"。
  subject 位本项目为空,不渲染空行。
- 日期行:`place(bottom + center)`,**13pt 黑色**,中文格式 `2026年9月8日`
  (`datetime.today().display("[year]年[month padding:none]月[day padding:none]日")`,
  月日不补零),取编译当日。

## 实现(main.typ)

1. 常量区(单一数据源):`cover-title`、`cover-author`、`cover-date = datetime.today()`;
   `ori.with(title:, author:, date:)` 与封面共用,`date` 只取一次,避免两次求值跨午夜不一致。
2. `ori.with` 设 `maketitle: false`,封面自定义块放在 `#show: ori.with(...)` 之前
   (ori 作用域外),因此需手动 `#set text(font: ((name: default-font.main, covers: "latin-in-cjk"),
   default-font.cjk), lang: "zh", region: "cn")` —— 经 ori 导出的 `default-font` 常量引用,
   ori 换字体时自动跟随。
3. 封面块末尾 `#pagebreak(weak: true)`(与 ori 原 maketitle 结尾一致,裁剪编译时不会产生空白页)。
4. **不要**把 `maketitle` 改回 `true`:自定义封面已替代它,双开会出现两页封面(已加注释)。
5. CI(build.yml Compile 步骤)固定 `env: TZ: Asia/Shanghai`:日期取编译主机当地日期,
   GitHub Actions 默认 UTC,凌晨(北京 0-8 点)推送会印成"昨天"。

## 文档漂移说明

早期 spec 版本(3a9f5e3)描述的"作者下方 10pt 灰色日期"已作废;以本文为准。

## 不做的事

- 不引入色带/徽标/装饰/新字体/图片;不改目录页与正文;不加封底。

## 验收

- `typst compile --font-path fonts --ignore-system-fonts main.typ RL-Notes.pdf` 零警告零错误;
- 第 1 页 = 原封面布局 + 页底中文日期;总页数 14 与改动前一致(封面 → 目录 → 正文);
- 封面日期与 PDF 元数据日期一致(同一 `cover-date` 常量)。
