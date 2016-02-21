
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Define.h"

@interface UIFactory : NSObject

+ (UIImage *)imageNamed:(NSString *)imageName;

+ (UILabel *)createLabelWithFrame:(CGRect)frame
                             text:(NSString *)text
                        textColor:(UIColor *)textColor
                             font:(UIFont *)font
                          bgColor:(UIColor *)bgColor;

+ (UIButton *)createButtonWithFrame:(CGRect)frame
                              title:(NSString *)title
                         titleColor:(UIColor *)color
                             target:(id)target
                             action:(SEL)selector;

+ (UIButton *)createButtonWithFrame:(CGRect )frame
                              title:(NSString *)title
                         titleColor:(UIColor *)color
                        normalImage:(NSString *)normalImage
                     highLightImage:(NSString *)highLightImage
                             target:(id)target
                             action:(SEL)selector;

+ (UIButton *)createButtonWithFrame:(CGRect )frame
                              title:(NSString *)title
                         titleColor:(UIColor *)color
                      normalBgImage:(NSString *)normalBgImage
                   highLightBgImage:(NSString *)highLightBgImage
                             target:(id)target
                             action:(SEL)selector;

+ (UIView *)loadViewWithNibName:(NSString *)nibName owner:(id)owner;
+ (UIViewController *)loadViewControllerWithNibName:(NSString *)nibName owner:(id)owner;

+(UIStoryboard *)loadStoryboardWithNibNmae:(NSString *)nibName owner:(id)owner;
@end
