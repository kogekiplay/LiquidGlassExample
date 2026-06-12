# LiquidGlassExample

A focused iOS 26 sample repo for two Liquid Glass bottom-control patterns:

1. a UIKit-backed custom glass dock copied from the final QuotaLens prototype, and
2. the official SwiftUI `TabView` bottom accessory API.

## UIKit Glass Dock

Open `LiquidGlassBottomAccessoryExample/Features/UIKitGlassDockExampleView.swift`.

This sample demonstrates:

- custom left/right `UIControl` buttons backed by `UIGlassEffect(style: .regular)`
- a centered `UISegmentedControl` that renders icon + text into each segment
- a SwiftUI `.glassEffect(.regular.interactive(), in: .capsule)` wrapper so the middle control reads as one glass capsule
- fixed dock geometry from QuotaLens: `58pt` side buttons, `58pt` control height, `222pt` middle minimum width, `350pt` max dock width

Use this when you need side actions such as add/refresh while keeping a segmented tab control visually aligned in the same bottom row.

## System Bottom Accessory

Open `LiquidGlassBottomAccessoryExample/Features/DemoRootView.swift`.

This sample demonstrates the official APIs:

- `tabViewBottomAccessory { ... }`
- `tabBarMinimizeBehavior(.onScrollDown)`
- `@Environment(\.tabViewBottomAccessoryPlacement)`
- `Tab(..., role: .search)` in the same shape as the reference article

Reference article: <https://www.createwithswift.com/enhancing-the-tab-bar-with-a-bottom-accessory/>

## Notes

`tabViewBottomAccessory` adds a persistent accessory above the tab bar while the tab bar is expanded. When paired with `.tabBarMinimizeBehavior(.onScrollDown)`, scrolling down lets the system collapse the tab bar and move the accessory into an inline placement with the minimized tab row.

This API does not create arbitrary always-inline action buttons at the leading and trailing edges of the expanded tab bar. If an app needs permanent custom actions in the same expanded row as normal tabs, that is a different interaction model and usually needs either:

- ordinary `Tab` items with custom selection routing, or
- a custom bottom bar that accepts the loss of some system `TabView` behavior.

## Run

```sh
/opt/homebrew/bin/xcodegen generate
```

Open `LiquidGlassBottomAccessoryExample.xcodeproj`, or build with XcodeBuildMCP / `xcodebuild`.
