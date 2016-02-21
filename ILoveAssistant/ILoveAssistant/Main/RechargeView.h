//
//  RechargeView.h
//  AssistantUI
//
//  Created by MoPellet on 15/9/22.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RechargeView : BaseView<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardNoTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardPwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *sumitButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@end
