

#import "RootNavViewController.h"

@interface RootNavViewController ()

@property (nonatomic, assign) UIInterfaceOrientationMask interfaceOrientationMask;

@end

@implementation RootNavViewController
@synthesize interfaceOrientationMask= _interfaceOrientationMask;


-(instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self setNavigationBarHidden:YES animated:YES];
    }
    return self;
}
- (void)changeSupportedInterfaceOrientations:(UIInterfaceOrientationMask)interfaceOrientation{
    
    _interfaceOrientationMask = interfaceOrientation;
}

-(BOOL)shouldAutorotate{
    
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations{
    
    return _interfaceOrientationMask;
}

@end
