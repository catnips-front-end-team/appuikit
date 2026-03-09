#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// 背景色主题协议（CGColor 版本）
/// 定义了各类背景场景下的标准颜色接口，适用于 iOS 平台
public protocol AppThemeBackgroundCGColor: AnyObject {
    /// 基础背景色（应用主背景色）
    var base: CGColor { get }
    /// 次级基础背景色（辅助背景色）
    var base2: CGColor { get }
    /// 页面背景色（内容页背景）
    var page: CGColor { get }
    /// 柔和背景色（浅色背景）
    var subtle: CGColor { get }
    /// 深色背景色（暗色背景）
    var dark: CGColor { get }
}

public final class CGBackgroundColor: AppThemeBackgroundCGColor {
    public lazy var base = CGColor.hex(0xF6F7F9)
    public lazy var base2 = CGColor.hex(0xEEF1F4)
    public lazy var page = CGColor.hex(0xFFFFFF)
    public lazy var subtle = CGColor.hex(0xF3F4F6)
    public lazy var dark = CGColor.hex(0x0F1115)
}

