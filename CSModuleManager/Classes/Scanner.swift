//
//  Scanner.swift
//  CSModuleManager
//
//  Created by CoderStar on 2022/11/25.
//

import Foundation

/// 扫描策略协议
public protocol ClassScannableStrategy {
    var types: [AnyClass] { get set }

    /// 是否符合指定要求
    func isMatched(anyClass: AnyClass) -> Bool

    /// 对符合指定要求的类进行处理
    func handle(anyClass: AnyClass)
}

public class Scanner {
    /// 扫描
    /// - Parameter strategies: 扫描策略
    public static func scan(strategies: [ClassScannableStrategy]) {
        if canEnumerateClassesInImage() {
            /// 快速查找
            enumerateClassesInMainBundle { type in
                for strategy in strategies {
                    if strategy.isMatched(anyClass: type) {
                        strategy.handle(anyClass: type)
                    }
                }
            }
        } else {
            /// 慢速查找
            let typeCount = Int(objc_getClassList(nil, 0))
            if typeCount > 0 {
                let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
                defer {
                    types.deallocate()
                }

                let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
                objc_getClassList(autoreleasingTypes, Int32(typeCount))

                for index in 0 ..< typeCount {
                    let type: AnyClass = types[index]
                    for strategy in strategies {
                        if strategy.isMatched(anyClass: type) {
                            strategy.handle(anyClass: type)
                        }
                    }
                }
            }
        }
    }
}
