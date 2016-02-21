//
//  BaseTextField.h
//  AssistantUI
//
//  Created by MoPellet on 15/9/22.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTextField : UITextField<UITextFieldDelegate>
@property(nonatomic,assign)   NSInteger   maxLength;
@end
