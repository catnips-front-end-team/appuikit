//
//  CGColor+AppExtension.swift
//  AppUIKit
//  颜色清单
//  https://www.figma.com/design/Y4f4BwipaEUckWUUjKqnNh/MATTER-Finder-MVP?node-id=173586-35650&m=dev
//  Created by xxf on 2025/7/9.
//

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public extension CGColor {

    static var accent: AppThemeAccentCGColor {
        return CGColorThemeCGColorPalette.shared.accent
    }

    static var brand: AppThemeBrandCGColor {
        return CGColorThemeCGColorPalette.shared.brand
    }

    static var neutral: AppThemeNeutralCGColor {
        return CGColorThemeCGColorPalette.shared.neutral
    }

    static var background: AppThemeBackgroundCGColor {
        return CGColorThemeCGColorPalette.shared.background
    }

    static var semantic: AppThemeSemanticCGColor {
        return CGColorThemeCGColorPalette.shared.semantic
    }
}
