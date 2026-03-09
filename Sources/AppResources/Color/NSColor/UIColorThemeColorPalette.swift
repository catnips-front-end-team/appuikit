#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public final class UIColorThemeColorPalette: @unchecked Sendable {
    public static let shared = UIColorThemeColorPalette()

    private init() {}

    public lazy var brand: AppThemeBrandColor = UIColorBrandColor()
    public lazy var neutral: AppThemeNeutralColor = UIColorNeutralColor()
    public lazy var background: AppThemeBackgroundColor = UIColorBackgroundColor()
    public lazy var accent: AppThemeAccentColor = UIColorAccentColor()
    public lazy var semantic: AppThemeSemanticColor = UIColorSemanticColor()
}

