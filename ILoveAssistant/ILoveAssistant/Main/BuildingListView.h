//
//  BuildingListView.h
//  AssistantUI
//
//  Created by Pellet Mo on 15/9/26.
//  Copyright © 2015年 MoPellt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuildingListTableView.h"
#import "UpgradeBuildingListUITableView.h"
@interface BuildingListView : UIScrollView
@property (weak, nonatomic) IBOutlet BuildingListTableView *buildingListTableView;
@property (weak, nonatomic) IBOutlet UpgradeBuildingListUITableView *upgradeBuildingListUITableView;

@end
