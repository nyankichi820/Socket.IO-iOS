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



-(NSString*)protocol{
    return self.useSecure ? @"https" : @"http";
}

+(NSString*)transportName{
    return @"polling";
}

-(void)connect{
    
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/octet-stream"];
    [manager GET:[self endpointURL]
      parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"data %@",operation.responseString);
          if(self.openedBlocks){
              self.openedBlocks();
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if(self.failureBlocks){
              self.failureBlocks(error);
          }
      }];
    
    
}


@end
