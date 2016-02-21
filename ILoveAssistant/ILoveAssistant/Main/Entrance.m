//
//  Entrance.m
//  ILoveAssistant
//
//  Created by MoPellet on 15/8/24.
//
//

#import "Entrance.h"
#import "MoUncaughtExceptionHandler.h"
#import "AssistantWindow.h"
#import "CustomNavigationController.h"
#import "DecayViewController.h"
@implementation Entrance

+(id)sharedInstance{
    NSLog(@"sharedInstance");
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Entrance alloc] init];
    });
    return sharedInstance;
}

-(instancetype)init{
    [super init];
    NSLog(@"init");
    if (self) {
        [MoUncaughtExceptionHandler setDefaultHandler];
        [self registerNotifications];
    }
    return self;
}

-(void)registerNotifications{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeKeyWindow:) name:UIWindowDidBecomeKeyNotification object:nil];
    
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeKeyWindow:) name:UIWindowDidBecomeVisibleNotification object:nil];
    
    
}
- (void)didBecomeKeyWindow:(NSNotification *)noti
{
    if (self.isLoaded == NO) {
        NSLog(@"add window");
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIViewController *vc = [((UIViewController *)[NSClassFromString(@"DecayViewController") alloc]) init];

//            DecayViewController *vc = [[DecayViewController alloc] init];
//            CGRect frame = [UIScreen mainScreen].bounds;
//            NSLog(@"屏幕：%@",NSStringFromCGRect(frame));
//                    if ([UIScreen mainScreen].bounds.size.width>[UIScreen mainScreen].bounds.size.height) {
//                      frame =  CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
//                    }
//            
            
            AssistantWindow *assistantWindow = [[AssistantWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            assistantWindow.rootViewController   = vc;
            assistantWindow.backgroundColor   = [UIColor clearColor];
//               assistantWindow.backgroundColor   =     rgba(255, 255, 255, 0.5);;
       
            [assistantWindow setWindowLevel:1];
            [assistantWindow setHidden:NO];
            self.loaded   = YES;
        });
    }
}

@end
