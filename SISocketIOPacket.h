//
//  SISocketIOPacket.h
//  Socket.IO-iOS
//
//  Created by masafumi yoshida on 2014/06/12.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum SISocketIOPacketType : NSInteger {
    SISocketIOPacketTypeConnect = 0,
    SISocketIOPacketTypeDisconnect =1,
    SISocketIOPacketTypeEvent = 2,
    SISocketIOPacketTypeBinaryEvent = 3,
    SISocketIOPacketTypeAck = 4,
    SISocketIOPacketTypeBinaryAck = 5,
    SISocketIOPacketTypeError = 6
} SISocketIOPacketType;

@interface SISocketIOPacket : NSObject
@property (nonatomic) SISocketIOPacketType type;
@property (nonatomic,strong) NSNumber *id;
@property (nonatomic,strong) NSString *nsp;
@property (nonatomic,strong) id data;
@property (nonatomic) NSInteger attachments;
-(NSDictionary*)message;

@end
