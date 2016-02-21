//
//  HomeView.m
//  AssistantUI
//
//  Created by MoPellet on 15/9/22.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "HomeView.h"
#import "RegisterView.h"
#import "BalanceView.h"
#import "RechargeView.h"
#import "ReplaceBindingView.h"
#import "MainView.h"
@interface HomeView()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) RegisterView *registerView;
@property (strong, nonatomic) BalanceView *balanceView;
@property(strong,nonatomic)RechargeView *rechargeView;
@property(strong,nonatomic)ReplaceBindingView *replaceBindingView;
@property(strong,nonatomic)MainView *mainView;
@end

@implementation HomeView

-(void)awakeFromNib{
    NSLog(@"awakeFromNib 加载。。。");
    [NotificationCenter addObserver:self selector:@selector(showMainView:) name:Notif_LoginSuccess object:nil];
    
    [[AppStatusCenter sharedInstance]addStyle:self.rigisterButton];
    [[AppStatusCenter sharedInstance]addStyle:self.balanceButton];
    [[AppStatusCenter sharedInstance]addStyle:self.rechargeButton];
    [[AppStatusCenter sharedInstance]addStyle:self.bindingButton];
    [[AppStatusCenter sharedInstance]addStyle:self.submitButton];
    [[AppStatusCenter sharedInstance]addStyle:self.closeButton];

    NSString *user = [[NSUserDefaults standardUserDefaults]  objectForKey:@"tweakUser"];
    NSString *pwd = [[NSUserDefaults standardUserDefaults]  objectForKey:@"tweakPwd"];

    if (user.length &&pwd.length) {
        [self.accountTextField setText:user];
        [self.passwordTextField setText:pwd];
    }

    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.adjustsImageWhenHighlighted= NO;
    [closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat closeBtnX = self.bounds.size.width -20;
      CGFloat closeBtnY =5;
    closeBtn .frame = CGRectMake(closeBtnX, closeBtnY, 16, 16);
    [closeBtn setImage:[UIFactory imageNamed:@"closes"] forState:UIControlStateNormal];
    [self addSubview:closeBtn];
    
    //10.07
    self.accountTextField.textAlignment = NSTextAlignmentCenter;
    self.passwordTextField.textAlignment = NSTextAlignmentCenter;
    self.accountTextField.delegate = self;
    self.passwordTextField.delegate = self;

}
//10.07
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.textAlignment= NSTextAlignmentLeft;
    CATransition *animation = [CATransition animation];
    [animation setDuration:1.0];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [animation setType:@"rippleEffect"];// rippleEffect
    [animation setSubtype:kCATransitionFromTop];
    [textField.layer addAnimation:animation forKey:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    textField.textAlignment= NSTextAlignmentCenter;
    CATransition *animation = [CATransition animation];
    [animation setDuration:1.0];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [animation setType:@"rippleEffect"];// rippleEffect
    [animation setSubtype:kCATransitionFromTop];
    [textField.layer addAnimation:animation forKey:nil];
}

#pragma mark buttonActions
/**
 *登陆
 */
- (IBAction)loginAction:(id)sender {
    [self endEditing:YES];
    //    [NotificationCenter addObserver:self selector:@selector(showMainView:) name:Notif_LoginSuccess object:nil];
    
    if (_accountTextField.text.length<=0 || _passwordTextField.text.length<=0) {
        return;
    }
    NSLog(@"loginAction");
    NSString *safeSerialNumber =  [[DeviceInfoCenter sharedInstance] safeSerialNumber];
    NSLog(@"--------safeSerialNumber:%@",safeSerialNumber);
    struct tCommand csend;
    memset(&csend,0 ,sizeof(csend) );
    GetRandom(csend.key);//生成客户端的key
    csend.commandType=CM7;//命令类型 登录
    NSLog(@"accountTextField:%@",self.accountTextField.text);
    NSLog(@"accountTextField:%@",self.passwordTextField.text);
    strncpy(csend.login.sUser,[_accountTextField.text UTF8String],16);
    strncpy(csend.login.sPass,[_passwordTextField.text UTF8String],16);
    
    strncpy(csend.login.sBind,[safeSerialNumber UTF8String],32);
    
    strncpy(mkey,csend.key,16);//保存到单例
    strncpy(user,csend.ye.sUser,16);
    
    encryptLen((unsigned long*)&csend,(unsigned long*)&csend.key,72);
    NSData * data = [NSData dataWithBytes:(char*)&csend length:88];
    [[SocketHelper sharedInstance] startSocketWith:data ];
    
    
}


-(void)showMainView:(NSNotification *)note{
    NSLog(@"登陆成功进入主界面");
    
    
    [[NSUserDefaults standardUserDefaults] setObject:self.accountTextField.text forKey:@"tweakUser"];
    [[NSUserDefaults standardUserDefaults]  setObject:self.passwordTextField.text forKey:@"tweakPwd"];
    
    self.mainView  = (MainView *)[UIFactory loadViewWithNibName:@"MainView" owner:nil];
    //    self.mainView  = [[[NSBundle mainBundle] loadNibNamed:@"MainView" owner:nil options:nil] firstObject];
    self.mainView.frame = self.bounds;
    [self addSubview:self.mainView];
}



/**
 *关闭
 */
- (IBAction)closeAction:(id)sender {
    [self removeFromSuperview];
    [AppStatusCenter sharedInstance].open = NO;
    NSLog(@"打开状态：%d", [AppStatusCenter sharedInstance].isOpen);
    [NotificationCenter postNotificationName:Notif_RemoveSuperview object:nil];
}
/**
 *注册
 */
- (IBAction)registerAction:(id)sender {
    self.registerView  = (RegisterView *)[UIFactory loadViewWithNibName:@"RegisterView" owner:nil];
    //      self.registerView  = [[[NSBundle mainBundle] loadNibNamed:@"RegisterView" owner:nil options:nil] firstObject];
    self.registerView.frame = self.bounds;
    [self addSubview:self.registerView];
}
/**
 *余额
 */
- (IBAction)balanceAction:(id)sender {
    self.balanceView  = (BalanceView *)[UIFactory loadViewWithNibName:@"BalanceView" owner:nil];
    //    self.balanceView  = [[[NSBundle mainBundle] loadNibNamed:@"BalanceView" owner:nil options:nil] firstObject];
    self.balanceView.frame = self.bounds;
    [self addSubview:self.balanceView];
}
/**
 *充值
 */
- (IBAction)rechargeAction:(id)sender {
    self.rechargeView  = (RechargeView *)[UIFactory loadViewWithNibName:@"RechargeView" owner:nil];
    //    self.rechargeView  = [[[NSBundle mainBundle] loadNibNamed:@"RechargeView" owner:nil options:nil] firstObject];
    self.rechargeView.frame = self.bounds;
    [self addSubview:self.rechargeView];
}
/**
 *更换绑定
 */
- (IBAction)replaceBindingAction:(id)sender {
    self.replaceBindingView  = (ReplaceBindingView *)[UIFactory loadViewWithNibName:@"ReplaceBindingView" owner:nil];
    //    self.replaceBindingView  = [[[NSBundle mainBundle] loadNibNamed:@"ReplaceBindingView" owner:nil options:nil] firstObject];
    CGRect frame = self.bounds;
    frame.size.height = self.bounds.size.height*2;
    self.replaceBindingView.frame = self.bounds;
    [self addSubview:self.replaceBindingView];
}




@end
