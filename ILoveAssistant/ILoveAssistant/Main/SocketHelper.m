//
//  SocketHelper.m
//  ILoveAssistant
//
//  Created by MoPellet on 15/9/1.
//
//

#import "SocketHelper.h"
#define  SERVERHOST @"113.105.152.15"
#define SERVERPORT  9824 //服务器端口
#define SOCKETPORT  9825 //服务器端口 保持socket端口
#define DLLPORT 9814 //服务器端口 (dll发送题目)

char mkey[16];
char user[100];
typedef enum {
    ServerConnectFailure = 0, //连接失败
    ServerConnectSuccess,//连接成功
    ServerConnected//连接中
} ServerConnectStatus;

//#define HOST_IP @"113.105.152.15"
//#define HOST_PORT 9824

@implementation SocketHelper
+(id)sharedInstance{
    NSLog(@"sharedInstance_SocketHelper");
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        //        NSError *err = nil;
        //        if (![self.asyncSocket connectToHost:SERVERHOST onPort:SERVERPORT error:&err]) {
        //            NSLog(@"连接失败：%ld %@", (long)[err code], [err localizedDescription]);
        //        } else {
        //            NSLog(@"连接到： \"%@\" on port %d...", SERVERHOST, SERVERPORT);
        //        }
    }
    return self;
}


- (int)startSocketWith:(NSData *)data  {
            [self.asyncSocket disconnect];
    NSLog(@"开始套接字,%d",  self.asyncSocket.isConnected);

    uint16_t port = SERVERPORT;
    NSString *host =SERVERHOST;
    self.requestData = data;
    //    self.myKey = key;
    if ( !self.asyncSocket.isConnected) {
        NSError *err = nil;
        if (![self.asyncSocket connectToHost:host onPort:port error:&err]) {
            NSLog(@"连接失败：%ld %@", (long)[err code], [err localizedDescription]);
            return ServerConnectFailure;
        } else {
            NSLog(@"连接到： \"%@\" on port %hu...", host, port);
            return ServerConnectSuccess;
        }
    }
    else{
        return ServerConnected;
    }
}




- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"socket:didConnectToHost:%@ port:%hu", host, port);
    [self.asyncSocket writeData:self.requestData withTimeout:-1.0 tag:0];
    [self.asyncSocket readDataWithTimeout:-1.0 tag:0];
    
    
}

- (void)socket:(GCDAsyncSocket *)sock didReceiveTrust:(SecTrustRef)trust
completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler
{
    NSLog(@"socket:shouldTrustPeer:");
    
    dispatch_queue_t bgQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(bgQueue, ^{
        
        
        SecTrustResultType result = kSecTrustResultDeny;
        OSStatus status = SecTrustEvaluate(trust, &result);
        
        if (status == noErr && (result == kSecTrustResultProceed || result == kSecTrustResultUnspecified)) {
            completionHandler(YES);
        }
        else {
            completionHandler(NO);
        }
    });
}

- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
    
    NSLog(@"socketDidSecure:");
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"socket:didWriteDataWithTag:");
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    
    NSLog(@"socket:didReadData:withTag:");
    struct tCommand crecv;
    memset(&crecv,0 ,sizeof(crecv) );
    [data getBytes:&crecv length:sizeof(crecv)];
    
    NSLog(@"mkey:%s",mkey);
    //解密
    decryptLen((unsigned long*)&crecv,(unsigned long*)mkey,72);
    NSLog(@"crecv.commandType:%lu",crecv.commandType);
    NSString *msg =[[NSString alloc] init];
    switch (crecv.commandType) {
        case CM2:{
            switch(crecv.regResp.dwResult)//返回0表示帐号已经存在 返回1注册成功
            {
                case 0:
                    msg = @"帐号已经存在,请更换注册帐号！";
                    break;
                case 1:
                    msg = @"恭喜注册成功！";
                    break;
                default:
                    msg = @"未知错误！";
                    break;
            }
        }
            break;
        case CM4:{
            if(crecv.czResp.dwResult==0)//返回0成功充值 返回1充值帐号不存在 返回2月卡帐号或密码错误 返回3此月卡已经被使用完
            {
                msg = @"恭喜,充值成功！";
            }
            else if(crecv.czResp.dwResult==1)
            {
                     msg = @"用户帐号不存在！";
            }
            else if(crecv.czResp.dwResult==2)
            {
                  msg = @"充值卡号或充值密码错误！";
            }
            else if(crecv.czResp.dwResult==3)
            {
                    msg = @"此充值卡已经被使用！";
            }
            else
            {
                  msg = @"未知错误！";
            }
        }
            break;
        case CM6:
        {
            
            switch(crecv.yeResp.dwResult)//查询余额 返回88888888不存在此帐号 正常返回余额
            {
                case 88888888:
                    msg = @"此账号不存在";
                    break;
                default:{
                    msg = [NSString stringWithFormat:@"帐号'%s'使用剩余<%d>！",user,(int)crecv.yeResp.dwResult];
                    NSLog(@"用户--crecv.ye.sUser:%s",crecv.ye.sUser);
                    NSLog(@"余额--crecv.yeResp.dwResult:%lu",crecv.yeResp.dwResult);
                }
                    break;
            }
            
        }
            break;
        case CM8:
        {
            if(crecv.loginResp.dwResult==1)//返回6才能登录 1帐号或密码错误 2机器码不正确 3余额不足
            {
                msg=@"帐号或密码错误！";
            }
            else if(crecv.loginResp.dwResult==2)
            {
                msg=@"当前帐号梆定机器不正确！";
            }
            else if(crecv.loginResp.dwResult==3)
            {
                msg=@"余额不足！";
            }
            else if(crecv.loginResp.dwResult==6)
            {
                msg=@"登陆成功";
                [NotificationCenter postNotificationName:Notif_LoginSuccess object:nil];
                
//                return;
                //            			//保存 第一次成功登录的 帐号 密码 机器码 供系统公告使用
                //            			extern char saveUser[50];
                //            			extern char savePass[50];
                //            			extern char saveBind[50];
                //            			GetDlgItemText(IDC_EDIT1,buf,sizeof(buf));//帐号
                //            			lstrcpy(saveUser,buf);
                //            			GetDlgItemText(IDC_EDIT2,buf,sizeof(buf));//密码
                //            			lstrcpy(savePass,buf);
                //            			lstrcpy(saveBind,bind);
                //
                //            			m_isLogin=133;//标识已经登录
                //            			myYe(saveUser);//显示一下余额
                //            			EndDialog(-1);
            }
            else
            {
                msg = @"未知错误！";
            }
        }
            break;
            
        default:
            break;
    }
    
    UIAlertView *alertview =[[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
    [alertview show];
    [alertview release];
    
    
    NSLog(@"Full HTTP Response:\n%@", data);
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"socketDidDisconnect:%p withError: %@", sock, err);
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (alertView.cancelButtonIndex ==buttonIndex) {
        NSLog(@"点击了取消");
        [self.asyncSocket disconnect];
    }
    
}


@end
