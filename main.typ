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

// 封面页:自定义版式,替代 ori maketitle(勿把下方 maketitle 改回 true,会出现两页封面)。
// 此处在 ori 作用域之外,手动套用同款字体栈(引用 default-font 常量,随 ori 换字体)。
#set text(
  font: ((name: default-font.main, covers: "latin-in-cjk"), default-font.cjk),
  lang: "zh",
  region: "cn",
)
#align(center + top)[
  #v(20%)
  #v(2em, weak: true)
  #text(2em, weight: 500)[#cover-title]
  #v(2em, weak: true)
  #cover-author
]
#place(bottom + center)[
  #text(size: 13pt)[#cover-date.display(
    "[year]年[month padding:none]月[day padding:none]日",
  )]
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

// 中文正文字重:ori 未设 weight(默认 400)偏轻,把段落内汉字提到 500。
// 必须限定在 par 内——裸的 `#show regex(...)` 会连标题汉字一并接管,把标题粗体压成 Medium。
#show par: it => {
  show regex("\p{script=Han}"): set text(weight: 500)
  it
}

#show raw: set text(size: 1.05em)

// 代码字体:Latin 用 JetBrains Mono,中文回退 Maple Mono NF。
// 须放在 ori.with 之后,整条覆盖其内置的 `show raw`(否则代码中文回退成正文宋体)。
// 家族名是 "Maple Mono NF"——Typst 会剥掉末尾的 `CN`,写全名会报 unknown 并静默回退。
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
