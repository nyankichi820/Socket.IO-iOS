//
//  SISocketIOTransportPolling.m
//  Socket.IO-iOS
//
//  Created by masafumi yoshida on 2014/06/12.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "SISocketIOTransportPolling.h"
#import <AFNetworking/AFNetworking.h>
@interface SISocketIOTransportPolling ()
@property (nonatomic,strong) AFHTTPRequestOperationManager* manager;
@end

@implementation SISocketIOTransportPolling


- (id) init{
    self = [super init];
    if(self){
        self.timestamp = 0;
        self.readyStatus = SISocketIOTransportStatusClosed;
        self.parser  = [[SISocketIOParser alloc] init];
        self.parser.delegate = self;
        self.manager = [AFHTTPRequestOperationManager manager];
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/octet-stream"];
    }
    return self;
    
}

-(NSString*)protocol{
    return self.useSecure ? @"https" : @"http";
}

+(NSString*)transportName{
    return @"polling";
}

-(NSString*)query{
    self.timestamp =[NSDate date].timeIntervalSince1970;
    
    NSString *query;
    if(!self.sid){
        query = [NSString stringWithFormat:@"EIO=2&t=%d-%d&transport=%@",self.timestamp,self.timestamps,self.class.transportName];
    }
    else{
        query = [NSString stringWithFormat:@"EIO=2&t=%d-%d&transport=%@&sid=%@",self.timestamp,self.timestamps,self.class.transportName,self.sid];
        
    }
    self.timestamps++;
    return query;
}


-(void)open{
    [self poll];
    
}

-(void)poll{
    self.readyStatus = SISocketIOTransportStatusOpening;
    [self.manager GET:[self endpointURL]
      parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"data %@",operation.responseData.description);
          
          [self.parser parseData:operation.responseData];
          
          
         
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          self.readyStatus = SISocketIOTransportStatusClosed;
          [self.delegate onError:self error:error];
      }];
    
    
}

- (void) onPacket:(SISocketIOPacket*)packet{
    
  
    [self.delegate onPacket:self packet:packet];
    [self poll];
    
    
}

-(void)close{
    if(self.manager){
        [self.manager.operationQueue cancelAllOperations];
    }
    self.readyStatus = SISocketIOTransportStatusClosed;
    [self.delegate onClose:self];
}


@end
