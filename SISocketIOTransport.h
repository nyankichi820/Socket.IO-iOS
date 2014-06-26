//
//  SISocketIOTransport.h
//  Socket.IO-iOS
//
//  Created by masafumi yoshida on 2014/06/12.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum SISocketIOTransportStatus : int {
    SISocketIOTransportStatusClosed,
    SISocketIOTransportStatusOpening,
    SISocketIOTransportStatusOpen
} SISocketIOTransportStatus;


typedef void (^SISocketIOTransportReceiveEventSuccessBlocks)(NSString *eventName,NSDictionary*message);
typedef void (^SISocketIOTransportOpenedBlocks)(void);
typedef void (^SISocketIOTransportClosedBlocks)(void);
typedef void (^SISocketIOTransportFailureBlocks)(NSError *error);


@protocol SISocketIOTransport <NSObject>
+(NSString*)transportName;
-(NSString*)protocol;
@end


@interface SISocketIOTransport : NSObject<SISocketIOTransport>
@property (nonatomic) SISocketIOTransportStatus readyState;
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

@property (nonatomic,strong) SISocketIOTransportReceiveEventSuccessBlocks receiveEventSuccessBlocks;
@property (nonatomic,strong) SISocketIOTransportFailureBlocks failureBlocks;
@property (nonatomic,strong) SISocketIOTransportOpenedBlocks openedBlocks;
@property (nonatomic,strong) SISocketIOTransportClosedBlocks closedBlocks;

-(NSString*)endpointURL;
-(void)connect;

@end
