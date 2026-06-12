import SwiftUI
import UIKit

enum UIKitDockVisualSpec {
    static let actionButtonSize: CGFloat = 58
    static let controlHeight: CGFloat = 58
    static let segmentedControlMinimumWidth: CGFloat = 222
    static let dockSpacing: CGFloat = 6
    static let maximumDockWidth: CGFloat = 350
}

enum UIKitDockTab: String, CaseIterable, Identifiable, Hashable {
    case today
    case insights
    case settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .today: "Today"
        case .insights: "Insights"
        case .settings: "Settings"
        }
    }

    var symbolName: String {
        switch self {
        case .today: "gauge.with.dots.needle.67percent"
        case .insights: "chart.line.uptrend.xyaxis"
        case .settings: "gearshape"
        }
    }
}

enum UIKitGlassDockReference {
    static let summary = "Custom leading/trailing UIGlassEffect buttons with a centered UISegmentedControl glass capsule."
    static let note = "Use this pattern when a brand dock needs side actions and a segmented tab control in one aligned row."
}

struct ExampleCatalogView: View {
    enum Example: String, CaseIterable, Identifiable {
        case uikitDock
        case bottomAccessory

        var id: Self { self }

        var title: String {
            switch self {
            case .uikitDock: "UIKit Dock"
            case .bottomAccessory: "System Accessory"
            }
        }
    }

    @State private var selectedExample: Example = .uikitDock

    var body: some View {
        VStack(spacing: 0) {
            Picker("Example", selection: $selectedExample) {
                ForEach(Example.allCases) { example in
                    Text(example.title).tag(example)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            switch selectedExample {
            case .uikitDock:
                UIKitGlassDockExampleView()
            case .bottomAccessory:
                DemoRootView()
            }
        }
    }
}

struct UIKitGlassDockExampleView: View {
    @State private var selectedTab: UIKitDockTab = .today
    @State private var addCount = 0
    @State private var refreshCount = 0

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    header
                    stats
                    rows
                }
                .padding(.horizontal, 18)
                .padding(.top, 18)
                .padding(.bottom, 110)
            }
            .background(UIKitGlassDockBackground())
            .navigationTitle(selectedTab.title)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                UIKitGlassDock(
                    selectedTab: $selectedTab,
                    onAdd: { addCount += 1 },
                    onRefresh: { refreshCount += 1 }
                )
                .padding(.horizontal, 10)
                .padding(.top, 8)
                .padding(.bottom, 8)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(selectedTab.title, systemImage: selectedTab.symbolName)
                .font(.largeTitle.bold())
            Text(UIKitGlassDockReference.summary)
                .font(.callout)
                .foregroundStyle(.secondary)
            Text("Add taps \(addCount) · refresh taps \(refreshCount)")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.teal)
                .contentTransition(.numericText())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .glassEffect(.regular, in: .rect(cornerRadius: 24))
    }

    private var stats: some View {
        HStack(spacing: 10) {
            UIKitDockMetric(value: "58pt", title: "row height")
            UIKitDockMetric(value: "222pt", title: "middle min")
            UIKitDockMetric(value: "350pt", title: "max width")
        }
    }

    private var rows: some View {
        LazyVStack(spacing: 12) {
            ForEach(1...14, id: \.self) { index in
                HStack(spacing: 12) {
                    Image(systemName: selectedTab.symbolName)
                        .font(.headline.weight(.semibold))
                        .frame(width: 38, height: 38)
                        .glassEffect(.regular, in: .circle)
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Dock sample row \(index)")
                            .font(.headline)
                        Text(UIKitGlassDockReference.note)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                    Spacer()
                }
                .padding(14)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
        }
    }
}

private struct UIKitGlassDock: View {
    @Binding var selectedTab: UIKitDockTab
    var onAdd: () -> Void
    var onRefresh: () -> Void

    var body: some View {
        GlassEffectContainer(spacing: UIKitDockVisualSpec.dockSpacing) {
            HStack(alignment: .center, spacing: UIKitDockVisualSpec.dockSpacing) {
                dockActionButton(symbol: "plus", label: "Add item", action: onAdd)

                UIKitSegmentedDockControl(selectedTab: $selectedTab)
                    .frame(height: UIKitDockVisualSpec.controlHeight)
                    .frame(minWidth: UIKitDockVisualSpec.segmentedControlMinimumWidth, maxWidth: .infinity)
                    .glassEffect(.regular.interactive(), in: .capsule)

                dockActionButton(symbol: "arrow.clockwise", label: "Refresh", action: onRefresh)
            }
            .frame(maxWidth: UIKitDockVisualSpec.maximumDockWidth, alignment: .center)
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }

    private func dockActionButton(symbol: String, label: String, action: @escaping () -> Void) -> some View {
        UIKitGlassActionButton(symbolName: symbol, accessibilityLabel: label, action: action)
            .frame(width: UIKitDockVisualSpec.actionButtonSize, height: UIKitDockVisualSpec.actionButtonSize)
    }
}

struct UIKitGlassActionButton: UIViewRepresentable {
    let symbolName: String
    let accessibilityLabel: String
    let action: () -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(action: action)
    }

    func makeUIView(context: Context) -> UIKitGlassActionControl {
        let control = UIKitGlassActionControl()
        control.configure(symbolName: symbolName, accessibilityLabel: accessibilityLabel)
        control.addTarget(context.coordinator, action: #selector(Coordinator.performAction), for: .touchUpInside)
        return control
    }

    func updateUIView(_ control: UIKitGlassActionControl, context: Context) {
        context.coordinator.action = action
        control.configure(symbolName: symbolName, accessibilityLabel: accessibilityLabel)
    }

    @MainActor
    final class Coordinator: NSObject {
        var action: () -> Void

        init(action: @escaping () -> Void) {
            self.action = action
        }

        @objc
        func performAction() {
            action()
        }
    }
}

final class UIKitGlassActionControl: UIControl {
    private let effectView = UIVisualEffectView()
    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        effectView.layer.cornerRadius = bounds.width / 2
        effectView.layer.cornerCurve = .continuous
        effectView.clipsToBounds = true
    }

