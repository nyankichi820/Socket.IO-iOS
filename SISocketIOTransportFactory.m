//
//  SISocketIOTransportFactory.m
//  Socket.IO-iOS
//
//  Created by masafumi yoshida on 2014/06/13.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "SISocketIOTransportFactory.h"


@implementation SISocketIOTransportFactory
+(SISocketIOTransport*)createTransport:(NSString*)transport{
    if([transport isEqualToString:[SISocketIOTransportPolling transportName]]){
        return [[SISocketIOTransportPolling alloc] init];
    }
    else if([transport isEqualToString:[SISocketIOTransportWebSocket transportName]]){
        return [[SISocketIOTransportWebSocket alloc] init];
    }
    return nil;
}
@end
