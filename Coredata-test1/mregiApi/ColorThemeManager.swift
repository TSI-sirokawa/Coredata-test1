//
//  ColorThemeManager.swift
//  mReji
//
//  Created by Matsuoka Yuri on 2024/03/26.
//

import SwiftUI

class ColorThemeManager: ObservableObject {
    static let shared = ColorThemeManager()

    enum Theme: String {
        case `default`
        case monochrome

        static func get(strVal: String?) -> Theme? {
            return if let strVal {
                Theme(rawValue: strVal)
            } else {
                nil
            }
        }

        func toLabel() -> String {
            switch self {
            case .default: "デフォルト"
            case .monochrome: "モノクロ"
            }
        }

        func mainColor() -> SwiftUI.Color {
            switch self {
            case .default: .gray //Asset.Colors.PrimaryTheme.swiftUIColor
            case .monochrome: .black
            }
        }

        func textColor() -> SwiftUI.Color {
            switch self {
            case .default: .gray //Asset.Colors.TextTheme.swiftUIColor
            case .monochrome: .white
            }
        }
    }

    private(set) var currentTheme = Theme.get(strVal: PermanentDataManager.load(type: .colorTheme) as? String) ?? .default

    func changeTheme(_ theme: Theme) {
        PermanentDataManager.save(type: .colorTheme, data: theme.rawValue)
        currentTheme = theme
    }

    // MARK: - テーマ色
    var primary: SwiftUI.Color {
        switch currentTheme {
        case .default: .gray //Asset.Colors.PrimaryTheme.swiftUIColor
        case .monochrome: .black
        }
    }

    var sub: SwiftUI.Color {
        switch currentTheme {
        case .default: .gray //Asset.Colors.SubTheme.swiftUIColor
        case .monochrome: .gray
        }
    }

    var text: SwiftUI.Color {
        switch currentTheme {
        case .default: .gray //Asset.Colors.TextTheme.swiftUIColor
        case .monochrome: .white
        }
    }

    var bg: SwiftUI.Color {
        switch currentTheme {
        case .default: .gray //Asset.Colors.BgTheme.swiftUIColor
        case .monochrome: .white
        }
    }

    var bgSecondary: SwiftUI.Color {
        switch currentTheme {
        case .default: .gray //Asset.Colors.BgSecondaryTheme.swiftUIColor
        case .monochrome: .gray
        }
    }

    var bgMenu: SwiftUI.Color {
        switch currentTheme {
        case .default: .gray //Asset.Colors.BgMenuTheme.swiftUIColor
        case .monochrome: .gray
        }
    }

    var bgOn: SwiftUI.Color {
        switch currentTheme {
        case .default: .gray //Asset.Colors.BgOnTheme.swiftUIColor
        case .monochrome: .gray
        }
    }

    var border: SwiftUI.Color {
        switch currentTheme {
        case .default: .gray //Asset.Colors.BorderTheme.swiftUIColor
        case .monochrome: .black
        }
    }

    var borderOn: SwiftUI.Color {
        switch currentTheme {
        case .default: .gray //Asset.Colors.BorderOnTheme.swiftUIColor
        case .monochrome: .black
        }
    }

    var bgHeader: SwiftUI.Image {
        switch currentTheme {
        case .default: Image(systemName: "1.square.fill")
        case .monochrome: Image(systemName: "1.square.fill")
        }
    }

    var bgTertiary: SwiftUI.Color {
        switch currentTheme {
        case .default: .gray //Asset.Colors.BgTertiaryTheme.swiftUIColor
        case .monochrome: .black
        }
    }

    // MARK: - 固定色
    struct Constant {
        static let textAttention = Color.black //Asset.Colors.TextAttention.swiftUIColor
        static let textSecondary = Color.black //Asset.Colors.TextSecondary.swiftUIColor
        static let textTertiary = Color.black //Asset.Colors.TextTertiary.swiftUIColor
        static let bgMain = Color.gray //Asset.Colors.BgMain.swiftUIColor
        static let bgSecondary = Color.gray //Asset.Colors.BgSecondary.swiftUIColor
        static let bgMenu = Color.gray //Asset.Colors.BgMenu.swiftUIColor
        static let borderSecondary = Color.gray //Asset.Colors.BorderSecondary.swiftUIColor
        static let border = Color.gray //Asset.Colors.Border.swiftUIColor
        static let bgError = Color.gray //Asset.Colors.BgError.swiftUIColor
    }
}
