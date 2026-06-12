import Foundation

enum BottomAccessoryReference {
    static let articleURL = URL(string: "https://www.createwithswift.com/enhancing-the-tab-bar-with-a-bottom-accessory/")!
    static let minimizeBehavior = "onScrollDown"
    static let expandedPlacementSummary = "above tab bar"
    static let inlinePlacementSummary = "inside minimized tab bar row"
}

enum DemoTab: String, CaseIterable, Identifiable {
    case home
    case alerts
    case favorites
    case search

    var id: Self { self }

    var title: String {
        switch self {
        case .home: "Home"
        case .alerts: "Alerts"
        case .favorites: "Favorites"
        case .search: "Search"
        }
    }

    var symbol: String {
        switch self {
        case .home: "house"
        case .alerts: "bell"
        case .favorites: "heart.fill"
        case .search: "magnifyingglass"
        }
    }

    var usesSearchRole: Bool {
        self == .search
    }
}
