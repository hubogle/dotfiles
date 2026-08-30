# PI

[pi](https://pi.dev) 编码智能体 Agent

## 概述

集中管理 pi Agent 的个性化配置、扩展、SKILL 以及开发规范，旨在为 AI 编码助手提供**一致的行为准则、工具链和工作流**。


## 目录结构

```
.
├── AGENTS.md          # 全局开发配置（语言、编码原则、工作流、命令策略）
├── settings.json      # pi 核心设置（主题、包、提供商、代理等）
├── agents             # Sub Agents
├── skills             # Agent Skills
├── extensions         # Pi 扩展/插件
├── prompts            # 可复用 Prompt 模板
└── README.md
```

## 配置说明

### settings.json

| 配置项 | 说明 |
|--------|------|
| `defaultProvider` / `defaultModel` | 默认 AI 提供商与模型（LinuxHub / deepseek-v4-flash-vision-exp） |
| `defaultThinkingLevel` | 默认思考等级（high） |
| `retry` | 自动重试策略（最多 8 次，基础延迟 10s，provider 最大重试延迟 120s） |
| `compaction` | 上下文压缩（已关闭） |
| `hideThinkingBlock` | 隐藏思考过程 |
| `showCacheMissNotices` | 缓存未命中提示 |
| `quietStartup` | 静默启动 |
| `tuiMode` | TUI 模式（regular） |
| `fullscreenExitOutput` | 全屏模式退出时输出的内容（transcript） |
| `markdown.mermaid` | Mermaid 图表渲染时机（final） |

### packages

```
pi install npm:pi-cc-extensions
pi install npm:@ff-labs/pi-fff
pi install npm:pi-rtk-optimizer
pi install npm:pi-subagents
```

```
┌──────────────────────────────────────────────┐
│                     Model                    │
└──────────────────────┬───────────────────────┘
                       │
                 Pi Harness Core
                       │
       ┌───────────────┼───────────────┐
       │               │               │
       ▼               ▼               ▼
      FFF             RTK            CC UI
  Code Search      Bash/Output       Render
       │               │               │
   find/grep        git/test/...    compact UI
   multi_grep        output slim     diff/thinking
       │
       ▼
 read → edit/write
```

## 开发规范（AGENTS.md）

`AGENTS.md` 是 AI 编码助手的行为准则，核心要点：

- **语言**：所有输出使用简体中文
- **编码原则**：先思考再编码、简洁优先、外科手术式修改、目标驱动执行
- **工作流**：普通功能 → 编码 → 审查 → 提交；复杂功能先规划
- **命令策略**：文件操作用专用工具，Git 只读操作自动执行，管理员/交互命令交用户执行
- **自动代理**：代码审查 `code-review-expert`、复杂规划 `planning-with-files` 自动触发
