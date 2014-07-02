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
        self.parser  = [[SIEngineIOParser alloc] init];
        self.manager = [AFHTTPRequestOperationManager manager];
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/octet-stream",@"text/html",@"application/json",nil];
        self.manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
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
    self.readyStatus = SISocketIOTransportStatusOpening;
    
    [self poll];
    
}

-(void)write:(NSArray*)packets{
    self.writable = NO;
    [self.parser encodePayloads:packets completion:^(NSData *data) {
        [self doWrite:data];
    }];
    
    
}


-(void)doWrite:(NSData*)data{
    NSError *error;
    NSString *url = [self endpointURL] ;
    NSLog(@"post url %@",url);
    NSMutableURLRequest *request = [self.manager.requestSerializer requestWithMethod:@"POST" URLString:url parameters:nil error:&error];
    [ request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    
    //POST body
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:data];
    [request setHTTPBody:postbody];
    
    AFHTTPRequestOperation *operation = [self.manager HTTPRequestOperationWithRequest:request
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"data %@",operation.responseData.description);
                                              if([operation.responseString isEqualToString:@"ok"]){
         //                                         [self poll];
                                              }
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"write error %@",error.description);
       // [self poll];
    }];
    [[self.manager operationQueue] addOperation:operation];
 
}

-(void)poll{
    [self.manager GET:[self endpointURL]
      parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"data %@",operation.responseData.description);
          
          [self.parser parseData:operation.responseData completion:^(SIEngineIOPacket *packet) {
                   [self onPacket:packet];
          }];
          
         
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"poll error %@",error.description);
          [self.delegate onError:self error:error];
      }];
    
    
}

- (void) onPacket:(SIEngineIOPacket*)packet{
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
