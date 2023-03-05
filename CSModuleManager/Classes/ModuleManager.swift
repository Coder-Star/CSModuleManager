//
//  ModuleManager.swift
//  CSModuleManager
//
//  Created by CoderStar on 2022/11/23.
//

import Foundation

/// 模块管理者
public class ModuleManager {
    public static let shared = ModuleManager()

    private var scannedClasses: [AnyClass] = []

    private init() {
        registerNotifications()
    }

    private var _modules: [Module] = []

    private let queue = DispatchQueue(label: "com.coderstar.modulemanager.lock", attributes: .concurrent)
}

extension ModuleManager {
    /// 自动注册所有符合协议的模块
    /// load 时机是接收到 UIApplication.didFinishLaunchingNotification 系统通知
    /// 所以默认注册时机是 didFinishLaunchingWithOptions 执行完毕，如果想提前这个时机，可以手动调用 load 方法
    public func autoRegisterAllModules() {
        let moduleScannableStrategy = ModuleScannableStrategy.shared
        if moduleScannableStrategy.types.isEmpty {
            Scanner.scan(strategies: [moduleScannableStrategy])
        }
        let scannedClasses = moduleScannableStrategy.types
        self.scannedClasses = scannedClasses
        for item in scannedClasses {
            if let module = item as? ModuleDelegate.Type {
                _ = register(delegate: module)
            }
        }
    }

    /// 加载指定模块
    /// 内部会实例化对象，并且调用 moduleDidFinishLaunch 代理
    /// - Parameter module: 模块
    /// - Returns: 模块是否加载成功，如果之前已经加载过，会返回false
    @discardableResult
    public func load(module: Module) -> Bool {
        if module.delegate == nil {
            module.delegate = module.options.delegateClass.init()
            module.delegate?.moduleDidFinishLaunch(module: module, context: ModuleContext.shared.copy())
            return true
        }
        return false
    }

    private func register(delegate: ModuleDelegate.Type) -> Module {
        let launchOptions = ModuleOptions(delegateClass: delegate, items: delegate.moduleOptions())
        let module = Module(options: launchOptions)
        addModule(with: module)
        return module
    }
}

extension ModuleManager {
    /// 触发自定义事件
    /// - Parameters:
    ///   - eventName: 事件名称
    ///   - eventParam: 事件参数
    public func triggerCustomEvent(eventName: String, eventParam: [String: Any]?) {
        for module in modules {
            module.delegate?.moduleDidReceiveCustomEvent(module: module, context: ModuleContext.shared.copy(), eventName: eventName, eventParam: eventParam)
        }
    }
}

/// 针对 modules 的 多读单写
extension ModuleManager {
    /// 已注册的模块
    public var modules: [Module] {
        queue.sync {
            _modules
        }
    }

    private func addModule(with module: Module) {
        queue.async(flags: [.barrier]) { [weak self] in
            guard let self = self else { return }
            self._modules.append(module)
        }
    }
}

// MARK: - 注册通知

extension ModuleManager {
    private func registerNotifications() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.didFinishLaunchingNotification,
            object: nil,
            queue: .main
        ) { notification in
            let application = notification.object as? UIApplication ?? UIApplication.shared
            let launchOptions = notification.userInfo as? [UIApplication.LaunchOptionsKey: Any]

            ModuleContext.shared.launchOptions = launchOptions
            ModuleContext.shared.application = application

            for module in self.modules {
                self.load(module: module)
            }
        }

        NotificationCenter.default.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: nil,
            queue: .main
        ) { _ in
            for module in self.modules {
                module.delegate?.moduleDidEnterBackground(module: module, context: ModuleContext.shared.copy())
            }
        }

        NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main
        ) { _ in
            for module in self.modules {
                module.delegate?.moduleWillEnterForeground(module: module, context: ModuleContext.shared.copy())
            }
        }

        NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: .main
        ) { _ in
            for module in self.modules {
                module.delegate?.moduleDidBecomeActive(module: module, context: ModuleContext.shared.copy())
            }
        }

        NotificationCenter.default.addObserver(
            forName: UIApplication.willResignActiveNotification,
            object: nil,
            queue: .main
        ) { _ in
            for module in self.modules {
                module.delegate?.moduleWillResignActive(module: module, context: ModuleContext.shared.copy())
            }
        }

        NotificationCenter.default.addObserver(
            forName: UIApplication.willTerminateNotification,
            object: nil,
            queue: .main
        ) { _ in
            for module in self.modules {
                module.delegate?.moduleWillTerminate(module: module, context: ModuleContext.shared.copy())
            }
        }

        NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil,
            queue: .main
        ) { _ in
            for module in self.modules {
                module.delegate?.moduleDidReceiveMemoryWarning(module: module, context: ModuleContext.shared.copy())
            }
        }
    }
}
