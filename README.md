# EasyAdMobBanner

EasyAdMobBanner is a SwiftUI wrapper for AdMob banner.
It simply make AdMob banner adjust its frame by adSize automatically.

If you think it's helpful, a coffee can help me keep work on it.

<a href="https://www.buymeacoffee.com/chenhaiteng"><img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=☕&slug=chenhaiteng&button_colour=FFDD00&font_colour=000000&font_family=Bree&outline_colour=000000&coffee_colour=ffffff" /></a>

## Installation:

The project is published with Swift Package Manager, and it depends on Google [Mobile Ads SDK(Swift Package Manager Version)](https://developers.google.com/admob/ios/quick-start#spm).

To avoid unexpected dependency issue, if your already installed [Mobile Ads SDK(CocoaPods)](https://developers.google.com/admob/ios/quick-start#cocoapods) for your project, it suggests to remove it, or use SPM version instead of.

If you still need CocoaPods version that can support **AdMob mediation**, you can install EasyAdMobBanner by duplicating the source code.

### Prerequisite:
Please ensure that you already setup Google Mobile Ads correctly.
Refer to [Get Started](https://developers.google.com/admob/ios/quick-start) for more detail.

### Add to Xcode(To use this package in your application):

1. File > Swift Packages > Add Package Dependency...
2. Choose Project you want to add EasyAdMobBanner
3. Paste repository https://github.com/chenhaiteng/EasyAdMobBanner.git
4. Rules > Version: Up to Next Major 1.0.0
It's can also apply Rules > Branch : main to access latest code.

> Note: It might need to link EasyAdMobBanner to your target maunally.
> 1. Open *Project Editor* by tap on root of project navigator
> 2. Choose the target you want to use EasyAdMobBanner.
> 3. Choose **Build Phases**, and expand **Link Binary With Libraries**
> 4. Tap on **+** button, and choose EasyAdMobBanner to add it.

### Add to SPM package(To use this package in your library/framework):
```swift
dependencies: [
    .package(url: "https://github.com/chenhaiteng/EasyAdMobBanner.git", from: "1.0.0")
    // To specify branch, use following statement to instead of.
    // .package(url: "https://github.com/chenhaiteng/EasyAdMobBanner.git", branch: "branch_name")
],
targets: [
    .target(
        name: "MyPackage",
        dependencies: ["EasyAdMobBanner"]),
]
```

## Use EasyAdMobBanner:

Just put the banner to where your want. No need to specify the width and height.

```swift

struct MyView: View {
    var body: some View {
        VStack {
            // Other contents
            Text("MyView")
            EasyAdMobBanner(ad_unit_id)
        }
    }
}

```
