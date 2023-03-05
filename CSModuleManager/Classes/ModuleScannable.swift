//
//  ModuleScannable.swift
//  CSModuleManager
//
//  Created by CoderStar on 2022/11/24.
//

import Foundation

/// 模块扫描策略
final public class ModuleScannableStrategy: ClassScannableStrategy {
    private init() {}

    public static let shared = ModuleScannableStrategy()

    public var types: [AnyClass] = []

    public func isMatched(anyClass: AnyClass) -> Bool {
        class_getSuperclass(anyClass) == ModuleScannableObject.self
    }

    public func handle(anyClass: AnyClass) {
        types.append(anyClass)
    }
}

open class ModuleScannableObject {
    /// 允许框架有能力去创建
    required public init() {}
}
