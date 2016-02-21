//
//  MainView.m
//  AssistantUI
//
//  Created by MoPellet on 15/9/22.
//  Copyright (c) 2015年 MoPellt. All rights reserved.
//

#import "MainView.h"
#import "STLibrary.h"

#import "myfun.h"


@interface MainView ()
@property(nonatomic,strong)UIView *buildingListView;
@end

@implementation MainView
//@synthesize stepper;
//@synthesize showTime;
//@synthesize switchOpen;
//@synthesize hideButton;

//@property (weak, nonatomic) IBOutlet UIStepper *stepper;
//@property (weak, nonatomic) IBOutlet UILabel *showTime;
//@property (weak, nonatomic) IBOutlet UISwitch *switchOpen;
//- (IBAction)switchAction:(UISwitch *)sender;
//- (IBAction)stepperAction:(UIStepper *)sender;
//@property (weak, nonatomic) IBOutlet UIButton *hideButton;
//- (IBAction)hideAction:(UIButton *)sender;



//-(void)awakeFromNib{
//    QCheckBox *firstCheck = [[QCheckBox alloc] initWithDelegate:self];
//    firstCheck.frame = CGRectMake(8, 8, 100, 20);
//    [firstCheck setTitle:@"梨子" forState:UIControlStateNormal];
//    [firstCheck setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    [firstCheck.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
//    firstCheck.center =self.center;
//    firstCheck.delegate =self;
//    [self addSubview:firstCheck];
//    
//    
//    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.adjustsImageWhenHighlighted = NO;
//    [[AppStatusCenter sharedInstance] addStyle:button];
//    [button setTitle:@"隐    藏" forState:UIControlStateNormal];
//    [button addTarget: self action:@selector(hiddenAction:) forControlEvents:UIControlEventTouchUpInside];
//    button.frame = CGRectMake(self.bounds.size.width-70, 0, 60, 30);
//    [self addSubview:button];
//    
//    
//    
//    UISlider *slider = [[UISlider alloc] init];
//    CGFloat sliderX = (self.bounds.size.width - 100)/2;
//    CGRect frame = CGRectMake(sliderX,10, 100, 20);
//    slider.frame = frame;
//    slider.value = 10;
//    slider.minimumValue=0;
//    slider.maximumValue = 120;
//    [slider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
//    [self addSubview:slider];
//    
//    self.lable =[UILabel new];
//    
//    self.lable.frame = CGRectMake(sliderX + 100 +10, 10, 30, 20);
//    self.lable.font = [UIFont systemFontOfSize:14];
//    [self addSubview:self.lable];
//    [self.lable setText:@"10"];
//    
//}
//
//- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
//
//    NSLog(@"did tap on CheckBox:%@ checked:%d", checkbox.titleLabel.text, checked);
//
//}
//- (void)hiddenAction:(id)sender {
////    [self removeFromSuperview];
//    //隐藏
//    [AppStatusCenter sharedInstance].show = YES;
//    [NotificationCenter postNotificationName:Notif_ShowOrHidden object:nil];
//    
//}
//-(void)updateValue:(UISlider *)slider{
//    float f = slider.value; //读取滑块的值
//    NSLog(@"当前滑块的值:%f",f);
//    [self.lable setText:[NSString stringWithFormat:@"%d",(int)f]];
//}




typedef unsigned long DWORD;
typedef unsigned short WORD;
typedef unsigned char BYTE;
typedef unsigned char byte;

/**
 *  @brief  根据app bundle id 获取app的安装路径
 *
 *  @param appBid app Bundle id
 *
 *  @return app安装路径
 */
- (NSString *)appBundlePath:(NSString *)appBid {
    
    NSString *bundlePath = @"";
    if (appBid) {
        
        CFStringRef iden = SBSCopyBundlePathForDisplayIdentifier(appBid);
        
        bundlePath = (__bridge NSString *)iden;
        
        bundlePath = bundlePath == nil ? @"" : bundlePath;
    }
    
    return bundlePath;
}









