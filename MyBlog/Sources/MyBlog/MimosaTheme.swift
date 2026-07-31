/**
*  Mimosa Theme
*/

import Foundation
import Publish
import Plot

public extension Theme {
    static var mimosa: Self {
        Theme(
            htmlFactory: FoundationHTMLFactory(),
            resourcePaths: [
                "Resources/MimosaTheme/mimosa.css",
                "Resources/MimosaTheme/archive.js",
                "Resources/MimosaTheme/theme.js"
            ]
        )
    }
}

enum MimosaPagination {
    static let itemsPerPage = 8

    static func pageCount(for itemCount: Int) -> Int {
        max(1, (itemCount + itemsPerPage - 1) / itemsPerPage)
    }
}

extension PublishingStep where Site == MyBlog {
    static func renderMarkdownAfterMoreSeparators() -> Self {
        .step(named: "Render Markdown after more separators") { context in
            let parser = context.markdownParser

            context.sections[.posts].mutateItems { item in
                let html = item.content.body.html

                // Ink treats a standalone HTML comment as a raw HTML block,
                // so parse the Markdown tail again while retaining the marker.
                guard let separatorRange = html.range(
                    of: "<!--more-->"
                ) else {
                    return
                }

                let excerptHTML = String(html[..<separatorRange.lowerBound])
                let remainingMarkdown = String(
                    html[separatorRange.upperBound...]
                )
                let remainingHTML = parser.html(from: remainingMarkdown)

                item.content.body = Content.Body(
                    html: excerptHTML + "<!--more-->" + remainingHTML
                )
            }
        }
    }

    static func addPostPaginationPages() -> Self {
        .step(named: "Add post pagination pages") { context in
            let itemCount = context.sections[.posts].items.count
            let pageCount = MimosaPagination.pageCount(for: itemCount)

            guard pageCount > 1 else {
                return
            }

            for pageNumber in 2...pageCount {
                context.addPage(
                    Page(
                        path: Path("posts/page/\(pageNumber)"),
                        content: Content(
                            title: "文章 · 第 \(pageNumber) 页"
                        )
                    )
                )
            }
        }
    }
}

private struct FoundationHTMLFactory<Site: Website>: HTMLFactory {
    func makeIndexHTML(for index: Index,
                       context: PublishingContext<Site>) throws -> HTML {
        var headIndex = index
        headIndex.title = ""

        let items = context.allItems(
            sortedBy: \.date,
            order: .descending
        )
        let postsSectionID = Site.SectionID.allCases.first {
            $0.rawValue == MyBlog.SectionID.posts.rawValue
        }

        return HTML(
            .lang(context.site.language),
            .head(
                for: headIndex,
                on: context.site,
                stylesheetPaths: ["/mimosa.css"]
            ),
            .body {
                ThemeScript()
                SiteHeader(
                    context: context,
                    selectedSelectionID: postsSectionID
                )
                Wrapper {
                    ItemList(
                        items: itemsForPage(1, from: items)
                    )
                    PostPagination(
                        currentPage: 1,
                        totalPages: MimosaPagination.pageCount(
                            for: items.count
                        )
                    )
                }
                SiteFooter()
            }
        )
    }

    func makeSectionHTML(for section: Section<Site>,
                         context: PublishingContext<Site>) throws -> HTML {
        let sectionID = section.id as! MyBlog.SectionID

        return HTML(
            .lang(context.site.language),
            .head(
                for: section,
                on: context.site,
                stylesheetPaths: ["/mimosa.css"]
            ),
            .body {
                ThemeScript()
                SiteHeader(context: context, selectedSelectionID: section.id)
                Wrapper {
                    if sectionID != .posts {
                        H1(section.title)
                    }
                    if !section.body.isEmpty {
                        Div(section.body)
                            .class(
                                sectionID == .about
                                    ? "content about-content"
                                    : "section-description"
                            )
                    }

                    switch sectionID {
                    case .archive:
                        ArchiveFilter(
                            items: context.allItems(
                                sortedBy: \.date,
                                order: .descending
                            )
                        )
                        ArchiveList(
                            items: context.allItems(
                                sortedBy: \.date,
                                order: .descending
                            )
                        )
                    case .posts:
                        ItemList(
                            items: itemsForPage(1, from: section.items)
                        )
                        PostPagination(
                            currentPage: 1,
                            totalPages: MimosaPagination.pageCount(
                                for: section.items.count
                            )
                        )
                    case .about:
                        EmptyComponent()
                    }
                }
                if sectionID == .archive {
                    Node<HTML.BodyContext>.script(
                        .src("/archive.js"),
                        .defer()
                    )
                }
                SiteFooter()
            }
        )
    }

