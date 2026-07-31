# 写作与发布

## 新建文章

在 `MyBlog/Content/posts/` 新建 Markdown 文件，使用稳定的英文文件名作为 URL slug，例如：

```text
my-new-article.md
```

文章地址将是：

```text
https://mim0sa.github.io/posts/my-new-article/
```

文章模板：

```markdown
---
title: 我的新文章
date: 2026-08-01 12:00
tags: iOS, Swift
---

这里是文章列表中显示的内容。

<!--more-->

这里是文章详情中的后续正文。
```

- 不要添加 `description`。
- `tags` 按原始写法填写。
- `<!--more-->` 必须单独占一行。
- 文章列表会完整渲染 `<!--more-->` 前面的内容。

## 添加图片

图片放在：

```text
MyBlog/Resources/Image/posts/my-new-article/
```

文章中使用绝对路径：

```markdown
![图片说明](/Image/posts/my-new-article/example.png)
```

图片位于 `<!--more-->` 前面时，也会显示在文章列表中。纯文字文章不需要图片。

## 本地预览

生成网站：

```bash
cd MyBlog
swift run
```

启动本地服务器：

```bash
cd Output
python3 -m http.server 8000 --bind 127.0.0.1
```

打开 `http://127.0.0.1:8000`，检查文章、图片、标签和归档。

## 发布

在项目根目录运行：

```bash
git add .
git commit -m "Add my new article"
git push
```

推送 `master` 后，GitHub Actions 会自动构建并发布到 `https://mim0sa.github.io`。
