//
//  BaseView.m
//  AssistantUI
//
//  Created by MoPellet on 15/9/22.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 6.0;
        self.backgroundColor = rgb(250, 231, 181);
    }
    return self;
}



@end
