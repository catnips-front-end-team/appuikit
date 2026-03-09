#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// 强调色主题协议
/// 定义了各种场景下的强调色接口，跨平台支持
public protocol AppThemeAccentColor: AnyObject {
    /// 天空蓝强调色
    var sky: PlatformColor { get }
    /// 紫罗兰强调色
    var violet: PlatformColor { get }
    /// 粉色强调色
    var pink: PlatformColor { get }
    /// 黄色强调色
    var yellow: PlatformColor { get }
    /// 橙色强调色
    var orange: PlatformColor { get }
    /// 珊瑚色强调色
    var coral: PlatformColor { get }
    /// 青色强调色
    var teal: PlatformColor { get }
}


public final class UIColorAccentColor: AppThemeAccentColor {
    public lazy var sky = PlatformColor(hex: 0x38BDF8)
    public lazy var violet = PlatformColor(hex: 0x7C5CFF)
    public lazy var pink = PlatformColor(hex: 0xFF7EDB)
    public lazy var yellow = PlatformColor(hex: 0xFFD84D)
    public lazy var orange = PlatformColor(hex: 0xFF9F43)
    public lazy var coral = PlatformColor(hex: 0xFF6868)
    public lazy var teal = PlatformColor(hex: 0x14B8A6)
}

