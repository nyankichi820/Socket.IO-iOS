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
@end

@implementation SISocketIOClient


- (id) init{
    self = [super init];
    if(self){
        self.transports = @[@"polling",@"websocket"];
        self.readyStatus = SISocketIOClientStatusClosed;
        self.writeBuffer = [NSMutableArray array];
    }
    
    return self;
    
}

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


-(void)send:(NSData*)data{
    [self sendPacket:SISocketIOPacketTypeMessage data:data];
    
}

-(void)sendPacket:(SISocketIOPacketType)type data:(NSData*)data{
    SISocketIOPacket *packet =[[SISocketIOPacket alloc] init];
    packet.type = type;
    packet.data = data;
    [self.writeBuffer addObject:packet];
    [self flush];
}


-(void)flush{
    if(self.readyStatus != SISocketIOClientStatusClosed && self.transport.writable
       &&  !self.upgrading && self.writeBuffer.count > 0){
        [self.transport send:self.writeBuffer];
        self.prevBufferLen = self.writeBuffer.count;
    
    }
    else{
        [self.transport send:self.writeBuffer];
        self.prevBufferLen = self.writeBuffer.count;
    }
    
}

-(void)open{
    NSString *transport;
    if (self.rememberUpgrade && [self.transports containsObject:@"websocket"]) {
        transport = @"websocket";
    } else {
        transport = [self.transports firstObject];
    }
    self.readyStatus = SISocketIOClientStatusOpening;
    
    self.transport = (SISocketIOTransportPolling*)[SISocketIOTransportFactory createTransport:transport];
    self.transport.delegate = self;
    self.transport.host = self.host;
    self.transport.port = self.port;
    self.transport.path = self.path ? self.path : @"socket.io";
    
    [self.transport open];
    
}


#pragma socketiostransportdelegate

- (void) onPacket:(SISocketIOTransport*)transport packet:(SISocketIOPacket*)packet{
    
    
    switch (packet.type) {
        case SISocketIOPacketTypeOpen:
            [self onHandshake:transport packet:packet];
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

-(NSArray*)filterUpgrades:(NSArray*)upgrades{
    NSMutableArray *filtered = [NSMutableArray array];
    
    for(NSString *transportName in upgrades){
        if([self.transports containsObject:transportName]){
            [filtered addObject:transportName];
        }
    }
    return filtered;
}

-(void)onHandshake:(SISocketIOTransport*)transport packet:(SISocketIOPacket*)packet{
    
    if(packet.type == SISocketIOPacketTypeOpen){
        self.sid =[packet.message objectForKey:@"sid"];
        self.upgrades = [self filterUpgrades:[packet.message objectForKey:@"upgrades"]];
        self.pingInterval =[[packet.message objectForKey:@"pingInterval"] integerValue];
        self.pingTimeout = [[packet.message objectForKey:@"pingTimeout"] integerValue];
        transport.sid = self.sid;
        
        [self onOpen:transport];
    }
    
    
}

-(void)setPing{
    
    
}


-(void)ping{
    
    
    
}

-(void)onOpen:(SISocketIOTransport*)transport{
    self.transport.readyStatus = SISocketIOTransportStatusOpen;
    [self.delegate socketIOClientOnOpen:self];
    
    /*
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
     
     */
}

-(void)onClose:(SISocketIOTransport*)transport{
    
}


-(void)onError:(SISocketIOTransport*)transport error:(NSError *)error{
    
}



@end
