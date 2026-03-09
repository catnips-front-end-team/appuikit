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
/// 背景色主题协议
/// 定义了各类背景场景下的标准颜色接口，适用于 iOS 平台
public protocol AppThemeBackgroundColor: AnyObject {
    /// 基础背景色（应用主背景色）
    var base: PlatformColor { get }
    /// 次级基础背景色（辅助背景色）
    var base2: PlatformColor { get }
    /// 页面背景色（内容页背景）
    var page: PlatformColor { get }
    /// 柔和背景色（浅色背景）
    var subtle: PlatformColor { get }
    /// 深色背景色（暗色背景）
    var dark: PlatformColor { get }
}

public final class UIColorBackgroundColor: AppThemeBackgroundColor {
    public lazy var base = PlatformColor(hex: 0xF6F7F9)
    public lazy var base2 = PlatformColor(hex: 0xEEF1F4)
    public lazy var page = PlatformColor(hex: 0xFFFFFF)
    public lazy var subtle = PlatformColor(hex: 0xF3F4F6)
    public lazy var dark = PlatformColor(hex: 0x0F1115)
}

