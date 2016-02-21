//
//  CustomNavigationController.m
//  ILoveAssistant
//
//  Created by MoPellet on 15/9/7.
//
//

#import "CustomNavigationController.h"

@implementation CustomNavigationController


-(instancetype)initWithRootViewController:(UIViewController *)rootViewController{

    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self setNavigationBarHidden:YES animated:YES];
     }
    return self;
}



-(BOOL)shouldAutorotate
{
    return NO;
    
}


-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait  ;
}


@end
