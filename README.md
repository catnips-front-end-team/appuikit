# AppUIKit

一个强大的 iOS UI 组件库，提供主题色彩管理、资源管理和基础组件支持。

## 特性

✨ **主题色彩系统** - 完整的 UIColor 和 CGColor 主题色管理
🎨 **SwiftGen 集成** - 自动生成类型安全的资源访问代码
🚀 **性能优化** - 使用 lazy 延迟加载，避免启动时创建所有颜色对象
📦 **Swift Package Manager** - 完全支持 SPM，易于集成
🎯 **仅支持 iOS** - 专为 iOS 平台优化（iOS 13+）

---

## 📚 文档导航

- **[AI 编程指南](AI_CODING_GUIDE.md)** - 为 AI 编程助手提供的详细编码规范、设计模式和最佳实践

---

## 安装

### Swift Package Manager

在你的 `Package.swift` 中添加依赖：

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/AppUIKit.git", from: "1.0.0")
]
```

或在 Xcode 中：
1. File > Add Package Dependencies...
2. 输入仓库 URL
3. 选择版本并添加到项目

---

## 使用指南

### 1. 主题色彩系统

#### UIColor 使用（推荐用于 UI 组件）

```swift
import AppUIKit

// 品牌色
let primaryColor = UIColor.brand.primary      // 品牌主色
let pressedColor = UIColor.brand.pressed      // 按压态
let softColor = UIColor.brand.soft            // 柔和色

// 强调色
let skyColor = UIColor.accent.sky             // 天空蓝
let violetColor = UIColor.accent.violet       // 紫罗兰
let pinkColor = UIColor.accent.pink           // 粉色
let yellowColor = UIColor.accent.yellow       // 黄色
let orangeColor = UIColor.accent.orange       // 橙色
let coralColor = UIColor.accent.coral         // 珊瑚色
let tealColor = UIColor.accent.teal           // 青色

// 中性色（黑白系列）
let whiteColor = UIColor.neutral.white100     // 纯白
let white90 = UIColor.neutral.white90         // 90% 白色
let white60 = UIColor.neutral.white60         // 60% 白色
let blackColor = UIColor.neutral.black100     // 纯黑
let black60 = UIColor.neutral.black60         // 60% 黑色

// 背景色
let baseBackground = UIColor.background.base  // 基础背景色
let pageBackground = UIColor.background.page  // 页面背景色
let darkBackground = UIColor.background.dark  // 深色背景色

// 语义色
let successColor = UIColor.semantic.success   // 成功
let warningColor = UIColor.semantic.warning   // 警告
let errorColor = UIColor.semantic.error       // 错误
let infoColor = UIColor.semantic.info         // 信息
```

#### CGColor 使用（用于 Layer 和动画）

```swift
import AppUIKit

// CGColor 版本 - 用于 CALayer 等场景
layer.backgroundColor = CGColor.brand.primary
layer.borderColor = CGColor.accent.sky
layer.shadowColor = CGColor.neutral.black20

// 所有 UIColor 的属性在 CGColor 中都有对应版本
```

#### 在 SwiftUI 中使用

```swift
import SwiftUI
import AppUIKit

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello World")
                .foregroundColor(Color(UIColor.brand.primary))

            Rectangle()
                .fill(Color(UIColor.accent.sky))
                .frame(height: 200)

            Button("按钮") {
                // action
            }
            .foregroundColor(Color(UIColor.neutral.white100))
            .background(Color(UIColor.brand.primary))
        }
    }
}
```

---

### 2. 图片资源管理

```swift
import AppUIKit

// 使用生成的类型安全访问
let image = AppAssets.Images.iconName.image
let uiImage = AppAssets.Images.iconName.uiImage

// SwiftUI 中使用
Image(uiImage: AppAssets.Images.iconName.uiImage)
```

---

### 3. 动画资源管理

```swift
import AppUIKit

// 访问动画资源
let animationData = AppAnimations.animationName

// 如果使用 Lottie，可以这样加载
// let animationView = LottieAnimationView(name: animationName)
```

---

## 项目结构

```
AppUIKit/
├── Package.swift                    # SPM 配置文件
├── Sources/
│   ├── AppUIKit/                    # 主模块
│   ├── AppResources/                # 资源模块
│   │   ├── Color/
│   │   │   ├── NSColor/             # UIColor 版本主题色
│   │   │   │   ├── DefaultAccentColor.swift
│   │   │   │   ├── DefaultBrandColor.swift
│   │   │   │   ├── DefaultNeutralColor.swift
│   │   │   │   ├── DefaultBackgroundColor.swift
│   │   │   │   ├── DefaultSemanticColor.swift
│   │   │   │   └── DefaultThemeColorPalette.swift
│   │   │   └── CGColor/             # CGColor 版本主题色
│   │   │       ├── DefaultAccentColor.swift
│   │   │       ├── DefaultBrandColor.swift
│   │   │       ├── DefaultNeutralColor.swift
│   │   │       ├── DefaultBackgroundColor.swift
│   │   │       ├── DefaultSemanticColor.swift
│   │   │       └── DefaultThemeCGColorPalette.swift
│   │   ├── Assets/
│   │   │   ├── Images.xcassets/     # 图片资源
│   │   │   ├── Colors.xcassets/     # 颜色资源（备用）
│   │   │   └── Animations/          # 动画资源
│   │   └── Generated/               # SwiftGen 生成的代码
│   │       ├── AppAssets.swift
│   │       └── AppAnimations.swift
│   └── AppFoundation/               # 基础组件
└── Tests/                           # 测试
```

---

## 高级配置

### SwiftGen 代码生成

本项目使用 SwiftGen 插件自动生成资源访问代码。

#### 环境变量控制

```bash
# 启用代码生成（默认在 Debug 模式下自动启用）
export CODEGEN_ENABLED=yes