    func makeItemHTML(for item: Item<Site>,
                      context: PublishingContext<Site>) throws -> HTML {
        return HTML(
            .lang(context.site.language),
            .head(
                for: item,
                on: context.site,
                stylesheetPaths: ["/mimosa.css"]
            ),
                .body(
                    .class("item-page"),
                    .components {
                    ThemeScript()
                    SiteHeader(context: context, selectedSelectionID: item.sectionID)
                    Wrapper {
                        Article {
                            Div {
                                Paragraph(formattedArticleDate(item.date))
                                    .class("article-date")
                                H1(item.title)
                                if !item.tags.isEmpty {
                                    ItemTagList(item: item)
                                }
                            }
                            .class("article-header")
                            Div(item.content.body).class("content")
                        }
                    }
                    SiteFooter()
                }
            )
        )
    }

    func makePageHTML(for page: Page,
                      context: PublishingContext<Site>) throws -> HTML {
        if let pageNumber = postPageNumber(from: page.path) {
            let items = context.allItems(
                sortedBy: \.date,
                order: .descending
            )
            let postsSectionID = Site.SectionID.allCases.first {
                $0.rawValue == MyBlog.SectionID.posts.rawValue
            }

            return HTML(
                .lang(context.site.language),
                .head(
                    for: page,
                    on: context.site,
                    stylesheetPaths: ["/mimosa.css"]
                ),
                .body {
                    ThemeScript()
                    SiteHeader(
                        context: context,
                        selectedSelectionID: postsSectionID
                    )
                    Wrapper {
                        ItemList(
                            items: itemsForPage(pageNumber, from: items)
                        )
                        PostPagination(
                            currentPage: pageNumber,
                            totalPages: MimosaPagination.pageCount(
                                for: items.count
                            )
                        )
                    }
                    SiteFooter()
                }
            )
        }

        return HTML(
            .lang(context.site.language),
            .head(
                for: page,
                on: context.site,
                stylesheetPaths: ["/mimosa.css"]
            ),
            .body {
                ThemeScript()
                SiteHeader(context: context, selectedSelectionID: nil)
                Wrapper(page.body)
                SiteFooter()
            }
        )
    }

    func makeTagListHTML(for page: TagListPage,
                         context: PublishingContext<Site>) throws -> HTML? {
        nil
    }

    func makeTagDetailsHTML(for page: TagDetailsPage,
                            context: PublishingContext<Site>) throws -> HTML? {
        nil
    }
}

private struct Wrapper: ComponentContainer {
    @ComponentBuilder var content: ContentProvider

    var body: Component {
        Div(content: content).class("wrapper")
    }
}

private struct ThemeScript: Component {
    var body: Component {
        Node<HTML.BodyContext>.script(.src("/theme.js"))
    }
}

private struct SiteHeader<Site: Website>: Component {
    var context: PublishingContext<Site>
    var selectedSelectionID: Site.SectionID?

    var body: Component {
        Header {
            Wrapper {
                Link(url: "/") {
                    Image(
                        url: "/Image/hey.png",
                        description: ""
                    )
                        .class("site-brand-mark")
                    Span(context.site.name)
                        .class("site-brand-name")
                }
                .class("site-brand")
                .attribute(
                    named: "aria-label",
                    value: "\(context.site.name) 首页"
                )

                Div {
                    if Site.SectionID.allCases.count > 1 {
                        navigation
                    }
                    ThemeToggle()
                }
                .class("header-actions")
            }
        }
    }

    private var navigation: Component {
        Navigation {
            List(Site.SectionID.allCases) { sectionID in
                let section = context.sections[sectionID]

                return Link(section.title,
                    url: section.path.absoluteString
                )
                .class(sectionID == selectedSelectionID ? "selected" : "")
            }
        }
        .class("headerNavigation")
    }
}

