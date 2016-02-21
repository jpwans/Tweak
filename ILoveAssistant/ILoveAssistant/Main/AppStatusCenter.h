

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface AppStatusCenter : NSObject
@property (nonatomic, assign,getter=isLoginSuccess) BOOL loginSuccess;
@property (nonatomic, assign,getter=isOpen) BOOL open;
@property (nonatomic, assign,getter=isShow) BOOL show; //显示或者隐藏  yes  隐藏  


@property (nonatomic,strong) NSMutableDictionary *checkDictionary;
+ (AppStatusCenter *)sharedInstance;

-(void)addStyle:(UIButton *)button;


//新增
@property (nonatomic,strong) NSMutableArray *buildingListArrays;//全部建筑列表
@property (nonatomic,strong) NSMutableArray *upgradeBuildingListArrays; //升级列表
//添加建筑到建筑列表
-(void)insetrBuildingtoBuildingListArrays:(NSString *)building;
//添加建筑到升级列表
-(void)insetrBuildingtoupgradeBuildingListArrays:(NSString *)building;


@property (nonatomic, assign,getter=isBuildingOpen) BOOL buildingOpen;
@end
