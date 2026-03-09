#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// 中性色主题协议（CGColor 版本）
/// 定义了黑白系列不同透明度的中性色接口，适用于 iOS 平台
public protocol AppThemeNeutralCGColor: AnyObject {
    // MARK: - 白色系（不同透明度）
    /// 纯白（100% 不透明）
    var white100: CGColor { get }
    /// 白色（90% 不透明）
    var white90: CGColor { get }
    /// 白色（60% 不透明）
    var white60: CGColor { get }
    /// 白色（40% 不透明）
    var white40: CGColor { get }
    /// 白色（20% 不透明，实际值 0.15）
    var white20: CGColor { get }
    /// 白色（10% 不透明）
    var white10: CGColor { get }
    /// 白色（6% 不透明）
    var white6: CGColor { get }

    // MARK: - 黑色系（不同透明度）
    /// 纯黑（100% 不透明）
    var black100: CGColor { get }
    /// 黑色（90% 不透明）
    var black90: CGColor { get }
    /// 黑色（60% 不透明）
    var black60: CGColor { get }
    /// 黑色（40% 不透明）
    var black40: CGColor { get }
    /// 黑色（20% 不透明）
    var black20: CGColor { get }
    /// 黑色（10% 不透明）
    var black10: CGColor { get }
    /// 黑色（6% 不透明）
    var black6: CGColor { get }
}

public final class CGNeutralColor: AppThemeNeutralCGColor {
    public lazy var white100 = CGColor.hex(0xFFFFFF)
    public lazy var white90 = CGColor.hex(0xFFFFFF, alpha: 0.9)
    public lazy var white60 = CGColor.hex(0xFFFFFF, alpha: 0.6)
    public lazy var white40 = CGColor.hex(0xFFFFFF, alpha: 0.3)
    public lazy var white20 = CGColor.hex(0xFFFFFF, alpha: 0.15)
    public lazy var white10 = CGColor.hex(0xFFFFFF, alpha: 0.10)
    public lazy var white6 = CGColor.hex(0xFFFFFF, alpha: 0.06)
    public lazy var black100 = CGColor.hex(0x000000)
    public lazy var black90 = CGColor.hex(0x000000, alpha: 0.9)
    public lazy var black60 = CGColor.hex(0x000000, alpha: 0.6)
    public lazy var black40 = CGColor.hex(0x000000, alpha: 0.4)
    public lazy var black20 = CGColor.hex(0x000000, alpha: 0.2)
    public lazy var black10 = CGColor.hex(0x000000, alpha: 0.1)
    public lazy var black6 = CGColor.hex(0x000000, alpha: 0.06)
}

