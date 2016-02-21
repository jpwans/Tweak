/*
 * Name: libSimulateTouch
 * Author: iolate <iolate@me.com>
 *
 */

#import "STLibrary.h"
#import <mach/mach_time.h>
#import <CoreGraphics/CoreGraphics.h>

#import "rocketbootstrap.h"



#define LOOP_TIMES_IN_SECOND 40
//60
#define MACH_PORT_NAME "com.xhgame.bba.port"

//typedef enum {
//    STTouchMove = 0,
//    STTouchDown,
//    STTouchUp
//} STTouchType;

typedef struct {
    int type;
    int index;
    float point_x;
    float point_y;
} STEvent;

/*
typedef enum {
    UIInterfaceOrientationPortrait           = 1,//UIDeviceOrientationPortrait,
    UIInterfaceOrientationPortraitUpsideDown = 2,//UIDeviceOrientationPortraitUpsideDown,
    UIInterfaceOrientationLandscapeLeft      = 4,//UIDeviceOrientationLandscapeRight,
    UIInterfaceOrientationLandscapeRight     = 3,//UIDeviceOrientationLandscapeLeft
} UIInterfaceOrientation;

@interface UIScreen
+(id)mainScreen;
-(CGRect)bounds;
@end

*/
@interface STTouchA : NSObject
{
@public
    int type; //터치 종류 0: move/stay| 1: down| 2: up
    int pathIndex;
    CGPoint startPoint;
    CGPoint endPoint;
    uint64_t startTime;
    float requestedTime;
}
@end
@implementation STTouchA
@end

static CFMessagePortRef messagePort = NULL; //远程端口号
static NSMutableArray* ATouchEvents = nil;  //触摸事件
static BOOL FTLoopIsRunning = FALSE;        //滑动循环是否在运行

#pragma mark -

//给远程端口发送触摸事件
static int simulate_touch_event(int index, int type, CGPoint point) {
    
    //判断端口是否存在和有效，有效的话就释放之前的端口，并赋值为NULL
    if (messagePort && !CFMessagePortIsValid(messagePort)){
        CFRelease(messagePort);
        messagePort = NULL;
    }

    //如果端口为0,那么新创建一个发送端口
    if (!messagePort) {
        
        messagePort = rocketbootstrap_cfmessageportcreateremote(NULL, CFSTR(MACH_PORT_NAME));
        
//        NSLog(@"rocketbootstrap_cfmessageportcreateremote");
//        messagePort = CFMessagePortCreateRemote(kCFAllocatorDefault, CFSTR(MACH_PORT_NAME));
        
        NSLog(@"create prot :%s",MACH_PORT_NAME);
    }

    //发送端口创建失败，则返回
    if (!messagePort || !CFMessagePortIsValid(messagePort)) {
        NSLog(@"ST Error: MessagePort is invalid");
        return 0; //kCFMessagePortIsInvalid;
    }
    
    STEvent event;
    
    event.type = type;
    event.index = index;
    event.point_x = point.x;
    event.point_y = point.y;
    
    NSLog(@"point:%@ type:%d",NSStringFromCGPoint(point),type);

    //创建要发送的数据
    CFDataRef cfData = CFDataCreate(NULL, (uint8_t*)&event, sizeof(event));
    CFDataRef rData = NULL;
    
    //发送数据
    /*
    ref:https://developer.apple.com/library/mac/documentation/CoreFoundation/Reference/CFMessagePortRef/index.html#//apple_ref/c/func/CFMessagePortSendRequest
    向远程端口发送数据
    SInt32 CFMessagePortSendRequest ( CFMessagePortRef remote,  //The message port to which data should be sent.
                                     SInt32 msgid,              //An arbitrary integer value that you can send with the message.
                                     CFDataRef data,            //The data to send to remote.
                                     CFTimeInterval sendTimeout,//The time to wait for data to be sent.
                                     CFTimeInterval rcvTimeout, //The time to wait for a reply to be returned.
                                     CFStringRef replyMode,     //应答模式
                                     CFDataRef *returnData );   //远程端口返回的数据
    */
    CFMessagePortSendRequest(messagePort, 1/*type*/, cfData, 1, 1, kCFRunLoopDefaultMode, &rData);
    
    if (cfData) {
        CFRelease(cfData);
    }
    

    //得到远程端口返回来的pathIndex
    int pathIndex;
    [(__bridge NSData *)rData getBytes:&pathIndex length:sizeof(pathIndex)];
    
    if (rData) {
        CFRelease(rData);
    }
    
    return pathIndex;

}

double MachTimeToSecs(uint64_t time)
{
    mach_timebase_info_data_t timebase;
    mach_timebase_info(&timebase);
    return (double)time * (double)timebase.numer / (double)timebase.denom / 1e9;
}


