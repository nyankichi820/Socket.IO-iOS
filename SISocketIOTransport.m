
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

-(NSString*)query{
    if(!self.timestamp){
        self.timestamp =[NSDate date].timeIntervalSince1970;
        
    }
    if(!self.timestamps){
        self.timestamps = 0;
    }
    else{
        self.timestamps++;
    }
    return [NSString stringWithFormat:@"EIO=2&t=%d-%d&transport=%@",self.timestamp,self.timestamps,self.class.transportName];
    
}

-(NSURL*)endpointURL{
    return [NSURL URLWithString:
            [NSString stringWithFormat:@"%@://%@:%d/%@?%@",[self protocol],[self host],[self port],[self path],[self query]]];
    
}

@end
