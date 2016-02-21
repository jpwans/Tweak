//
//  MoUncaughtExceptionHandler.h
//  ILoveAssistant
//
//  Created by MoPellet on 15/8/24.
//
//

#import <Foundation/Foundation.h>

@interface MoUncaughtExceptionHandler : NSObject
+ (void)setDefaultHandler;
+ (NSUncaughtExceptionHandler *)getHandler;
void uncaughtExceptionHandler(NSException *exception);
NSString * applicationDocumentsDirectory(void);
@end
