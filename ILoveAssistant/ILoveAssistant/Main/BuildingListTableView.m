//
//  BuildingListTableView.m
//  AssistantUI
//
//  Created by Pellet Mo on 15/9/26.
//  Copyright © 2015年 MoPellt. All rights reserved.
//

#import "BuildingListTableView.h"
@interface BuildingListTableView()
{
    CGFloat rowHight;
    CGFloat marginLeft ;
}
@end;
@implementation BuildingListTableView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.dataSource =self;
        self.delegate=self;
        self. separatorStyle =UITableViewCellSeparatorStyleNone;
//        self.bounces = NO;
        rowHight = 30;
        marginLeft = 10;
        self.backgroundColor = rgb(250, 231, 181);
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

/*设置标题头的宽度*/
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

/*设置标题头的名称*/
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lable = [UILabel new];
    [lable setText:@"当前现有建筑"];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:14];
    lable.backgroundColor = rgb(255, 174, 66);
    return lable;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return   [AppStatusCenter sharedInstance].buildingListArrays.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell =[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [AppStatusCenter sharedInstance].buildingListArrays[indexPath.row];
    cell.font=[UIFont systemFontOfSize:13];
    //画分割线
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(marginLeft, rowHight - 1, cell.bounds.size.width-marginLeft, 1.0f);
    bottomBorder.backgroundColor =[UIColor grayColor].CGColor;
    [cell.layer addSublayer:bottomBorder];
    //选择没状态
     cell.backgroundColor = rgb(250, 231, 181);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowHight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//选中
    NSLog(@"选中了");
//添加到更新的数组里面

    NSString *tempBuilding = [AppStatusCenter sharedInstance].buildingListArrays[indexPath.row];
    NSUInteger count = [AppStatusCenter  sharedInstance].upgradeBuildingListArrays.count;
    //避免重复添加
    for (int i = 0; i <count; i++ ) {
        if ([tempBuilding isEqualToString:[[AppStatusCenter sharedInstance].upgradeBuildingListArrays objectAtIndex:i]] ) {
            return;
        }
    }

    
//    [[AppStatusCenter sharedInstance] insetrBuildingtoupgradeBuildingListArrays:tempBuilding];
//      [[AppStatusCenter  sharedInstance].upgradeBuildingListArrays addObject:tempBuilding];
    NSMutableArray *mutaArray = [[NSMutableArray alloc] init];
    [mutaArray addObjectsFromArray:[AppStatusCenter sharedInstance].upgradeBuildingListArrays];
    
    [mutaArray addObject:tempBuilding];
    
    [AppStatusCenter sharedInstance] .upgradeBuildingListArrays = mutaArray;
    NSLog(@"upgradeBuildingListArrays:%@",[AppStatusCenter sharedInstance].upgradeBuildingListArrays);
    NSLog(@"temp:%@",tempBuilding);
    
    
//    [[AppStatusCenter sharedInstance].buildingListArrays removeObjectAtIndex:indexPath.row];//移除左边列表的
//    [self reloadData];  左边的不用移除
    
 
    //添加到偏好设置
    [[NSUserDefaults standardUserDefaults ] setObject:[AppStatusCenter sharedInstance].upgradeBuildingListArrays forKey:UpgradeKey];
    NSLog(@"NotificationCenter");
    #define Notif_ReloadData @"reloadData"
    [NotificationCenter postNotificationName:Notif_ReloadData object:nil];

}



@end
