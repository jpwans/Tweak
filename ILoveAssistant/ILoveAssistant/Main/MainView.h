//
//  MainView.h
//  AssistantUI
//
//  Created by MoPellet on 15/9/22.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "BaseView.h"

@interface MainView : BaseView<QCheckBoxDelegate>
{
@public
    int isThread;//是否开启
}
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UILabel *showTime;
@property (weak, nonatomic) IBOutlet UISwitch *switchOpen;
- (IBAction)switchAction:(UISwitch *)sender;
- (IBAction)stepperAction:(UIStepper *)sender;
@property (weak, nonatomic) IBOutlet UIButton *hideButton;
- (IBAction)hideAction:(UIButton *)sender;

- (void) threadsale;//新线程
- (void) threadsale2;//新线程


- (NSString *)appBundlePath:(NSString *)appBid;

//新增
@property (weak, nonatomic) IBOutlet UISwitch *switchUpgrade;
@property (weak, nonatomic) IBOutlet UIButton *buildingListButton;
- (IBAction)buildingAction:(UIButton *)sender;
- (IBAction)upgradeAction:(UISwitch *)sender;//开关

@end
