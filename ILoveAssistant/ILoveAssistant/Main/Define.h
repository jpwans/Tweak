//
//  Define.h
//  ILoveAssistant
//
//  Created by MoPellet on 15/8/24.
//
//

#ifndef ILoveAssistant_Define_h
#define ILoveAssistant_Define_h
#define DEBUG_MODE  0

#define IGameAssistantButtonTappedNoti  @"IGameAssistantButtonTappedNoti"

#define kBundlePath     @"/Library/MobileSubstrate/DynamicLibraries/images.bundle"
#define kNibsDundlePath @"/Library/MobileSubstrate/DynamicLibraries/nibs.bundle"
#define kStoryboardDundlePath @"/Library/MobileSubstrate/DynamicLibraries/storyboard.bundle"

#define kFilePath @"/Library/MobileSubstrate/DynamicLibraries/text.text"

//宏
#define rgb(a,b,c)      [UIColor colorWithRed:a/255.0f green:b/255.0f blue:c/255.0f alpha:1.0f]
#define rgba(r,g,b,a)   [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define ButtonBgColor  rgb(255,164, 116)

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
//主屏高
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define NotificationCenter [NSNotificationCenter defaultCenter]

#define CloseButtonSize 30

typedef enum {
    AlertViewStatusRegister=100,//注册
    AlertViewStatusBalance,//余额
    AlertViewStatusRecharge// 充值
} AlertViewStatus;

#define NotificationCenter [NSNotificationCenter defaultCenter]
#define Notif_LoginSuccess @"loginSuccess"

#define Notif_RemoveSuperview @"removeSuperview"
#define Notif_ShowOrHidden @"ShowOrHidden"


#define UpgradeKey @"upgradeKey"

#endif
