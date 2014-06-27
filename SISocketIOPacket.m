//
//  SISocketIOPacket.m
//  Socket.IO-iOS
//
//  Created by masafumi yoshida on 2014/06/12.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "SISocketIOPacket.h"

@implementation SISocketIOPacket

-(NSDictionary*)message{
    NSError *error;
    
    NSDictionary* message = [NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingMutableContainers error:&error];
    
    if(error){
        NSLog(@"packet deserialize error %@",error.description);
        return nil;
    }
    
    return message;
    
}
@end
