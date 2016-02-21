
#import "DecayViewController.h"
#import "UIFactory.h"
#import "SocketHelper.h"
#import "AssistiveTouch.h"
#import "HomeView.h"
@interface DecayViewController()<UIGestureRecognizerDelegate,AssistiveTouchDelegate>
{
    AssistiveTouch *mwindow;
}
@property(nonatomic,strong) HomeView *homeView;
@end

@implementation DecayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.backgroundColor = rgba(255, 255, 255, 0.5);
    self.view.backgroundColor = [UIColor clearColor];
    [self addAssistantButton];
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
                                       withObject:(id)UIInterfaceOrientationPortrait];
    }
    
    
    [AppStatusCenter sharedInstance].buildingListArrays = [NSMutableArray new];//这个在初始化的时候实例化
    [AppStatusCenter sharedInstance].upgradeBuildingListArrays = [NSMutableArray new];//这个在初始化的时候实例化
    
    //读取升级列表
    if ( [[NSUserDefaults standardUserDefaults] objectForKey:UpgradeKey]) {
        [AppStatusCenter sharedInstance].upgradeBuildingListArrays = [[NSUserDefaults standardUserDefaults] objectForKey:UpgradeKey];
    }
    
    //10.07
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
}

 //10.07
- (BOOL)prefersStatusBarHidden
{
    return YES;
}




#pragma mark - Private Instance methods

- (void)addAssistantButton
{
    mwindow = [[AssistiveTouch alloc]initWithFrame:CGRectMake(100, 200, 40, 40) ];
    mwindow.assistiveDelegate = self;
    mwindow.center = self.view.center;
    [self.view addSubview:mwindow];
//    [NotificationCenter addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [NotificationCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [NotificationCenter addObserver:self selector:@selector(removeContentView:) name:Notif_RemoveSuperview object:nil];
    [NotificationCenter addObserver:self selector:@selector(showOrHidden:) name:Notif_ShowOrHidden object:nil];
}
//- (void)statusBarOrientationChange:(NSNotification *)notification
//{
//    NSLog(@"屏幕开始旋转了");
//    [[UIDevice currentDevice] setValue: [NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
//}
-(void)assistiveTocuhs{
    [self TouchUpInside:nil];
}

- (void)TouchUpInside:(UIButton *)sender {
    NSLog(@"我现在点你了");
//    [[UIDevice currentDevice] setValue: [NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
    if (!self.contentView) {
        NSLog(@"开始创建");
        NSLog(@"宽：%f，高:%f",self.view.bounds.size.width,self.view.bounds.size.height);
        CGRect frame = self.view.bounds;
//        if (self.view.bounds.size.width>self.view.bounds.size.height) {
//          frame =  CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width);
//        }
        
        self.contentView = [[PassEventView alloc] initWithFrame:frame];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.contentView];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchDownToKeyboard:)];
        [self.contentView addGestureRecognizer:tap];
        tap.delegate = self;
    }
//            self.contentView.backgroundColor = rgba(255, 255, 255, 0.5);
//            self.contentView.alpha= 0.5;
    if ([AppStatusCenter sharedInstance].isOpen) {
        NSLog(@"打开了呢");
        
    }
    else
    {
        NSLog(@"还没打开");
        //打开页面
        [self openMainInterface];
    }
}

-(void)openMainInterface {
    NSLog(@"打开页面");
    NSLog(@"--打开:%@",self.contentView);
    [AppStatusCenter sharedInstance].show = NO;
    self.contentView.hidden= NO;
//    if (!self.homeView) {
//        NSLog(@"开始创建homeView");
//        CGFloat loginViewW =300;
//        CGFloat loginViewH = 150;
//        self.homeView  = (HomeView *)[UIFactory loadViewWithNibName:@"HomeView" owner:nil];
//        self.homeView.frame = CGRectMake(0, 0, loginViewW, loginViewH);
//        self.homeView.center = self.contentView.center;
//       
//    }
//     [self.contentView addSubview:  self.homeView ];
    
    //10.07
    if (!self.homeView) {
        NSLog(@"开始创建homeView");
        //        CGFloat loginViewW =300;
        //        CGFloat loginViewH =150;
        self.homeView  = (HomeView *)[UIFactory loadViewWithNibName:@"HomeView" owner:nil];
        self.homeView.translatesAutoresizingMaskIntoConstraints = NO;
        //        self.homeView.frame = CGRectMake(0, 0, loginViewW, loginViewH);
        //        self.homeView.center = self.contentView.center;
        
    }
    [self.contentView addSubview:  self.homeView ];
    
    //begin
    //设置高度
    NSLayoutConstraint *homeViewHeight = [NSLayoutConstraint constraintWithItem:self.homeView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:150];
    [self.homeView addConstraint:homeViewHeight];
    //设置宽度
    NSLayoutConstraint *homeViewWidth = [NSLayoutConstraint constraintWithItem:self.homeView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:300];
    [self.homeView addConstraint:homeViewWidth];
    //垂直居中
   NSLayoutConstraint*verticalLayout =[NSLayoutConstraint constraintWithItem:self.homeView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self.contentView addConstraint:verticalLayout];
    //水平居中
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.homeView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    //end

}

