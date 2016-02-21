//
//  ReplaceBindingView.m
//  AssistantUI
//
//  Created by MoPellet on 15/9/22.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "ReplaceBindingView.h"

@implementation ReplaceBindingView

-(void)awakeFromNib{
    NSString * safeSerialNumber = [[DeviceInfoCenter sharedInstance] safeSerialNumber];
    self.currentBindingCode.text =safeSerialNumber ;
    self.accountTextField.delegate =self;

    [[AppStatusCenter sharedInstance ] addStyle:self.bindingButton];
    [[AppStatusCenter sharedInstance] addStyle:self.closeButton];
    
}

- (IBAction)replaceBindingAction:(id)sender {
    NSString *user =  self.accountTextField.text;
    NSString *pwd = self.passwordTextField.text;
    NSString *machineCode = self.oldBindingCode.text;
    NSString *nowMachineCode = self.currentBindingCode.text;
    NSString *urlText = [ NSString stringWithFormat:@"http://113.105.152.15:84/bindc.aspx?ss=%@&ss2=%@&ss3=%@&ss4=%@",user,pwd,machineCode,nowMachineCode];
    [ [ UIApplication sharedApplication] openURL:[ NSURL  URLWithString:urlText]];

}
- (IBAction)closeAction:(id)sender {
    [ self removeFromSuperview];
}


@end
