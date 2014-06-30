//
//  SISocketIOParser.h
//  Socket.IO-iOS
//
//  Created by masafumi yoshida on 2014/06/12.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SISocketIOPacket.h"



@interface SISocketIOParser : NSObject

- (void)parseData:(id)message completion:(void (^)(SISocketIOPacket*))completion;
- (void)encodePayloads:(NSArray*)packets completion:(void (^)(NSData*))complete;
-(SISocketIOPacket *)parsePacketBinary:(NSData*)data;
- (NSData*)encodePayloadBinary:(SISocketIOPacket*)packet;
@end
