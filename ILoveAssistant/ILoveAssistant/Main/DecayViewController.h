

#import <UIKit/UIKit.h>
#import "PassEventView.h"
#import "QCheckBox.h"
@interface DecayViewController : UIViewController<UIAlertViewDelegate,QCheckBoxDelegate>
@property (nonatomic, strong) PassEventView *contentView;
@property (nonatomic, strong) UIView *loginView;
@property (nonatomic, strong) UIButton *deleteAngleButton;


@property (nonatomic, strong)  UITextField *accountTextField ;
@property (nonatomic, strong)  UITextField *passwordTextField ;

@property (nonatomic, strong) UIAlertView *registerView;
@property (nonatomic, strong) UIAlertView *balanceView;
@property (nonatomic, strong) UIView *rechargeView;
@property (nonatomic, strong) UIView *bindingView;
//@property(nonatomic,strong) UIView *homeView;

@property (nonatomic, strong) UITextField *userTextField;
@property (nonatomic, strong) UITextField *pwdTextField;
@property (nonatomic, strong) UITextField *cardNoField;
@property (nonatomic, strong) UITextField *cardPwdField;
@property (nonatomic, strong) UITextField *machineCodeField;
@property (nonatomic, strong) UITextField *nowMachineCodeField;
@end
