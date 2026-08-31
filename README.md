# RL-Notes

《强化学习的数学原理》课程笔记（Typst 编写）。

## 编译

```bash
typst compile main.typ   # 生成 main.pdf
typst watch main.typ     # 实时预览
```

## 结构

- `main.typ` — 总装：全局设置 + 章节引入 + 参考文献
- `chapters/` — 章节内容（带序号命名）
- `refs.bib` — 参考文献（正文用 `@key` 引用）
- `figures/` — 图片
- `papers/`、`books/` — 参考资料 PDF

## 引用规范

- 正文引用：`@zhao2025RLBook`
- 图片图注：`（图源：...）` 并在 `refs.bib` 登记来源
- 图片引用：`#ref(<标签>)`，图后打标签 `<标签>`
