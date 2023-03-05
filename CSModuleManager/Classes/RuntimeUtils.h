//
//  NCRuntimeUtils.h
//  NCModuleManager
//
//  Created by CoderStar on 2022/11/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 检查是否可以扫描 macho
FOUNDATION_EXTERN BOOL canEnumerateClassesInImage(void);

/// 扫描macho，获取所有的class
FOUNDATION_EXTERN void enumerateClassesInMainBundle(void(^handler)(__unsafe_unretained Class aClass));

NS_ASSUME_NONNULL_END
