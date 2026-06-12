# LiquidGlassBottomAccessoryExample

A minimal iOS 26 SwiftUI sample for the official `TabView` bottom accessory API:

- `tabViewBottomAccessory { ... }`
- `tabBarMinimizeBehavior(.onScrollDown)`
- `@Environment(\.tabViewBottomAccessoryPlacement)`
- `Tab(..., role: .search)` in the same shape as the reference article

Reference article: <https://www.createwithswift.com/enhancing-the-tab-bar-with-a-bottom-accessory/>

## What This Demonstrates

`tabViewBottomAccessory` adds a persistent accessory above the tab bar while the tab bar is expanded. When paired with `.tabBarMinimizeBehavior(.onScrollDown)`, scrolling down lets the system collapse the tab bar and move the accessory into an inline placement with the minimized tab row.

This is useful for compact persistent controls such as a now-playing strip, sync status, or lightweight contextual action.

## What This Does Not Demonstrate

This API does not create arbitrary always-inline action buttons at the leading and trailing edges of the expanded tab bar. If an app needs permanent custom actions in the same expanded row as normal tabs, that is a different interaction model and usually needs either:

- ordinary `Tab` items with custom selection routing, or
- a custom bottom bar that accepts the loss of some system `TabView` behavior.

## Run

```sh
/opt/homebrew/bin/xcodegen generate
```

Open `LiquidGlassBottomAccessoryExample.xcodeproj`, or build with XcodeBuildMCP / `xcodebuild`.

## Public Repository Notes

This folder is ready to publish as a public GitHub repository:

```sh
git init
git add .
git commit -m "Add Liquid Glass bottom accessory sample"
gh repo create LiquidGlassBottomAccessoryExample --public --source=. --remote=origin --push
```

Keep the repo small and focused so other agents can copy the `DemoRootView` pattern directly.
