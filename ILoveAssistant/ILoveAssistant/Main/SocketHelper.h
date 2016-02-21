//
//  SocketHelper.h
//  ILoveAssistant
//
//  Created by MoPellet on 15/9/1.
//
//

#import <Foundation/Foundation.h>
extern  char mkey[16];
extern  char user[100];

@interface SocketHelper : NSObject<GCDAsyncSocketDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) GCDAsyncSocket    *asyncSocket;       // socket
@property(nonatomic,strong) NSData *requestData;

+ (id)sharedInstance;

- (int)startSocketWith:(NSData *)data  ;

@end


