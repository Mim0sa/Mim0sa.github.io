---
title: SF Symbols 27 使用指南
date: 2026-10-12 12:00
tags: iOS, 设计
typora-root-url: ../../Resources
typora-copy-images-to: ../../Resources/Image/posts/sf-symbols-27-guide
---

本文将从 SF Symbols 的特性切入，讨论 SF Symbols 这款由系统字体支持的符号库有哪些特点以及最常见的使用方式，也会简单提一下近期更新和最新特性。

SF Symbols 在 2025 年延续了既有框架，进一步增强了绘制和动画能力。到了 WWDC26，已经没有自己的 WWDC session。同时，在最新的 SF Symbols 网站中，我注意到现在的正式命名随着 OS 的更新也变成了 SF Symbols 27，所以本文是一份迟到的 SF Symbols 27 使用指南。除了以往的内容外，新增了 SF Symbols 7(2025) 和 SF Symbols 27(2026) 的内容。

本文基于个人理解、往期 session 和 WWDC 2025 [What’s new in SF Symbols 7](https://developer.apple.com/videos/play/wwdc2025/337/) 梳理。

前情提要：

* [SF Symbols 6 使用指南](https://mim0sa.github.io/posts/sf-symbols-6-guide)
* [SF Symbols 5 使用指南](https://mim0sa.github.io/posts/sf-symbols-5-guide)
* [SF Symbols 4 使用指南](https://mim0sa.github.io/posts/sf-symbols-4-guide)
* [定制属于你的 Symbols](https://mim0sa.github.io/posts/custom-symbols)
* [SF Symbols 3 使用指南](https://mim0sa.github.io/posts/sf-symbols-3-guide)

![WWDC24History](/Image/posts/sf-symbols-27-guide/WWDC2526History.png)

<!--more-->

## 什么是 SF Symbols

符号在界面中起着非常重要的作用，它们能在没有文字的情况下有效地传达意义，同时也能节约空间、整洁界面。符号的实现和使用方式多种多样，在设计和使用符号时，符号和文字经常在用户界面中以各种不同的大小被使用，他们之间的排列形式、对齐方式、符号颜色、文本字重与符号粗细的协调、本地化配置以及无障碍设计都需要开发者和设计师来细心配置和协调。

为了方便开发者和设计师更便捷、轻松地使用符号，Apple 在 iOS 13 中开始引入他们自己设计的海量高质量符号，称之为 SF Symbols。现在 SF Symbols 拥有超过 7000 个符号，与 Apple 平台的系统字体 San Francisco 无缝集成。

大部分没有使用过的开发者对 SF Symbols 的印象是：一个官方免费的「图标库」。但实际上他其实和传统「图标」不尽相同，使用 SF Symbols 时，不需要自己导入图片，你可以针对不同的使用场景调整符号的字号、字重、比例、渲染模式、动画等行为，而且它和系统原生的组件紧密结合，使用起来非常方便。在符合你的需求的情况下，往往可以起到事半功倍的效果。

![A grid of new SF symbols including icons for wifi, sliders, package, documents, people, and more](/Image/posts/sf-symbols-27-guide/vx-poster-sf-symbols-new-symbols_2x.png)

## 如何正确使用 SF Symbols

### 相关工具

#### 1. SF Symbols App

在开始介绍如何使用 SF Symbols 之前，可以先下载来自 Apple 官方的 SF Symbols App，它支持搜索所有的 SF Symbols，并且展示所有符号的各种形态和动画，以及可以自定义 Symbols，这是官方提供的 SF Symbols 字典+设计工具。你可以在[这里](https://developer.apple.com/sf-symbols/)下载最新的 SF Symbols App。

![image-20261012154539140](/Image/posts/sf-symbols-27-guide/sf-symbols-app.png)

#### 2. SymbolsLibrary

我做了一个在移动端上可以查阅 SF Symbols 的免费 app，叫做 [SymbolsLibrary](https://apps.apple.com/app/symbolslibrary/id6773283238)，方便在手机上查阅相关信息。除了和官方 App 类似的常规内容外，我的 app 中还可以查看 Apple 未公布的私有符号，可以以网格、基准线来预览系统组件中符号的表现，也支持自然语言搜索（比官方支持的早！）。目前在佛系维护中，欢迎有需要的小伙伴下载看看。

![截屏2026-10-30 10.40.14](/Image/posts/sf-symbols-27-guide/截屏2026-10-30 10.40.14.png)

### 如何使用符号

使用 SF Symbols 非常简单，可以先去 SF Symbols App 中找到你喜欢的符号，然后复制这个符号的名字，将它粘贴到代码中即可。对于 SF Symbols 来说，我们可以调节他的字号、字重和比例来满足搭配不同类型文字的需求，和系统字体一样，SF Symbols 有 9 种字重和 3 种比例来满足你不同场景下的使用需求。你可以利用系统框架 UIKit、AppKit 或者 SwiftUI 中的组件来实现。

![SF Symbols 的三种比例与九种字重](/Image/posts/sf-symbols-27-guide/new3x9.png)

```swift
Image(systemName: "thermometer.sun.fill")
    .fontWeight(.semibold)
    .imageScale(.large)
```

### 符号的渲染模式

SF Symbols 可以自定义颜色和透明度。想要使用这些带有自定义颜色的符号，你需要知道：SF Symbols 在渲染模式的颜色逻辑上是预先分层的（如下图的温度计符号就分为三层），我们可以改变渲染模式来调整颜色，SF Symbols 会根据每一层的路径作出相应变化，SF Symbols 有**四种渲染模式**。

![RenderingModes](/Image/posts/sf-symbols-27-guide/RenderingModes.png)

#### 单色模式 Monochrome

设置单色模式会让符号变成纯色。要注意的是，设置视图的 tint 等属性只是改变颜色，并不等于指定了单色模式，因为有些符号默认使用分层模式。如果你希望符号保持单色，需要先显式指定单色模式，再设置你想要的颜色。

```swift
// SwiftUI
Image(systemName: "battery.100percent.bolt")
    .foregroundStyle(.yellow)
    .symbolRenderingMode(.monochrome)

// UIKit
let image = UIImage(systemName: "battery.100percent.bolt")
imageView.image = image
imageView.tintColor = .yellow
imageView.preferredSymbolConfiguration = .preferringMonochrome()
```

![Monochrome](/Image/posts/sf-symbols-27-guide/Monochrome.png)

#### 分层模式 Hierarchical

从渲染的逻辑上来说每个符号都是预先分层的，如下图所示。分层模式和调色盘模式使用最多三个颜色层级：Primary，Secondary，Tertiary。要注意的是，这里的三个层级并不代表符号最多只有三个图层，实际的路径和图层可以更多，多色模式也不受三种颜色的限制。**SF Symbols 的分层设定不仅在分层模式下有效，在其他渲染模式下也是有意义的**。

分层模式和单色模式一样，可以设置一个颜色。但是分层模式会以该颜色为基础，生成降低主颜色的不透明度而衍生出来的其他颜色（如下图中的**电池符号**看起来是由三种黄色组合而成）。

层级结构很重要，如果缺少某一个层级，则相关的派生颜色将不会被使用。

```swift
// SwiftUI
Image(systemName: "battery.100percent.bolt")
    .foregroundStyle(.yellow)
    .symbolRenderingMode(.hierarchical)

// UIKit
let image = UIImage(systemName: "battery.100percent.bolt")
imageView.image = image
let config = UIImage.SymbolConfiguration(hierarchicalColor: .yellow)
imageView.preferredSymbolConfiguration = config
```

![Hierarchical](/Image/posts/sf-symbols-27-guide/Hierarchical.png)

#### 调色盘模式 Palette

调色盘模式和分层模式很像，和分层模式一样是，调色盘模式也会对符号的各个层级进行上色。不同的是，调色盘模式允许你自由的分别设置各个层级的颜色。

```swift
// SwiftUI
Image(systemName: "battery.100percent.bolt")
    .foregroundStyle(.red, .orange, .yellow)
    .symbolRenderingMode(.palette)

// UIKit
let image = UIImage(systemName: "battery.100percent.bolt")
imageView.image = image
let config = UIImage.SymbolConfiguration(paletteColors: [.red, .orange, .yellow])
imageView.preferredSymbolConfiguration = config
```

![Palette](/Image/posts/sf-symbols-27-guide/Palette.png)

#### 多色模式 Multicolor

在 SF Symbols 中，有许多符号的意象在现实生活中已经深入人心，比如：⚠️警告的符号应该是黄色的，🌈彩虹符号应该是彩色的。所以 SF Symbols 也提供了与现实世界色彩相契合的颜色模式：多色渲染模式。

当你使用多色模式的时候，你不需要指定任何颜色，就能看到预设的橙色太阳符号，红色删除符号。你可以在 SF Symbols App 中查阅每个符号多色渲染模式下的表现。

```swift
// SwiftUI
Image(systemName: "battery.100percent.bolt")
    .symbolRenderingMode(.multicolor)

// UIKit
let image = UIImage(systemName: "battery.100percent.bolt")
imageView.image = image
imageView.preferredSymbolConfiguration = .preferringMulticolor()
```

![Multicolor](/Image/posts/sf-symbols-27-guide/Muticolor.png)

#### 自动渲染模式 Automatic

假如不去特意配置符号的渲染模式，那么它将使用默认渲染模式，大部分符号的默认渲染模式都是单色模式。但也有一些特别的，例如 `shareplay` 这个符号将会使用分层模式作为默认渲染模式。

之前的版本中，可以在 SF Symbols App 中查阅每个符号默认的是哪个渲染模式，选择符号后，在对应渲染模式下方会有一个空心圆点，但是最新版的 App 我没找到这个提示了，可能是他们改坏了吧。

### 渐变效果

除了改变渲染模式能够调整符号颜色之外，SF Symbols 7 中新增了渐变的效果，可自动从单个源颜色生成平滑的线性渐变效果，从而增加光效和维度，提升符号表现力。渐变效果适用于所有渲染模式，可以与单色、分层、调色盘和多色模式搭配使用。

![多色模式下的 SF Symbols 渐变效果](/Image/posts/sf-symbols-27-guide/sf-symbols-gradient.png)

```swift
Image(systemName: "pc")
	.symbolRenderingMode(.multicolor)
  .symbolColorRenderingMode(.gradient)
```

### 可变颜色/绘制

有的时候，我们使用符号并不只想表达一个概念或者意象，也想体现一些数值、比例或者程度，例如 Wi-Fi 强度或者铃声音量，在 SF Symbols 中，对于这种场景可以使用可变符号。

在 SF Symbols App 中的 `Variable` 目录中找到所有可变符号，可以通过右侧面板的滑块来查看不同百分比程度下可变符号的形态。可变符号分为可变颜色和可变绘制，可变颜色是离散的，视觉效果是一块一块亮起来的感觉，可变绘制是连续的，像进度条那样流畅变化。

> 在 SF Symbols App 中，你可以看到除了 draw 和 color 之外，还有一个 default mode。在 UIKit 和 AppKit 中，对应的是 `.automatic`，系统会根据符号自动选择可变模式。SwiftUI 虽然没有 `.automatic`，但 `symbolVariableValueMode` 接受 `nil`，[文档](https://developer.apple.com/documentation/swiftui/environmentvalues/symbolvariablevaluemode)将它描述为自动选择模式。
>
> 不过这里有一个实际表现上的差异：对于本次测试的、只支持可变绘制的符号，在 iOS 27.0 和 macOS 27.0.1 上，UIKit 和 AppKit 中，使用 `.automatic` 或者不指定模式，都可以随着 `variableValue` 的变化显示绘制进度；但在 SwiftUI 中，传入 `nil` 或者不指定模式，符号都不会随数值变化，只有显式指定 `.draw` 才有效。这与文档描述不一致，应该是 SwiftUI 当前版本的一个 bug。所以，如果你需要在 SwiftUI 中使用可变绘制，建议显式指定 `.symbolVariableValueMode(.draw)`。

![可变颜色（上排）与可变绘制（下排）演示](/Image/posts/sf-symbols-27-guide/VariableSymbols.gif)

在代码中，我们在初始化符号时增加一个 `Double` 类型的 `variableValue` 参数，就可以实现可变颜色在不同程度下的不同形态。假如你的可变符号（例如上图 Wi-Fi 符号）可变颜色部分有三层，那么这个 `variableValue` 将会三等分判定，0.2 和 0.5 的效果将会不一样，但是 0.1 和 0.2 的表现是一样的；如果是可变绘制，那么将根据 `variableValue` 的变化而实时变动。

要注意的是，`variableValue` 用 `0...1` 表达当前程度，本身不会让符号自动播放动画，需要由你的代码更新数值。后文的 `.symbolEffect(.variableColor)` 则是自动播放的预设动画。同一个符号可以同时支持可变颜色和可变绘制，但一次渲染只能选择其中一种。

```swift
// SwiftUI
Image(systemName: "wifi", variableValue: 0.2)
		.symbolVariableValueMode(.color) // 显式使用可变颜色
Image(systemName: "thermometer.sun", variableValue: 0.5)
		.symbolVariableValueMode(.draw)

// AppKit（macOS 26+）
let wifiImage = NSImage(
    systemSymbolName: "wifi",
    variableValue: 0.2,
    accessibilityDescription: nil
)?.withSymbolConfiguration(
    NSImage.SymbolConfiguration(variableValueMode: .color) // 显式使用可变颜色
)

let thermometerImage = NSImage(
    systemSymbolName: "thermometer.sun",
    variableValue: 0.5,
    accessibilityDescription: nil
)?.withSymbolConfiguration(
    NSImage.SymbolConfiguration(variableValueMode: .draw)
)
```

> 注意，可变符号的可变颜色部分也是一种分层的表现，但这里的分层和上文提到的渲染模式使用的分层没有关系且可以不同。一个符号可以在渲染模式中只分两层，但在可变颜色的分层中分为三层或者更多。
>
> 例如上图中第二个符号 `speaker.wave.3.fill`，在分层渲染模式中，可以看到左侧的喇叭是一层，右侧三条 wave 整体是第二层，没有第三层。但它的可变颜色分为三层，集中在右侧的三条 wave 上，左侧的喇叭图形不参与可变颜色的逻辑。

![ColoredVariableSymbols](/Image/posts/sf-symbols-27-guide/ColoredVariableSymbols.gif)

可变颜色的可变部分是利用不透明度来实现的，当可变颜色和不同的渲染模式结合后，会有很好的效果。

### 认识 Animation

SF Symbols 有执行动画的能力，这是一种给你的界面增添活力、动感的方式，你可以从一系列不同的可配置的动画预设中选择你想要的来使用。这些动画支持不同的比例、字重和渲染模式，这让符号们的动画既易于定制也使用简单。具体的动画表现也取决于符号本身的支持情况，例如 `Variable Color` 需要有参与可变颜色的图层，`DrawOn` 和 `DrawOff` 的路径绘制则需要相应的绘制标注。

![SF Symbols 动画效果演示](/Image/posts/sf-symbols-27-guide/sf-symbols-animation.gif)

### 12 种动画

目前 SF Symbols 的动画一共有 12 种，分别是：

* `Bounce`, `Scale`, `Wiggle`, `Rotate`, `Breathe`, `Variable Color`, `Pulse`
* `Appear`, `Disappear`
* `DrawOn`, `DrawOff`（SF Symbols 7 新增）
* `Replace`

大部分动画效果，在 sdk 中我们称之为 `SymbolEffect`。接下来我会通过代码来展示每个动画的运作机制和特点，在这之前，可以先打开 SF Symbols App，在这里看到所有符号的所有动画的预览，你也可以通过调节选项来预览不同的动画效果组合，以及直接复制你调整好的动画代码。

#### Bounce

`Bounce` 是一个非常有动感的动画，常常在强调某个区域或者按钮的时候用到这个效果，动画默认使用 `.byLayer`，会将符号各个图层单独在不同时间段进行动画，会有一种弹跳的动感。

如果你想要整个符号所有图层同时进行动画，需要在代码中使用 `.wholeSymbol` 特别指定一下，同理，接下来的要介绍的所有动画（除了 `Variable Color` 动画）也都有这个特点，后文就不再单独介绍这个特性了。

```swift
// SwiftUI
Image(systemName: "checkmark.seal")
    .symbolEffect(.bounce.up,
                  options: .repeat(.periodic(delay: 1)))
Image(systemName: "checkmark.seal")
    .symbolEffect(.bounce.up.wholeSymbol,
                  options: .repeat(.periodic(delay: 1)))

// UIKit
imgView.addSymbolEffect(.bounce.up)
```

![Bounce](/Image/posts/sf-symbols-27-guide/Bounce-preview.gif)

#### Scale

`Scale` 在动画效果上和 `Bounce` 是相似的，但是他更多的是用在提醒用户某个区域正处于一个特殊状态，例如在 macOS 上，我们的鼠标经过了某个按钮，我们可以为该按钮提供一个 `Scale` 动画并保持住 `Scale` 状态以提醒用户：这里是可以点击的并且你的指针已经在这个按钮上了。

```swift
Image(systemName: "folder.badge.plus")
    .symbolEffect(.scale.up, isActive: isActive)

isActive.toggle()
```

![Scale](/Image/posts/sf-symbols-27-guide/Scale-preview.gif)

#### Wiggle

`Wiggle` 是一个非常可爱的动画，它可以让符号以任意角度做一个扭动的效果。可以在需要用户特别注意的地方使用这个动画，暗示或提示用户下一步操作的位置。你可以选择：上、下、左、右、顺/逆时针或者用数字指定的角度来掌控扭动的方向。如果你不指定方向，每个符号自身也有一个默认的方向。

```swift
Image(systemName: "arrow.right.circle")
    .symbolEffect(.wiggle,
                  options: .repeat(.periodic(delay: 0.5)))
Image(systemName: "iphone.gen3.radiowaves.left.and.right")
    .symbolEffect(.wiggle.clockwise.wholeSymbol,
                  options: .repeat(.periodic(delay: 0.5)))
```

![WiggleAnimation](/Image/posts/sf-symbols-27-guide/Wiggle-preview.gif)

#### Rotate

`Rotate` 可以让符号旋转。这个动画可以运用在等待或者表示在过程中的情况。旋转的方向我们可以选择顺时针、逆时针，也可以通过调整这个动画的 repeat behavior 来实现均匀连续的旋转。

```swift
Image(systemName: "fan.desk")
    .symbolEffect(.rotate.clockwise, options: .repeat(.periodic(delay: 0)))
Image(systemName: "fan.desk")
    .symbolEffect(.rotate.counterClockwise, options: .repeat(.continuous))
```

![RotateAnimation](/Image/posts/sf-symbols-27-guide/Rotate-preview.gif)

在默认的情况下是会选择 `.byLayer` 执行动画，例如在上图的电风扇符号中，只有扇叶层会旋转，这是 SF Symbols 预先设计好的。如果你手动指定动画按照 `.wholeSymbol` 执行，那整个电风扇符号（连同风扇底座）都会旋转起来，好奇的可以亲手实践一下🐶。

#### Variable Color

我们也可以为有可变颜色特性的符号做动画，而且动画顺序将会遵循可变颜色的层级顺序来实现。要注意的是，在可变颜色中，如果设置部分图层完全不参与可变颜色的变化，那么在可变颜色动画中，这部分图层也完全不会参与动画。另外，为没有可变颜色特性的符号做可变颜色动画时将不会有动画效果。

`Variable Color` 的动画比较特别，你可以选择动画过程中要把未激活的图层隐藏还是降低不透明度、动画模式是累加还是迭代、一次动画结束之后要不要反向再做一次动画等。这些动画都可以在 SF Symbols App 中任意组合预览。

```swift
Image(systemName: "rainbow")
    .symbolEffect(.variableColor.cumulative.dimInactiveLayers.reversing)
Image(systemName: "rainbow")
    .symbolEffect(.variableColor.iterative.hideInactiveLayers.nonReversing)
```

![ShowVariableColorOptions](/Image/posts/sf-symbols-27-guide/VariableColor-preview.gif)

`Variable Color` 的动画分为 open loop 和 closed loop，对应下图左和右，closed loop 符号的头尾是相连的，当 closed loop 的符号执行动画时，动画执行完一圈之后不会有短暂停止，会无缝衔接下一圈动画。在自定义符号时，可以修改符号的 loop 类型。

```swift
Image(systemName: "waveform")
    .symbolEffect(.variableColor.iterative, options: .repeat(.continuous))
Image(systemName: "progress.indicator")
    .symbolEffect(.variableColor.iterative, options: .repeat(.continuous))
```

![VariableColorLoopAnimation](/Image/posts/sf-symbols-27-guide/VariableColorLoop-preview.gif)

#### Pulse

`Pulse` 是一种闪烁效果，可以用来表示一种正在进行中的状态，例如我们下左图这个符号可以用来表示正在分享屏幕。要注意的是，和 `Rotate` 一样，该动画默认来说会按图层执行动画，有的部分符号预设了需要强调闪烁的部分（如下左图），所以在执行动画时，会有部分图层不闪烁。

```swift
Image(systemName: "rectangle.inset.filled.and.person.filled")
    .symbolEffect(.pulse)
Image(systemName: "globe")
    .symbolEffect(.pulse)
```

![Pulse](/Image/posts/sf-symbols-27-guide/Pulse-preview.gif)

#### Breathe

`Breathe` 是一种和 `Pulse` 有一些类似的动画，更适合用于更活泼、更有生命力的场景。`Breathe` 通过缓慢放大和缩小产生呼吸感，也可以像 `Pulse` 一样叠加不透明度变化。你可以手动选择该符号在呼吸时要不要闪烁，例如使用 `.plain` 就不会叠加闪烁效果。

```swift
Image(systemName: "leaf")
    .symbolEffect(.breathe.plain)
Image(systemName: "lungs")
    .symbolEffect(.breathe)
```

![BreatheAnimation](/Image/posts/sf-symbols-27-guide/Breathe-preview.gif)

#### Appear / Disappear

`Appear` 和 `Disappear` 分别让符号出现和消失。根据符号是否需要保留在布局中，可以选择两种实现方式：

* 左侧使用 `.symbolEffect`：符号消失后仍占据原来的位置，两侧的树不会移动。
* 右侧使用 `.transition`：符号从视图层级中移除，两侧的树随布局收拢；再次插入时，布局展开，符号出现。

![Appear / Disappear：保留位置与布局收拢对比](/Image/posts/sf-symbols-27-guide/AppearDisappear.gif)

先看左侧保留位置的效果。通过 `isActive` 控制 `.disappear` 是否生效，符号只在自身控件内更新画面，不影响周围的布局；取消该效果时，符号会重新出现。

```swift
// SwiftUI
HStack {
    Image(systemName: "tree")
    Image(systemName: "sun.max.fill")
        .symbolEffect(.disappear, isActive: isSunHidden)
    Image(systemName: "tree")
}

// UIKit
imageView.addSymbolEffect(.disappear)
...
imageView.addSymbolEffect(.appear)  // Re-appear
```

右侧则通过条件判断插入或移除符号，并使用 `.transition(.symbolEffect)` 为这个过程添加出现与消失的动画。配合 `withAnimation`，周围的布局也会随之平滑变化。UIKit 中可以在消失动画完成后，将控件从父视图移除。

```swift
// SwiftUI
HStack {
    Image(systemName: "tree")
    if !isSunHidden {
        Image(systemName: "sun.max.fill")
            .transition(.symbolEffect)
    }
    Image(systemName: "tree")
}

withAnimation {
    isSunHidden.toggle()
}

// UIKit
let imageView = UIImageView()
imageView.addSymbolEffect(.disappear) { context in
    if let imageView = context.sender as? UIImageView, context.isFinished {
        imageView.removeFromSuperview()
    }
}
```

#### DrawOn / DrawOff

绘制是 SF Symbols 7 中新增的动画，他是受手写笔触启发，旨在让符号更富有表现力地进入和退出界面。它利用符号的图层结构，路径导向编排，来引导符号的运动。

绘制支持 `byLayer`、`wholeSymbol` 和 `individually` 三种绘制方式， 决定了符号多图层中的每个图层执行动画的时机。

绘制的动画方向已经被预设，例如 `wind.snow` 的动画就是从左向右，一些阿拉伯语言的符号变体则是从右往左绘制的，像 `rainbow` 这样的对称符号则是从中间往两侧绘制的。

和 Appear / Disappear 一样，也有两种预期的效果，以及对应的不同实现方式。

```swift
// Indefinite
Image(systemName: "pencil.and.outline")
		.symbolEffect(.drawOn, isActive: isDrawing)

Image(systemName: "pencil.and.outline")
		.symbolEffect(.drawOff, isActive: isDrawing)

// Transition
HStack {
    Image(systemName: "cloud")
    if !isTornadoHidden {
        Image(systemName: "tornado")
            .transition(.symbolEffect(.drawOn))
    }
    Image(systemName: "cloud")
}

withAnimation {
    isTornadoHidden.toggle()
}
```

![SF Symbols DrawOn / DrawOff 绘制动画演示](/Image/posts/sf-symbols-27-guide/sf-symbols-draw.gif)

#### Replace

`Replace` 是一种替换符号的方案，在你需要给按钮替换或者更新符号时常常用到。他是一种 `.contentTransition`，你有三种动画配置可以选择：`.downUp` 会让旧符号缩小退出、新符号放大进入；`.upUp` 会让旧符号和新符号都以放大的方式退出和进入；`.offUp` 则会立即隐藏旧符号，让新符号放大进入。这里的 up 和 down 指的是缩放，而不是上下移动的方向。

当你使用的两个符号只有某一部分不同，或者说你使用的两个符号都是从某个基础符号演变而来的时候，例如下图中的 `video.fill` 和 `video.slash.fill` ，这两个符号的差别只有一条 slash 线，那么系统默认使用 `MagicReplace` 动画，不会让摄像机符号消失再出现，使动画看起来更加流畅。如果你熟悉 Keynote 的话，这个效果就像 Keynote 里面的[神奇移动效果](https://education.apple.com/learning-center/T024609A-zh_CN)。

SF Symbols 7 还为 `MagicReplace` 增加了相同外框的匹配：当两个符号有相同的外框时，系统可以保留外框，只替换内部不同的部分。

如果你使用的符号拥有绘制效果，那么默认情况下，也会执行 `drawOff` -> `drawOn` 的绘制动画，这也是 `MagicReplace` 的表现。如下图第 3、4 个符号的动画。

```swift
// SwiftUI
Image(systemName: isActive ? "figure.stand" : "figure.walk")
    .contentTransition(.symbolEffect(.replace.downUp))
Image(systemName: isActive ? "video.fill" : "video.slash.fill")
    .contentTransition(.symbolEffect(.replace)) // MagicReplace

// UIKit
let image = UIImage(systemName: "video.slash.fill")
imageView.setSymbolImage(image, contentTransition: .replace.downUp)
```

![Replace](/Image/posts/sf-symbols-27-guide/ReplaceAnimation.gif)

### 控制动画

除了产生动画之外，我们也要知道如何控制动画。上文提到的 `Bounce`、`Variable Color`、`Pulse`、`Rotate`、`Wiggle`、`Breathe` 都属于 `Discrete` 动画，遵循 `DiscreteSymbolEffect` 协议。这些动画的触发可以是不连续的、离散的，我们在某个时机告诉系统动画开始进行，动画需要进行几次，这样在动画执行完之后他就不需要我们再去处理了。

```swift
// SwiftUI
Image(systemName: "fan.desk")
    .symbolEffect(
        .bounce,
        options: .repeat(2),
        value: value
    )

// UIKit
imageView.addSymbolEffect(.bounce, options: .repeat(.periodic(2)))
```

在 SwiftUI 中，`value:` 每次发生变化都会触发动画，如果传入的是 `Bool`，变成 `true` 或 `false` 都会触发。因此，如果你想在每次点击时触发一次动画，可以传入一个计数器，并在点击时递增。

那另一种更常见的情况是，我希望在代码中有一个变量来控制效果的状态，使效果可以通过代码来开启或者关闭。这类效果属于 `Indefinite` 类型，遵循 `IndefiniteSymbolEffect` 协议。上文介绍的 `Bounce`、`Variable Color`、`Pulse`、`Rotate`、`Wiggle`、`Breathe`，以及 `Scale`、`Dis/Appear`、`DrawOn/Off` 都支持这种行为。

`isActive:` 则控制效果是否生效：`true` 时启用，`false` 时取消。`Indefinite` 表示效果会持续影响符号，直到被禁用或移除。这既可以表现为持续运动，也可以表现为保持某种状态，并不意味着动画一定会不断循环。你可以发现很多动画既支持 `Discrete`，也支持 `Indefinite`：它们既可以单独被触发固定次数，也可以通过变量来控制效果是否生效。

```swift
// SwiftUI
Image(systemName: "fan.desk")
    .symbolEffect(
        .rotate,
        options: .repeat(.periodic),
        isActive: isActive
    )

// UIKit
imageView.addSymbolEffect(.variableColor)
...
imageView.removeSymbolEffect(ofType: .variableColor)
```

对于支持重复播放的效果，可以用代码设置动画的执行次数、重复间隔和速度。要注意的是，像 `Scale`、`Appear` 这样改变并保持符号状态的效果，并不能通过设置重复次数来让它们不断循环。

```swift
// 执行一次
options: .nonRepeating,
// 执行 5 次，期间每次 delay 1 秒
options: .repeat(.periodic(5, delay: 1)),
// 持续重复，支持时采用连续动画
options: .repeat(.continuous),
// 调整速度
options: .speed(1),
```

我们的 `Dis/Appear`、`DrawOn/Off` 动画有两种形式，上文提到的 `Indefinite` 是不影响组件外部、只在符号组件内部更新画面的那种形式。还有另一种在执行过程中会影响到整体的布局，需要使用 `.transition` 来修饰的，这种属于 `Transition` 类型，遵循 `TransitionSymbolEffect`。还剩下 `Replace` 动画，单独属于 `Content Transition` 类型，遵循 `ContentTransitionSymbolEffect`。

![Protocols27](/Image/posts/sf-symbols-27-guide/Protocols27.png)

> 特别注意，iOS 18 之前  `bounce` 不支持 `Indefinite` 协议。

最后也别忘了无障碍体验：只有符号的按钮，也应该让 VoiceOver 能读出操作含义，例如“收藏”，而不是符号名称。对于持续旋转、缩放等效果，可以通过 SwiftUI 的 `accessibilityReduceMotion` 或 UIKit 的 `UIAccessibility.isReduceMotionEnabled` 检查“减少动态效果”设置，按需减少动画或提供静态状态提示。

## 符号的扩展

### 符号变体

对于某些符号来说，有多种表现形式，我们以 `heart` 这个符号为例子，他有许多种变体：

![Variants](/Image/posts/sf-symbols-27-guide/Variants.png)

如果我们想要使用 `heart.circle.fill` 这个符号，除了通过字符串拼接名称的方式，我们还可以通过 `.symbolVariant` 来实现，这种实现方式有助于在代码中统一符号的风格。

```swift
// SwiftUI
Label("Heart", systemImage: "heart")
    .symbolVariant(.circle.fill)

// UIKit
// 以前 WWDC21 演示过 imageVariant 属性，可以用来指定符号变体，
// 但现在的 SDK 中已经找不到 UIImageView.imageVariant 这个公开属性了。
```

系统组件会在某些场景中通过环境自动指定符号变体。例如在 SwiftUI 的 `TabView` 标签栏中，即使你写的是 `heart`，也会自动使用对应的 `.fill` 变体，`swipeActions` 中的符号也有类似行为，因此通常不需要手动拼接 `.fill`，这是 [SymbolVariants](https://developer.apple.com/documentation/swiftui/symbolvariants) 的环境机制。

### 本地化

从 SF Symbols 3 开始，许多符号为特定语言和书写系统提供了很多本地化变体，当设备语言更改时，特定于语言和文字的变体会自动随之变化。

![Localized](/Image/posts/sf-symbols-27-guide/Localized.png)

### Symbol Components

SF Symbols 在定制化方面还有一个强大功能，那就是 Symbol Components。这个功能可以把基于可变模板的自定义符号与组件库中的外框、徽标、斜线等组件组合，让你的符号以各种你熟悉的形态加入到 app 中，来适配 macOS、iOS 以及你所需要的界面风格。通过这个方式生成的新符号，系统会自动地帮你设置好需要 Erase 的图层，并处理相应的渲染和动画行为，以及不同字重和比例下的表现，非常方便。

同时你需要注意的是，通过这个方式生成的符号，不能再导出可编辑模板来手动修改路径和图层，但仍然可以在 App 中调整徽标的位置、斜线的长度、内部符号的尺寸等细节。组合后的符号也支持 `replace` 动画下的 `MagicReplace` 效果，在相关符号之间切换时，可以保留相同的部分。

下图用几个熟悉的符号来示意这种组合关系，实际使用时，需要将自定义符号与组件库中提供的组件组合，并不是任意两个系统符号都可以直接相加。

![Component](/Image/posts/sf-symbols-27-guide/Component.png)

### 系统版本兼容

SF Symbols App 的版本、符号本身的可用版本和功能 API 的系统要求，需要分开看。下载了最新版 App，并不代表旧系统也能使用其中的所有符号和效果。本文主要动画和新功能的最低系统要求如下：

| 功能 | iOS / iPadOS | macOS |
| --- | --- | --- |
| Bounce、Scale、Pulse、Variable Color 动画、Appear / Disappear、Replace | 17 | 14 |
| Wiggle、Rotate、Breathe、Magic Replace、新版 RepeatBehavior | 18 | 15 |
| DrawOn / DrawOff、可变绘制、渐变效果 | 26 | 26 |

这里的版本指功能 API，具体符号及其效果支持仍需单独确认。使用前可以在 SF Symbols App 的信息面板中查看符号的可用版本；兼容旧系统时，通过 `#available` 判断新 API，并为不可用的符号准备旧符号或图片作为替代。

另外，同一个符号在不同版本中也可能使用不同的名称。例如麦克风符号，旧名称是 `mic`，新名称 `microphone` 从 iOS 18 / macOS 15 开始可用，兼容更早的系统时需要使用 `mic`。如果从最新版 SF Symbols App 复制的名称在旧系统上无法显示，不一定是这个符号不存在，也可能只是名称不同，需要核对目标系统支持的旧名称。更多说明可以参考[官方文档](https://developer.apple.com/documentation/uikit/configuring-and-displaying-symbol-images-in-your-ui)。
