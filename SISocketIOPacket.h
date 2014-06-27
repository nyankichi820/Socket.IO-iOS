//
//  SISocketIOPacket.h
//  Socket.IO-iOS
//
//  Created by masafumi yoshida on 2014/06/12.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum SISocketIOPacketType : int {
    SISocketIOPacketTypeOpen,
    SISocketIOPacketTypeClose,
    SISocketIOPacketTypePing,
    SISocketIOPacketTypePong,
    SISocketIOPacketTypeMessage,
    SISocketIOPacketTypeUpgrade,
    SISocketIOPacketTypeNoop,
    SISocketIOPacketTypeError
} SISocketIOPacketType;


@interface SISocketIOPacket : NSObject
@property (nonatomic) SISocketIOPacketType type;
@property (nonatomic,strong) NSData *data;
-(NSDictionary*)message;

@end
