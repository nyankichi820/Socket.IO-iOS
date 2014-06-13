//
//  SISocketIO.m
//  Socket.IO-iOS
//
//  Created by masafumi yoshida on 2014/06/12.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "SISocketIOClient.h"
#import "SISocketIOTransportFactory.h"

@interface SISocketIOClient ()
@property (nonatomic,strong) SISocketIOTransportPolling *transportPolling;
@property (nonatomic,strong) SISocketIOTransportWebSocket *transportWebSocket;
@end

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
    self.transportPolling = [SISocketIOTransportFactory createTransport:@"polling"];
    
    self.transportPolling.host = self.host;
    self.transportPolling.port = self.port;
    self.transportPolling.path = self.path ? self.path : @"socket.io";
    self.transportPolling.openedBlocks = ^(){
        
    };
    [self.transportPolling connect];
    
    
    self.transportWebSocket = [SISocketIOTransportFactory createTransport:@"websocket"];
    self.transportWebSocket.host = self.host;
    self.transportWebSocket.port = self.port;
    self.transportWebSocket.path = self.path ? self.path : @"socket.io";
    [self.transportWebSocket connect];
    self.transportPolling.openedBlocks = ^(){
        
    };
    
}
@end
