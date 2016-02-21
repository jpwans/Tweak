//
//  AssistantWindow.m
//  ILoveAssistant
//
//  Created by MoPellet on 15/8/25.
//
//

#import "AssistantWindow.h"
#import "PassEventView.h"
@implementation AssistantWindow


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    
    UIView *view = [super hitTest:point withEvent:event];
    NSLog(@"view:%@ event:%@",view,event);
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:view];
    
    NSLog(@"view.hidden:%d touchPoint:%@",view.hidden,NSStringFromCGPoint(touchPoint));
    
    
    //3.如果touch到了controller.view 就返回nil把事件传递到下层window.refer:http://stackoverflow.com/questions/14740921/passing-touches-between-stacked-uiwindows
    if (view == self.rootViewController.view || view.hidden == YES) {
        
        return nil;
    }
    else if ([view isKindOfClass:[PassEventView class]]) {
        PassEventView *passView = (PassEventView *)view;
        
        if (passView.passTouchEvents == YES) {
            return nil;
        }
        else
        {
            return view;
        }
    }
    return view;
}

//-
//- (BOOL)shouldAutorotate{
//    return NO;
//}

//-(NSUInteger)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskPortrait;
//}
//-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    return UIInterfaceOrientationPortrait  ;
//}



@end
