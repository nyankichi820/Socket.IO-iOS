//
//  SIEngineIOPacket.h
//  Socket.IO-iOS
//
//  Created by masafumi yoshida on 2014/07/01.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum SIEngineIOPacketType : NSInteger {
    SIEngineIOPacketTypeOpen,
    SIEngineIOPacketTypeClose,
    SIEngineIOPacketTypePing,
    SIEngineIOPacketTypePong,
    SIEngineIOPacketTypeMessage,
    SIEngineIOPacketTypeUpgrade,
    SIEngineIOPacketTypeNoop,
    SIEngineIOPacketTypeError
} SIEngineIOPacketType;



@interface SIEngineIOPacket : NSObject
@property (nonatomic) SIEngineIOPacketType type;
@property (nonatomic,strong) NSData *data;
-(NSDictionary*)message;
@end
