# RL-Notes

《强化学习的数学原理》课程笔记，基于 [Typst](https://typst.com) 与 [ori](https://github.com/OrangeX4/typst-ori) 模板。

**📥 [下载最新 PDF](https://github.com/tortrixx/RL-Notes/releases/latest/download/RL-Notes.pdf) · [📖 在线阅读](https://tortrixx.github.io/RL-Notes/RL-Notes.pdf)**

> 每次推送 `main`，GitHub Actions 自动编译并更新以上链接（release 链接与 GitHub Pages 同步发布）。

## 编译

```bash
typst compile main.typ RL-Notes.pdf
```

## 结构

| 路径 | 说明 |
|---|---|
| `main.typ` | 入口：设置、章节引入、参考文献 |
| `chapters/` | 章节内容（按序号命名） |
| `refs.bib` | 参考文献 |
| `assets/` | 图片 |

## 引用

- 正文：`@key`（对应 `refs.bib` 条目）
- 图片：`#ref(<label>)` 交叉引用；图注标注图源

## 参考

- [《强化学习的数学原理》](https://github.com/MathFoundationRL/Book-Mathematical-Foundation-of-Reinforcement-Learning)
