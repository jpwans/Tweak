
#import <UIKit/UIKit.h>
@protocol AssistiveTouchDelegate;
@interface AssistiveTouch : UIView
{
    UIImageView *_imageView;
}
@property(nonatomic,assign)BOOL isShowMenu;
@property(nonatomic,unsafe_unretained)id<AssistiveTouchDelegate> assistiveDelegate;
-(id)initWithFrame:(CGRect)frame ;
@end

@protocol AssistiveTouchDelegate <NSObject>
@optional
//悬浮窗点击事件
-(void)assistiveTocuhs;
@end
