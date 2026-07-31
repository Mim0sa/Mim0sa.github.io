# AGENTS.md

## 项目

- `Archive/` 是历史原始存档，除非明确要求，否则不要修改。
- `MyBlog/` 是 Swift Publish 博客；内容在 `Content/`，主题在 `Sources/MyBlog/MimosaTheme.swift`，样式在 `Resources/MimosaTheme/mimosa.css`。
- `MyBlog/Output/` 是生成产物，已忽略；不要手工编辑或提交。

## 文章

- 文章放在 `MyBlog/Content/posts/`，使用稳定的英文 URL slug。
- metadata：

```markdown
---
title: 文章标题
date: 2025-04-27 12:00
tags: iOS, Swift
---
```

- 保留原文标题、日期、标签和正文；不要改写标签或补写 `description`。
- 使用单独一行 `<!--more-->`；文章列表完整渲染其前面的内容，不使用独立封面。
- 图片放在 `MyBlog/Resources/Image/posts/<slug>/`，引用路径为 `/Image/posts/<slug>/image.png`。
- 归档按年份显示“月日 + 标题”，标签在归档页筛选；不要把文章放进 `Content/archive/`。

## 构建与发布

- 在 `MyBlog/` 运行 `swift run`，确认页面、图片、分页、RSS 和 sitemap 正常。
- 推送 `master` 后，[Pages 工作流](.github/workflows/pages.yml) 会执行 Release 构建并发布到 `https://mim0sa.github.io`。
- 发布源码到 `origin`；不要手动发布 `Output/`。

保持博客主题简约克制、适合长文阅读，并兼顾明暗模式、响应式布局与可访问性。
