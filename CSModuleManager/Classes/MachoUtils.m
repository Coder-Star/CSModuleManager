//
//  MachoUtils.m
//  CSModuleManager
//
//  Created by CoderStar on 2022/11/25.
//

#import "MachoUtils.h"
#include <mach-o/dyld.h>
#import <objc/runtime.h>
#import <dlfcn.h>
#import <mach-o/getsect.h>
#import <mach/mach.h>

#pragma mark - 查询

void enumerateClassesInImageWithHeader(const mach_header_xx *mh, void(^handler)(Class __unsafe_unretained aClass)) {
    if (handler == nil) {
        return;
    }
#ifndef __LP64__
    const struct section *section = getsectbynamefromheader(mh, "__DATA", "__objc_classlist");
    if (section == NULL) {
        section = getsectbynamefromheader(mh, "__DATA_CONST", "__objc_classlist");
    }
    if (section == NULL) {
        return;
    }
    uint32_t size = section->size;
#else
    const struct section_64 *section = getsectbynamefromheader_64(mh, "__DATA", "__objc_classlist");
    if (section == NULL) {
        section = getsectbynamefromheader_64(mh, "__DATA_CONST", "__objc_classlist");
    }
    if (section == NULL) {
        return;
    }
    uint64_t size = section->size;
#endif
    
    char *imageBaseAddress = (char *)mh;
    Class *classReferences = (Class *)(void *)(imageBaseAddress + ((uintptr_t)section->offset&0xffffffff));
    for (unsigned long i = 0; i < size/sizeof(void *); i++) {
        Class aClass = classReferences[i];
        if (aClass) {
            handler(aClass);
        }
    }
}

void enumerateImageHeader(void(^handler)(const mach_header_xx *mh, const char *path)) {
    if (handler == nil) {
        return;
    }
    for (uint32_t i = 0, count = _dyld_image_count(); i < count; i++) {
        handler((const mach_header_xx *)_dyld_get_image_header(i), _dyld_get_image_name(i));
    }
}


void enumerateClasses(bool isMainBundle, void(^handler)(__unsafe_unretained Class aClass)) {
    if (handler == nil) {
        return;
    }
    
    enumerateImageHeader(^(const mach_header_xx *mh, const char *path) {
        if (strstr(path, "/System/Library/") != NULL ||
            strstr(path, "/usr/") != NULL ||
            strstr(path, ".dylib") != NULL) {
            return;
        }
        
        if (isMainBundle) {
            NSString *mainBundlePath = [NSBundle mainBundle].executablePath;
            if (strcmp(path, mainBundlePath.UTF8String) != 0) {
                return;
            }
        }
        
        enumerateClassesInImageWithHeader(mh, ^(__unsafe_unretained Class aClass) {
            handler(aClass);
        });
    });
}

#pragma mark - 检查

typedef struct objc_cache *Cache;

typedef struct class_t {
    const struct class_t *isa;
    const struct class_t *superclass;
    const Cache cache;
    const IMP *vtable;
    const uintptr_t data_NEVER_USE;
} class_t;

/// 检查是否是可以读到父类
static BOOL canReadSuperclassOfClass(Class aClass) {
    class_t *cls = (__bridge class_t *)aClass;
    uintptr_t superClassAddr = (uintptr_t)cls + sizeof(class_t *);
    uintptr_t superClass;
    vm_size_t size;
    kern_return_t result = vm_read_overwrite(mach_task_self(), superClassAddr, sizeof(void*), (vm_address_t)&superClass, &size);
    if (result != KERN_SUCCESS) {
        return NO;
    }
    return YES;
}

BOOL canEnumerateClasses() {
    if (canReadSuperclassOfClass([NSObject class]) == NO) {
        return NO;
    }
    NSString *mainBundlePath = [NSBundle mainBundle].executablePath;
    for (uint32_t i = 0, count = _dyld_image_count(); i < count; i++) {
        const char *path = _dyld_get_image_name(i);
        if (strcmp(path, mainBundlePath.UTF8String) == 0) {
            const mach_header_xx *mh = (const mach_header_xx *)_dyld_get_image_header(i);
#ifndef __LP64__
            const struct section *section = getsectbynamefromheader(mh, "__DATA", "__objc_classlist");
            if (section == NULL) {
                section = getsectbynamefromheader(mh, "__DATA_CONST", "__objc_classlist");
            }
            if (section == NULL) {
                return NO;
            }
            uint32_t size = section->size;
#else
            const struct section_64 *section = getsectbynamefromheader_64(mh, "__DATA", "__objc_classlist");
            if (section == NULL) {
                section = getsectbynamefromheader_64(mh, "__DATA_CONST", "__objc_classlist");
            }
            if (section == NULL) {
                return NO;
            }
            uint64_t size = section->size;
#endif
            if (size > 0) {
                char *imageBaseAddress = (char *)mh;
                Class *classReferences = (Class *)(void *)(imageBaseAddress + ((uintptr_t)section->offset&0xffffffff));
                Class firstClass = classReferences[0];
                if (canReadSuperclassOfClass(firstClass) == NO) {
                    return NO;
                }
            }
            break;
        }
    }
    return YES;
}




