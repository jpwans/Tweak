//
//  DeviceInfoCenter.m
//  NewTest
//
//  Created by Tony on 6/20/15.
//
//

#import "DeviceInfoCenter.h"
#import <UIKit/UIKit.h>
#include <CommonCrypto/CommonDigest.h>

@interface DeviceInfoCenter (private)

- (void)fetchDeviceType;
- (void)fetchSerialNumber;

@end

@implementation DeviceInfoCenter

+ (DeviceInfoCenter *)sharedInstance {
    
    static DeviceInfoCenter *instance = nil;
    static dispatch_once_t once_t;
    
    dispatch_once(&once_t, ^{
        
        instance = [[DeviceInfoCenter alloc] init];
    });
    
    return instance;
}

- (id)init {
    
    self = [super init];
    
    if (self) {

        NSLog(@"get device info");
        [self fetchDeviceType];
        [self fetchSerialNumber];
        

        
        //os version
        
        self.osVersion  = [[[UIDevice currentDevice] systemVersion] floatValue];
        
        CGRect screen = [UIScreen mainScreen].bounds;
        self.screenScale    = [[UIScreen mainScreen] scale];
        self.screenWidth    = screen.size.width * self.screenScale;
        self.screenHeight   = screen.size.height * self.screenScale;
        
        self.deviceName     = [[UIDevice currentDevice] name];
    }
    
    return self;
}

- (void)dealloc {
    
//    [self->_serialnumber release];
//    [self->_safeSerialNumber release];
//    
//    [self->_batterysn release];
//    [self->_safeBatterysn release];
//    
//    [super dealloc];
}

#pragma mark private

- (void)fetchDeviceType {
    
    UIDevice *device = [UIDevice currentDevice];
    
    if ([device.model compare:@"iPod touch"]) {
        
        if ([device.model compare:@"iPhone"]) {
            
            
            if ([device.model compare:@"iPad"] == 0) {
                
                self.deviceType = 2;
            }
            
        }
        else {
            
            self.deviceType = 1;
        }
    }
    else
    {
        self.deviceType = 0;
    }
    
}

- (void)fetchSerialNumber {
    
    NSString *serialNumber = @"FFFFFF";
    NSString *batter = @"000000";
    
    UIDevice *device = [UIDevice currentDevice];
    
    NSString *sn = [device serialnumber];
    
    if (sn) {
        
        serialNumber = sn;
    }
    
    NSLog(@"serialnumber:%@",serialNumber);
    self.serialnumber = serialNumber;
    
    NSString *bs = [device batterysn];
    
    if (bs) {
        batter = bs;
    }
    
    NSLog(@"batter:%@",batter);
    
    NSString *mixed = [NSString stringWithFormat:@"%@:%@",sn,bs];
    
    self.safeSerialNumber = [self encrypt:mixed];
    self.safeBatterysn  = [self encrypt:mixed];
    
}

- (NSString *)encrypt:(NSString *)str {

//    [str retain];
    const char *strPtr = [str UTF8String];

    CC_LONG length = (CC_LONG)strlen(strPtr);
    unsigned char md5Str[16];
    CC_MD5(strPtr, length, md5Str);
//    NSString *safeStr = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
//                         md5Str[0],md5Str[1],md5Str[2],md5Str[3],
//                         md5Str[4],md5Str[5],md5Str[6],md5Str[7],
//                         md5Str[8],md5Str[9],md5Str[10],md5Str[11],
//                         md5Str[12],md5Str[13],md5Str[14],md5Str[15]];
//    NSString *safeStr = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
//                         md5Str[8],md5Str[9],md5Str[10],md5Str[11],
//                         md5Str[4],md5Str[5],md5Str[6],md5Str[7],
//                         md5Str[0],md5Str[1],md5Str[2],md5Str[3],
//                         md5Str[12],md5Str[13],md5Str[14],md5Str[15]];
    NSString *safeStr = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                         md5Str[8],md5Str[9],md5Str[10],md5Str[11],
                         md5Str[4],md5Str[5],md5Str[6],md5Str[7],
                         md5Str[0],md5Str[1],md5Str[2],md5Str[3]];

    NSLog(@"safeStr:%@",safeStr);
//    [str release];
    return safeStr;
}

@end
