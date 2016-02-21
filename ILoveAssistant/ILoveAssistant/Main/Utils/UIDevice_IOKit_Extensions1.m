//
//  UIDevice+UIDevice_IOKit_Extensions_h.m
//  NewTest
//
//  Created by Tony on 6/20/15.
//
//

#import "UIDevice_IOKit_Extensions.h"
#include <mach/port.h>
#include <mach/mach_port.h>
#if TARGET_CPU_ARM
#import <IOKit/IOKitLib.h>
#endif
//#import "Config.h"

#if TARGET_CPU_ARM  //真机才有这个方法，不然编译模拟器编译报错
NSArray* getValue(NSString *key);

NSArray* getValue(NSString *key) {
    
    mach_port_name_t name = 0;

    if (!IOMasterPort(0,&name)) {
        
        io_registry_entry_t rootEntry = IORegistryGetRootEntry(name);
        if (rootEntry) {
            
            CFTypeRef typeRef = IORegistryEntrySearchCFProperty(rootEntry, "IODeviceTree", (__bridge CFStringRef)key, 0, 1);

            if (typeRef) {
                
                CFTypeID typeID = CFGetTypeID(typeRef);
                
                if (typeID == CFDataGetTypeID()) {
                    
                    NSUInteger length = (NSUInteger)CFDataGetLength((CFDataRef)typeRef);

                    if (length) {
                        
                        const void *ptr = CFDataGetBytePtr((CFDataRef)typeRef);
                        NSString *sn = [[NSString alloc] initWithBytes:ptr length:length encoding:NSUTF8StringEncoding];
                        mach_port_deallocate(mach_task_self(),name);
                        CFRelease(typeRef);
                        
                        return [sn componentsSeparatedByString:@"/0"];
                    }
                }
            }
        }
    }
    else {
        mach_port_deallocate(mach_task_self(), name);
    }
    return NULL;
}

#endif
@implementation UIDevice (UIDevice_IOKit_Extensions)

- (NSString *)serialnumber {
    
    NSString *result = @"00000000000";
#if    TARGET_CPU_ARM
    NSArray *arr = (NSArray *)getValue(@"serial-number");

    if (arr) {
        
        const char *sn = [[arr firstObject] UTF8String];
        result = [[NSString alloc] initWithCString:sn encoding:NSUTF8StringEncoding];
    }
#endif
    return result;
}

- (NSString *)batterysn {
    
#if    TARGET_CPU_ARM
    CFMutableDictionaryRef dic = IOServiceMatching("IOPMPowerSource");
    io_service_t server = IOServiceGetMatchingService(kIOMasterPortDefault,dic);
    
    kern_return_t krt = IORegistryEntryCreateCFProperties(server, &dic, 0, 0);
    
    NSString *serial = CFDictionaryGetValue(dic, CFSTR("Serial"));
    
    NSString *serialStr = [NSString stringWithString:serial];
    
    if (serialStr == nil) {
        
        serialStr = @"";
    }
    
    CFRelease(dic);
    IOObjectRelease(server);
    
    
    return serialStr;
#else
    return nil;
#endif
}

@end
