#import "@preview/ori:0.2.5": *

#set heading(
  numbering: numbly("{1:一}、", default: "1.1  "),
)

#set math.equation(numbering: "(1)")

#show: ori.with(
  title: "Reinforcement Learning",
  author: "Jiaxin Liu",
  semester: "2026 秋",
  date: datetime.today(),

  maketitle: true,
  makeoutline: true,

  media: "print",
)

#include "chapters/01-introduction.typ"
#include "chapters/02-basic-concepts.typ"

#bibliography("refs.bib")
