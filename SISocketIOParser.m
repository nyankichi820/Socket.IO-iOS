//
//  SISocketIOParser.m
//  Socket.IO-iOS
//
//  Created by masafumi yoshida on 2014/07/01.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "SISocketIOParser.h"

@implementation SISocketIOParser
- (NSArray*)encodeData:(SISocketIOPacket *)packet{
    switch (packet.type) {
        case SISocketIOPacketTypeBinaryEvent:
            return [self encodeBinaryPacket:packet];
            break;
        case SISocketIOPacketTypeBinaryAck:
             return [self encodeBinaryPacket:packet];
            break;
            
        default:
            return @[ [self encodeStringData:packet]];
            break;
    }
}

-(NSArray*)encodeBinaryPacket:(SISocketIOPacket*)packet{
    NSDictionary *deconstruct = [self deconstructBinaryPacket:packet];
    id pack = [self encodeStringData:[deconstruct objectForKey:@"packet" ]];
    NSMutableArray *buffers = [deconstruct objectForKey:@"buffers"];
    [buffers insertObject:pack atIndex:0];
    return buffers;
}

- (NSDictionary*)deconstructBinaryPacket:(SISocketIOPacket *)packet{
    NSMutableArray *buffers = [NSMutableArray array];
    
    packet.data = [self deconstructBinaryData:packet.data buffers:buffers];
    
    packet.attachments = buffers.count;
    return @{@"packet":packet,@"buffers":buffers};
    
}

- (id)deconstructBinaryData:(id)data buffers:(NSMutableArray*)buffers{
    if([data isKindOfClass:[NSData class]]){
        NSDictionary *placeholder = @{@"_placeholder": @YES, @"num":  [NSNumber numberWithInt: buffers.count]};
        [buffers addObject:data];
        return placeholder;
    }
    else if([data isKindOfClass:[NSArray class]]){
        NSMutableArray *dataArray = [NSMutableArray array];
        for(id row in data){
            [dataArray addObject:[self deconstructBinaryData:row buffers:buffers]];
        }
        return dataArray;
    }
    else if([data isKindOfClass:[NSDictionary class]]){
        NSDictionary *dataDictionary = (NSDictionary*)data;
        NSMutableDictionary *newDataDictionary = [NSMutableDictionary dictionary];
        
        for(NSString *key in dataDictionary.allKeys){
           [ newDataDictionary setValue:[self deconstructBinaryData:[dataDictionary objectForKey:key] buffers:buffers] forKey:key];
        }
        
    }
    return nil;
    
}

- (NSString*)encodeStringData:(SISocketIOPacket *)packet{
    NSMutableString *encodeString = [NSMutableString string];
    [encodeString appendString:[NSString stringWithFormat:@"%d",packet.type]];
    
    if(packet.type == SISocketIOPacketTypeBinaryEvent || packet.type == SISocketIOPacketTypeBinaryAck){
        [encodeString appendString:[NSString stringWithFormat:@"%d-",packet.attachments]];
    }
    
    BOOL nsp = NO;
    if(packet.nsp && packet.nsp.length > 0 && ![packet.nsp isEqualToString:@"/"]){
        nsp = YES;
        [encodeString appendString:packet.nsp];
    }
    
    if(packet.id){
        if(nsp){
            [encodeString appendString:@","];
            nsp = NO;
        }
        [encodeString appendString:packet.id.stringValue];
    }
    
    if(packet.data){
        if(nsp){
            [encodeString appendString:@","];
        }
        NSError *error;
        NSData *data= [NSJSONSerialization dataWithJSONObject:packet.data options:nil error:&error];

        [encodeString appendString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding ]];
    }
    
    return encodeString;
    
}