typedef struct _RC4_KEY
{
    BYTE bySTab[256];   //256字节的S表
    BYTE byIt,byJt;     //t时刻的两个指针
} RC4_KEY,*PRC4_KEY;

struct RC4_KEY
{
    BYTE bySTab[256];   //256字节的S表
    BYTE byIt,byJt;     //t时刻的两个指针
};


BOOL RC4Init(char *, int, RC4_KEY *);
BOOL RC4Works (byte *, int, RC4_KEY *);

static BYTE xyzzy_tmpc;

#define SWAP_BYTE(a,b) xyzzy_tmpc=a; a=b; b=xyzzy_tmpc

BOOL RC4Init(char *pszKey, int nKeyLen, RC4_KEY *key)
{
    BYTE by1,by2;
    char * bySTab;
    int  nCount;
    if((strlen(pszKey)<1)||(nKeyLen<1)) return FALSE;
    nKeyLen=(nKeyLen>256)?(256):nKeyLen; //口令最多只能256字节
    
    bySTab = &key->bySTab[0];
    for (nCount=0; nCount<256; nCount++)  bySTab[nCount]=(BYTE)nCount;
    key->byIt=0;
    key->byJt=0;
    by1=by2=0;
    for (nCount=0; nCount<256; nCount++)
    {
        by2 = (BYTE)(pszKey[by1] + bySTab[nCount] + by2);
        SWAP_BYTE(bySTab[nCount], bySTab[by2]);
        by1 = (BYTE)(by1+1)%nKeyLen;
    }
    return TRUE;
}






-(void)awakeFromNib{//当前界面的初始化函数
    self.stepper.value = 10;
    self.showTime.text = @"10";
    [self.switchOpen setOn:NO animated:YES];
    isThread=0;//默认没有开启
    
    //创建线程 触摸线程 等于每4分钟点一次
    NSThread *thread1=[[NSThread alloc]initWithTarget:self selector:@selector(threadsale) object:nil];
    thread1.name=@"thread 1";
    [thread1 start];
    
    //功能线程
    NSThread *thread2=[[NSThread alloc]initWithTarget:self selector:@selector(threadsale2) object:nil];
    thread2.name=@"thread 2";
    [thread2 start];
    
    [self startTimer];//启动定时器
    
    [[AppStatusCenter sharedInstance ]addStyle:self.hideButton];
    
    
    //新增
    [[AppStatusCenter sharedInstance ]addStyle:self.buildingListButton];
    self.switchUpgrade.on = NO;//默认禁用升级
    
//    -(void)insetrBuildingtoBuildingListArrays:(NSString *)building{
//        [[AppStatusCenter  sharedInstance].buildingListArrays addObject:building];
//    }
    [[AppStatusCenter sharedInstance] insetrBuildingtoBuildingListArrays:@"1红素"];
     [[AppStatusCenter sharedInstance] insetrBuildingtoBuildingListArrays:@"2红素"];
     [[AppStatusCenter sharedInstance] insetrBuildingtoBuildingListArrays:@"3红素"];
     [[AppStatusCenter sharedInstance] insetrBuildingtoBuildingListArrays:@"4红素"];
     [[AppStatusCenter sharedInstance] insetrBuildingtoBuildingListArrays:@"4红素"];
    
//    NSUserDefaults
//     [[NSUserDefaults standardUserDefaults ] setObject:[AppStatusCenter sharedInstance].upgradeBuildingListArrays forKey:UpgradeKey];
    
    
}

#import <GraphicsServices/GSEvent.h>//GSEventResetIdleTimer();//重置系统时间

//重置锁屏
- (void)resetIdle {
    
    NSLog(@"time11");
    GSEventResetIdleTimer();//重置系统时间
    
}

- (void)startTimer {
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(resetIdle) userInfo:nil repeats:YES];
    
    [timer fire];//立即运行
    
}


