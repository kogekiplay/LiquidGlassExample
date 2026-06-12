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
}
