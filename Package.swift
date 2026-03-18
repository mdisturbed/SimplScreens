// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SimplScreens",
    platforms: [.tvOS(.v17)],
    products: [
        .library(name: "SimplScreensKit", targets: ["SimplScreensKit"])
    ],
    targets: [
        .target(
            name: "SimplScreensKit",
            path: "Shared",
            sources: [
                "Models",
                "Services",
                "Utilities",
                "ViewModels"
            ]
        )
    ]
)