private struct ThemeToggle: Component {
    var body: Component {
        Button {
            Span {
                Node<HTML.BodyContext>.raw(
                    """
                    <svg viewBox="0 0 24 24" aria-hidden="true">
                        <circle cx="12" cy="12" r="4"></circle>
                        <path d="M12 2v2M12 20v2M4.93 4.93l1.42 1.42M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.42-1.42M17.66 6.34l1.41-1.41"></path>
                    </svg>
                    """
                )
            }
            .class("theme-icon theme-icon-sun")

            Span {
                Node<HTML.BodyContext>.raw(
                    """
                    <svg viewBox="0 0 24 24" aria-hidden="true">
                        <path d="M20.25 15.35A9 9 0 0 1 8.65 3.75a9 9 0 1 0 11.6 11.6Z"></path>
                    </svg>
                    """
                )
            }
            .class("theme-icon theme-icon-moon")
        }
        .class("theme-toggle")
        .attribute(named: "type", value: "button")
        .attribute(named: "aria-label", value: "切换显示模式")
        .attribute(named: "title", value: "切换显示模式")
    }
}

private struct ItemList<Site: Website>: Component {
    var items: [Item<Site>]

    var body: Component {
        List(items) { item in
            Article {
                Paragraph(formattedDate(item.date))
                    .class("item-date")
                H1(Link(item.title, url: item.path.absoluteString))

                let excerpt = excerptHTML(for: item)
                if !excerpt.isEmpty {
                    Div(Content.Body(html: excerpt))
                        .class("content item-excerpt")
                }

                if !item.tags.isEmpty {
                    ItemTagList(item: item)
                }
            }
            .class("item-row")
        }
        .class("item-list")
    }
}

private struct PostPagination: Component {
    var currentPage: Int
    var totalPages: Int

    var body: Component {
        guard totalPages > 1 else {
            return EmptyComponent()
        }

        return Navigation {
            paginationDirection(
                title: "上一页",
                pageNumber: currentPage - 1,
                isEnabled: currentPage > 1
            )

            List(Array(1...totalPages)) { pageNumber in
                if pageNumber == currentPage {
                    Span(String(pageNumber))
                        .class("pagination-page is-current")
                        .attribute(
                            named: "aria-current",
                            value: "page"
                        )
                } else {
                    Link(
                        String(pageNumber),
                        url: postPageURL(pageNumber)
                    )
                    .class("pagination-page")
                    .accessibilityLabel("第 \(pageNumber) 页")
                }
            }
            .class("pagination-pages")

            paginationDirection(
                title: "下一页",
                pageNumber: currentPage + 1,
                isEnabled: currentPage < totalPages
            )
        }
        .class("post-pagination")
        .accessibilityLabel("文章分页")
    }

    private func paginationDirection(
        title: String,
        pageNumber: Int,
        isEnabled: Bool
    ) -> Component {
        if isEnabled {
            return Link(title, url: postPageURL(pageNumber))
                .class("pagination-direction")
        }

        return Span(title)
            .class("pagination-direction is-disabled")
            .attribute(named: "aria-hidden", value: "true")
    }
}

private struct ArchiveList<Site: Website>: Component {
    var items: [Item<Site>]

    private var yearGroups: [ArchiveYearGroup<Site>] {
        let calendar = Calendar(identifier: .gregorian)
        let groupedItems = Dictionary(grouping: items) { item in
            calendar.component(.year, from: item.date)
        }

        return groupedItems
            .map {
            ArchiveYearGroup(
                year: $0.key,
                items: $0.value.sorted { $0.date > $1.date }
            )
        }
        .sorted { $0.year > $1.year }
    }

    var body: Component {
        List(yearGroups) { yearGroup in
            ListItem {
                Div {
                    H2(String(yearGroup.year))
                    List(yearGroup.items) { item in
                        ListItem {
                            Div {
                                Span(formattedArchiveDate(item.date))
                                    .class("archive-date")
                                Link(
                                    item.title,
                                    url: item.path.absoluteString
                                )
                            }
                            .class("archive-entry")
                        }
                        .data(named: "archive-item", value: "true")
                        .data(named: "tags", value: encodedTags(for: item))
                    }
                    .class("archive-entries")
                }
                .class("archive-year")
            }
            .data(named: "archive-year-group", value: "true")
        }
        .class("archive-list")
        .id("archive-results")
    }
}

private struct ArchiveFilter<Site: Website>: Component {
    var items: [Item<Site>]

    private var tagCounts: [ArchiveTagCount] {
        var counts = [String: Int]()

        for item in items {
            for tag in item.tags {
                counts[tag.string, default: 0] += 1
            }
        }

        return counts
            .map(ArchiveTagCount.init)
            .sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
    }

