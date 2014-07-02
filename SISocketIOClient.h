//
//  SISocketIO.h
//  Socket.IO-iOS
//
//  Created by masafumi yoshida on 2014/06/12.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SISocketIOTransport.h"



typedef enum SISocketIOClientStatus : int {
    SISocketIOClientStatusClosed,
    SISocketIOClientStatusOpening,
    SISocketIOClientStatusOpen,
} SISocketIOClientStatus;

@protocol SISocketIOClientDelegate;


@interface SISocketIOClient : NSObject<SISocketIOTransportDelegate>
@property (nonatomic) SISocketIOClientStatus readyStatus;
@property (nonatomic) NSInteger pingInterval;
@property (nonatomic) NSInteger pingTimeout;
@property (nonatomic) NSInteger timestamp;
@property (nonatomic) NSInteger prevBufferLen;
@property (nonatomic) NSString *host;
@property (nonatomic) NSInteger port;
@property (nonatomic) NSString *sid;
@property (nonatomic) NSString *path;
@property (nonatomic) BOOL useSecure;
@property (nonatomic) BOOL upgrade;
@property (nonatomic) BOOL upgrading;
@property (nonatomic) BOOL onlyBinaryUpgrades;
@property (nonatomic) BOOL forceJSONP;
@property (nonatomic) BOOL forceBase64;
@property (nonatomic) BOOL rememberUpgrade;
@property (nonatomic) SISocketIOTransport *transport;
@property (nonatomic) NSMutableArray *writeBuffer;
@property (nonatomic) NSArray *transports;
@property (nonatomic) NSArray *upgrades;
@property (nonatomic) NSString *timestampParam;
@property (nonatomic) id<SISocketIOClientDelegate> delegate;

- (id) initWithHost:(NSString *)host onPort:(NSInteger)port;
- (id) initWithHost:(NSString *)host onPort:(NSInteger)port withParams:(NSDictionary *)params;
- (id) initWithHost:(NSString *)host onPort:(NSInteger)port withParams:(NSDictionary *)params withPath:(NSString *)path;


-(void)send:(NSData*)data;

-(void)sendPacket:(SIEngineIOPacketType)type data:(NSData*)data;

-(void)open;
-(void)close;

@end

@protocol SISocketIOClientDelegate <NSObject>
- (void) socketIOClientOnOpen:(SISocketIOClient*)client;
- (void) socketIOClientOnClose:(SISocketIOClient*)client;
- (void) socketIOClientOnPacket:(SISocketIOClient*)client packet:(SIEngineIOPacket*)packet;
- (void) socketIOClientOnError:(SISocketIOClient*)client error:(NSError*)error;
@end


