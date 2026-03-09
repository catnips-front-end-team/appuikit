#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public final class CGColorThemeCGColorPalette: @unchecked Sendable {
    public static let shared = CGColorThemeCGColorPalette()

    private init() {}

    public lazy var brand: AppThemeBrandCGColor = CGBrandColor()
    public lazy var neutral: AppThemeNeutralCGColor = CGNeutralColor()
    public lazy var background: AppThemeBackgroundCGColor = CGBackgroundColor()
    public lazy var accent: AppThemeAccentCGColor = CGAccentColor()
    public lazy var semantic: AppThemeSemanticCGColor = CGSemanticColor()
}

