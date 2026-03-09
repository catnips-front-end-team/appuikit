# AppUIKit AI 编程指南

> 本文档为 AI 编程助手提供 AppUIKit 项目的编码规范、设计模式和最佳实践指导。

---

## 📋 目录

1. [核心设计理念](#核心设计理念)
2. [项目架构](#项目架构)
3. [编程模式](#编程模式)
4. [代码风格规范](#代码风格规范)
5. [常用工具方法](#常用工具方法)
6. [颜色系统使用](#颜色系统使用)
7. [性能优化要求](#性能优化要求)
8. [条件编译规范](#条件编译规范)
9. [SwiftGen 集成](#swiftgen-集成)
10. [最佳实践示例](#最佳实践示例)
11. [常见问题处理](#常见问题处理)

---

## 核心设计理念

在为 AppUIKit 编写代码时，必须遵循以下核心设计理念：

### 1. 协议驱动开发 (Protocol-Oriented Programming)

- 使用协议定义接口，保持实现的灵活性
- 支持依赖注入和测试
- 便于扩展和自定义主题

### 2. 性能优先

- 使用 `lazy var` 延迟加载，减少启动时间
- 单例模式避免重复创建对象
- 避免在启动时初始化未使用的资源

### 3. 类型安全

- 利用 Swift 类型系统，避免硬编码字符串
- SwiftGen 生成类型安全的资源访问代码
- 使用枚举和协议约束类型

### 4. 跨平台兼容

- 使用条件编译支持 iOS 和 macOS
- `PlatformColor` 类型别名统一 UIColor/NSColor
- 平台特定代码使用 `#if canImport` 隔离

### 5. 代码可维护性

- 清晰的命名约定
- 模块化设计，职责分离
- 详细的文档注释

---

## 项目架构

### 模块结构

```
AppUIKit/
├── AppUIKit/              # 主模块（导出层）
│   └── AppUIKit.swift     # 统一导出所有子模块
├── AppResources/          # 资源模块
│   ├── Color/             # 主题色彩系统
│   │   ├── NSColor/       # UIColor 实现
│   │   ├── CGColor/       # CGColor 实现
│   │   └── PlatformColor.swift  # 跨平台类型别名
│   ├── Images/            # 图片资源扩展
│   ├── Assets/            # 资源文件（xcassets）
│   └── Generated/         # SwiftGen 生成代码
└── AppFoundation/         # 基础工具模块
    ├── Extensions/        # 扩展方法
    └── Utils/             # 工具类
```

### 模块依赖关系

```
AppUIKit (主模块)
    ├── @_exported AppResources
    └── @_exported AppFoundation

AppResources (资源模块)
    └── 依赖 AppFoundation

AppFoundation (基础模块)
    └── 无外部依赖
```

---

## 编程模式

### 1. 协议-实现分离模式

**定义协议（接口）：**

```swift
/// 品牌色主题协议
/// 定义产品专属的品牌色系接口
public protocol AppThemeBrandColor: AnyObject {
    /// 品牌主色（核心品牌色，用于主要按钮、关键强调等）
    var primary: PlatformColor { get }

    /// 按压态（用于按钮按下状态）
    var pressed: PlatformColor { get }

    /// 柔和色（用于次要元素、浅色背景）
    var soft: PlatformColor { get }
}
```

**实现具体类：**

```swift
/// UIColor 版本的品牌色实现
/// 适用于 UIKit 场景（UIView, UILabel 等）
public final class UIColorBrandColor: AppThemeBrandColor {
    /// 品牌主色 #C6FF2E
    public lazy var primary = PlatformColor(hex: 0xC6FF2E)

    /// 按压态 #A9E522
    public lazy var pressed = PlatformColor(hex: 0xA9E522)

    /// 柔和色 #F4FFE0
    public lazy var soft = PlatformColor(hex: 0xF4FFE0)
}
```

**为什么这样设计？**
- 协议定义了接口契约，使用者依赖协议而非具体实现
- 支持运行时替换主题实现（依赖注入）
- 便于单元测试（可以 mock 协议实现）
- 易于扩展新的颜色主题

---

### 2. 单例 + Lazy 加载模式

```swift
/// UIColor 主题调色板单例
/// 管理所有 UIColor 版本的主题色分类
public final class UIColorThemeColorPalette: @unchecked Sendable {
    /// 全局单例实例
    public static let shared = UIColorThemeColorPalette()

    /// 私有初始化器，防止外部创建实例
    private init() {}

    /// 品牌色（延迟初始化，首次访问时创建）
    public lazy var brand: AppThemeBrandColor = UIColorBrandColor()

    /// 强调色（延迟初始化）
    public lazy var accent: AppThemeAccentColor = UIColorAccentColor()

    /// 中性色（延迟初始化）
    public lazy var neutral: AppThemeNeutralColor = UIColorNeutralColor()

    /// 背景色（延迟初始化）
    public lazy var background: AppThemeBackgroundColor = UIColorBackgroundColor()

    /// 语义色（延迟初始化）
    public lazy var semantic: AppThemeSemanticColor = UIColorSemanticColor()
}
```

**关键点：**
- `static let shared`：全局唯一实例
- `private init()`：防止外部实例化
- `lazy var`：延迟初始化，首次访问时才创建
- `@unchecked Sendable`：标记为线程安全（Swift 6.0+ 并发支持）

---

### 3. 扩展方法模式

```swift
/// UIColor 扩展，提供便捷的主题色访问入口
#if canImport(UIKit)
import UIKit

public extension UIColor {
    /// 强调色（天空蓝、紫罗兰等多彩强调色）
    static var accent: AppThemeAccentColor {
        return UIColorThemeColorPalette.shared.accent
    }

    /// 品牌色（主色、按压态、柔和色）
    static var brand: AppThemeBrandColor {
        return UIColorThemeColorPalette.shared.brand
    }

    /// 中性色（黑白灰系列）
    static var neutral: AppThemeNeutralColor {
        return UIColorThemeColorPalette.shared.neutral
    }

    /// 背景色（页面、卡片、深色背景）
    static var background: AppThemeBackgroundColor {
        return UIColorThemeColorPalette.shared.background
    }

    /// 语义色（成功、警告、错误、信息）
    static var semantic: AppThemeSemanticColor {
        return UIColorThemeColorPalette.shared.semantic
    }
}
#endif
```

**使用方式：**

```swift
// 便捷访问，无需直接使用单例
let primaryColor = UIColor.brand.primary
let skyColor = UIColor.accent.sky
let errorColor = UIColor.semantic.error
```

---

## 代码风格规范

### 命名约定

| 类型 | 命名规则 | 示例 | 说明 |
|------|---------|------|------|
| **协议** | `AppTheme[Category]Color` | `AppThemeBrandColor` | 统一使用 `AppTheme` 前缀 |
| **UIColor 实现** | `UIColor[Category]Color` | `UIColorBrandColor` | 明确标识 UIColor 实现 |
| **CGColor 实现** | `CG[Category]Color` | `CGBrandColor` | 明确标识 CGColor 实现 |
| **调色板** | `[Platform]ColorThemeColorPalette` | `UIColorThemeColorPalette` | 完整的类型描述 |
| **生成代码** | `App[ResourceType]` | `AppAssets` | 使用 `App` 前缀避免冲突 |
| **扩展文件** | `[Type]+App[Extension].swift` | `UIColor+AppExtension.swift` | 清晰的扩展标识 |

### 访问控制规范

```swift
// ✅ 推荐：公开 API 使用 public
public final class UIColorBrandColor: AppThemeBrandColor {
    public lazy var primary = PlatformColor(hex: 0xC6FF2E)
}

// ✅ 推荐：使用 final 防止继承
public final class UIColorThemeColorPalette { }

// ✅ 推荐：单例使用 private init
private init() {}

// ❌ 避免：不必要的 open 关键字
open class UIColorBrandColor { } // 除非确实需要继承

// ❌ 避免：遗漏 public，导致无法外部访问
lazy var primary = PlatformColor(hex: 0xC6FF2E) // 缺少 public
```

### 文档注释规范

```swift
/// 品牌色主题协议
///
/// 定义产品专属的品牌色系接口，包含主色、按压态和柔和色。
/// 适用于 iOS 和 macOS 平台。
///
/// ## 使用示例
///
/// ```swift
/// let primaryColor = UIColor.brand.primary
/// button.backgroundColor = UIColor.brand.primary
/// button.setBackgroundColor(UIColor.brand.pressed, for: .highlighted)
/// ```
///
/// ## 注意事项
/// - 所有颜色使用 lazy 延迟加载，首次访问时创建
/// - 颜色值基于设计规范，不建议随意修改
public protocol AppThemeBrandColor: AnyObject {
    /// 品牌主色（核心品牌色，用于主要按钮、关键强调等）
    ///
    /// 颜色值：#C6FF2E
    /// 适用场景：主要操作按钮、导航栏、Tab 选中状态
    var primary: PlatformColor { get }

    /// 按压态（用于按钮按下状态）
    ///
    /// 颜色值：#A9E522
    /// 适用场景：按钮 `.highlighted` 状态
    var pressed: PlatformColor { get }

    /// 柔和色（用于次要元素、浅色背景）
    ///
    /// 颜色值：#F4FFE0
    /// 适用场景：次要按钮背景、选中区域背景
    var soft: PlatformColor { get }
}
```

**文档注释要点：**
- 使用三斜杠 `///` 格式
- 包含功能描述、使用示例和注意事项
- 详细说明每个属性的用途和适用场景
- 标注颜色值（十六进制格式）

---

## 常用工具方法

### 1. 十六进制颜色初始化

**UIColor 版本：**

```swift
/// 扩展 PlatformColor，支持十六进制颜色初始化
extension PlatformColor {
    /// 使用十六进制值创建颜色
    ///
    /// - Parameters:
    ///   - hex: 十六进制颜色值（例如：0xFF5733）
    ///   - alpha: 透明度（0.0 - 1.0，默认 1.0）
    ///
    /// ## 使用示例
    ///
    /// ```swift
    /// let red = UIColor(hex: 0xFF0000)           // 红色
    /// let semiTransparent = UIColor(hex: 0xFF0000, alpha: 0.5)  // 半透明红色
    /// ```
    public convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let r = CGFloat((hex >> 16) & 0xFF) / 255.0
        let g = CGFloat((hex >> 8) & 0xFF) / 255.0
        let b = CGFloat(hex & 0xFF) / 255.0

        #if canImport(UIKit)
        self.init(red: r, green: g, blue: b, alpha: alpha)
        #elseif canImport(AppKit)
        self.init(red: r, green: g, blue: b, alpha: alpha)
        #endif
    }
}
```

**CGColor 版本：**

```swift
/// CGColor 扩展，支持十六进制颜色初始化
public extension CGColor {
    /// 使用十六进制值创建 CGColor
    ///
    /// - Parameters:
    ///   - value: 十六进制颜色值（例如：0xFF5733）
    ///   - alpha: 透明度（0.0 - 1.0，默认 1.0）
    /// - Returns: CGColor 实例
    ///
    /// ## 使用示例
    ///
    /// ```swift
    /// layer.backgroundColor = CGColor.hex(0xFF0000)
    /// layer.borderColor = CGColor.hex(0x00FF00, alpha: 0.8)
    /// ```
    static func hex(_ value: Int, alpha: CGFloat = 1.0) -> CGColor {
        let r = CGFloat((value >> 16) & 0xFF) / 255.0
        let g = CGFloat((value >> 8) & 0xFF) / 255.0
        let b = CGFloat(value & 0xFF) / 255.0

        return CGColor(srgbRed: r, green: g, blue: b, alpha: alpha)
    }
}
```

### 2. 跨平台类型别名

```swift
#if canImport(UIKit)
import UIKit
/// iOS 平台使用 UIColor
public typealias PlatformColor = UIColor
#elseif canImport(AppKit)
import AppKit
/// macOS 平台使用 NSColor
public typealias PlatformColor = NSColor
#endif
```

**使用场景：**
```swift
// 统一使用 PlatformColor，自动适配平台
public protocol AppThemeBrandColor: AnyObject {
    var primary: PlatformColor { get }  // iOS: UIColor, macOS: NSColor
}
```

### 3. Sendable 协议扩展

```swift
/// 为 SwiftGen 生成的类型添加 Sendable 支持
/// 确保在 Swift 6.0+ 并发环境下安全使用
extension ImageAsset: @unchecked Sendable {}
extension ColorAsset: @unchecked Sendable {}
extension AnimationAsset: @unchecked Sendable {}
```

**为什么需要 `@unchecked Sendable`？**
- Swift 6.0+ 强制并发安全检查
- SwiftGen 生成的类型本身是线程安全的，但未标记 Sendable
- 使用 `@unchecked` 告诉编译器我们已验证线程安全性

---

## 颜色系统使用

### 颜色分类

| 分类 | 用途 | 典型场景 |
|------|------|---------|
| **Brand** | 品牌主色 | 主要按钮、导航栏、品牌标识 |
| **Accent** | 强调色 | 图标、标签、次要按钮 |
| **Neutral** | 中性色 | 文本、分割线、边框 |
| **Background** | 背景色 | 页面背景、卡片背景 |
| **Semantic** | 语义色 | 成功/警告/错误提示 |

### 使用规范

**✅ 推荐使用方式：**

```swift
// UIKit 场景
let button = UIButton()
button.backgroundColor = UIColor.brand.primary
button.setTitleColor(UIColor.neutral.white100, for: .normal)
button.setBackgroundColor(UIColor.brand.pressed, for: .highlighted)

// CALayer 场景
let layer = CALayer()
layer.backgroundColor = CGColor.brand.primary
layer.borderColor = CGColor.accent.sky
layer.shadowColor = CGColor.neutral.black20

// SwiftUI 场景
struct ContentView: View {
    var body: some View {
        Text("Hello")
            .foregroundColor(Color(UIColor.brand.primary))
            .background(Color(UIColor.background.page))
    }
}
```

**❌ 避免硬编码：**

```swift
// ❌ 不要直接使用十六进制值
button.backgroundColor = UIColor(hex: 0xC6FF2E)

// ✅ 应该使用主题色
button.backgroundColor = UIColor.brand.primary
```

### 透明度管理

```swift
// 中性色提供了多个透明度级别
let white100 = UIColor.neutral.white100  // 100% 不透明
let white90 = UIColor.neutral.white90    // 90% 不透明
let white60 = UIColor.neutral.white60    // 60% 不透明
let white40 = UIColor.neutral.white40    // 30% 不透明
let white20 = UIColor.neutral.white20    // 15% 不透明
let white10 = UIColor.neutral.white10    // 10% 不透明
let white6 = UIColor.neutral.white6      // 6% 不透明

// 黑色也有对应的透明度级别
let black100 = UIColor.neutral.black100
let black90 = UIColor.neutral.black90
let black60 = UIColor.neutral.black60
// ...
```

---

## 性能优化要求

### 1. Lazy 延迟加载

**✅ 推荐：**

```swift
public final class UIColorBrandColor: AppThemeBrandColor {
    // 使用 lazy，首次访问时才创建
    public lazy var primary = PlatformColor(hex: 0xC6FF2E)
    public lazy var pressed = PlatformColor(hex: 0xA9E522)
    public lazy var soft = PlatformColor(hex: 0xF4FFE0)
}
```

**❌ 避免：**

```swift
public final class UIColorBrandColor: AppThemeBrandColor {
    // 启动时立即创建所有颜色对象，影响性能
    public let primary = PlatformColor(hex: 0xC6FF2E)
    public let pressed = PlatformColor(hex: 0xA9E522)
    public let soft = PlatformColor(hex: 0xF4FFE0)
}
```

**性能对比：**

| 方式 | 启动时间 | 内存占用 | 首次访问 | 后续访问 |
|------|---------|---------|---------|---------|
| `lazy var` | 快（0ms） | 低（0KB） | 稍慢（创建对象） | 快（使用缓存） |
| `let` | 慢（创建所有对象） | 高（所有颜色） | 快 | 快 |

### 2. 单例模式优化

```swift
// ✅ 推荐：单例 + 私有初始化
public final class UIColorThemeColorPalette {
    public static let shared = UIColorThemeColorPalette()
    private init() {}
}

// ❌ 避免：每次创建新实例
public class UIColorThemeColorPalette {
    public init() {}  // 允许外部创建实例，浪费内存
}
```

### 3. 避免不必要的计算

```swift
// ✅ 推荐：预计算透明度，避免运行时转换
public lazy var white90 = PlatformColor(hex: 0xFFFFFF, alpha: 0.9)
public lazy var white60 = PlatformColor(hex: 0xFFFFFF, alpha: 0.6)

// ❌ 避免：运行时动态计算透明度
public var white90: PlatformColor {
    return PlatformColor(hex: 0xFFFFFF).withAlphaComponent(0.9)
}
```

---

## 条件编译规范

### 平台检测

```swift
#if canImport(UIKit)
import UIKit
// iOS 特定代码
#elseif canImport(AppKit)
import AppKit
// macOS 特定代码
#endif
```

### 扩展方法的条件编译

```swift
// UIColor 扩展（仅 iOS）
#if canImport(UIKit)
import UIKit

public extension UIColor {
    static var brand: AppThemeBrandColor {
        return UIColorThemeColorPalette.shared.brand
    }
}
#endif

// NSColor 扩展（仅 macOS）
#if canImport(AppKit)
import AppKit

public extension NSColor {
    static var brand: AppThemeBrandColor {
        return UIColorThemeColorPalette.shared.brand
    }
}
#endif
```

### 类型别名统一接口

```swift
// PlatformColor 统一 UIColor 和 NSColor
#if canImport(UIKit)
public typealias PlatformColor = UIColor
#elseif canImport(AppKit)
public typealias PlatformColor = NSColor
#endif

// 协议使用 PlatformColor，自动适配平台
public protocol AppThemeBrandColor: AnyObject {
    var primary: PlatformColor { get }
}
```

---

## SwiftGen 集成

### 配置文件 (swiftgen.yml)

```yaml
# SwiftGen 配置文件
# 用于自动生成类型安全的资源访问代码

# 图片资源配置
xcassets:
  inputs:
    - Sources/AppResources/Assets/Images.xcassets
  outputs:
    - templatePath: Tools/SwiftGenTemplates/xcassets-swift5-runtime-imageasset.stencil
      output: Sources/AppResources/Generated/AppAssets.swift
      params:
        forceNestedGroups: true  # 强制嵌套分组
        publicAccess: true       # 生成 public 访问权限
        enumName: "AppAssets"    # 枚举名称

# 动画资源配置
files:
  inputs:
    - Sources/AppResources/Assets/Animations
  outputs:
    - templateName: files-swift5
      output: Sources/AppResources/Generated/AppAnimations.swift
      params:
        publicAccess: true
        enumName: "AppAnimations"
```

### 使用生成的代码

```swift
import AppUIKit

// 类型安全的图片访问
let iconImage = AppAssets.Images.Icons.user.uiImage
let logoImage = AppAssets.Images.Logo.appLogo.uiImage

// SwiftUI 中使用
struct ContentView: View {
    var body: some View {
        Image(uiImage: AppAssets.Images.Icons.user.uiImage)
    }
}

// 动画资源访问
let animationData = AppAnimations.loading
```

### 条件编译控制

```swift
// Package.swift 中的插件配置
#if CODEGEN_ENABLED
.plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin")
#endif
```

**环境变量控制：**

```bash
# 启用代码生成（Debug 模式）
export CODEGEN_ENABLED=yes

# 禁用代码生成（Release 模式）
export CODEGEN_ENABLED=no
```

---

## 最佳实践示例

### 示例 1：添加新的主题色分类

假设需要添加一个"渐变色"分类，包含多种渐变配色。

**步骤 1：定义协议**

```swift
// Sources/AppResources/Color/AppThemeGradientColor.swift

import Foundation

/// 渐变色主题协议
///
/// 定义渐变配色方案，包含起始色和结束色。
/// 适用于需要渐变效果的 UI 场景。
///
/// ## 使用示例
///
/// ```swift
/// let startColor = UIColor.gradient.sunriseStart
/// let endColor = UIColor.gradient.sunriseEnd
/// let gradient = CAGradientLayer()
/// gradient.colors = [startColor.cgColor, endColor.cgColor]
/// ```
public protocol AppThemeGradientColor: AnyObject {
    /// 日出渐变 - 起始色
    var sunriseStart: PlatformColor { get }

    /// 日出渐变 - 结束色
    var sunriseEnd: PlatformColor { get }

    /// 海洋渐变 - 起始色
    var oceanStart: PlatformColor { get }

    /// 海洋渐变 - 结束色
    var oceanEnd: PlatformColor { get }
}
```

**步骤 2：实现 UIColor 版本**

```swift
// Sources/AppResources/Color/NSColor/UIColorGradientColor.swift

#if canImport(UIKit)
import UIKit

/// UIColor 版本的渐变色实现
/// 适用于 UIKit 场景
public final class UIColorGradientColor: AppThemeGradientColor {
    /// 日出渐变 - 起始色 #FF6B6B
    public lazy var sunriseStart = PlatformColor(hex: 0xFF6B6B)

    /// 日出渐变 - 结束色 #FFD93D
    public lazy var sunriseEnd = PlatformColor(hex: 0xFFD93D)

    /// 海洋渐变 - 起始色 #667EEA
    public lazy var oceanStart = PlatformColor(hex: 0x667EEA)

    /// 海洋渐变 - 结束色 #38BDF8
    public lazy var oceanEnd = PlatformColor(hex: 0x38BDF8)
}
#endif
```

**步骤 3：实现 CGColor 版本**

```swift
// Sources/AppResources/Color/CGColor/CGGradientColor.swift

import CoreGraphics

/// CGColor 版本的渐变色实现
/// 适用于 CALayer、动画等场景
public final class CGGradientColor: AppThemeGradientColor {
    /// 日出渐变 - 起始色 #FF6B6B
    public lazy var sunriseStart = CGColor.hex(0xFF6B6B)

    /// 日出渐变 - 结束色 #FFD93D
    public lazy var sunriseEnd = CGColor.hex(0xFFD93D)

    /// 海洋渐变 - 起始色 #667EEA
    public lazy var oceanStart = CGColor.hex(0x667EEA)

    /// 海洋渐变 - 结束色 #38BDF8
    public lazy var oceanEnd = CGColor.hex(0x38BDF8)
}
```

**步骤 4：添加到调色板**

```swift
// Sources/AppResources/Color/NSColor/UIColorThemeColorPalette.swift

public final class UIColorThemeColorPalette: @unchecked Sendable {
    public static let shared = UIColorThemeColorPalette()
    private init() {}

    // 现有主题色
    public lazy var brand: AppThemeBrandColor = UIColorBrandColor()
    public lazy var accent: AppThemeAccentColor = UIColorAccentColor()

    // 新增渐变色
    public lazy var gradient: AppThemeGradientColor = UIColorGradientColor()
}
```

**步骤 5：添加扩展方法**

```swift
// Sources/AppResources/Color/NSColor/UIColor+AppExtension.swift

#if canImport(UIKit)
import UIKit

public extension UIColor {
    /// 渐变色（日出、海洋等渐变配色）
    static var gradient: AppThemeGradientColor {
        return UIColorThemeColorPalette.shared.gradient
    }
}
#endif
```

**步骤 6：使用新主题色**

```swift
import AppUIKit

// 创建渐变层
let gradientLayer = CAGradientLayer()
gradientLayer.colors = [
    UIColor.gradient.sunriseStart.cgColor,
    UIColor.gradient.sunriseEnd.cgColor
]
gradientLayer.startPoint = CGPoint(x: 0, y: 0)
gradientLayer.endPoint = CGPoint(x: 1, y: 1)
view.layer.insertSublayer(gradientLayer, at: 0)
```

---

### 示例 2：自定义主题实现

假设需要为特定客户创建自定义品牌色主题。

```swift
import AppUIKit

/// 客户 A 的自定义品牌色
final class ClientABrandColor: AppThemeBrandColor {
    /// 客户 A 的品牌主色
    lazy var primary = UIColor(hex: 0xFF0000)  // 红色

    /// 客户 A 的按压态
    lazy var pressed = UIColor(hex: 0xCC0000)  // 深红色

    /// 客户 A 的柔和色
    lazy var soft = UIColor(hex: 0xFFCCCC)     // 浅红色
}

/// 客户 A 的自定义主题调色板
final class ClientAThemeColorPalette {
    static let shared = ClientAThemeColorPalette()
    private init() {}

    /// 使用自定义品牌色
    lazy var brand: AppThemeBrandColor = ClientABrandColor()

    /// 其他主题色继续使用默认实现
    lazy var accent: AppThemeAccentColor = UIColorAccentColor()
    lazy var neutral: AppThemeNeutralColor = UIColorNeutralColor()
    lazy var background: AppThemeBackgroundColor = UIColorBackgroundColor()
    lazy var semantic: AppThemeSemanticColor = UIColorSemanticColor()
}

// 使用自定义主题
let customPrimaryColor = ClientAThemeColorPalette.shared.brand.primary
```

---

### 示例 3：SwiftUI 中使用主题色

```swift
import SwiftUI
import AppUIKit

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 20) {
            // 标题
            Text("欢迎登录")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(UIColor.neutral.black100))

            // 输入框
            TextField("用户名", text: $username)
                .padding()
                .background(Color(UIColor.background.base))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(UIColor.neutral.white40), lineWidth: 1)
                )

            SecureField("密码", text: $password)
                .padding()
                .background(Color(UIColor.background.base))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(UIColor.neutral.white40), lineWidth: 1)
                )

            // 登录按钮
            Button(action: login) {
                Text("登录")
                    .font(.headline)
                    .foregroundColor(Color(UIColor.neutral.black100))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(UIColor.brand.primary))
                    .cornerRadius(8)
            }

            // 忘记密码
            Button(action: forgotPassword) {
                Text("忘记密码？")
                    .font(.subheadline)
                    .foregroundColor(Color(UIColor.accent.sky))
            }
        }
        .padding()
        .background(Color(UIColor.background.page))
    }

    func login() {
        // 登录逻辑
    }

    func forgotPassword() {
        // 忘记密码逻辑
    }
}
```

---

## 常见问题处理

### 问题 1：颜色未生效

**症状：**
```swift
let color = UIColor.brand.primary
print(color)  // 输出不是预期的颜色
```

**排查步骤：**

1. 检查是否正确导入模块：
   ```swift
   import AppUIKit  // 确保导入了主模块
   ```

2. 检查调色板是否正确初始化：
   ```swift
   // 调试输出
   print(UIColorThemeColorPalette.shared.brand.primary)
   ```

3. 检查十六进制值是否正确：
   ```swift
   // 确认颜色值
   public lazy var primary = PlatformColor(hex: 0xC6FF2E)  // 确保 0x 前缀存在
   ```

---

### 问题 2：SwiftGen 代码未生成

**症状：**
```
'AppAssets' is undefined
```

**解决方案：**

1. 检查环境变量：
   ```bash
   echo $CODEGEN_ENABLED  # 应该输出 "yes"
   ```

2. 手动运行 SwiftGen：
   ```bash
   cd /path/to/AppUIKit
   swiftgen config run
   ```

3. 检查 `swiftgen.yml` 配置：
   ```yaml
   xcassets:
     inputs:
       - Sources/AppResources/Assets/Images.xcassets  # 确认路径正确
   ```

4. 清理并重新构建：
   ```bash
   swift package clean
   swift build
   ```

---

### 问题 3：并发警告 (Swift 6.0+)

**症状：**
```
warning: type 'ImageAsset' does not conform to the 'Sendable' protocol
```

**解决方案：**

在 `Assets+Sendable.swift` 中添加：
```swift
extension ImageAsset: @unchecked Sendable {}
extension ColorAsset: @unchecked Sendable {}
```

---

### 问题 4：跨平台编译失败

**症状：**
```
error: cannot find 'UIColor' in scope
```

**解决方案：**

使用条件编译：
```swift
#if canImport(UIKit)
import UIKit
// UIColor 相关代码
#elseif canImport(AppKit)
import AppKit
// NSColor 相关代码
#endif
```

或使用 `PlatformColor` 类型别名：
```swift
public protocol AppThemeBrandColor: AnyObject {
    var primary: PlatformColor { get }  // 自动适配平台
}
```

---

### 问题 5：Lazy 属性线程安全

**症状：**
多线程同时访问 lazy 属性可能导致竞态条件。

**解决方案：**

1. 标记类为 `@unchecked Sendable`：
   ```swift
   public final class UIColorThemeColorPalette: @unchecked Sendable {
       // ...
   }
   ```

2. 确保单例线程安全：
   ```swift
   public static let shared = UIColorThemeColorPalette()  // static let 保证线程安全
   ```

3. 避免在多线程中修改 lazy 属性：
   ```swift
   // ✅ 推荐：只读访问
   let color = UIColor.brand.primary

   // ❌ 避免：多线程写入
   UIColorThemeColorPalette.shared.brand = CustomBrandColor()
   ```

---

## 总结

### 核心原则

1. **协议驱动** - 使用协议定义接口，保持灵活性
2. **性能优先** - Lazy 加载 + 单例模式优化启动性能
3. **类型安全** - SwiftGen 生成类型安全的资源访问代码
4. **跨平台** - 条件编译和类型别名支持多平台
5. **可维护** - 清晰的命名、文档和模块化设计

### 关键代码模式

| 模式 | 示例 | 用途 |
|------|------|------|
| 协议-实现 | `AppThemeBrandColor` + `UIColorBrandColor` | 接口与实现分离 |
| 单例 + Lazy | `UIColorThemeColorPalette.shared` | 全局唯一实例，延迟加载 |
| 扩展方法 | `UIColor.brand.primary` | 便捷访问入口 |
| 类型别名 | `PlatformColor` | 跨平台统一接口 |
| 十六进制初始化 | `UIColor(hex: 0xC6FF2E)` | 简化颜色创建 |

### 开发检查清单

在编写代码前，请确认：

- [ ] 是否使用了 `lazy var` 延迟加载？
- [ ] 是否添加了详细的文档注释？
- [ ] 是否遵循命名约定？
- [ ] 是否使用 `public` 修饰公开 API？
- [ ] 是否使用 `final` 防止不必要的继承？
- [ ] 是否使用 `PlatformColor` 支持跨平台？
- [ ] 是否避免硬编码颜色值？
- [ ] 是否使用条件编译隔离平台代码？
- [ ] 是否标记为 `@unchecked Sendable`（如需并发安全）？
- [ ] 是否为 SwiftGen 生成的类型添加 Sendable 扩展？

---

## 参考资源

- [AppUIKit 主文档](README.md)
- [Swift Package Manager 文档](https://swift.org/package-manager/)
- [SwiftGen 官方文档](https://github.com/SwiftGen/SwiftGen)
- [Swift API 设计指南](https://swift.org/documentation/api-design-guidelines/)

---

**版本：** v1.0.0
**最后更新：** 2026-03-09
**维护者：** AppUIKit Team
