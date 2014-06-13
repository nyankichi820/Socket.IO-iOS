
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
        
    }
    
    return self;
    
}

-(NSString*)query{
        self.timestamp =[NSDate date].timeIntervalSince1970;
    NSString *query = [NSString stringWithFormat:@"EIO=2&t=%d-%d&transport=%@",self.timestamp,self.timestamps,self.class.transportName];
    self.timestamps++;
    return query;
}

-(NSString*)endpointURL{
    
    NSString *url = [NSString stringWithFormat:@"%@://%@:%d/%@/?%@",[self protocol],[self host],[self port],[self path],[self query]];
    NSLog(url);
    return url;
}

@end
