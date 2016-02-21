

#import "UIButton+Helper.h"
#import "UIFactory.h"

@implementation UIButton (Helper)

- (void)setBtnNormalBGImage:(NSString *)normalBGImageName highlightBGImage:(NSString *)highlightBGImageName {
    
    if (normalBGImageName) {
        
        UIImage *image = [UIFactory imageNamed:normalBGImageName];
        
        [self setBackgroundImage:image forState:UIControlStateNormal];
    }
    
    if (highlightBGImageName) {
        
        UIImage *image = [UIFactory imageNamed:highlightBGImageName];
        
        [self setBackgroundImage:image forState:UIControlStateHighlighted];
    }
}

- (void)setBtnNormalImage:(NSString *)normalImageName highlightImage:(NSString *)highlightImageName {
    
    if (normalImageName) {
        
        UIImage *image = [UIFactory imageNamed:normalImageName];
        
        [self setBackgroundImage:image forState:UIControlStateNormal];
    }
    
    if (highlightImageName) {
        
        UIImage *image = [UIFactory imageNamed:highlightImageName];
        
        [self setBackgroundImage:image forState:UIControlStateHighlighted];
    }
    
}

@end
