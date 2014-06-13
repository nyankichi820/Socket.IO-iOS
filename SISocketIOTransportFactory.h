//
//  SISocketIOTransportFactory.h
//  Socket.IO-iOS
//
//  Created by masafumi yoshida on 2014/06/13.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SISocketIOTransport.h"
#import "SISocketIOTransportPolling.h"
#import "SISocketIOTransportWebSocket.h"

@interface SISocketIOTransportFactory : NSObject
+(SISocketIOTransport*)createTransport:(NSString*)transport;
@end
