
//
//  SISocketIOTransport.m
//  Socket.IO-iOS
//
//  Created by masafumi yoshida on 2014/06/12.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "SISocketIOTransport.h"
#import "SISocketIOTransportPolling.h"
#import "SISocketIOTransportWebSocket.h"

@implementation SISocketIOTransport


- (id) init{
    self = [super init];
    if(self){
        self.timestamp = 0;
        self.readyStatus = SISocketIOTransportStatusClosed;
        self.parser = [[SIEngineIOParser alloc] init];
    }
    return self;
    
}

-(NSString*)endpointURL{
    
    NSString *url = [NSString stringWithFormat:@"%@://%@:%d/%@/?%@",[self protocol],[self host],[self port],[self path],[self query]];
    NSLog(url);
    return url;
}


-(void)send:(NSArray*)packets{
    if(self.readyStatus == SISocketIOTransportStatusOpen){
        [self write:packets];
    }
    
}

-(void)close{
    self.readyStatus = SISocketIOTransportStatusClosed;
    [self.delegate onClose:self];

}

- (void) onPacket:(SIEngineIOPacket*)packet{
    [self.delegate onPacket:self packet:packet];
}

@end
