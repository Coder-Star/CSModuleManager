//
//  MachoUtils.h
//  CSModuleManager
//
//  Created by CoderStar on 2022/11/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#ifndef __LP64__
typedef struct mach_header mach_header_xx;
#else
typedef struct mach_header_64 mach_header_xx;
#endif

/// 检查是否可以扫描 macho
/// 防止macho结构发生变化，启发性检测
FOUNDATION_EXTERN BOOL canEnumerateClasses(void);

/// 遍历镜像image的__objc_classlist
FOUNDATION_EXTERN void enumerateClassesInImageWithHeader(const mach_header_xx *mh, void(^handler)(Class __unsafe_unretained aClass));


/// 扫描macho
/// 遍历 __objc_classlist
FOUNDATION_EXTERN void enumerateClasses(bool isMainBundle, void(^handler)(__unsafe_unretained Class aClass));


NS_ASSUME_NONNULL_END
