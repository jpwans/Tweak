//
//  BalanceView.m
//  AssistantUI
//
//  Created by MoPellet on 15/9/22.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "BalanceView.h"

@implementation BalanceView
-(void)awakeFromNib{
    
    self.accountTextField.delegate =self;
    
    [[AppStatusCenter sharedInstance]addStyle:self.queryButton];
    [[AppStatusCenter sharedInstance] addStyle:self.closeButton];
}


- (IBAction)queryAction:(id)sender {
    NSLog(@"queryAction");
    
    if (self.accountTextField.text.length<=0) {
        NSLog(@"查询账号不能为空");
        return;
    }
    struct tCommand csend;
    memset(&csend,0 ,sizeof(csend) );
    GetRandom(csend.key);//生成客户端的key
    NSLog(@"----------------------key:%s",csend.key);
    strncpy(mkey,csend.key,16);
    csend.commandType=CM5;//命令类型 CM5;查询余额
    strncpy(csend.ye.sUser,[self.accountTextField.text UTF8String],16);
    strncpy(user,csend.ye.sUser,16);
    encryptLen((unsigned long*)&csend,(unsigned long*)&csend.key,72);
    NSData * data = [NSData dataWithBytes:(char*)&csend length:88];
    [[SocketHelper sharedInstance] startSocketWith:data ];

}
- (IBAction)closeAction:(id)sender {
    [self removeFromSuperview];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==self.accountTextField) {
        [self queryAction:nil];
    }
    return YES;
}
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
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.accountTextField) {
        if (textField.text.length > 16) {
            textField.text = [textField.text substringToIndex:16];
        }
    }
}
@end
