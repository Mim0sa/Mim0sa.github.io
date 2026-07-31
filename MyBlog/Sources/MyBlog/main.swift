import Foundation
import HighlightJSPublishPlugin
import Publish
import Plot

// This type acts as the configuration for your website.
struct MyBlog: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case posts
        case archive
        case about
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
    }

    var url = URL(string: "https://mim0sa.github.io")!
    var name = "Mim0sa's Blog"
    var description = "记录 iOS、Swift 与游戏开发，也记录生活里的折腾。"
    var language: Language { .simplifiedChinese }
    var imagePath: Path? { Path("Image/hey.png") }
    var favicon: Favicon? { Favicon(path: "Image/hey.png") }
    var tagHTMLConfig: TagHTMLConfiguration? { nil }
}

try MyBlog().publish(
    withTheme: .mimosa,
    additionalSteps: [
        .renderMarkdownAfterMoreSeparators(),
        .addPostPaginationPages()
    ],
    plugins: [.highlightJS()]
)
