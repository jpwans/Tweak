//
//  MoUncaughtExceptionHandler.m
//  ILoveAssistant
//
//  Created by MoPellet on 15/8/24.
//
//

#import "MoUncaughtExceptionHandler.h"

@implementation MoUncaughtExceptionHandler



+ (void)setDefaultHandler
{
    NSSetUncaughtExceptionHandler (&uncaughtExceptionHandler);
}

+ (NSUncaughtExceptionHandler*)getHandler
{
    return NSGetUncaughtExceptionHandler();
}

void uncaughtExceptionHandler(NSException *exception) {
    NSArray *arr = [exception callStackSymbols];//得到当前调用栈信息
    NSString *reason = [exception reason];//非常重要，就是崩溃的原因
    NSString *name = [exception name];//异常类型
    NSDictionary *userInfo = [exception userInfo];
    //    NSString *url = [NSString stringWithFormat:@"=============异常崩溃报告=============\nname:\n%@\nreason:\n%@\ncallStackSymbols:\n%@",
    //                     name,reason,[arr componentsJoinedByString:@"\n"]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * time = [formatter stringFromDate:date];
    NSString *exceptionInfo = [NSString stringWithFormat:@"current time: %@\n exception name: %@\n exception reason: %@\n exception userinfo: %@\n Stack Trace: %@",
                               time,name ,reason, userInfo, [arr componentsJoinedByString:@"\n"]];
    
    
    
    NSLog(@"%@",exceptionInfo);
    
    return;
    NSString *path = [ applicationDocumentsDirectory() stringByAppendingPathComponent:@"Exception.txt" ];
    
    [exceptionInfo writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    //获取文件指针
    FILE *filePath = fopen("Exception.txt", "a+"); // 文件打开方式 如果原来有内容也会销毁
    if (filePath==0) {
        printf("can't open file\n");
        return ;
    }
  
    fseek(filePath, 0, SEEK_END);
    fwrite(exceptionInfo, 1, StrLength(exceptionInfo), filePath);
    fflush(filePath);
    fclose(filePath);
    
    //除了可以选择写到应用下的某个文件，通过后续处理将信息发送到服务器等
    //还可以选择调用发送邮件的的程序，发送信息到指定的邮件地址
    //或者调用某个处理程序来处理这个信息
}

NSString * applicationDocumentsDirectory() {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)  lastObject];
}

@end
