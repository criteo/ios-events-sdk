// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Criteo",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Criteo",
            type: .dynamic,
            targets: ["Criteo"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Criteo",
            dependencies: [],
            path: "Sources/Criteo",
            // exclude: ["Criteo/Info.plist"],
            cSettings: [
                .headerSearchPath("event"),
                .headerSearchPath("event/serializer"),
                .headerSearchPath("network"),
                .headerSearchPath("product"),
                .headerSearchPath("service"),
                .headerSearchPath("util"),
            ]),
        // We can't import tests because both Nocilla (https://github.com/luisobo/Nocilla) and
        // OCMock (https://github.com/erikdoe/ocmock) does not supports Swift Package Manager.
        // .testTarget(
        //    name: "CriteoTests",
        //    dependencies: ["Criteo"],
        //    exclude: ["Tests/CriteoTests/Info.plist"])
    ]
)
