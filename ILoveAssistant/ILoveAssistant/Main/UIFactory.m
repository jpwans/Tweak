

#import "UIFactory.h"

@implementation UIFactory

+ (UIImage *)imageNamed:(NSString *)imageName
{
    UIImage *image = nil;
#if DEBUG_MODE

    image = [UIImage imageNamed:imageName];
#else
    
    NSBundle *bundle = [NSBundle bundleWithPath:kBundlePath];
    NSString *imagePathStr = [bundle pathForResource:[imageName stringByAppendingString:@"@2x"] ofType:@"png"];
        NSLog(@"imagePathStr:%@",imagePathStr);
    image = [UIImage imageWithContentsOfFile:imagePathStr];
        NSLog(@"image:%@",image);
#endif
    return image;
}

+ (UILabel *)createLabelWithFrame:(CGRect)frame
                             text:(NSString *)text
                        textColor:(UIColor *)textColor
                             font:(UIFont *)font
                          bgColor:(UIColor *)bgColor
{
    UILabel *label  = [[[UILabel alloc] initWithFrame:frame] autorelease];
    label.text      = text;
    if (textColor) {
        
        label.textColor = textColor;
    }
    if (bgColor) {
        label.backgroundColor   = bgColor;
    }
    if (font) {
        
        label.font      = font;
    }
    
    return label;
}

+ (UIButton *)createButtonWithFrame:(CGRect )frame
                              title:(NSString *)title
                         titleColor:(UIColor *)color
                        normalImage:(NSString *)normalImage
                     highLightImage:(NSString *)highLightImage
                             target:(id)target
                             action:(SEL)selector
{
    UIButton *button = [self createButtonWithFrame:frame
                                             title:title
                                        titleColor:color
                                            target:target
                                            action:selector];
    
    if (normalImage != nil) {
        
        [button setImage:[UIFactory imageNamed:normalImage] forState:UIControlStateNormal];
    }
    
    //    [button setImage:[UIFactory imageName:highLightImage] forState:UIControlStateHighlighted];
    
    button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    
    return button;
    
}

+ (UIButton *)createButtonWithFrame:(CGRect)frame
                              title:(NSString *)title
                         titleColor:(UIColor *)color
                      normalBgImage:(NSString *)normalBgImage
                   highLightBgImage:(NSString *)highLightBgImage
                             target:(id)target
                             action:(SEL)selector {
    
    UIButton *button = [self createButtonWithFrame:frame
                                             title:title
                                        titleColor:color
                                            target:target
                                            action:selector];
    if (normalBgImage != nil) {
        
        [button setBackgroundImage:[UIFactory imageNamed:normalBgImage] forState:UIControlStateNormal];
    }
    
    if (highLightBgImage != nil) {
        
        [button setBackgroundImage:[UIFactory imageNamed:highLightBgImage] forState:UIControlStateHighlighted];
    }
    
    button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    
    return button;
}

+ (UIButton *)createButtonWithFrame:(CGRect)frame
                              title:(NSString *)title
                         titleColor:(UIColor *)color
                             target:(id)target
                             action:(SEL)selector
{
    UIButton *button = [[[UIButton alloc] initWithFrame:frame] autorelease];
    
    UIColor *titleColor = color ? color : [UIColor blackColor];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+ (UIViewController *)loadViewControllerWithNibName:(NSString *)nibName owner:(id)owner {
    

#if DEBUG_MODE
    NSBundle *bundle    = [NSBundle mainBundle];
#else
    NSBundle *bundle = [NSBundle bundleWithPath:kNibsDundlePath];
#endif
    
    UIViewController *vc = [[((UIViewController *)[NSClassFromString(nibName) alloc]) init] autorelease];
    
    [bundle loadNibNamed:nibName owner:vc options:nil];
    
    [vc viewDidLoad];
    
    return vc;
}

+ (UIView *)loadViewWithNibName:(NSString *)nibName owner:(id)owner {
    
    
//#if DEBUG_MODE
//    NSBundle *bundle    = [NSBundle mainBundle];
//#else
    NSBundle *bundle = [NSBundle bundleWithPath:kNibsDundlePath];
//#endif 
    NSLog(@"bundle------%@",bundle);
//    UIView *vc = [[((UIView *)[NSClassFromString(nibName) alloc]) init] autorelease];
   
   UIView *vc  =  [[bundle loadNibNamed:nibName owner:nil options:nil] firstObject] ;
     NSLog(@"vc------%@",vc);
//    [vc awakeFromNib];
    NSLog(@"[vc awakeFromNib];");
    return vc;
}






+(UIStoryboard *)loadStoryboardWithNibNmae:(NSString *)nibName owner:(id)owner{
    
#if DEBUG_MODE
    NSBundle *bundle    = [NSBundle mainBundle];
#else
    NSBundle *bundle = [NSBundle bundleWithPath:kStoryboardDundlePath];
#endif
    
    UIStoryboard *storyboard =[[UIStoryboard storyboardWithName:nibName bundle:bundle] autorelease];
    
    return storyboard;
}
@end
