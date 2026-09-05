# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

《强化学习的数学原理》(赵世钰课程)学习笔记,用 [Typst](https://typst.com) 编写,基于 [ori](https://github.com/OrangeX4/typst-ori) 0.2.5 模板(作者 OrangeX4)。渲染出的 PDF 通过 GitHub Actions 发布到 `latest` release,README 中的下载链接指向该 release。

## Build & verify

```bash
typst compile main.typ RL-Notes.pdf   # 唯一构建命令,输出必须是 RL-Notes.pdf
```

- 无测试/lint;编译零警告零错误即为通过。本地需安装 IBM Plex 与 Noto Serif SC 字体(CI 的 workflow 中已配置安装步骤)。
- 修改后务必本地编译验证:`#definition`、`#figure`、公式、交叉引用等错误只在编译时暴露。

## Architecture

- **main.typ** — 唯一入口:导入 ori、全局样式(`#set heading` 编号、`math.equation` 编号、脚注/引用块样式)、按顺序 `#include` 章节、`#bibliography("refs.bib")`。新增章节需在此注册并加 `#pagebreak()`。
- **chapters/NN-topic.typ** — 章节内容。标题用英文(`= Introduction`、`== About this note`),正文用中文,语言风格简要明了。章节文件不继承 main.typ 的导入作用域。
- **refs.bib** — BibTeX 文献。主参考书目在第一章用脚注全格式引用:`#footnote[#cite(<zhao2025RLBook>, form: "full", style: "chicago-notes")]`。
- **assets/** — 图片。引用用根相对路径 `/assets/xxx.png`(leading `/` 相对项目根,在子目录章节中也直接可用)。图片包 `#figure(..., caption: [...]) <label>` 并用 `#ref(<label>)` 交叉引用,图注需标注图源。
- **code/** — 预留,存放后续的代码实现示例。

## Typst gotchas (踩过的坑)

- **没有 `**加粗**` 标记**:`**x**` 会被解析成空强调并报 "no text within stars" 警告,只渲染成普通文本。加粗一律用 `#strong[...]`,斜体用 `*...*`。
- **章节内用 ori 函数需自己 import**:`#include` 的子文件不继承 main.typ 的作用域,需在章节文件顶部加 `#import "@preview/ori:0.2.5": *`。ori 0.2.5 经 Theorion 包提供定理环境:`#definition`、`#theorem`、`#proposition`、`#lemma`、`#corollary`、`#proof`、`#example`、`#assumption`、`#conclusion`、`#problem`、`#remark-block`,签名均为 `#env[标题][内容] <label>`(自动编号,可 `@标签` 交叉引用)。**语句放框内,解释文字放框外**——第三章约定:Bellman 方程用 `#theorem` 框、矩阵形式用 `#corollary` 框。
- **`#show bibliography: none` 是有意为之**:隐藏参考文献列表但保留引用解析——文献全量信息已写在脚注里,不要删除该行。
- **公式自动编号**:main.typ 设置了 `#set math.equation(numbering: "(1)")`,独立的 `$ ... $` 行即为编号公式。公式后可加标签 `$ ... $ <bellman-eq>` 供 `#ref(<bellman-eq>)` 交叉引用(第三章 Bellman 方程、矩阵形式已如此)。
- **多行公式对齐**:多步推导每行以 `&=` 开头(等号对齐),行间用 `\` 换行;仅靠源码换行不会对齐等号。示例:
  ```typst
  $
      v_pi(s)
      &= bb(E)[G_t | S_t = s] \
      &= bb(E)[R_(t+1) | S_t = s] + gamma bb(E)[G_(t+1) | S_t = s]
  $
  ```
- **下标约定(第二章)**:统一用标准约定 $s_t, a_t \to r_{t+1}, s_{t+1}$,轨迹为 $\{s_0, a_0, r_1, s_1, a_1, r_2, \dots\}$,马尔科夫性质公式为 $p(s_{t+1} \mid a_t, s_t, \dots, a_0, s_0)$。新增内容保持此约定。

## Notes workflow

- 推送 main 分支即自动触发 `.github/workflows/build.yml`:编译 PDF 并更新 `latest` release。
- 推送 main 后 build.yml 编译成功即触发 `.github/workflows/pages.yml`(通过 `workflow_run` 监听,而非 release 事件——CI 用 GITHUB_TOKEN 创建的 release 不会触发 `release: published`,这是 GitHub 防递归规则);手动发布 Release(浏览器/个人 token)同样触发。pages.yml 从 Release 提取 `RL-Notes.pdf` 部署到 GitHub Pages,直链 `https://tortrixx.github.io/RL-Notes/RL-Notes.pdf`(根目录无 index.html,访问根路径 404)。可用 `workflow_dispatch` 手动重新部署当前 `latest` release;部署末尾 smoke-test 校验直链返回 `200 application/pdf`,异常则流程报红。
- 首次部署前需在仓库 Settings → Pages 将 Source 设为 **GitHub Actions**(`actions/configure-pages` 步骤会自动完成配置,若仍报 Pages 未启用则需手动设置一次)。
