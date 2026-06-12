import SwiftUI

struct DemoRootView: View {
    @State private var selectedTab: DemoTab = .home
    @State private var accessoryTapCount = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(DemoTab.home.title, systemImage: DemoTab.home.symbol, value: DemoTab.home) {
                DemoTabContentView(tab: .home)
            }

            Tab(DemoTab.alerts.title, systemImage: DemoTab.alerts.symbol, value: DemoTab.alerts) {
                DemoTabContentView(tab: .alerts)
            }

            Tab(DemoTab.favorites.title, systemImage: DemoTab.favorites.symbol, value: DemoTab.favorites) {
                DemoTabContentView(tab: .favorites)
            }

            Tab(DemoTab.search.title, systemImage: DemoTab.search.symbol, value: DemoTab.search, role: .search) {
                NavigationStack {
                    DemoSearchView()
                }
            }
        }
        .tint(.teal)
        .tabBarMinimizeBehavior(.onScrollDown)
        .tabViewBottomAccessory {
            DemoBottomAccessoryView(
                selectedTab: selectedTab,
                tapCount: accessoryTapCount,
                onTap: { accessoryTapCount += 1 }
            )
        }
    }
}

private struct DemoTabContentView: View {
    let tab: DemoTab

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 14) {
                    DemoHeaderView(tab: tab)

                    ForEach(1...24, id: \.self) { index in
                        DemoCard(index: index, tab: tab)
                    }
                }
                .padding(.horizontal, 18)
                .padding(.top, 18)
                .padding(.bottom, 80)
            }
            .background(DemoBackground())
            .navigationTitle(tab.title)
        }
    }
}

private struct DemoHeaderView: View {
    let tab: DemoTab

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(tab.title, systemImage: tab.symbol)
                .font(.largeTitle.bold())

            Text("Scroll down to let the system minimize the tab bar. The bottom accessory starts above the tab bar, then moves inline with the minimized tab bar row.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .glassEffect(.regular, in: .rect(cornerRadius: 24))
    }
}

private struct DemoCard: View {
    let index: Int
    let tab: DemoTab

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: tab.symbol)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 42, height: 42)
                .background(.teal.gradient, in: Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text("Scrollable row \(index)")
                    .font(.headline)
                Text("The accessory placement changes only through the system tab bar behavior.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(16)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private struct DemoSearchView: View {
    @State private var query = ""

    var body: some View {
        List {
            Section("Search role tab") {
                Text("This tab uses role: .search, matching the article's shape.")
                Text("The bottom accessory remains attached to the tab view.")
            }
        }
        .searchable(text: $query)
        .navigationTitle("Search")
    }
}

private struct DemoBottomAccessoryView: View {
    @Environment(\.tabViewBottomAccessoryPlacement) private var placement

    let selectedTab: DemoTab
    let tapCount: Int
    var onTap: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "star.fill")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.yellow)

            VStack(alignment: .leading, spacing: 2) {
                Text("Bottom Accessory")
                    .font(.subheadline.weight(.semibold))
                Text("\(selectedTab.title) · \(String(describing: placement)) · taps \(tapCount)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .contentTransition(.numericText())
            }

            Spacer(minLength: 10)

            Button {
                onTap()
            } label: {
                Image(systemName: "arrow.clockwise")
                    .font(.body.weight(.semibold))
            }
            .buttonStyle(.glass)
            .accessibilityLabel("Refresh accessory")
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }
}

private struct DemoBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color.teal.opacity(0.18),
                Color.cyan.opacity(0.08),
                Color(.systemBackground)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

#Preview {
    DemoRootView()
}
