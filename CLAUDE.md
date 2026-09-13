# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

《强化学习的数学原理》(赵世钰课程)学习笔记,用 [Typst](https://typst.com) 编写,基于 [ori](https://github.com/OrangeX4/typst-ori) 0.2.5 模板(作者 OrangeX4)。渲染出的 PDF 通过 GitHub Actions 发布到 `latest` release,README 中的下载链接指向该 release。

## Build & verify

```bash
typst compile --font-path fonts --ignore-system-fonts main.typ RL-Notes.pdf   # 唯一构建命令,输出必须是 RL-Notes.pdf
```

- 无测试/lint;编译零警告零错误即为通过(含 "unknown font family" 警告)。
- 字体已 vendored 在 **fonts/**,**本地无需安装任何字体**。`--font-path fonts` 加载仓库字体,`--ignore-system-fonts` 屏蔽本机已装字体,保证本地 / CI / typst.app 云端三端字体解析一致(typst.app 会自动发现项目内的字体文件,经 GitHub import 即生效,无需手工上传)。若新增字体族,须先把字体文件放入 fonts/ 并附 OFL 等可再分发许可,否则编译会因缺字体告警或三端不一致。
- **裸 `typst compile main.typ` 会静默出错**:Typst **不搜索**项目里的 `fonts/` 子目录,必须显式 `--font-path fonts`。漏掉时项目字体全部失效、回退到本机系统字体——编译照样成功,只报 "unknown font family",还会把本机专有字体(如 macOS 的 `KaiTi`)嵌进 PDF,换台机器 / CI 上版式完全不同。**产物叫 `main.pdf` 而不是 `RL-Notes.pdf`,就是跑错命令的信号。**
- 修改后务必本地编译验证:`#definition`、`#figure`、公式、交叉引用等错误只在编译时暴露。
- **提交/推送前先格式化,CI 会校验**:本地 `typstyle -i main.typ chapters/*.typ`(`brew install typstyle`,当前 v0.15.1);`.github/workflows/format.yml` 以 `typstyle --check` 把关。它只重排源码、**不改变渲染结果**(实测 250ppi 下逐页像素一致),因此独立成 workflow 而不阻断 PDF 发布。三个注意点:① **CI 钉的版本必须与本地一致**——版本不同会对同一文件给出不同结果,造成"本地通过、CI 报红"的假失败;② 缩进统一成 2 空格;③ `&=` 只在部分位置被规范化为 `& =`,两种写法共存是正常的,别手工来回改。已归档的 typstfmt(仅支持 Typst 0.10)勿用。

## Architecture

- **main.typ** — 唯一入口:导入 ori、全局样式(`#set heading` 编号、`math.equation` 编号、脚注/引用块样式)、按顺序 `#include` 章节、`#bibliography("refs.bib")`。新增章节需在此注册并加 `#pagebreak()`。
- **chapters/NN-topic.typ** — 章节内容。标题用英文(`= Introduction`、`== About this note`),正文用中文,语言风格简要明了。章节文件不继承 main.typ 的导入作用域。
- **refs.bib** — BibTeX 文献。主参考书目在第一章用脚注全格式引用:`#footnote[#cite(<zhao2025RLBook>, form: "full", style: "chicago-notes")]`。
- **fonts/** — vendored 字体(许可文件随附为 `LICENSE-*.txt`):IBM Plex Serif(7 个字形)+ IBM Plex Mono(4 个,OFL)、Noto Serif SC(静态 7 字重,OFL,取自 notofonts/noto-cjk `Serif2.003` 的 SubsetOTF,勿换成 Google 可变字体——默认实例是 ExtraLight)、AR PL UKai(文鼎中楷,`ARPLUKai.ttf`,Arphic Public License,来源 Debian `fonts-arphic-ukai` 的 ukai.ttc 拆出 CN 面——typst.app 不识别 `.ttc` 集合文件,必须用单文件 ttf;中文强调用楷体)、**代码字体** JetBrains Mono(4 个字形 Regular/Bold/Italic/BoldItalic,OFL)+ Maple Mono NF CN(`MapleMono-NF-CN-{Regular,Bold}.ttf`,OFL,21MB/字重;raw 块内中文回退用它)。**IBM Plex 的 Medium/SemiBold/SemiBoldItalic 必须用 TTF 版**(IBM/plex 仓库 `fonts/complete/ttf/`):对应 OTF 的家族名是缩写后缀 `Medm`/`SmBld`,Typst 无法归并进 "IBM Plex Serif" 家族,500/600 字重(标题页、定理框标题)会静默落到 Regular/Bold。与 ori 0.2.5 默认字体一一对应;唯 ori 默认中文强调字体 "KaiTi" 是苹果/微软专有字体、无法分发,已在 main.typ 用 `font: (emph-cjk: "AR PL UKai")` 覆盖。
- **assets/** — 图片。引用用根相对路径 `/assets/xxx.png`(leading `/` 相对项目根,在子目录章节中也直接可用)。图片包 `#figure(..., caption: [...]) <label>` 并用 `#ref(<label>)` 交叉引用,图注用英文;外部素材须标注图源,统一写成 `(Source: #link(url)[Name])`(不用 `src`/`from` 写法),自制图可省略。
- **code/** — 预留,存放后续的代码实现示例。

## Typst gotchas (踩过的坑)

- **没有 `**加粗**` 标记**:`**x**` 会被解析成空强调并报 "no text within stars" 警告,只渲染成普通文本。加粗一律用 `#strong[...]`,斜体用 `*...*`。
- **章节内用 ori 函数需自己 import**:`#include` 的子文件不继承 main.typ 的作用域,需在章节文件顶部加 `#import "@preview/ori:0.2.5": *`。ori 0.2.5 经 Theorion 包提供定理环境:`#definition`、`#theorem`、`#proposition`、`#lemma`、`#corollary`、`#proof`、`#example`、`#assumption`、`#conclusion`、`#problem`、`#remark-block`,签名均为 `#env[标题][内容] <label>`(自动编号,可 `@标签` 交叉引用)。**语句放框内,解释文字放框外**——第三章约定:Bellman 方程用 `#theorem` 框、矩阵形式用 `#corollary` 框。
- **代码字体在 main.typ 覆盖,别动 ori 的 `cjk` 字段**:ori 自带 `show raw: set text(font: ((name: font.mono, covers: "latin-in-cjk"), font.cjk))`(`lib.typ:78`),把代码块中文回退到**正文**宋体,很违和。须在 `#show: ori.with(...)` **之后**再写一条 `show raw` 整条覆盖(后定义的 show 规则优先);**不能**改 `ori.with(font: (cjk: ...))`——那会连整本书正文中文字体一起换掉。当前:Latin 用 JetBrains Mono,中文回退 Maple Mono NF(`covers: "latin-in-cjk"` 限定前者只吃 Latin)。
- **字体家族名末尾的 `CN` 会被 Typst 吃掉**:`MapleMono-NF-CN-Regular.ttf` 的 name 表 nameID 1 明明白白写着 `Maple Mono NF CN`,但 `typst fonts` 报出的家族名是 **`Maple Mono NF`**——Typst 会剥掉家族名末尾的 `CN` token(只剥 `CN`,大小写不敏感;`SC`/`TC`/`JP`/`KR`/`Hant` 以及非末尾位置的 `CN` 均原样保留)。**以 `typst fonts` 的输出为准**(`typst fonts --font-path fonts --ignore-system-fonts`);若按文件里的名字写成 `"Maple Mono NF CN"`,Typst 只报一条 "unknown font family" 警告然后静默回退——**回退到哪个字体取决于环境**(typst.app 用自带字体,裸编译用本机系统字体如 `KaiTi`),编译照样成功,只是字体悄悄不对,所以编译警告必须清零。
- **不要试图给正文汉字加粗一档**:ori 未设 `weight`(默认 400),Noto Serif SC 的 Regular 看着偏轻,但把它提到 500 会**破坏三端一致**。Typst 的 `#strong` 是**增量式**的(基准 + 300):汉字 500 + 300 = **800**,而 800 到 `Bold`(700)与 `Black`(900)的距离**完全相等**——平局使本地判给 Bold、CI 判给 Black,同一份源码渲染出不同字重。试过 9 种 `show strong` 写法(绝对赋值 `weight: 700`、调整定义顺序、嵌进 `par`)**全部无效**,strong 的增量总是盖过用户 show 规则。结论:**正文基准字重必须落在字面网格上**(400 + 300 = 700 ✅;500 + 300 = 800 ✗),否则要先消除平局(如移除非网格字面)。
- **`#show bibliography: none` 是有意为之**:隐藏参考文献列表但保留引用解析——文献全量信息已写在脚注里,不要删除该行。
- **公式自动编号**:main.typ 设置了 `#set math.equation(numbering: "(1)")`,独立的 `$ ... $` 行即为编号公式。公式后可加标签 `$ ... $ <bellman-eq>` 供 `#ref(<bellman-eq>)` 交叉引用(第三章 Bellman 方程、矩阵形式已如此)。
- **多行公式对齐**:多步推导用 `&` 作对齐点(等号对齐),行间用 `\` 换行;仅靠源码换行不会对齐等号。**`&=` 与 `& =` 渲染结果完全相同**,用哪种都行——但见 Build & verify 的 typstyle 条目:它会**在部分位置**把 `&=` 规范化成 `& =`,所以格式化后两种写法混着出现是正常的,不要手工来回改。示例:
  ```typst
  $
      v_pi(s)
      &= bb(E)[G_t | S_t = s] \
      &= bb(E)[R_(t+1) | S_t = s] + gamma bb(E)[G_(t+1) | S_t = s]
  $
  ```
- **下标约定(第二章)**:统一用标准约定 $s_t, a_t \to r_{t+1}, s_{t+1}$,轨迹为 $\{s_0, a_0, r_1, s_1, a_1, r_2, \dots\}$,马尔科夫性质公式为 $p(s_{t+1} \mid a_t, s_t, \dots, a_0, s_0)$。新增内容保持此约定。
- **SVG 图片的坑**:Typst 嵌入 SVG 时**忽略 `<foreignObject>`**——编译给出 warning,其中内容(常是 HTML 排版的数学文字)全部丢失(官方 issue #1421)。**任何含 foreignObject 的 SVG(如 Gemini 生成的图)都不要直接 `#image` 嵌入**。另 SVG 内文字按 Typst 字体簿回退渲染,CI 只装 IBM Plex 与 Noto Serif SC,未声明这两族的 `<text>` 在本地与 CI 渲染可能不一致。含 HTML/外来字体的 SVG 须先烧字再引用,两种产物:
  - 矢量 PDF(推荐,无损缩放):写个 `@page { size: <宽>px <高>px; margin: 0 }` 的 HTML 包住 `<img src=...svg>`,再 `"Google Chrome" --headless=new --disable-gpu --no-pdf-header-footer --print-to-pdf=out.pdf "file:///wrap.html"`,`image()` 直接嵌 PDF;
  - PNG 后备:`"Google Chrome" --headless=new --disable-gpu --force-device-scale-factor=2 --window-size=<宽>,<高> --screenshot=out.png "file:///绝对路径/in.svg"`
  (assets/DQN.svg 即此类源图,其烧字产物为 DQN.pdf;SVG 源保留入库,改图后重跑对应命令)。
- **图片格式约定**:矢量线框图优先存 SVG(文字须声明 CI 已装字体族),或存烧字 PDF(Typst 0.15+ 支持 `image()` 直接嵌 PDF,matplotlib 等绘图工具的输出推荐);含外来字体/HTML 结构的复杂 SVG 与照片截图一律用高分辨率 PNG(2x+),如 assets/BookMap.png 等截图类。

## Notes workflow

- 推送 main 分支即自动触发 `.github/workflows/build.yml`:编译 PDF 并更新 `latest` release。
- 推送 main 后 build.yml 编译成功即触发 `.github/workflows/pages.yml`(通过 `workflow_run` 监听,而非 release 事件——CI 用 GITHUB_TOKEN 创建的 release 不会触发 `release: published`,这是 GitHub 防递归规则);手动发布 Release(浏览器/个人 token)同样触发。pages.yml 从 Release 提取 `RL-Notes.pdf` 部署到 GitHub Pages,直链 `https://tortrixx.github.io/RL-Notes/RL-Notes.pdf`(根目录无 index.html,访问根路径 404)。可用 `workflow_dispatch` 手动重新部署当前 `latest` release;部署末尾 smoke-test 校验直链返回 `200 application/pdf`,异常则流程报红。
- 首次部署前需在仓库 Settings → Pages 将 Source 设为 **GitHub Actions**(`actions/configure-pages` 步骤会自动完成配置,若仍报 Pages 未启用则需手动设置一次)。
