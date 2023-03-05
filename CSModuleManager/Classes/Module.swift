//
//  Module.swift
//  CSModuleManager
//
//  Created by CoderStar on 2022/11/28.
//

import Foundation

/// 模块
public class Module {
    /// 代理
    var delegate: ModuleDelegate?

    /// 配置
    let options: ModuleOptions

    init(options: ModuleOptions) {
        self.options = options
    }
}

extension Module {
    /// 模块名称
    public var name: String {
        options.name
    }
}

extension Module: CustomStringConvertible {
    public var description: String {
        return """
        Module
        name: \(name)
        """
    }
}

/// 模块配置
/// 内部结构
class ModuleOptions {
    /// 代理类型
    let delegateClass: ModuleDelegate.Type

    /// 名称
    let name: String

    init(delegateClass: ModuleDelegate.Type, items: [ModuleOptionsItem]) {
        self.delegateClass = delegateClass

        var nameValue: String?

        for item in items {
            switch item {
            case let .name(name):
                nameValue = name
            }
        }

        name = nameValue ?? String(reflecting: delegateClass)
    }
}

/// 模块选项
public enum ModuleOptionsItem {
    /// 模块名称
    case name(name: String)
}