-(SISocketIOPacket*)decodeData:(id)data{
    int type;
    if([data isKindOfClass:[NSString class]]){
        type = [NSNumber numberWithChar:[data characterAtIndex:0]].integerValue;
    }
    else if([data isKindOfClass:[NSData class]]){
        NSData *binaryData = (NSData*)data;
        [binaryData getBytes:&type length:1];
    }
    
    
    switch (type) {
        case SISocketIOPacketTypeBinaryEvent:
            return [self decodeBinaryData:data];
            break;
        case SISocketIOPacketTypeBinaryAck:
            return [self decodeBinaryData:data];
            break;
            
        default:
            return [self decodeStringData:data];
            break;
    }
    
}


- (id)reconstructBinaryData:(id)data buffers:(NSMutableArray*)buffers{
    if([data isKindOfClass:[NSData class]]){
        NSDictionary *placeholder = @{@"_placeholder": @YES, @"num":  [NSNumber numberWithInt: buffers.count]};
        [buffers addObject:data];
        return placeholder;
    }
    else if([data isKindOfClass:[NSArray class]]){
        NSMutableArray *dataArray = [NSMutableArray array];
        for(id row in data){
            [dataArray addObject:[self deconstructBinaryData:row buffers:buffers]];
        }
        return dataArray;
    }
    else if([data isKindOfClass:[NSDictionary class]]){
        NSDictionary *dataDictionary = (NSDictionary*)data;
        NSMutableDictionary *newDataDictionary = [NSMutableDictionary dictionary];
        
        for(NSString *key in dataDictionary.allKeys){
            [ newDataDictionary setValue:[self deconstructBinaryData:[dataDictionary objectForKey:key] buffers:buffers] forKey:key];
        }
        
    }
    return nil;
    
}


-(SISocketIOPacket *)decodeBinaryData:(id)data{
    if([data isKindOfClass:[NSString class]]){
        SISocketIOPacket *packet = [self decodeStringData:data];
        
        
    }
    else if([data isKindOfClass:[NSData class]]){
    
        
        
    }
    return nil;
}

-(SISocketIOPacket *)decodeStringData:(id)data{
    int i = 0;
    NSString *string = (NSString*)data;
    
    SISocketIOPacket *packet = [[SISocketIOPacket alloc] init];
    packet.type = [string substringWithRange:NSMakeRange(0,1)].integerValue;
    
    
    if(packet.type == SISocketIOPacketTypeBinaryEvent || packet.type == SISocketIOPacketTypeBinaryAck){
        NSMutableString *attachments = [NSMutableString string];
        while(YES){
            i++;
            NSString *c = [string substringWithRange:NSMakeRange(i,1)] ;
            if([c isEqualToString:@"-"]){
                packet.attachments = attachments.integerValue;
                break;
            }
            [attachments appendString:c];
        }
        
    }
    
    if([[string substringWithRange:NSMakeRange(1,1)] isEqualToString:@"/"]){
        NSMutableString *nsp = [NSMutableString string];
        while(YES){
            i++;
            NSString *c = [string substringWithRange:NSMakeRange(i,1)] ;
            if([c isEqualToString:@","]){
                packet.nsp = nsp;
                break;
            }
            [nsp appendString:c];
            if((i  + 1) == string.length){
                packet.nsp = nsp;
                return packet;
            }
        }
    }
    char next = [string characterAtIndex:i+1] ;
    
    if(isdigit(next)){
        NSMutableString *idString = [NSMutableString string];
        while(YES){
            i++;
            char c = [string characterAtIndex:i];
            if(!isdigit(c) ){
                packet.id = [NSNumber numberWithInteger:idString.integerValue] ;
                i--;
                break;
            }
            [idString appendString:[NSString stringWithFormat:@"%c",c]];
            if((i  + 1) == string.length){
                packet.id = [NSNumber numberWithInteger:idString.integerValue];
                return packet;
                break;
            }
        }
    }
    NSString *stringData =  [string substringFromIndex:i+1];
    NSError *error;
    packet.data  = [NSJSONSerialization JSONObjectWithData:[stringData dataUsingEncoding:NSUTF8StringEncoding] options:nil error:&error];
    return packet;
}

@end
