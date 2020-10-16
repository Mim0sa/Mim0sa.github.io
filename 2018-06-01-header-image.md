---
title: Post with Header Image
tags: TeXt
article_header:
  type: cover
  image:
    src: /screenshot.jpg
---

A Post with Header Image, See [Page layout](https://tianqi.name/jekyll-TeXt-theme/samples.html#page-layout) for more examples.

<!--more-->

### 前言

原文出自`AsyncDisplayKit`（现在叫`Texture`）文档中的一篇关于圆角的文章：[Corner Rounding](https://texturegroup.org/docs/corner-rounding.html)

### 圆角的处理

当谈到圆角处理，许多开发人员都坚持使用`CALayer`的`.cornerRadius`属性。不幸的是，这个使用方便的属性极大地增加了性能压力，你应当在没有其他选择时才使用这个属性才对。这篇文章将涵盖：

* 为什么不应该使用`CALayer`的`.cornerRadius`
* 更多高性能的圆角设置方式以及何时使用它们
* 一张告诉你该如何选择圆角策略的流程图
* 在`Texture`中设置圆角的样例

### 设置`.cornerRadius`的代价很大

为什么`.cornerRadius`的代价很大？因为使用`CALayer`的`.cornerRadius`属性会在滚动期间为60FPS的屏幕上触发离屏渲染（offscreen rendering），即使该区域的内容没有任何改变。这意味着GPU必须在每一帧上切换上下文（context），包括合成整个帧和每次使用`.cornerRadius`所导致的附加遍历之间(?)。

重要的是，这些消耗不会显示在Time Profiler中，因为它们会影响到CoreAnimation Render Server帮助App做的工作(?)。这种莽的不行的行为消耗了许多设备的性能。在iPhone 4、4S和5 / 5C（以及类似的iPad / iPod）上，你能性能显着下降。在更新版本的iPhone上，即使你看不到直接的影响，它也会使内存空间减少，从而更容易产生掉帧的情况。

### 圆角的高性能设置策略

选择圆角设置策时只需要考虑三件事：

* 在圆角下方有移动嘛？
* 在圆角处有移动么？
* 四个圆角都属于同一个**节点**？ 并且 有没有其他**节点**在圆角区域相交？