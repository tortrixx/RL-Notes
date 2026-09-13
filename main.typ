#import "@preview/ori:0.2.5": *

#set heading(numbering: "1.1 ")

#set math.equation(numbering: "(1)")

#show footnote: set super(
  typographic: false,
  size: 0.7em,
  baseline: -0.45em,
)

#show footnote.entry: entry => {
  let location = entry.note.location()
  box(
    align(right, super(
      typographic: false,
      size: 0.7em,
      baseline: -0.45em,
      counter(footnote).display(at: location, "1"),
    )),
  )
  h(0.2em)
  entry.note.body
}

// 封面与 ori 元数据共用(单一数据源;日期只取一次,避免两次取值跨午夜不一致)
#let cover-title = "Reinforcement Learning"
#let cover-author = "Jiaxin Liu"
#let cover-date = datetime.today()

// 封面页:沿用 ori 0.2.5 maketitle 原版布局(subject 位本项目为空,省去空行),
// 编译日期置于页面底部居中。封面区在 ori 作用域之外,手动套用 ori 同款字体栈
// (经 default-font 常量引用,ori 换字体时自动跟随)。
// 注意:此自定义封面替代 ori maketitle,勿将下方 ori.with 的 maketitle 改回 true,否则会出现两页封面。
#set text(font: ((name: default-font.main, covers: "latin-in-cjk"), default-font.cjk), lang: "zh", region: "cn")
#align(center + top)[
  #v(20%)
  #v(2em, weak: true)
  #text(2em, weight: 500)[#cover-title]
  #v(2em, weak: true)
  #cover-author
]
#place(bottom + center)[
  #text(size: 13pt)[#cover-date.display("[year]年[month padding:none]月[day padding:none]日")]
]
#pagebreak(weak: true)

#show: ori.with(
  title: cover-title,
  author: cover-author,
  semester: "2026 秋",
  date: cover-date,

  // 中文强调字体:ori 默认 "KaiTi"(专有字体,云端/CI 缺失),改用随项目分发的开源楷体(文鼎中楷)
  font: (emph-cjk: "AR PL UKai"),

  maketitle: false,
  makeoutline: true,

  media: "print",
)

#show raw: set text(size: 1.05em)

// 代码字体:Latin 用 JetBrains Mono,中文注释回退到等宽中文 Maple Mono NF。
// `covers: "latin-in-cjk"` 限定 JetBrains 只吃 Latin,汉字落到第二个字体。
// 必须放在 ori.with 之后——ori 内部自带一条 `show raw`,把中文回退到正文的 Noto Serif SC
// (lib.typ:78),后定义的 show 规则优先,在此整条覆盖;不能改 ori 的 cjk 字段,
// 那会连正文中文字体一起换掉。
//
// 注意字体名写作 "Maple Mono NF":文件是 MapleMono-NF-CN-Regular.ttf,name 表里
// nameID 1 也确实写着 "Maple Mono NF CN",但 Typst 会剥掉家族名末尾的 `CN` token
// (`typst fonts` 里显示什么就得写什么)。写成 "Maple Mono NF CN" 会报
// "unknown font family" 并静默回退。
#show raw: set text(
  font: ((name: "JetBrains Mono", covers: "latin-in-cjk"), "Maple Mono NF"),
  size: 1.05em,
)

#show quote: it => block(
  width: 100%,
  inset: (left: 12pt, y: 5pt),
  stroke: (left: 2pt + luma(70%)),
  text(fill: luma(35%))[#it.body],
)

#include "chapters/01-introduction.typ"

#pagebreak()

#include "chapters/02-basic-concepts.typ"

#pagebreak()

#include "chapters/03-bellman-equation.typ"

#pagebreak()

#include "chapters/09-policy-gradient.typ"

#pagebreak()

#show bibliography: none
#bibliography("refs.bib")
