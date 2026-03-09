#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// 语义色主题协议（CGColor 版本）
/// 定义了各类语义场景下的标准颜色接口，适用于 iOS 平台
public protocol AppThemeSemanticCGColor: AnyObject {
    /// 成功状态颜色（如操作成功提示、完成态图标等）
    var success: CGColor { get }

    /// 警告状态颜色（如提示提醒、需注意的操作等）
    var warning: CGColor { get }

    /// 错误状态颜色（如操作失败、错误提示、危险操作等）
    var error: CGColor { get }

    /// 信息提示颜色（如普通提示、说明文本、辅助信息等）
    var info: CGColor { get }
}

public final class CGSemanticColor: AppThemeSemanticCGColor {
    public lazy var success = CGColor.hex(0x22C55E)
    public lazy var warning = CGColor.hex(0xF59E0B)
    public lazy var error = CGColor.hex(0xEF4444)
    public lazy var info = CGColor.hex(0x38BDF8)
}

