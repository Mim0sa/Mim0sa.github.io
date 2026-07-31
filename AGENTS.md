# AGENTS.md

## 项目说明

- `Archive/` 是历史文章的原始存档，不直接参与网站生成，也不要修改或删除其中的原文件。
- `MyBlog/` 是基于 Swift Publish 的静态博客项目。
- 网站内容来自 `MyBlog/Content/`，主题位于 `MyBlog/Sources/MyBlog/MimosaTheme.swift`，样式位于 `MyBlog/Resources/MimosaTheme/styles.css`。
- `MyBlog/Output/` 是 Publish 的生成结果，不要手工编辑。

## 文章迁移

- 正式文章放在 `MyBlog/Content/posts/`，使用稳定的英文文件名作为 URL slug。
- metadata 使用以下格式：

```markdown
---
title: 文章标题
date: 2025-04-27 12:00
tags: iOS, Swift
---
```

- 不要为文章补写 `description`，文章列表也不使用独立封面。
- 每篇文章使用单独一行 `<!--more-->` 标记摘要结束位置；文章列表完整渲染该标记之前的正文、图片、代码和列表。
- 图片放在 `MyBlog/Resources/Image/posts/<article-slug>/`。
- Markdown 图片使用 `/Image/posts/<article-slug>/image.png` 形式的绝对路径。
- 迁移时保留原文内容，只调整 metadata、资源路径和明显的格式问题。
- 网站的“归档”页面按年份分组，每行显示月日和文章标题；不要把旧文章迁入 `Content/archive/`。

## 开发与验证

在 `MyBlog/` 目录运行：

```bash
swift run
```

每次修改内容或主题后，都应确认：

- 构建成功并重新生成 `Output/`。
- 文章标题、日期和标签正确。
- 正文图片全部可访问，移动端没有横向溢出。
- `feed.rss` 与 `sitemap.xml` 包含新文章。

保持 Mim0sa 主题的深色、克制和长文阅读导向；优先保证清晰排版、响应式布局与可访问性。
