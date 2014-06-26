//
//  SISocketIOTransport.h
//  Socket.IO-iOS
//
//  Created by masafumi yoshida on 2014/06/12.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SISocketIOParser.h"


typedef enum SISocketIOTransportStatus : int {
    SISocketIOTransportStatusClosed,
    SISocketIOTransportStatusOpening,
    SISocketIOTransportStatusOpen,
} SISocketIOTransportStatus;





@protocol SISocketIOTransport <NSObject>
+(NSString*)transportName;
-(NSString*)protocol;
-(NSString*)query;
@end

@protocol SISocketIOTransportDelegate <NSObject>
- (void) onData:(id)message;
- (void) onOpen:(id <SISocketIOTransport>)transport;
- (void) onClose:(id <SISocketIOTransport>)transport;
- (void) onError:(id <SISocketIOTransport>)transport error:(NSError*)error;
@end


@interface SISocketIOTransport : NSObject<SISocketIOTransport>
@property (nonatomic) SISocketIOTransportStatus readyStatus;
@property (nonatomic) NSInteger timestamp;
@property (nonatomic) NSInteger timestamps;
@property (nonatomic) NSString *host;
@property (nonatomic) NSInteger port;
@property (nonatomic) NSString *sid;
@property (nonatomic) NSString *path;
@property (nonatomic) BOOL useSecure;
@property (nonatomic) BOOL upgrade;
@property (nonatomic) BOOL onlyBinaryUpgrades;
@property (nonatomic) BOOL forceJSONP;
@property (nonatomic) BOOL forceBase64;
@property (nonatomic) SISocketIOTransport *transport;
@property (nonatomic) NSArray *transports;
@property (nonatomic) NSString *timestampParam;
@property (nonatomic) SISocketIOParser *parser;
@property (nonatomic,weak) id <SISocketIOTransportDelegate> delegate;



-(NSString*)endpointURL;
-(void)emit:(NSString*)eventName data:(NSData*)data;
-(void)emit:(NSString*)eventName params:(NSDictionary*)params;

-(void)onPacket:(id)message;

-(void)open;
-(void)close;
@end
