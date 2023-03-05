//
//  ModuleDelegate.swift.swift
//  CSModuleManager
//
//  Created by CoderStar on 2022/11/23.
//

import Foundation

/// 系统可以自动扫描的模块
/// 继承该类
public typealias ScannableModule = ModuleScannableObject & ModuleDelegate

/// 模块代理
public protocol ModuleDelegate: AnyObject {
    /// 实现该协议的类允许被框架进行创建
    init()

    static func moduleOptions() -> [ModuleOptionsItem]

    func moduleDidFinishLaunch(module: Module, context: ModuleContext)

    func moduleDidEnterBackground(module: Module, context: ModuleContext)

    func moduleWillEnterForeground(module: Module, context: ModuleContext)

    func moduleDidBecomeActive(module: Module, context: ModuleContext)

    func moduleWillResignActive(module: Module, context: ModuleContext)

    func moduleWillTerminate(module: Module, context: ModuleContext)

    func moduleDidReceiveMemoryWarning(module: Module, context: ModuleContext)

    /// 自定义事件
    func moduleDidReceiveCustomEvent(module: Module, context: ModuleContext, eventName: String, eventParam: [String: Any]?)
}

extension ModuleDelegate {
    public static func moduleOptions() -> [ModuleOptionsItem] { [] }

    public func moduleDidFinishLaunch(module: Module, context: ModuleContext) {}

    public func moduleDidEnterBackground(module: Module, context: ModuleContext) {}

    public func moduleWillEnterForeground(module: Module, context: ModuleContext) {}

    public func moduleDidBecomeActive(module: Module, context: ModuleContext) {}

    public func moduleWillResignActive(module: Module, context: ModuleContext) {}

    public func moduleWillTerminate(module: Module, context: ModuleContext) {}

    public func moduleDidReceiveMemoryWarning(module: Module, context: ModuleContext) {}

    public func moduleDidReceiveCustomEvent(module: Module, context: ModuleContext, eventName: String, eventParam: [String: Any]?) {}
}
