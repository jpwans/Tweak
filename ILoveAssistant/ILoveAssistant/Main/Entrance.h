//
//  Entrance.h
//  ILoveAssistant
//
//  Created by MoPellet on 15/8/24.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RootNavViewController.h"
@interface Entrance : NSObject
+ (id)sharedInstance;
@property (nonatomic, assign, getter=isLoaded) BOOL loaded;
-(void)registerNotifications;
- (void)didBecomeKeyWindow:(NSNotification *)noti;
@property (strong, nonatomic) RootNavViewController *rootNavViewController;
@end
