//
//  SISocketIOTransportWebSocket.h
//  Socket.IO-iOS
//
//  Created by masafumi yoshida on 2014/06/12.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "SISocketIOTransport.h"
#import <SocketRocket/SRWebSocket.h>
@interface SISocketIOTransportWebSocket : SISocketIOTransport<SISocketIOTransport,SRWebSocketDelegate>

@end
