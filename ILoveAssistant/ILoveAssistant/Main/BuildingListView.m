//
//  BuildingListView.m
//  AssistantUI
//
//  Created by Pellet Mo on 15/9/26.
//  Copyright © 2015年 MoPellt. All rights reserved.
//

#import "BuildingListView.h"

@implementation BuildingListView

-(void)awakeFromNib{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:nil];
    [self addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.adjustsImageWhenHighlighted= NO;
    [closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat closeBtnX = self.bounds.size.width -20;
    CGFloat closeBtnY =5;
    closeBtn .frame = CGRectMake(closeBtnX, closeBtnY, 16, 16);
        [closeBtn setImage:[UIFactory imageNamed:@"closes"] forState:UIControlStateNormal];
//    [closeBtn setImage:[UIImage imageNamed:@"closes"] forState:UIControlStateNormal];
    [self addSubview:closeBtn];
}

-(void)closeAction:(UIButton *)button{
    self.upgradeBuildingListUITableView.editing = NO;
    [AppStatusCenter sharedInstance].buildingOpen = NO;
    self.hidden = ![AppStatusCenter sharedInstance].buildingOpen;
}

@end
