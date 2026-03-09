//
//  UIColor+AppExtension.swift
//  AppUIKit
//  颜色清单
//  https://www.figma.com/design/Y4f4BwipaEUckWUUjKqnNh/MATTER-Finder-MVP?node-id=173586-35650&m=dev
//  Created by xxf on 2025/7/9.
//

#if canImport(UIKit)
import UIKit

public extension UIColor {

    static var accent: AppThemeAccentColor {
        return UIColorThemeColorPalette.shared.accent
    }

    static var brand: AppThemeBrandColor {
        return UIColorThemeColorPalette.shared.brand
    }

    static var neutral: AppThemeNeutralColor {
        return UIColorThemeColorPalette.shared.neutral
    }

    static var background: AppThemeBackgroundColor {
        return UIColorThemeColorPalette.shared.background
    }

    static var semantic: AppThemeSemanticColor {
        return UIColorThemeColorPalette.shared.semantic
    }
}
#elseif canImport(AppKit)
import AppKit

public extension NSColor {

    static var accent: AppThemeAccentColor {
        return UIColorThemeColorPalette.shared.accent
    }

    static var brand: AppThemeBrandColor {
        return UIColorThemeColorPalette.shared.brand
    }

    static var neutral: AppThemeNeutralColor {
        return UIColorThemeColorPalette.shared.neutral
    }

    static var background: AppThemeBackgroundColor {
        return UIColorThemeColorPalette.shared.background
    }

    static var semantic: AppThemeSemanticColor {
        return UIColorThemeColorPalette.shared.semantic
    }
}
#endif
