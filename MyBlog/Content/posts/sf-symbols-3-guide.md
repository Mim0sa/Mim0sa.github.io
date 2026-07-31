---
title: SF Symbols 3 使用指南
date: 2022-10-07 12:00
tags: iOS, 内参, 设计
image: Image/posts/sf-symbols-3-guide/Cover.png
---

> 本文是 [WWDC21 内参](https://xiaozhuanlan.com/wwdc21) 的供稿，如今关注 [老司机周报](https://github.com/SwiftOldDriver) 就可免费领取。

本文基于 WWDC 2021 [Session 10097](https://developer.apple.com/videos/play/wwdc2021/10097), [Session 10251](https://developer.apple.com/videos/play/wwdc2021/10251) 和 [Session 10349](https://developer.apple.com/videos/play/wwdc2021/10349) 梳理。本文从 SF Symbols 的特性和优点切入，主要谈论 SF Symbols 应该如何在各个平台的代码中使用。在这次 WWDC 2021 中，除了符号的数量的增加之外，还有多种颜色渲染模式和更多的本地化选项供开发者实践，让 SF Symbols 这把利器变得更加趁手和锋利。

![Cover](/Image/posts/sf-symbols-3-guide/Cover.png)

<!--more-->


- [WWDC21 - SF Symbols 3 使用指南](https://mim0sa.github.io/2022/10/07/SF-Symbols-3-%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97.html)
- [WWDC21 - 定制属于你的 Symbols](https://mim0sa.github.io/2022/10/08/%E5%AE%9A%E5%88%B6%E5%B1%9E%E4%BA%8E%E4%BD%A0%E7%9A%84-Symbols.html)
- [WWDC22 - SF Symbols 4 使用指南](https://mim0sa.github.io/2022/10/09/SF-Symbols-4-%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97.html)

## 什么是 SF Symbols

符号在界面中起着非常重要的作用，它们能有效地传达意义，它们可以表明你选择了哪些项目，它们可以用来从视觉上区分不同类型的内容，而且符号出现在整个视觉系统的各处，这使整个用户界面营造了一种熟悉的感觉。

符号的实现和使用方式多种多样，但设计和使用符号时有一个更古不变的问题，那就是将符号与用户界面的另一个基本元素----'“文本”很好地配合。符号和文字在用户界面中以各种不同的大小被使用，他们之间的排列形式、对齐方式、符号颜色、文本字重与符号粗细的协调、本地化配置以及无障碍设计都需要开发者和设计师来细心配置和协调。

![SF Symbols](/Image/posts/sf-symbols-3-guide/SF-Symbols.png)

为了方便开发者更便捷、轻松地使用符号，Apple 在 iOS 13 中开始引入他们自己设计的海量高质量符号，称之为 SF Symbols。SF Symbols 拥有超过 3100 个符号，是一个图标库，旨在与 Apple 平台的系统字体 San Francisco 无缝集成。符号有 9 种字重和 3 种比例，并自动与文本标签对齐。同时这些符号是矢量的，这意味着它们是可以被拉伸的，使得他们在无论用什么大小时都会呈现出很好的效果。它们也可以被导出并在矢量图形编辑工具中进行编辑，来创建具有共享设计特征和无障碍功能的自定义符号。

![colored symbols](/Image/posts/sf-symbols-3-guide/colored-symbols.jpeg)

对于开发者来说，这套 SF Symbols 无论是在 UIKit，AppKit 还是 SwiftUI 中都能运作良好，且使用方式也很简单方便。本文将会使用 AppKit、UIKit 或 SwiftUI 的代码示例来带大家探索如何在自己的 App 中轻松加入 SF Symbols。 

## 如何使用 SF Symbols

### SF Symbols 3 App

在开始介绍如何使用 SF Symbols 之前，我们可以先下载来自 Apple 官方的 SF Symbols 3 App，这款 App 中收录了所有的 SF Symbols，并且记录了每个符号的名称，支持的渲染模式，不同语言的变体，不同 OS 版本下可能出现的不同的名称，并且可以实时预览不同渲染模式下不同强调色的不同效果。你可以在[这里](https://developer.apple.com/sf-symbols/)下载 SF Symbols 3 App。

![SF Symbols 3](/Image/posts/sf-symbols-3-guide/SF-Symbols-3.png)

### 符号的渲染模式

通过之前的图片你可能已经注意到了，SF Symbols 可以拥有多种颜色，有一些 symbol 甚至还有预设的颜色，例如代表天气、肺部、电池的符号等等。如果要使用这些带有自定义颜色的符号，你需要了解，SF Symbols 有四种渲染模式：

#### 单色模式 Monochrome

在 iOS 15 / macOS 11 之前，单色模式是唯一的渲染模式，顾名思义，单色模式会让符号有一个单一的颜色。要设置单色模式的符号，我们只需要设置图片的 tint color 或者 accent color 就可以完成。

```swift
let image = UIImage(systemName: "battery.100.bolt")
imageView.image = image
imageView.tintColor = .systemYellow

// SwiftUI
Image(systemName: "battery.100.bolt")
  .foregroundStyle(.yellow)
```

![Monochrome](/Image/posts/sf-symbols-3-guide/Monochrome.png)

#### 分层模式 Hierarchical

每个符号都是预先分层的，如下图所示，符号按顺序最多分成三个层级：primary，secondary，tertiary。有一些符号只有一个层级，也就是只有 primary 层。有一些符号只有两个层级，其中第一个层级一定是 primary 层，第二个层级可以是 secondary 层，也可以是 tertiary 层。**SF Symbols 的分层设定不仅在分层模式下有效，在后文别的渲染模式下也是有作用的。**

分层模式和单色模式一样，可以设置一个颜色。但是分层模式会以该颜色为基础，生成降低主颜色的不透明度而衍生出来的其他颜色（如图中的电池符号看起来是由三种黄色组合而成）。在这个模式中，层级结构很重要，如果缺少一个层级，相关的派生颜色将不会被使用。

```swift
var image = NSImage(systemSymbolName: "battery.100.bolt",
                    accessibilityDescription: "Battery")
let config = NSImage.SymbolConfiguration(hierarchicalColor: .systemYellow)
imageView.image = image
imageView.symbolConfiguration = config

// SwiftUI
Image(systemName: "battery.100.bolt")
  .foregroundStyle(.yellow)
	.symbolRenderingMode(.hierarchical)
```

![Hierarchical](/Image/posts/sf-symbols-3-guide/Hierarchical.png)

> 你可以在 SF Symbols 3 App 中查询到每个符号有几个层级以及层级是如何分配的

#### 调色盘模式 Palette

调色盘模式和分层模式很像，但也有些许不同。和分层模式一样是，调色盘模式也会对符号的各个层级进行上色，而不同的是，调色盘模式允许你自由的分别设置三个层级各自的颜色，就像你正在用一块调色盘一样🎨。

```swift
let image = UIImage(systemName: "battery.100.bolt")
let config = UIImage.SymbolConfiguration(paletteColors: [.red, .orange, .yellow])
imageView.image = image
imageView.symbolConfiguration = config

// SwiftUI
Image(systemName: "battery.100.bolt")
    .foregroundStyle(.red, .yellow, .red)
```

![Palette](/Image/posts/sf-symbols-3-guide/Palette.png)

>  注意：如果你的符号只有两个层级，那你也可以使用 `[.red, .yellow]`  类似这样的只有两个颜色的数组。系统会将数组中的第二个颜色添加到符号的非 primary 层级上。但如果你的符号有三个层级，但你只提供了两个颜色的数组，你的非 primary 层级将会都使用颜色数组中的最后一个颜色。

#### 多色模式 Muticolor

在 SF Symbols 中，有许多符号的意象在现实生活中已经深入人心，比如：删除操作应该是红色的，添加操作应该是绿色的，天空应该是蓝色的等等。所以 SF Symbols 也提供了与现实世界色彩相契合的颜色模式：多色渲染模式。当你使用多色模式的时候，就能看到预设的黄色太阳符号，橙色药丸符号，且你不需要指定任何颜色。

```swift
let image = UIImage(systemName: "battery.100.bolt")
let config = UIImage.SymbolConfiguration.preferringMultiColor
imageView.image = image
imageView.preferredSymbolConfiguration = config

// SwiftUI
Image(systemName: "battery.100.bolt")
	.symbolRenderingMode(.multicolor)
```

![Muticolor](/Image/posts/sf-symbols-3-guide/Muticolor.png)

不是所有 SF Symbols 都有多色模式的，如果对没有多色模式的符号设置多色模式将没有效果。假如你需要对某个处于多色模式的符号手动指定颜色，且该符号有图层可以接受强调色的话，直接设置其 tint color 也可以达到效果。

```swift
let image = UIImage(systemName: "flame.fill") // 🔥
let config = UIImage.SymbolConfiguration.preferringMultiColor
imageView.image = image
imageView.preferredSymbolConfiguration = config
// configure the fire symbol with red color
imageView.tintColor = .red
```
此外，你也可以将多色模式与其他渲染模式结合起来，当符号支持多色模式时会使用多色模式预设的颜色，而不支持时会使用另一个渲染模式。要注意的是，当你结合分层模式和调色板模式的时候只能选择一个，因为它们是互斥的。若这两个颜色模式也不被该符号支持，那就会使用单色模式。除此之外，也可以通过类似的操作，将渲染模式和字重等其他配置结合起来。

```swift
let image = UIImage(systemName: "battery.100.bolt")
let multiColorConfig = UIImage.SymbolConfiguration.preferringMultiColor
let paletteConfig = UIImage.SymbolConfiguration(paletteColors: [.red, .orange, .yellow])
let config = multiColorConfig.applying(paletteConfig)
imageView.image = image
imageView.preferredSymbolConfiguration = config
```

> 你可以在 SF Symbols 3 App 中查询到每个符号支持哪些模式

### 字重和比例

SF Symbols 和 Apple 平台的系统字体 San Francisco 一样，拥有九种字重：

* Ultralight
* Thin
* Light
* Regular
* Medium
* Semibold
* Bold
* Heavy
* Black

同时为了在不同使用场合体现不一样的强调性，SF Symbols 还提供了三种比例可以选择：

* Small
* Medium
* Large

这意味着每个 SF Symbol 都有 27 种样式以供使用：

![3+9](/Image/posts/sf-symbols-3-guide/3-9.png)

```swift
let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .large)
imageView.preferredSymbolConfiguration = config

// SwiftUI
Label("Heart", systemImage: "heart")
  .imageScale(.large)
  .font(.system(size: 20, weight: .semibold))
```

符号的字重和文本的字重原理相同，都是通过加粗线条来增加字重。值得一提的是，SF Symbols 的三种比例尺寸并不是单纯的对符号进行缩放。如果你仔细观察，会发现对于同一个字重，但是不同比例的符号来说，他们线条的粗细是一样的，但是对符号的整体进行了扩充和延展，以应对不一样的使用环境。

![muti scale](/Image/posts/sf-symbols-3-guide/muti-scale.png)

### 符号变体

对于某些符号来说，有多种表现形式，我们以 `"heart"` 这个符号为例子，他有许多种变体：

![heart  varient](/Image/posts/sf-symbols-3-guide/heart-varient.png)

在以前，如果我们想要使用圆形底填充样式的爱心，我们可以使用 `UIImage(systemImage: "heart.circle.fill")` 这样名称字符串拼接的形式来实现。但是要注意的是你需要先拼接 `".circle"` 再拼接 `".fill"`，如果反过来将会找不到这个符号。

现在我们有了更简便的方法，更好用也更不容易出错：

```swift
let imageView = UIImageView(image: UIImage(systemName: "heart"))
imageView.imageVariant = .circle.fill

// SwiftUI
Label("Heart", systemImage: "heart")
  .symbolVarient(.circle.fill)
```

在不同的使用场景下我们通常会使用不同风格的符号，比如 iOS 在 tab bar 中我们会使用填充样式（`.fill`）的符号，而 macOS 在 tab bar 中我们更倾向于线性符号。但如果你是在 SwiftUI 中，在系统提供的大部分 View 中使用符号的话，你无需使用填充样式，系统会根据自身平台是 iOS 还是 macOS 来决定到底展示哪种风格的符号。以下方代码为例子，该 TabView 在 iOS 下是填充样式，而在 macOS 下是线性样式。

```swift
TabView {
  CardsView().tabItem {
    Label("Cards", systemImage: "person.circle") // 不需要加.fill
  }
}
```

### 一些其它技巧

#### 符号的本地化

有一些符号对于不同地区不同语言的使用者来说，有着不同的特点。比如字典上的文字，🌏地球的角度，书写文本的方向等等，这些符号都是需要本地化的，而 SF Smybols 已经为我们处理好了这个问题。在今年，Apple 扩大了 SF Symbols 多语言本地化的覆盖范围，增加了阿拉伯文、希伯来文和德瓦那加里文的新符号，并包括泰文、中文、日文和韩文的设计。所有这些本地化的符号和文字变体都能根据用户的设备语言自动适应，包括从右到左的书写系统，从而使之变得简单，且开发者不需要做额外的工作。

![Localization](/Image/posts/sf-symbols-3-guide/Localization.png)

#### 在 Interface Builder 中使用符号

在代码中对 SF Symbols 进行配置的这些代码，在 Interface Builder 中也可以实现🎉。

![Interface Builder](/Image/posts/sf-symbols-3-guide/Interface-Builder.png)

## 总结

从上文介绍 SF Symbols 的特性和优点我们可以看到，它的出现是为了解决符号与文本之间的协调性问题，私以为在这方面，Apple 提供的这个工具已经做的非常好了，对各个细节的处理都十分到位。有个小小的遗憾是：今年更新的许多内容，例如渲染模式以及很多新的有趣符号，都是仅支持 iOS 15 以上，距离广泛引用还有一段距离。但这次更新之后，SF Symbols 无论是在查询符号、原生支持、代码接入以及符号的丰富程度上来说，都达到了让人惊艳的程度，相信对于大部分小型开发者来说，可以说是会放在第一手选择的的符号工具🥳。

## 更多资料

以下是更多关于 SF Symbols 的资料：

* [&#91; WWDC 21 &#93; What’s new in SF Symbols](https://developer.apple.com/videos/play/wwdc2021/10097)
* [&#91; WWDC 21 &#93; SF Symbols in UIKit and AppKit](https://developer.apple.com/videos/play/wwdc2021/10251/)
* [&#91; WWDC 21 &#93; SF Symbols in SwiftUI](https://developer.apple.com/videos/play/wwdc2021/10349)
* [&#91; WWDC 21 &#93; Explore the SF Symbols 3 app](https://developer.apple.com/videos/play/wwdc2021/10288)
* [&#91; WWDC 21 &#93; Create custom symbols](https://developer.apple.com/videos/play/wwdc2021/10250)
* [&#91; WWDC 20 &#93; SF Symbols 2](https://developer.apple.com/videos/play/wwdc2020/10207)
* [&#91; WWDC 19 &#93; Introducing SF Symbols](https://developer.apple.com/videos/play/wwdc2019/206)
* [&#91; Human Interface Guidelines &#93; SF Symbols](https://developer.apple.com/design/human-interface-guidelines/sf-symbols/overview/)
* [&#91; Developer &#93; SF Symbols](https://developer.apple.com/sf-symbols/)
