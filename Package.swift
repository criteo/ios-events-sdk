// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Criteo",
    products: [
        .library(
            name: "Criteo",
            type: .dynamic,
            targets: ["Criteo"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Criteo",
            dependencies: [],
            path: "Sources",
            // exclude: ["Criteo/Info.plist"],
            cSettings: [
                .headerSearchPath("Criteo/event"),
                .headerSearchPath("Criteo/event/serializer"),
                .headerSearchPath("Criteo/network"),
                .headerSearchPath("Criteo/product"),
                .headerSearchPath("Criteo/service"),
                .headerSearchPath("Criteo/util"),
            ]),
        // We can't import tests because both Nocilla (https://github.com/luisobo/Nocilla) and
        // OCMock (https://github.com/erikdoe/ocmock) does not supports Swift Package Manager.
        // .testTarget(
        //    name: "CriteoTests",
        //    dependencies: ["Criteo"],
        //    exclude: ["Tests/CriteoTests/Info.plist"])
    ]
)