    var body: Component {
        Div {
            List {
                ListItem {
                    Button {
                        Span("全部")
                        Span(String(items.count))
                            .class("archive-filter-count")
                    }
                    .class("archive-filter-button is-active")
                    .attribute(named: "type", value: "button")
                    .attribute(named: "aria-pressed", value: "true")
                    .attribute(
                        named: "aria-controls",
                        value: "archive-results"
                    )
                }

                for tag in tagCounts {
                    ListItem {
                        Button {
                            Span(tag.name)
                            Span(String(tag.count))
                                .class("archive-filter-count")
                        }
                        .class("archive-filter-button")
                        .attribute(named: "type", value: "button")
                        .attribute(named: "aria-pressed", value: "false")
                        .attribute(
                            named: "aria-controls",
                            value: "archive-results"
                        )
                        .data(named: "tag", value: tag.name)
                        .data(named: "tag-key", value: archiveTagKey(tag.name))
                    }
                }
            }
            .class("archive-filter-options")

            Paragraph("全部 · \(items.count) 篇文章")
                .class("archive-filter-status")
                .id("archive-filter-status")
                .attribute(named: "aria-live", value: "polite")
        }
        .class("archive-filter")
        .id("archive-filter")
        .data(named: "archive-filter", value: "true")
        .accessibilityLabel("按标签筛选归档文章")
    }
}

private struct ArchiveTagCount {
    var name: String
    var count: Int

    init(key: String, value: Int) {
        name = key
        count = value
    }
}

private struct ArchiveYearGroup<Site: Website> {
    var year: Int
    var items: [Item<Site>]
}

private func encodedTags<Site: Website>(for item: Item<Site>) -> String {
    item.tags
        .map { archiveTagKey($0.string) }
        .joined(separator: ",")
}

private func archiveTagKey(_ tag: String) -> String {
    var allowedCharacters = CharacterSet.alphanumerics
    allowedCharacters.insert(charactersIn: "-_.")

    return tag.addingPercentEncoding(
        withAllowedCharacters: allowedCharacters
    ) ?? tag
}

private func itemsForPage<Site: Website>(
    _ pageNumber: Int,
    from items: [Item<Site>]
) -> [Item<Site>] {
    let startIndex = (pageNumber - 1) * MimosaPagination.itemsPerPage

    guard startIndex >= 0, startIndex < items.count else {
        return []
    }

    let endIndex = min(
        startIndex + MimosaPagination.itemsPerPage,
        items.count
    )
    return Array(items[startIndex..<endIndex])
}

private func excerptHTML<Site: Website>(for item: Item<Site>) -> String {
    let html = item.content.body.html

    guard let separatorRange = html.range(of: "<!--more-->") else {
        return ""
    }

    return String(html[..<separatorRange.lowerBound])
        .trimmingCharacters(in: .whitespacesAndNewlines)
}

private func postPageNumber(from path: Path) -> Int? {
    let components = path.string.split(separator: "/")

    guard components.count == 3,
          components[0] == "posts",
          components[1] == "page",
          let pageNumber = Int(components[2]),
          pageNumber > 1 else {
        return nil
    }

    return pageNumber
}

private func postPageURL(_ pageNumber: Int) -> String {
    pageNumber <= 1 ? "/posts/" : "/posts/page/\(pageNumber)/"
}

private func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy.MM.dd"
    return formatter.string(from: date)
}

private func formattedArticleDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy.MM.dd"
    return formatter.string(from: date)
}

private func formattedArchiveDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "MMM dd"
    return formatter.string(from: date)
}

private struct ItemTagList<Site: Website>: Component {
    var item: Item<Site>

    var body: Component {
        List(item.tags) { tag in
            Link(tag.string, url: archiveURL(for: tag))
        }
        .class("tag-list")
    }
}

private func archiveURL(for tag: Tag) -> String {
    var components = URLComponents()
    components.path = "/archive/"
    components.queryItems = [URLQueryItem(name: "tag", value: tag.string)]
    return components.string ?? "/archive/"
}

private struct SiteFooter: Component {
    var body: Component {
        Footer {
            Wrapper {
                Paragraph {
                    Text("使用 ")
                    Link("Publish", url: "https://github.com/johnsundell/publish")
                    Text(" 生成")
                }
                Paragraph {
                    Link("RSS 订阅", url: "/feed.rss")
                }
            }
        }
    }
}
