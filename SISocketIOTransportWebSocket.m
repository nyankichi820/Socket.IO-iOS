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
@property (nonatomic) SRWebSocket *webSocket;
@end

@implementation SISocketIOTransportWebSocket


-(NSString*)protocol{
    return self.useSecure ? @"wss" : @"ws";
}

+(NSString*)transportName{
    return @"websocket";
}


-(void)connect{
    self.webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:[self endpointURL]]];
    self.webSocket.delegate = self;
    [self.webSocket open];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{

    
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    if(self.openedBlocks){
        self.openedBlocks();
    }
}
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    if(self.failureBlocks){
        self.failureBlocks(error);
    }
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    if(self.closedBlocks){
        self.closedBlocks();
    }
}

@end
