//
//  SISocketIO.m
//  Socket.IO-iOS
//
//  Created by masafumi yoshida on 2014/06/12.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "SISocketIOClient.h"
#import "SISocketIOTransportFactory.h"

@implementation SISocketIOClient


- (id) initWithHost:(NSString *)host onPort:(NSInteger)port{
    self = [self init];
    if(self){
        self.host = host;
        self.port = port;
        
    }
    
    return self;
    
}

- (id) initWithHost:(NSString *)host onPort:(NSInteger)port withParams:(NSDictionary *)params{
    self = [self init];
    if(self){
        
        
    }
    return self;
}
- (id) initWithHost:(NSString *)host onPort:(NSInteger)port withParams:(NSDictionary *)params withPath:(NSString *)path{
    self = [self init];
    if(self){
        
        
    }
    return self;
}


-(void)connect{
    SISocketIOTransport *transportPolling = [SISocketIOTransportFactory createTransport:@"polling"];
    [transportPolling connect];
    SISocketIOTransport *transportWebSocket = [SISocketIOTransportFactory createTransport:@"websocket"];
     [transportWebSocket connect];
    
    
}
@end
