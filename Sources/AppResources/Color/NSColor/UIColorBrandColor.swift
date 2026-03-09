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
/// 品牌色主题协议
/// 定义产品专属的品牌色系接口，适用于 iOS 平台
public protocol AppThemeBrandColor: AnyObject {
    /// 品牌主色（核心品牌色，用于主要按钮、关键强调等）
    var primary: PlatformColor { get }

    /// 品牌按压态颜色（主色的按下/激活状态，比主色略深）
    var pressed: PlatformColor { get }

    /// 品牌柔和色（主色的弱化版本，用于背景、辅助强调等）
    var soft: PlatformColor { get }
}

public final class UIColorBrandColor: AppThemeBrandColor {
    public lazy var primary = PlatformColor(hex: 0xC6FF2E)
    public lazy var pressed = PlatformColor(hex: 0xA9E522)
    public lazy var soft = PlatformColor(hex: 0xF4FFE0)
}

