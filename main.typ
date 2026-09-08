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

#show: ori.with(
  title: "Reinforcement Learning",
  author: "Jiaxin Liu",
  semester: "2026 秋",
  date: datetime.today(),

  // 中文强调字体:ori 默认 "KaiTi"(专有字体,云端/CI 缺失),改用随项目分发的开源楷体
  font: (emph-cjk: "LXGW WenKai"),

  maketitle: true,
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
