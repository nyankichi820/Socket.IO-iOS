//
//  SISocketIOTransportPolling.m
//  Socket.IO-iOS
//
//  Created by masafumi yoshida on 2014/06/12.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "SISocketIOTransportPolling.h"
#import <AFNetworking/AFNetworking.h>

@implementation SISocketIOTransportPolling

+(NSString*)transportName{
    return @"polling";
}

-(void)connect{
    
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:[self endpointURL]
      parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
      }];
    
    
}


@end
