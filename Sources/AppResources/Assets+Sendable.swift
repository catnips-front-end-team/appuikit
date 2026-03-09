//
//  Assets+Sendable.swift
//  AppUIKit
//
//  Created by xxf on 2025/7/11.
//

// Sources/AppUIKit/Assets+Sendable.swift
import Foundation

// MARK: - Silence ImageAsset concurrency warnings

// 这些类型都是 SwiftGen 生成的：ImageAsset、ColorAsset、SymbolAsset、DataAsset、ARResourceGroupAsset
// 直接通过空扩展声明他们为 unchecked Sendable

extension ImageAsset: @unchecked Sendable {}
extension ColorAsset: @unchecked Sendable {}
// extension SymbolAsset: @unchecked Sendable {}
// extension DataAsset: @unchecked Sendable {}
// extension ARResourceGroupAsset: @unchecked Sendable {}
