#import "@preview/ori:0.2.5": *

#set heading(
  numbering: numbly("{1:一}、", default: "1.1  "),
)

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

// 封面与 ori 元数据共用(单一数据源)
#let cover-title = "Reinforcement Learning"
#let cover-author = "Jiaxin Liu"
// 封面页:逐字复用 ori 0.2.5 maketitle 原版布局,编译日期置于页面底部居中
// 封面区在 ori 作用域之外,需手动设置与正文一致的字体栈
#set text(font: ((name: "IBM Plex Serif", covers: "latin-in-cjk"), "Noto Serif SC"), size: 11pt, lang: "zh", region: "cn")
#align(center + top)[
  #v(20%)
  #text(2em, weight: 500, none)
  #v(2em, weak: true)
  #text(2em, weight: 500)[#cover-title]
  #v(2em, weak: true)
  #cover-author
]
#place(bottom + center)[
  #let now = datetime.today()
  #text(size: 13pt)[#now.year()年#now.month()月#now.day()日]
]
#pagebreak()

#show: ori.with(
  title: cover-title,
  author: cover-author,
  semester: "2026 秋",
  date: datetime.today(),

  // 中文强调字体:ori 默认 "KaiTi"(专有字体,云端/CI 缺失),改用随项目分发的开源楷体(文鼎中楷)
  font: (emph-cjk: "AR PL UKai"),

  maketitle: false,
  makeoutline: true,

  media: "print",
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