    func configure(symbolName: String, accessibilityLabel: String) {
        imageView.image = UIImage(systemName: symbolName)
        self.accessibilityLabel = accessibilityLabel
    }

    private func setup() {
        isAccessibilityElement = true
        accessibilityTraits = [.button]
        backgroundColor = .clear

        let effect = UIGlassEffect(style: .regular)
        effect.isInteractive = true
        effect.tintColor = UIColor.systemBackground.withAlphaComponent(0.22)
        effectView.effect = effect
        effectView.isUserInteractionEnabled = false
        effectView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(effectView)

        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 25, weight: .semibold)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        effectView.contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            effectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            effectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            effectView.topAnchor.constraint(equalTo: topAnchor),
            effectView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.centerXAnchor.constraint(equalTo: effectView.contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: effectView.contentView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 28),
            imageView.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
}

struct UIKitSegmentedDockControl: UIViewRepresentable {
    @Binding var selectedTab: UIKitDockTab

    func makeCoordinator() -> Coordinator {
        Coordinator(selectedTab: $selectedTab)
    }

    func makeUIView(context: Context) -> UISegmentedControl {
        let control = UIKitDockSegmentedControl(frame: .zero)

        UIKitDockTab.allCases.enumerated().forEach { index, tab in
            let image = UIKitDockSegmentImageFactory.image(for: tab)
            control.insertSegment(with: image, at: index, animated: false)
            control.setContentOffset(.zero, forSegmentAt: index)
        }

        control.selectedSegmentIndex = UIKitDockTabMapper.tag(for: selectedTab)
        control.addTarget(context.coordinator, action: #selector(Coordinator.segmentChanged(_:)), for: .valueChanged)
        control.heightAnchor.constraint(equalToConstant: UIKitDockVisualSpec.controlHeight).isActive = true
        control.apportionsSegmentWidthsByContent = false
        control.backgroundColor = .clear
        control.selectedSegmentTintColor = UIColor.systemBackground.withAlphaComponent(0.42)
        control.tintColor = UIColor.systemTeal
        control.layer.cornerRadius = UIKitDockVisualSpec.controlHeight / 2
        control.layer.cornerCurve = .continuous
        control.clipsToBounds = true

        return control
    }

    func updateUIView(_ control: UISegmentedControl, context: Context) {
        let selectedIndex = UIKitDockTabMapper.tag(for: selectedTab)
        if control.selectedSegmentIndex != selectedIndex {
            control.selectedSegmentIndex = selectedIndex
        }
    }

    @MainActor
    final class Coordinator: NSObject {
        private var selectedTab: Binding<UIKitDockTab>

        init(selectedTab: Binding<UIKitDockTab>) {
            self.selectedTab = selectedTab
        }

        @objc
        func segmentChanged(_ control: UISegmentedControl) {
            guard let tab = UIKitDockTabMapper.tab(for: control.selectedSegmentIndex) else {
                return
            }
            selectedTab.wrappedValue = tab
        }
    }
}

enum UIKitDockTabMapper {
    static func tag(for tab: UIKitDockTab) -> Int {
        UIKitDockTab.allCases.firstIndex(of: tab) ?? 0
    }

    static func tab(for index: Int) -> UIKitDockTab? {
        guard UIKitDockTab.allCases.indices.contains(index) else {
            return nil
        }
        return UIKitDockTab.allCases[index]
    }
}

final class UIKitDockSegmentedControl: UISegmentedControl {
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.height = UIKitDockVisualSpec.controlHeight
        return size
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        layer.cornerCurve = .continuous
        clipsToBounds = true
    }
}

enum UIKitDockSegmentImageFactory {
    static func image(for tab: UIKitDockTab) -> UIImage? {
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        let symbol = UIImage(systemName: tab.symbolName, withConfiguration: symbolConfiguration)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 11, weight: .medium),
            .foregroundColor: UIColor.label
        ]
        let title = NSAttributedString(string: tab.title, attributes: titleAttributes)
        let titleSize = title.size()
        let symbolSize = CGSize(width: 23, height: 23)
        let imageSize = CGSize(width: max(48, titleSize.width + 8), height: 43)
        let renderer = UIGraphicsImageRenderer(size: imageSize)

        let renderedImage = renderer.image { _ in
            let symbolRect = CGRect(
                x: (imageSize.width - symbolSize.width) / 2,
                y: 1,
                width: symbolSize.width,
                height: symbolSize.height
            )
            symbol?.withTintColor(.label, renderingMode: .alwaysOriginal).draw(in: symbolRect)

            let titleRect = CGRect(
                x: (imageSize.width - titleSize.width) / 2,
                y: symbolRect.maxY + 1,
                width: titleSize.width,
                height: titleSize.height
            )
            title.draw(in: titleRect)
        }

        return renderedImage.withRenderingMode(.alwaysOriginal)
    }
}

private struct UIKitDockMetric: View {
    let value: String
    let title: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.headline.weight(.bold))
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .glassEffect(.regular, in: .rect(cornerRadius: 18))
    }
}

private struct UIKitGlassDockBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color.teal.opacity(0.18),
                Color.blue.opacity(0.08),
                Color(.systemBackground)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

#Preview {
    UIKitGlassDockExampleView()
}
