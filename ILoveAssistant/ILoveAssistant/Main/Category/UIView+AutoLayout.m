

#import "UIView+AutoLayout.h"

@implementation UIView (AutoLayout)

- (void)equalToSuperViewEdge
{
    NSDictionary *viewDic = @{@"myView":self};
    [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[myView]|" options:0 metrics:0 views:viewDic]];
    [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[myView]|" options:0 metrics:0 views:viewDic]];
}

@end
