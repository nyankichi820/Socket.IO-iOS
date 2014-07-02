//
//  SISocketIOParser.h
//  Socket.IO-iOS
//
//  Created by masafumi yoshida on 2014/06/12.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIEngineIOPacket.h"



@interface SIEngineIOParser : NSObject

- (void)parseData:(id)message completion:(void (^)(SIEngineIOPacket*))completion;
- (void)encodePayloads:(NSArray*)packets completion:(void (^)(NSData*))complete;
-(SIEngineIOPacket *)parsePacketBinary:(NSData*)data;
- (NSData*)encodePayloadBinary:(SIEngineIOPacket*)packet;
@end