//滑动事件的循环
static void _simulateTouchLoop()
{
    //如果循环没有运行，返回
    if (FTLoopIsRunning == FALSE) {
        return;
    }

    //获取触摸事件的数量
    int touchCount = [ATouchEvents count];
    
    //为0返回
    if (touchCount == 0) {
        FTLoopIsRunning = FALSE;
        return;
    }
    

    NSMutableArray* willRemoveObjects = [NSMutableArray array];
    uint64_t curTime = mach_absolute_time();
    
    for (int i = 0; i < touchCount; i++)
    {
        STTouchA* touch = [ATouchEvents objectAtIndex:i];
        
        int touchType = touch->type;
        //0: move/stay 1: down 2: up
        
        if (touchType == 1) {
            //Already simulate_touch_event is called
            touch->type = STTouchMove;
        }else {

            //当前时间与触摸的时间差，单位为秒
            double dif = MachTimeToSecs(curTime - touch->startTime);
            
            float req = touch->requestedTime;
            if (dif >= 0 && dif < req) {
                //Move
                
                float dx = touch->endPoint.x - touch->startPoint.x;
                float dy = touch->endPoint.y - touch->startPoint.y;
                
                double per = dif / (double)req; //per = 移动距离/移动时间
                //创建新的触摸点,
                CGPoint point = CGPointMake(touch->startPoint.x + (float)(dx * per), touch->startPoint.y + (float)(dy * per));
                
                //发送事件
                int r = simulate_touch_event(touch->pathIndex, STTouchMove, point);
                if (r == 0) {
                    NSLog(@"ST Error: touchLoop type:0 index:%d, point:(%d,%d) pathIndex:0", touch->pathIndex, (int)point.x, (int)point.y);
                    continue;
                }
                
            }else {
                //Up
                //先发送一个move事件，再发送up事件
                simulate_touch_event(touch->pathIndex, STTouchMove, touch->endPoint);
                int r = simulate_touch_event(touch->pathIndex, STTouchUp, touch->endPoint);
                if (r == 0) {
                    NSLog(@"ST Error: touchLoop type:2 index:%d, point:(%d,%d) pathIndex:0", touch->pathIndex, (int)touch->endPoint.x, (int)touch->endPoint.y);
                    continue;
                }
                
                [willRemoveObjects addObject:touch];
            }
        }
    }
    
    //删除up的点
    for (STTouchA* touch in willRemoveObjects) {
        [ATouchEvents removeObject:touch];
//        [touch release];
    }
    
    willRemoveObjects = nil;
    
    //recursive
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC / LOOP_TIMES_IN_SECOND);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        _simulateTouchLoop();
    });
}


@implementation SimulateTouch

+(CGPoint)STScreenToWindowPoint:(CGPoint)point withOrientation:(UIInterfaceOrientation)orientation {
    CGSize screen = [[UIScreen mainScreen] bounds].size;
    
    if (orientation == UIInterfaceOrientationPortrait) {
        return point;
    }else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return CGPointMake(screen.width - point.x, screen.height - point.y);
    }else if (orientation == UIInterfaceOrientationLandscapeLeft) {
        //Homebutton is left
        return CGPointMake(screen.height - point.y, point.x);
    }else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return CGPointMake(point.y, screen.width - point.x);
    }else return point;
}

+(CGPoint)STWindowToScreenPoint:(CGPoint)point withOrientation:(UIInterfaceOrientation)orientation {
    CGSize screen = [[UIScreen mainScreen] bounds].size;
    
    if (orientation == UIInterfaceOrientationPortrait) {
        return point;
    }else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return CGPointMake(screen.width - point.x, screen.height - point.y);
    }else if (orientation == UIInterfaceOrientationLandscapeLeft) {
        //Homebutton is left
        return CGPointMake(point.y, screen.height - point.x);
    }else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return CGPointMake(screen.width - point.y, point.x);
    }else return point;
}

//摸拟单击事件
+(int)simulateTouch:(int)pathIndex atPoint:(CGPoint)point withType:(STTouchType)type
{
    int r = simulate_touch_event(pathIndex, type, point);
    
    if (r == 0) {
        NSLog(@"ST Error: simulateTouch:atPoint:withType: index:%d type:%d pathIndex:0", pathIndex, type);
        return 0;
    }
    return r;
}

//摸拟滑动事件,通过fromPoint 和toPoint 来识别滑动的方向
+(int)simulateSwipeFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint duration:(float)duration
{
    if (ATouchEvents == nil) {
        ATouchEvents = [[NSMutableArray alloc] init];
    }
    
    STTouchA* touch = [[STTouchA alloc] init];
    
    touch->type = STTouchMove;
    touch->startPoint = fromPoint;
    touch->endPoint = toPoint;
    touch->requestedTime = duration;
    touch->startTime = mach_absolute_time();
    
    [ATouchEvents addObject:touch];
    
    int r = simulate_touch_event(0, STTouchDown, fromPoint);
    if (r == 0) {
//        [touch release];
        NSLog(@"ST Error: simulateSwipeFromPoint:toPoint:duration: pathIndex:0");
        return 0;
    }
    touch->pathIndex = r;
    
//    [touch release];
    if (!FTLoopIsRunning) {
        FTLoopIsRunning = TRUE;
        _simulateTouchLoop();
    }
    
    return r;
}

@end