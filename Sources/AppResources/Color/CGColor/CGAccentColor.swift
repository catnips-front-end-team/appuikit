#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// 强调色主题协议（CGColor 版本）
/// 定义了各种场景下的强调色接口，适用于 iOS 平台
public protocol AppThemeAccentCGColor: AnyObject {
    /// 天空蓝强调色
    var sky: CGColor { get }
    /// 紫罗兰强调色
    var violet: CGColor { get }
    /// 粉色强调色
    var pink: CGColor { get }
    /// 黄色强调色
    var yellow: CGColor { get }
    /// 橙色强调色
    var orange: CGColor { get }
    /// 珊瑚色强调色
    var coral: CGColor { get }
    /// 青色强调色
    var teal: CGColor { get }
}

extension CGColor {
    // 用16进制创建 CGColor
    static func hex(_ value: Int, alpha: CGFloat = 1.0) -> CGColor {
        let r = CGFloat((value >> 16) & 0xFF) / 255.0
        let g = CGFloat((value >> 8) & 0xFF) / 255.0
        let b = CGFloat(value & 0xFF) / 255.0
        return CGColor(srgbRed: r, green: g, blue: b, alpha: alpha)
    }
}

public final class CGAccentColor: AppThemeAccentCGColor {
    public lazy var sky = CGColor.hex(0x38BDF8)
    public lazy var violet = CGColor.hex(0x7C5CFF)
    public lazy var pink = CGColor.hex(0xFF7EDB)
    public lazy var yellow = CGColor.hex(0xFFD84D)
    public lazy var orange = CGColor.hex(0xFF9F43)
    public lazy var coral = CGColor.hex(0xFF6868)
    public lazy var teal = CGColor.hex(0x14B8A6)
}

