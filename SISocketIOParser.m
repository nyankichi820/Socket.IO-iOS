//
//  SISocketIOParser.m
//  Socket.IO-iOS
//
//  Created by masafumi yoshida on 2014/06/12.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "SISocketIOParser.h"

@implementation SISocketIOParser
- (NSDictionary*)parseData:(NSData*)message{
    unsigned char type[1];
    [message getBytes:type length:1];
    unsigned char data[message.length -1];
    [message getBytes:data range:NSMakeRange(1, message.length -1)];
    NSLog(@"type %@",[NSString stringWithCString:type]);
    NSLog(@"data %@",[NSString stringWithCString:data]);
    
    
    return @{};
}
@end
