//
//  SISocketIOParser.h
//  Socket.IO-iOS
//
//  Created by masafumi yoshida on 2014/07/01.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SISocketIOPacket.h"
@interface SISocketIOParser : NSObject
- (NSArray*)encodeData:(SISocketIOPacket *)packet;
-(SISocketIOPacket *)decodeData:(id)data;
@end
