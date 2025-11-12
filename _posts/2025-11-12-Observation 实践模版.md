---
title: Observation 实践模版
tags: ["iOS"]
key: blog-2025-11-12
---

如何使用 `Observation`，实际上是很容易搜索到的内容，即使是在中文互联网，也能找到不少讲解清晰的 `Observation` 框架使用指南，原理剖析。但是问题出在 AI 不能很好的去实践 `Observation` 框架，我想肯定和之前推出的 `@ObservableObject`、`@StateObject` 等看起来有点类似的关键字有关，AI 有的时候能搞清楚两者区别，有的时候又会将两者混用，让人胆战心惊。

所以我在这边准备了一份给 AI 的 `Observation` 实践模版，在需要的时候，能让AI 更懂 `Observation`。

<!--more-->

> 每个项目的架构、每个人的代码风格不同，会导致模版代码有差异，请检查后使用

## 实践模版

##### 写在代码前

`Observation` 需要 iOS 17.0+ 支持，如需支持更早版本，有第三方库可以选择，例如：[ObservationBP](https://github.com/onevcat/ObservationBP)。

如果即将编写的代码，从结构上是分离，与其他部分没有过多耦合，那么可以只使用 `Observation` 框架，不使用 `@ObservableObject`、`@StateObject` 等关键字。

##### 具体如何使用 `Observation`

给类前面加一个 `@observable` 就可以让它可被观察：

```swift
@Observable class Blog {
    var title: String
    var author: String
  	var progress: Double = 0.0
    
    init(title: String, author: String) {
        self.title = title
        self.author = author
    }
}
```

在 SwiftUI 相关的 View 里直接使用：

```swift
struct BlogView: View {
    @State var blog = Blog(title: "溪云初起日沉阁", author: "Mim0sa")
    var body: some View {
        VStack {
            Text("Title: \(blog.title)")
            Text("Author: \(blog.author)")
        }
        .padding()
    }
}
```

通过直接传递的形式使用：

```swift
struct BlogView: View {
    @State var blog = Blog(title: "溪云初起日沉阁", author: "Mim0sa")
    var body: some View {
        DisplayView(blog: blog).padding()
    }
}

struct DisplayView: View {
    let blog: Blog
    var body: some View {
        VStack {
            Text("Title: \(blog.title)")
            Text("Author: \(blog.author)")
        }
    }
}
```

通过直接传递的形式使用，同时需要实现数据的绑定：

```swift
struct BlogView: View {
    @State var blog = Blog(title: "溪云初起日沉阁", author: "Mim0sa")
    var body: some View {
        VStack {
            Text("Title: \(blog.title)")
            Text("Author: \(blog.author)")
            Text("Progress: \(Int(blog.progress * 100))%")
            ControlView(blog: blog)
        }
        .padding()
    }
}

struct ControlView: View {
    @Bindable var blog: Blog
    var body: some View {
        VStack {
            Slider(value: $blog.progress, in: 0...1)
            Button("Change Blog Info") {
                blog.title = "山雨欲来风满楼"
                blog.author = "Mimoku"
            }
        }
    }
}
```

另一种通过传递的形式使用；可行，但性质变了，不推荐这样使用：

```swift
struct BlogView: View {
    @State var blog = Blog(title: "溪云初起日沉阁", author: "Mim0sa")
    var body: some View {
        VStack {
            Text("Title: \(blog.title)")
            Text("Author: \(blog.author)")
            Text("Progress: \(Int(blog.progress * 100))%")
            ControlView(blog: $blog)
        }
        .padding()
    }
}

struct ControlView: View {
    @Binding var blog: Blog
    var body: some View {
        VStack {
            Slider(value: $blog.progress, in: 0...1)
            Button("Change Blog Info") {
                blog.title = "山雨欲来风满楼"
                blog.author = "Mimoku"
            }
        }
    }
}
```

通过 enviroment 注入可观察对象，供 `@Enviroment` 来使用；注意 `@Bindable` 的绑定实现：

```swift
struct BlogView: View {
    @State var blog = Blog(title: "溪云初起日沉阁", author: "Mim0sa")
    var body: some View {
        VStack {
            Text("Title: \(blog.title)")
            Text("Author: \(blog.author)")
            Text("Progress: \(Int(blog.progress * 100))%")
            ControlView()
        }
        .padding()
        .environment(blog)
    }
}

struct ControlView: View {
    @Environment(Blog.self) var blog: Blog // 这里也可以是 Blog? 可选
    var body: some View {
        VStack {
            @Bindable var bindableBlog = blog
            Slider(value: $bindableBlog.progress, in: 0...1)
            Button("Change Blog Info") {
                blog.title = "山雨欲来风满楼"
                blog.author = "Mimoku"
            }
        }
    }
}
```

##### 如何与 `@AppStorage` 配合使用

实际上在原生上，并没有特别好的配合方案，所以约定按下方这样使用；请注意，通常情况下尽量让 `@AppStorage` 在 SwiftUI View 中直接声明，谨慎将其在类似 ViewModel 的组织中使用：

```swift
enum BlogAppStorageKeys: String {
    case lastOpenedBlogTitle
    case myFavoriteBlogAuthor
}

struct AnyBlogView: View {
    @AppStorage(BlogAppStorageKeys.lastOpenedBlogTitle.rawValue) var lastOpenedBlogTitle = ""
    @AppStorage(BlogAppStorageKeys.myFavoriteBlogAuthor.rawValue) var myFavoriteBlogAuthor = ""
    var body: some View {
        VStack {
            Text("Title: \(lastOpenedBlogTitle)")
            Text("Author: \(myFavoriteBlogAuthor)")
            Button("Update AppStorage Values") {
                lastOpenedBlogTitle = "山雨欲来风满楼"
                myFavoriteBlogAuthor = "Mim0sa"
            }
        }
        .padding()
    }
}
```

##### 不要这样做⚠️

在 `Observation` 框架之前，可能会有类似这样的数据传输形式，将数据拆分开，向下传递；在之前，这样的传递形式可以减少 View 的不必要更新次数；但是在 `Observation` 框架下不要这样写❌：

```swift
struct ContentView: View {
  @State var blog = Blog(title: "溪云初起日沉阁", author: "Mim0sa")
  var body: some View {
    TitleView(title: blog.title)
    AuthorView(author: blog.author)
  }
}

struct TitleView: View {
  let title: String
  var body: some View { Text(title) }
}

struct AuthorView: View {
  let author: String
  var body: some View { Text(author) }
}
```

✅正确的写法：

```swift
struct ContentView: View {
  @State var blog = Blog(title: "溪云初起日沉阁", author: "Mim0sa")
  var body: some View {
    TitleView(blog: blog)
    AuthorView(blog: blog)
  }
}

struct TitleView: View {
  @Bindable var blog: Blog
  var body: some View { Text(blog.title) }
}

struct AuthorView: View {
  @Bindable var blog: Blog
  var body: some View { Text(blog.author) }
}
```











