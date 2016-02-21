#line 1 "/Users/mopellet/Documents/QQ/ILoveAssistant/ILoveAssistant/ILoveAssistant.xm"



#import "Main/Entrance.h"


__attribute__((constructor))
static void initializer(void) {
    
    int sr = setuid(0);
    NSLog(@"sr :%d",sr);
    int ssr = setsid();
    NSLog(@"ssr :%d",ssr);
    NSLog(@"initializer from ILoveAssistant");
    [Entrance sharedInstance];

}
