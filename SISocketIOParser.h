//
//  SISocketIOParser.h
//  Socket.IO-iOS
//
//  Created by masafumi yoshida on 2014/06/12.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SISocketIOPacket.h"


@protocol SISocketIOParserDelegate <NSObject>
- (void) onPacket:(SISocketIOPacket*)packet;
@end


@interface SISocketIOParser : NSObject
@property(nonatomic,strong) id<SISocketIOParserDelegate> delegate;

- (void)parseData:(NSData*)message ;
@end
