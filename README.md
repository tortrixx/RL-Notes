# RL-Notes

《强化学习的数学原理》课程笔记，基于 [Typst](https://typst.com) 与 [ori](https://github.com/OrangeX4/typst-ori) 模板。

**📥 [下载最新 PDF](https://github.com/tortrixx/RL-Notes/releases/latest/download/RL-Notes.pdf) · 📖 [在线阅读](https://tortrixx.github.io/RL-Notes/RL-Notes.pdf)**

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

## 许可证

作者原创内容（笔记正文、自绘图表）采用 [CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/)（署名-非商业性使用）授权；课程、书籍来源的图片版权归原作者，图注已标注出处。

## 参考

- [《强化学习的数学原理》](https://github.com/MathFoundationRL/Book-Mathematical-Foundation-of-Reinforcement-Learning)

- [李宏毅 Deep Reinforcement Learning, 2018](https://youtube.com/playlist?list=PLJV_el3uVTsODxQFgzMzPLa16h6B8kWM_&si=kBkxp0OGjZY06Xmt)

- [CleanRL: High-quality Single-file Implementations of Deep RL Algorithms](https://github.com/vwxyzjn/cleanrl)
