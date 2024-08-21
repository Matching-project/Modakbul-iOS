import ProjectDescription

let project = Project(
    name: "Modakbul",
    targets: [
        .target(
            name: "Modakbul",
            destinations: [.iPhone, .iPad],
            product: .app,
            bundleId: "com.team.Modakbul",
            deploymentTargets: .iOS("16.0"),
            infoPlist: "Modakbul/Info.plist",
            sources: ["Modakbul/Sources/**"],
            resources: ["Modakbul/Resources/**"],
            dependencies: [
                .external(name: "KakaoSDKCommon"),
                .external(name: "KakaoSDKAuth"),
                .external(name: "KakaoSDKUser"),
                .external(name: "Moya")
            ],
            settings: .settings(configurations: [
               .debug(name: "Debug", xcconfig: "./xcconfigs/Modakbul.xcconfig"),
               .release(name: "Release", xcconfig: "./xcconfigs/Modakbul.xcconfig"),
           ])
        ),
        .target(
            name: "ModakbulTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.team.ModakbulTests",
            infoPlist: .default,
            sources: ["Modakbul/Tests/**"],
            resources: [],
            dependencies: [.target(name: "Modakbul")]
        ),
    ]
)
