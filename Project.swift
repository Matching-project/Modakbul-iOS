import ProjectDescription

let project = Project(
    name: "Modakbul",
    targets: [
        .target(
            name: "Modakbul",
            destinations: [.iPhone, .iPad],
            product: .app,
            bundleId: "com.Modakbul",
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
            settings: .settings(
                base: ["CODE_SIGN_STYLE": "Manual"],
                configurations: [
                    .debug(name: "Debug",
                           settings: ["CODE_SIGN_IDENTITY": "iPhone Developer",
                                      "PROVISIONING_PROFILE_SPECIFIER": "Modakbul_Provisioning_Development"],
                           xcconfig: "./xcconfigs/Modakbul.xcconfig"),
                    .release(name: "Release",
                             settings: ["CODE_SIGN_IDENTITY": "iPhone Distribution",
                                        "PROVISIONING_PROFILE_SPECIFIER": "Modakbul_Provisioning_Distribution_AdHoc"],
                             xcconfig: "./xcconfigs/Modakbul.xcconfig"),
                ])
        ),
        .target(
            name: "ModakbulTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.ModakbulTests",
            infoPlist: .default,
            sources: ["Modakbul/Tests/**"],
            resources: [],
            dependencies: [.target(name: "Modakbul")]
        ),
    ]
)
