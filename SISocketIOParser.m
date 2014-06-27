//
//  SISocketIOParser.m
//  Socket.IO-iOS
//
//  Created by masafumi yoshida on 2014/06/12.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "SISocketIOParser.h"

@implementation SISocketIOParser

- (void)parsePayloadBinary:(NSData*)message{
    NSLog([[NSString alloc] initWithData:message encoding:NSUTF8StringEncoding]);
    
    NSMutableArray *buffers = [NSMutableArray array];
    
    NSData *bufferTail = [NSData dataWithData:message];
    
    
    while(bufferTail.length > 0){
        const uint8_t *fileBytes = (const uint8_t*)[bufferTail bytes];
      
        NSUInteger length = [message length];
        
        NSData *buffer;
        NSMutableString *strLength = [NSMutableString stringWithCapacity: 0];
        
        BOOL isString = (fileBytes[0] == 0) ;
       
        NSLog(@"%d",fileBytes[0]);
        for(int i = 1;i < length  ; i++){
            UInt8 ui= fileBytes[i];
            if (ui == 255) {
                break;
            }
            [strLength appendString:[NSNumber numberWithUnsignedInt:ui].stringValue];
        }
        
        NSLog(@"str length %d",strLength.intValue);
       
        unsigned char aBuffer[strLength.intValue];
        [bufferTail getBytes:aBuffer range:NSMakeRange(2 + strLength.length,strLength.intValue)];
        buffer = [NSData dataWithBytes:aBuffer length:strLength.intValue];
        [buffers addObject:buffer];
        int nextLength = length -  strLength.intValue - 2 - strLength.length;
        NSLog(@"next buffer %d",nextLength);
        unsigned char nextBuffer[nextLength];
        
        [bufferTail getBytes:nextBuffer range:NSMakeRange(2 + strLength.length + strLength.intValue,nextLength)];
        
        bufferTail = [NSData dataWithBytes:nextBuffer length:nextLength];
        
    }
 
    for(NSData *buffer in buffers){
        //NSLog(@"message: %@",[[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding]);
        [self parsePacketBinary:buffer];
    }
}


- (void)parseData:(id)message{

    if([message isKindOfClass:[NSData class]]){
        [self parsePayloadBinary:message];
    }
    else if([message isKindOfClass:[NSString class]]){
        [self parsePacket:message];
    }
    else{
        NSAssert(NO,@"unknown packet");
    }
    
}


- (void)encodePayload:(NSArray*)packets{
    
    for(SISocketIOPacket *packet in packets){
        [self encodePayloadBinary:packet];
        
    }
    
    
}



- (void)encodePayloadBinary:(SISocketIOPacket*)packet{
    Byte type = packet.type;
    NSMutableData *data = [NSData dataWithBytes:type length:1];
    [data appendData:packet.data];
    NSLog([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    
    
    
    
    
}



-(void)parsePacketBinary:(NSData*)data{
    
    
    UInt8 type[1];
    
    [data getBytes:type length:1];
    
    unsigned char messageBytes[data.length -1];
    
    [data getBytes:messageBytes range:NSMakeRange(1, data.length -1)];
    
    NSData *message  = [NSData dataWithBytes:messageBytes length:(data.length -1)];
    NSLog(@"type %c",type[0]);
    NSLog(@"message %@",[[NSString alloc] initWithData:message encoding:NSUTF8StringEncoding]);
    SISocketIOPacket *packet = [[SISocketIOPacket alloc] init];
    packet.type = [NSString stringWithFormat:@"%c",type[0]].intValue;
    packet.data = message;
    [self.delegate onPacket:packet];
    
}

-(void)parsePacket:(NSString*)message{
    
    
    NSLog(@"type %c",[message characterAtIndex:0]);
    NSLog(@"message %@",[message substringFromIndex:1]);
    SISocketIOPacket *packet = [[SISocketIOPacket alloc] init];
    packet.type = [NSString stringWithFormat:@"%c",[message characterAtIndex:0]].intValue;
    packet.data = [[message substringFromIndex:1] dataUsingEncoding:NSUTF8StringEncoding];
    [self.delegate onPacket:packet];
    
}

@end
