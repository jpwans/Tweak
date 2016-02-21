
#import "AppStatusCenter.h"

@implementation AppStatusCenter
+ (id)sharedInstance
{
    static id sharedInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AppStatusCenter alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.checkDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}



-(void)addStyle:(UIButton *)button{
    button.backgroundColor = [UIColor colorWithRed:255/255.0f green:164/255.0f blue:116/255.0f alpha:1.0f];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 6.0;
    [button setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [button setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
}




//添加建筑到建筑列表
-(void)insetrBuildingtoBuildingListArrays:(NSString *)building{
    [[AppStatusCenter  sharedInstance].buildingListArrays addObject:building];
}

//添加建筑到升级列表
-(void)insetrBuildingtoupgradeBuildingListArrays:(NSString *)building{
    [[AppStatusCenter  sharedInstance].upgradeBuildingListArrays addObject:building];
}

@end
