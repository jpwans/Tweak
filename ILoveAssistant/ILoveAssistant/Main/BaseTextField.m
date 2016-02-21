//
//  BaseTextField.m
//  AssistantUI
//
//  Created by MoPellet on 15/9/22.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "BaseTextField.h"

@implementation BaseTextField

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.delegate = self;
        self.textAlignment = NSTextAlignmentCenter;
         [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
      self.maxLength = 16;
    }
    return self;
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

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self) {
        if (textField.text.length > self.maxLength) {
            textField.text = [textField.text substringToIndex:self.maxLength];
        }
    }
}


@end
