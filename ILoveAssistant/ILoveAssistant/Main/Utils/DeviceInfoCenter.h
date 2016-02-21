//
//  DeviceInfoCenter.h
//  NewTest
//
//  Created by Tony on 6/20/15.
//
//

#import <Foundation/Foundation.h>
#import "UIDevice_IOKit_Extensions.h"

@interface DeviceInfoCenter : NSObject

@property (nonatomic, assign) int deviceType;
@property (nonatomic, retain) NSString *serialnumber;
@property (nonatomic, retain) NSString *safeSerialNumber;
@property (nonatomic, retain) NSString *batterysn;
@property (nonatomic, retain) NSString *safeBatterysn;
@property (nonatomic, assign) CGFloat osVersion;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) CGFloat screenScale;
@property (nonatomic, strong) NSString *deviceName;

+ (DeviceInfoCenter *)sharedInstance;
- (NSString *)encrypt:(NSString *)str;

@end
