//
//  CustomButton.m
//  AssistantUI
//
//  Created by MoPellet on 15/9/22.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton



- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:255/255.0f green:164/255.0f blue:116/255.0f alpha:1.0f];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 6.0;
        [self setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        [self setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    }
    return self;
}

-(void)setHighlighted:(BOOL)highlighted{
    
}


@end
