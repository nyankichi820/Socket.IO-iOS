//
//  SISocketIOTransport.h
//  Socket.IO-iOS
//
//  Created by masafumi yoshida on 2014/06/12.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SISocketIOTransport <NSObject>
+(NSString*)transportName;
-(NSString*)protocol;
@end


@interface SISocketIOTransport : NSObject<SISocketIOTransport>
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


-(NSURL*)endpointURL;
-(void)connect;

@end