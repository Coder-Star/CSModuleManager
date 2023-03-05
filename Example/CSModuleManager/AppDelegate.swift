//
//  AppDelegate.swift
//  CSModuleManager
//
//  Created by CoderStar on 02/11/2023.
//  Copyright (c) 2023 CoderStar. All rights reserved.
//

import UIKit
import CSModuleManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        /// 自动扫描并注册所有的模块
        ModuleManager.shared.autoRegisterAllModules()

        /// 首帧需要启动的模块
        /// 提前进行load
        for item in ModuleManager.shared.modules where item.name == "OneModule" {
            ModuleManager.shared.load(module: item)
            break
        }

        print("didFinishLaunchingWithOptions 执行完毕")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


// MARK: - 示例

/// 继承 ScannableModule 便会自动被扫描
class OneModule: ScannableModule {
    static func moduleOptions() -> [ModuleOptionsItem] {
        return [.name(name: "OneModule")]
    }

    func moduleDidFinishLaunch(module: Module, context: ModuleContext) {
        print("OneModule moduleDidFinishLaunch")
        print("context.application \(context.application as Any)")
        print("context.launchOptions \(context.launchOptions as Any)")
    }
}
