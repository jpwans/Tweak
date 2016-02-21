//
//  ReplaceBindingView.h
//  AssistantUI
//
//  Created by MoPellet on 15/9/22.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "BaseView.h"

@interface ReplaceBindingView : BaseView<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *oldBindingCode;
@property (weak, nonatomic) IBOutlet UITextField *currentBindingCode;

@property (weak, nonatomic) IBOutlet UIButton *bindingButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@end
