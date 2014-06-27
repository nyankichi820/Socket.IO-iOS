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


-(void)emit:(NSString*)eventName params:(NSDictionary*)params{
    
    
}

-(void)open{
    self.transportPolling = (SISocketIOTransportPolling*)[SISocketIOTransportFactory createTransport:@"polling"];
    self.transportPolling.delegate = self;
    self.transportPolling.host = self.host;
    self.transportPolling.port = self.port;
    self.transportPolling.path = self.path ? self.path : @"socket.io";
    
    [self.transportPolling open];
    
}


#pragma socketiostransportdelegate

- (void) onPacket:(id <SISocketIOTransport>)transport packet:(SISocketIOPacket*)packet{
    
    
    switch (packet.type) {
        case SISocketIOPacketTypeOpen:
            [self.delegate socketIOClientOnClose:self];
            break;
        case SISocketIOPacketTypeMessage:
              [self.delegate socketIOClientOnPacket:self packet:packet];
            break;
            
        case SISocketIOPacketTypeClose:
              [self.delegate socketIOClientOnClose:self];
            break;
        case SISocketIOPacketTypePing:
            
            break;
        case SISocketIOPacketTypePong:
            
            break;
        case SISocketIOPacketTypeNoop:
            
            break;
        case SISocketIOPacketTypeUpgrade:
            
            break;
        case SISocketIOPacketTypeError:
         
            break;
            
        default:
            break;
    }

    
    
}

-(void)onOpen:(id <SISocketIOTransport>)transport{
  
    if([transport isEqual:self.transportPolling]){
        self.transportWebSocket = (SISocketIOTransportWebSocket*)[SISocketIOTransportFactory createTransport:@"websocket"];
        self.transportWebSocket.host = self.host;
        self.transportWebSocket.port = self.port;
        self.transportWebSocket.sid  = self.transportPolling.sid;
        self.transportWebSocket.path = self.path ? self.path : @"socket.io";
        [self.transportWebSocket open];
        
    }
    else{
        
    }
}

-(void)onClose:(id <SISocketIOTransport>)transport{
    
}


-(void)onError:(id<SISocketIOTransport>)transport error:(NSError *)error{
    
}



@end
