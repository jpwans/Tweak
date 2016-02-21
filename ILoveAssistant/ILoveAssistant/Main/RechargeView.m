//
//  RechargeView.m
//  AssistantUI
//
//  Created by MoPellet on 15/9/22.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "RechargeView.h"
@interface RechargeView ()

@end
@implementation RechargeView


-(void)awakeFromNib{
    
    self.cardNoTextField.delegate =self;
    self.cardPwdTextField.delegate =self;
    [self.cardNoTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.cardPwdTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    [self addStyle:self.sumitButton];
//    [self addStyle:self.closeButton];
    [[AppStatusCenter sharedInstance] addStyle:self.sumitButton];
    [[AppStatusCenter sharedInstance] addStyle:self.closeButton];
}

//-(void)addStyle:(UIButton *)button{
//    button.backgroundColor = [UIColor colorWithRed:255/255.0f green:164/255.0f blue:116/255.0f alpha:1.0f];
//    button.layer.masksToBounds = YES;
//    button.layer.cornerRadius = 6.0;
//    [button setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
//    [button setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
//}


- (IBAction)rechargeAction:(id)sender {
    NSLog(@"rechargeAction");
    
    struct tCommand csend;
    memset(&csend,0 ,sizeof(csend) );
    GetRandom(csend.key);//生成客户端的key
    csend.commandType=CM3;//命令类型 CM3;充值
    
    strncpy(csend.cz.sUser,[self.accountTextField.text UTF8String],16);
    strncpy(csend.cz.sCard,[self.cardNoTextField.text UTF8String],24);
    strncpy(csend.cz.sCardPass,[ self.cardPwdTextField.text UTF8String],24);
    
    strncpy(mkey,csend.key,16);//保存到单例
    
    encryptLen((unsigned long*)&csend,(unsigned long*)&csend.key,72);
    NSData * data = [NSData dataWithBytes:(char*)&csend length:88];
    [[SocketHelper sharedInstance] startSocketWith:data ];
 
}

- (IBAction)closeAction:(id)sender {
    [self  removeFromSuperview];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.cardNoTextField  || textField == self.cardPwdTextField ) {
        if (textField.text.length > 24) {
            textField.text = [textField.text substringToIndex:24];
        }
    }
}
#pragma mark textFieldDelegate
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==self.cardPwdTextField) {
        [self rechargeAction:nil];
    }
    return YES;
}


@end