- (void)touchDownToKeyboard:(id)sender {
    [self.contentView endEditing:YES];
}
#pragma mark - NSNotification
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 设置窗口的颜色
    self.contentView.window.backgroundColor = self.contentView.backgroundColor;
    
    // 0.取出键盘动画的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 1.取得键盘最后的frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 2.计算控制器的view需要平移的距离
    CGFloat transformY = (keyboardFrame.origin.y - self.contentView.frame.size.height)/3;
    
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.contentView.transform = CGAffineTransformMakeTranslation(0, transformY);
    }];
}

- (void)removeContentView:(NSNotification *)note{
    NSLog(@"移除contentView");
//        self.contentView=nil;
        [self.contentView endEditing:YES];
//    [self.contentView removeFromSuperview];
//    self.contentView.hidden = YES;
    [AppStatusCenter sharedInstance] .show =YES;
    [self showOrHidden:nil];
    NSLog(@"移除contentView:%@",self.contentView);

}

- (void)showOrHidden:(NSNotification *)note{
    //    [self.contentView removeFromSuperview];// 隐藏
    
    self.contentView.hidden = [AppStatusCenter sharedInstance] .isShow;
    [self.view endEditing:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    //
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UIView"]) {
        return NO;
    }
    return  YES;
}



//- (NSUInteger)supportedInterfaceOrientations
//{
//    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
//    NSLog(@"orientation:%d",orientation);
//    
//    if (UIDeviceOrientationLandscapeLeft ==orientation ) {
//      return UIInterfaceOrientationMaskLandscapeRight;
//    }
//    else if(UIDeviceOrientationLandscapeRight ==orientation){
//        return UIInterfaceOrientationMaskLandscapeLeft;
//    }
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//- (BOOL)shouldAutorotate
//{
//        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
//        NSLog(@"orientation:%d",orientation);
//        if(UIDeviceOrientationPortrait == orientation || orientation ==UIDeviceOrientationPortraitUpsideDown ) {
//            return NO;
//        }
//    return YES;
//}

//10.07
- (NSUInteger)supportedInterfaceOrientations
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    NSLog(@"设备支持的方向:%d",orientation);
    if ([DecayViewController getIOSVersion]<8) {
        //        return UIInterfaceOrientationMaskLandscape;
        return UIInterfaceOrientationMaskPortrait;
    }
    if (UIDeviceOrientationLandscapeLeft ==orientation ) {
        return UIInterfaceOrientationMaskLandscapeRight;
    }
    else if(UIDeviceOrientationLandscapeRight ==orientation){
        return UIInterfaceOrientationMaskLandscapeLeft;
    }
    return UIInterfaceOrientationMaskPortrait;
}
+ (float)getIOSVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

- (BOOL)shouldAutorotate
{
    //    NSLog(@"当前视图方向1：%d",self.interfaceOrientation);
    //    [UIApplication sharedApplication].keyWindow.rootViewController.view;
    UIInterfaceOrientation interface  = [[UIApplication sharedApplication] statusBarOrientation];
    NSLog(@"当前视图方向2：%d",interface);
    if (interface==UIInterfaceOrientationPortrait) {
        return NO;
    }
    if ([DecayViewController getIOSVersion]>=8) {
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        NSLog(@"orientation:%d",orientation);
        if(UIDeviceOrientationPortrait == orientation || orientation ==UIDeviceOrientationPortraitUpsideDown
           || orientation==UIDeviceOrientationFaceUp || orientation ==UIDeviceOrientationFaceDown
           ) {
            return NO;
            NSLog(@"1..NO");
        }
        NSLog(@"2..yes");
        return YES;
    }
    else{
        NSLog(@"这是4..yes");
        return YES;
    }
}


-(void)dealloc{
    [super dealloc];
//    [NotificationCenter removeObserver:self name:Notif_LoginSuccess object:nil];
//        [NotificationCenter removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
//        [NotificationCenter removeObserver:self name:Notif_RemoveSuperview object:nil];
//        [NotificationCenter removeObserver:self name:Notif_ShowOrHidden object:nil];
//        [NotificationCenter removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

@end
