import XCTest
@testable import LiquidGlassBottomAccessoryExample

final class BottomAccessoryReferenceTests: XCTestCase {
    func testReferenceFactsDescribeTheOfficialBottomAccessoryBehavior() {
        XCTAssertEqual(BottomAccessoryReference.articleURL.absoluteString, "https://www.createwithswift.com/enhancing-the-tab-bar-with-a-bottom-accessory/")
        XCTAssertEqual(BottomAccessoryReference.minimizeBehavior, "onScrollDown")
        XCTAssertEqual(BottomAccessoryReference.expandedPlacementSummary, "above tab bar")
        XCTAssertEqual(BottomAccessoryReference.inlinePlacementSummary, "inside minimized tab bar row")
    }

    func testDemoTabsMatchArticleShape() {
        XCTAssertEqual(DemoTab.allCases.map(\.title), ["Home", "Alerts", "Favorites", "Search"])
        XCTAssertTrue(DemoTab.search.usesSearchRole)
    }

    func testUIKitGlassDockExampleMatchesQuotaLensFinalGeometry() throws {
        let source = try String(contentsOf: exampleSourceURL(), encoding: .utf8)

        XCTAssertTrue(source.contains("static let actionButtonSize: CGFloat = 58"))
        XCTAssertTrue(source.contains("static let controlHeight: CGFloat = 58"))
        XCTAssertTrue(source.contains("static let segmentedControlMinimumWidth: CGFloat = 222"))
        XCTAssertTrue(source.contains("static let dockSpacing: CGFloat = 6"))
        XCTAssertTrue(source.contains("static let maximumDockWidth: CGFloat = 350"))
        XCTAssertTrue(source.contains("final class UIKitGlassActionControl: UIControl"))
        XCTAssertTrue(source.contains("UIGlassEffect(style: .regular)"))
        XCTAssertTrue(source.contains("UISegmentedControl"))
        XCTAssertTrue(source.contains(".glassEffect(.regular.interactive(), in: .capsule)"))
        XCTAssertFalse(source.contains("UITabBar"))
    }

    private func exampleSourceURL() throws -> URL {
        let testURL = URL(fileURLWithPath: #filePath)
        let projectRoot = testURL.deletingLastPathComponent().deletingLastPathComponent()
        let sourceURL = projectRoot.appendingPathComponent("LiquidGlassBottomAccessoryExample/Features/UIKitGlassDockExampleView.swift")

        if !FileManager.default.fileExists(atPath: sourceURL.path) {
            XCTFail("UIKitGlassDockExampleView.swift is missing at \(sourceURL.path)")
        }

        return sourceURL
    }
}
