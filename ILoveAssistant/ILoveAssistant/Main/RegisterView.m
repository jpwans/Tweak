//
//  RegisterView.m
//  AssistantUI
//
//  Created by MoPellet on 15/9/22.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "RegisterView.h"

@implementation RegisterView
-(void)awakeFromNib{

    //10.07
    self.accountTextField.textAlignment = NSTextAlignmentCenter;
    self.passwordTextField.textAlignment = NSTextAlignmentCenter;
    
    self.accountTextField.delegate =self;
    self.passwordTextField.delegate =self;
    
    [[AppStatusCenter sharedInstance] addStyle:self.registerButton];
    [[AppStatusCenter sharedInstance] addStyle:self.closeButton];
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

- (IBAction)registerAction:(id)sender {
    NSLog(@"registerAction");

    if (self.accountTextField.text.length<=0 ||self.passwordTextField.text.length<=0) {
        NSLog(@"账号或者这密码不能为空");
        return;
    }
    struct tCommand csend;
    memset(&csend,0 ,sizeof(csend) );
    GetRandom(csend.key);//生成客户端的key
    csend.commandType=CM1;//命令类型 注册
    
    strncpy(csend.login.sUser,[self.accountTextField.text UTF8String],16);
    strncpy(csend.login.sPass,[self.passwordTextField.text UTF8String],16);
    NSString *safeSerialNumber =  [[DeviceInfoCenter sharedInstance] safeSerialNumber];
    strncpy(csend.login.sBind,[safeSerialNumber UTF8String],32);
    
    strncpy(mkey,csend.key,16);//保存到单例
    strncpy(user,csend.ye.sUser,16);
    
    encryptLen((unsigned long*)&csend,(unsigned long*)&csend.key,72);
    NSData * data = [NSData dataWithBytes:(char*)&csend length:88];
    [[SocketHelper sharedInstance] startSocketWith:data ];
    
    
}
- (IBAction)closeAction:(id)sender {
    [self removeFromSuperview];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==_passwordTextField) {
        [self registerAction:nil];
    }
    return YES;
}
@end