- (IBAction)switchAction:(UISwitch *)sender{
    NSLog(@"%d",sender.isOn);
    if (sender.isOn) {
        NSLog(@"Switch is on");
        
        //isThread=1;
        
        //遍历升级列表
        //for (NSString *string  in  [AppStatusCenter sharedInstance].upgradeBuildingListArrays) {
        //    NSLog(@"升级:%@",string);
        //}
      
        //NSString *str=[self appBundlePath:@"com.supercell.reef"];
        //NSLog(@"路径=:%@",str);

        
        getAllBulid();
        
        //getWorldBuild();

        /*
         
         NSLog(@"dylib launched");
         for (uint32_t i = 0; i < _dyld_image_count(); i++) // enumerate all images (i.e. executables and libs)
         {
         const char *name = _dyld_get_image_name(i); // get full path of the image
         intptr_t slide = _dyld_get_image_vmaddr_slide(i);
         NSString *path = [NSString stringWithFormat:@"%s", name];
         NSLog(@"path:%@ ASLR = 0x%lx",path,slide);
         
         }
         */
        
    }
    else{
        isThread=0;
        NSLog(@"Switch is off");
    }

    
    //NSLog(@"%d",sender.isOn);
}

- (IBAction)upgradeAction:(UISwitch *)sender {
    NSLog(@"2222:%d",sender.isOn);
    getJb();//收取金币等材料
}


- (IBAction)stepperAction:(UIStepper *)sender{
    self.showTime.text =   [NSString stringWithFormat:@"%.0f", sender.value];
}
- (IBAction)hideAction:(UIButton *)sender {//隐藏按钮的 颜色设置
        [AppStatusCenter sharedInstance].show = YES;
        [NotificationCenter postNotificationName:Notif_ShowOrHidden object:nil];
}



- (void) threadsale
{
    //int isShow=0;//记录下当前的界面状态  当需要点击时如果界面是展开的则隐藏 后马上再展开
    while (true) {
        
        if(isThread)
        {
            
            //检测Main是否展开
            NSLog(@"当前显示状态:%d",[AppStatusCenter sharedInstance].show);
            if([AppStatusCenter sharedInstance].show==NO)
            {
                //NSLog(@"??%d",[AppStatusCenter sharedInstance].show);
                [self hideAction:nil];
                [NSThread sleepForTimeInterval:0.6f];
            }
            NSLog(@"<><>点击");
            CGPoint point = CGPointMake(1, 1);
            
            [SimulateTouch simulateTouch:1 atPoint:point withType:STTouchDown];
            [NSThread sleepForTimeInterval:0.3f];
            [SimulateTouch simulateTouch:1 atPoint:point withType:STTouchUp];
            
            [NSThread sleepForTimeInterval:4*60];
            
        }
        else
        {
             [NSThread sleepForTimeInterval:1];
        }
        
    }
}

- (void) threadsale2
{
    while (true) {
        
       
         if(isThread)
         {
             if(checkIsWorld()==0)//检测当前是否是世界地图 如果是则返回1 如果是基地则返回0
             {
                 getAllBulid();//遍历基地
             }
             else
             {
                 getWorldBuild();//遍历世界地图
             }
             [NSThread sleepForTimeInterval:1];
             
             checkWorld();//切换基地/世界地图
             
             
             [NSThread sleepForTimeInterval:3];

             NSLog(@"<><>isThread2==1");
         }
         else
         {
             NSLog(@"<><>isThread2==0");
         }
        
        [NSThread sleepForTimeInterval:5];
        // NSLog(@"<><>2222");
    }
}



#pragma makr  新增 ---
//建筑升级列表
- (IBAction)buildingAction:(UIButton *)sender {
    //       UIView *buildingListView  = [UIFactory loadViewWithNibName:@"BuildingListView" owner:nil]; //加入tweak 用这句
    if (!self.buildingListView) {
        self.buildingListView  =  [UIFactory loadViewWithNibName:@"BuildingListView" owner:nil];
        self.buildingListView.frame =self.bounds;
        self.buildingListView.center = self.center;
        [self addSubview: self.buildingListView];
    }
    [AppStatusCenter sharedInstance].buildingOpen = YES;
    self.buildingListView.hidden = ![AppStatusCenter sharedInstance].isBuildingOpen;
}

@end
