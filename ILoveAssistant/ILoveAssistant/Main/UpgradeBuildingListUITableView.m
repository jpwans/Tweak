//
//  UpgradeBuildingListUITableView.m
//  AssistantUI
//
//  Created by Pellet Mo on 15/9/26.
//  Copyright © 2015年 MoPellt. All rights reserved.
//

#import "UpgradeBuildingListUITableView.h"
@interface UpgradeBuildingListUITableView()
{
    CGFloat rowHight;
    CGFloat marginLeft ;
    BOOL gestureStatus;
}
@end;
@implementation UpgradeBuildingListUITableView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        #define Notif_ReloadData @"reloadData"
        [NotificationCenter addObserver:self selector:@selector(reloadData) name:Notif_ReloadData object:nil];

        self.dataSource =self;
        self.delegate=self;
        self. separatorStyle =UITableViewCellSeparatorStyleNone;
        //        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        rowHight = 30;
        marginLeft = 10;
        gestureStatus= NO;
        self.backgroundColor = rgb(250, 231, 181);
        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
        longPressGr.minimumPressDuration = 0.5;
        [self addGestureRecognizer:longPressGr];
    }
    return self;
}

/*长按进入编辑模式*/
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:self];
        NSIndexPath * indexPath = [self indexPathForRowAtPoint:point];
        if(indexPath == nil) return ;
        self.editing = YES;
        NSLog(@"----%@",        [AppStatusCenter sharedInstance ] .upgradeBuildingListArrays[indexPath.row]);
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return   [AppStatusCenter sharedInstance].upgradeBuildingListArrays.count;

}
/*设置标题头的高度*/
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

/*设置标题头的名称*/
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lable = [UILabel new];
    [lable setText:@"自动升级建筑"];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:14];
    lable.backgroundColor =     lable.backgroundColor = rgb(255, 174, 66);
    return lable;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell =[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [AppStatusCenter sharedInstance].upgradeBuildingListArrays[indexPath.row];
    cell.font=[UIFont systemFontOfSize:13];
    //画分割线
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(marginLeft, rowHight - 1, cell.bounds.size.width-marginLeft-marginLeft, 1.0f);
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

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    //选中
//    //
////    self.editing = !self.editing;
////    self.editing= YES;
//}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        //        获取选中删除行索引值
        NSInteger row = [indexPath row];
        NSLog(@"------%d ,删除:%@",row,[AppStatusCenter sharedInstance].upgradeBuildingListArrays);
        //        通过获取的索引值删除数组中的值
//        [[AppStatusCenter sharedInstance].upgradeBuildingListArrays removeObjectAtIndex:row];
//            NSLog(@"删除后:%@",[AppStatusCenter sharedInstance].upgradeBuildingListArrays);
        
        
        NSMutableArray *mutaArray = [[NSMutableArray alloc] init];
        [mutaArray addObjectsFromArray:[AppStatusCenter sharedInstance].upgradeBuildingListArrays];
        
        [mutaArray removeObjectAtIndex:row];
        
        [AppStatusCenter sharedInstance] .upgradeBuildingListArrays = mutaArray;
        
        
        
        [[NSUserDefaults standardUserDefaults] setObject:[AppStatusCenter sharedInstance].upgradeBuildingListArrays forKey:UpgradeKey];
        
        //        删除单元格的某一行时，在用动画效果实现删除过程
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
            [self animateWithEditing];
    }  
}
-(NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexpath{
return @"删除";
}

-(void)animateWithEditing{

    [UIView  animateWithDuration:0.3 animations:^{
        self.editing = NO;
    }];
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(BOOL)tableView:(UITableView *) tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //打开编辑
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSLog(@"sourceIndexPath:%ld",(long)sourceIndexPath.row);
    NSLog(@"destinationIndexPath:%ld",(long)destinationIndexPath.row);
        NSString *source=  [AppStatusCenter sharedInstance] .upgradeBuildingListArrays[sourceIndexPath.row];
    if (sourceIndexPath.row>destinationIndexPath.row) {//从下移到上
        [[AppStatusCenter sharedInstance] .upgradeBuildingListArrays insertObject:source atIndex:destinationIndexPath.row];
        
        [[AppStatusCenter sharedInstance] .upgradeBuildingListArrays removeObjectAtIndex:sourceIndexPath.row+1];

    }
    else if (sourceIndexPath.row<destinationIndexPath.row){//从上移到下
        [[AppStatusCenter sharedInstance] .upgradeBuildingListArrays removeObjectAtIndex:sourceIndexPath.row];
        [[AppStatusCenter sharedInstance] .upgradeBuildingListArrays insertObject:source atIndex:destinationIndexPath.row];
        
    
    }
    
        NSLog(@"%@",[AppStatusCenter sharedInstance] .upgradeBuildingListArrays );
    
    
    //交换数据

    [self animateWithEditing];
}


@end
