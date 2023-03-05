//
//  ModuleContext.swift
//  CSModuleManager
//
//  Created by CoderStar on 2022/11/23.
//

import Foundation

/// 模块上下文
/// 用于在模块间共享数据
public class ModuleContext {
    private init() {}

    static let shared = ModuleContext()

    public internal(set) var application: UIApplication?

    public internal(set) var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
}

extension ModuleContext {
    func copy() -> ModuleContext {
        let context = ModuleContext()
        context.application = application
        context.launchOptions = launchOptions
        return context
    }
}