# 禁用代码生成（Release 模式使用已生成的代码）
export CODEGEN_ENABLED=no
```

#### 手动运行 SwiftGen

```bash
# 在项目根目录执行
swiftgen config run
```

---

### 自定义主题色

如果需要自定义主题色，可以创建自己的实现：

```swift
import AppUIKit

// 1. 创建自定义品牌色
final class MyBrandColor: AppThemeBrandColor {
    lazy var primary = UIColor(hex: 0xFF0000)   // 自定义红色
    lazy var pressed = UIColor(hex: 0xCC0000)
    lazy var soft = UIColor(hex: 0xFFCCCC)
}

// 2. 创建自定义主题调色板
final class MyThemeColorPalette {
    static let shared = MyThemeColorPalette()
    lazy var brand: AppThemeBrandColor = MyBrandColor()
    // ... 其他主题色
}

// 3. 在需要的地方使用
let myColor = MyThemeColorPalette.shared.brand.primary
```

---

## 性能优化说明

### Lazy 延迟加载

所有颜色对象都使用 `lazy var` 实现延迟加载：

```swift
// ❌ 旧方式：启动时立即创建所有颜色
let sky = UIColor(hex: 0x38BDF8)

// ✅ 新方式：首次访问时才创建
lazy var sky = UIColor(hex: 0x38BDF8)
```

**优势：**
- 🚀 启动时间更快（不创建未使用的颜色）
- 💾 内存占用更少（只为实际使用的颜色分配内存）
- ⚡️ 按需加载（首次访问时才创建，后续访问使用缓存）

---

## 颜色列表

### 品牌色（Brand）
- `primary` - 品牌主色 #C6FF2E
- `pressed` - 按压态 #A9E522
- `soft` - 柔和色 #F4FFE0

### 强调色（Accent）
- `sky` - 天空蓝 #38BDF8
- `violet` - 紫罗兰 #7C5CFF
- `pink` - 粉色 #FF7EDB
- `yellow` - 黄色 #FFD84D
- `orange` - 橙色 #FF9F43
- `coral` - 珊瑚色 #FF6868
- `teal` - 青色 #14B8A6

### 中性色（Neutral）
- `white100` - 纯白 #FFFFFF (100%)
- `white90` - 白色 #FFFFFF (90%)
- `white60` - 白色 #FFFFFF (60%)
- `white40` - 白色 #FFFFFF (30%)
- `white20` - 白色 #FFFFFF (15%)
- `white10` - 白色 #FFFFFF (10%)
- `white6` - 白色 #FFFFFF (6%)
- `black100` - 纯黑 #000000 (100%)
- `black90` - 黑色 #000000 (90%)
- `black60` - 黑色 #000000 (60%)
- `black40` - 黑色 #000000 (40%)
- `black20` - 黑色 #000000 (20%)
- `black10` - 黑色 #000000 (10%)
- `black6` - 黑色 #000000 (6%)

### 背景色（Background）
- `base` - 基础背景 #F6F7F9
- `base2` - 次级背景 #EEF1F4
- `page` - 页面背景 #FFFFFF
- `subtle` - 柔和背景 #F3F4F6
- `dark` - 深色背景 #0F1115

### 语义色（Semantic）
- `success` - 成功 #22C55E
- `warning` - 警告 #F59E0B
- `error` - 错误 #EF4444
- `info` - 信息 #38BDF8

---

## 系统要求

- iOS 13.0+
- Swift 6.0+
- Xcode 15.0+

---

## 开发说明

### SwiftGen 配置

如果需要修改 SwiftGen 配置，编辑 `swiftgen.yml` 文件：

```yaml
# 配置图片资源生成
xcassets:
  inputs:
    - Sources/AppResources/Assets/Images.xcassets
  outputs:
    - templateName: swift5
      output: Sources/AppResources/Generated/AppAssets.swift
```

---

## 许可证

MIT License

---

## 贡献

欢迎提交 Issue 和 Pull Request！

---

## 更新日志

### v1.0.0
- ✅ 完整的主题色彩系统（UIColor + CGColor）
- ✅ SwiftGen 自动代码生成
- ✅ Lazy 延迟加载性能优化
- ✅ 仅支持 iOS 平台
- ✅ 移除 Lottie 依赖
- ✅ 统一使用 App 前缀命名
