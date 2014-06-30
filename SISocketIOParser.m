//
//  SISocketIOParser.m
//  Socket.IO-iOS
//
//  Created by masafumi yoshida on 2014/06/12.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "SISocketIOParser.h"

@implementation SISocketIOParser

- (void)parsePayloadBinary:(NSData*)message  completion:(void (^)(SISocketIOPacket*))completion{
    NSLog([message description]);
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
        SISocketIOPacket *packet = [self parsePacketBinary:buffer];
        completion(packet);
    }
}


- (void)parseData:(id)message  completion:(void (^)(SISocketIOPacket*))completion{

    if([message isKindOfClass:[NSData class]]){
        [self parsePayloadBinary:message completion:completion];
    }
    else if([message isKindOfClass:[NSString class]]){
        SISocketIOPacket *packet = [self parsePacket:message];
        completion(packet);
    }
    else{
        NSAssert(NO,@"unknown packet");
    }
    
}


- (void)encodePayloads:(NSArray*)packets  completion:(void (^)(SISocketIOPacket*))completion{
    NSMutableArray *encodePackets = [NSMutableArray array];
    int totalLength = 0;
    for(SISocketIOPacket *packet in packets){
        NSData *data = [self encodePayloadBinary:packet];
        NSString *strLength = [NSString stringWithFormat:@"%d",data.length ];
        totalLength += data.length + strLength.length + 2;
        [encodePackets addObject:data];
    }
    
    uint8_t resultArray[totalLength];
    
    int bufferIndex = 0;
    for(NSData *data in encodePackets){
        resultArray[bufferIndex++] = (unsigned int)0;
        NSString *strLength = [NSString stringWithFormat:@"%d",data.length ];
        for(int i = 0 ;i< strLength.length;i++){
            uint8_t charI= (uint8_t)[strLength substringWithRange:NSMakeRange(i,1)].integerValue ;
            resultArray[bufferIndex++] = charI;
        }
        resultArray[bufferIndex++]  = 255;
        const uint8_t *bytes = (const uint8_t*)[data bytes];
        for(int i=0;i<data.length ;i++){
            resultArray[bufferIndex++] = bytes[i];
        }
    }

    NSData *encodeData =[ NSData dataWithBytes:resultArray length:totalLength];
    completion(encodeData);
}



- (NSData*)encodePayloadBinary:(SISocketIOPacket*)packet{
    unsigned char type = [[NSString  stringWithFormat:@"%d",packet.type] characterAtIndex:0];
    

    const uint8_t *bytes = (const uint8_t*)[packet.data bytes];
    NSLog(@"size %d %d",packet.data.length ,sizeof(type));
    uint8_t payload[packet.data.length + 1];
    payload[0] = type;
    for(int i=0;i<packet.data.length ;i++){
        payload[i+1] = bytes[i];
    }
    
    
    

    NSData *data =[ NSData dataWithBytes:payload length:(1 + packet.data.length)];
    
    NSLog([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    return data;
    
    
    
    
}



-(SISocketIOPacket *)parsePacketBinary:(NSData*)data{
    
    
    UInt8 type[1];
    
    [data getBytes:type length:1];
    
    unsigned char messageBytes[data.length -sizeof(type)];
    
    [data getBytes:messageBytes range:NSMakeRange(sizeof(type), data.length -sizeof(type))];
    NSLog(@"data %@",[data description]);
    NSLog(@"encode %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    NSData *message  = [NSData dataWithBytes:messageBytes length:(data.length -sizeof(type))];
    NSLog(@"type %c",type[0]);
    NSLog(@"message %@",[[NSString alloc] initWithData:message encoding:NSUTF8StringEncoding]);
    SISocketIOPacket *packet = [[SISocketIOPacket alloc] init];
    packet.type = [NSString stringWithFormat:@"%c",type[0]].intValue;
    packet.data = message;
    return packet;
    
}

-(SISocketIOPacket *)parsePacket:(NSString*)message{
    
    
    NSLog(@"type %c",[message characterAtIndex:0]);
    NSLog(@"message %@",[message substringFromIndex:1]);
    SISocketIOPacket *packet = [[SISocketIOPacket alloc] init];
    packet.type = [NSString stringWithFormat:@"%c",[message characterAtIndex:0]].intValue;
    packet.data = [[message substringFromIndex:1] dataUsingEncoding:NSUTF8StringEncoding];
    return packet;
    
}

@end
