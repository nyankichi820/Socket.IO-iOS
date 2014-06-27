//
//  SISocketIOTransportWebSocket.m
//  Socket.IO-iOS
//
//  Created by masafumi yoshida on 2014/06/12.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "SISocketIOTransportWebSocket.h"
#import <SocketRocket/SRWebSocket.h>

@interface SISocketIOTransportWebSocket ()
@property (nonatomic,strong) SRWebSocket *webSocket;
@end

@implementation SISocketIOTransportWebSocket




-(NSString*)protocol{
    return self.useSecure ? @"wss" : @"ws";
}

+(NSString*)transportName{
    return @"websocket";
}


-(NSString*)query{
    NSString *query;
    
    if(self.sid){
        query = [NSString stringWithFormat:@"EIO=2&transport=%@&sid=%@",self.class.transportName,self.sid];
    }
    else{
        query = [NSString stringWithFormat:@"EIO=2&transport=%@",self.class.transportName];
    }
    return query;
}


-(void)open{
    self.readyStatus = SISocketIOTransportStatusOpening;
    
    self.webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:[self endpointURL]]];
    self.webSocket.delegate = self;
    [self.webSocket open];
}

-(void)close{
    if(self.webSocket){
        [self.webSocket close];
    }
    self.readyStatus = SISocketIOTransportStatusClosed;
    [self.delegate onClose:self];
}

-(void)emit:(NSString*)eventName params:(NSDictionary*)params{
    

    
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    
    [self.parser parseData:message];
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    self.readyStatus = SISocketIOTransportStatusOpen;
    
    [self.delegate onOpen:self];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    self.readyStatus = SISocketIOTransportStatusClosed;
    
    [self.delegate onError:self error:error];
    
}
    
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    self.readyStatus = SISocketIOTransportStatusClosed;
    [self.delegate onClose:self];
}



@end
