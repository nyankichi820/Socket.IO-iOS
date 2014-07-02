//
//  Socket_IO_iOSTests.m
//  Socket.IO-iOSTests
//
//  Created by masafumi yoshida on 2014/06/12.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SIEngineIOPacket.h"
#import "SIEngineIOParser.h"
#import "SISocketIOPacket.h"
#import "SISocketIOParser.h"
@interface Socket_IO_iOSTests : XCTestCase

@end

@implementation Socket_IO_iOSTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testParseAndDecodePayloadEngineIOPacket
{
    SIEngineIOPacket *packet = [[SIEngineIOPacket alloc] init];
    
    packet.type = SIEngineIOPacketTypeOpen;
    packet.data = [@"{\"sid\":\"ovKLLn-wzqb85FGSAAAN\",\"upgrades\":[],\"pingInterval\":25000,\"pingTimeout\":60000}" dataUsingEncoding:NSUTF8StringEncoding];
    
    SIEngineIOParser *parser = [[SIEngineIOParser alloc] init];
    
    NSData *data = [parser encodePayloadBinary:packet];
    
   SIEngineIOPacket *packet2 =  [parser parsePacketBinary:data];
   XCTAssertTrue(packet.type == packet2.type, @"type");
    XCTAssertTrue([packet.data isEqual:packet2.data], @"data");
}

- (void)testParseAndDecodeEngineIOPacket
{
    SIEngineIOPacket *packet = [[SIEngineIOPacket alloc] init];
    
    packet.type = SIEngineIOPacketTypeMessage;
    packet.data = [@"{\"sid\":\"ovKLLn-wzqb85FGSAAAN\",\"upgrades\":[],\"pingInterval\":25000,\"pingTimeout\":60000}" dataUsingEncoding:NSUTF8StringEncoding];
    
    SIEngineIOParser *parser = [[SIEngineIOParser alloc] init];
    
    [parser encodePayloads:@[packet] completion:^(NSData *data) {
        [parser parseData:data completion:^(SIEngineIOPacket *packet2) {
            XCTAssertTrue(packet.type == packet2.type, @"type");
            XCTAssertTrue([packet.data isEqual:packet2.data], @"data");
        }];
        
        
    }];
    
  
}




- (void)testEncodeAndDecodeSocketIOPacketString
{
    SISocketIOPacket *packet = [[SISocketIOPacket alloc] init];
    
    packet.type = SISocketIOPacketTypeEvent;
    packet.data = @{@"hoge":@"hoge"} ;
    
    SISocketIOParser *parser = [[SISocketIOParser alloc] init];
    
    NSArray *result = [parser encodeData:packet ];
    
    SISocketIOPacket *packet2 = [parser decodeData:[result objectAtIndex:0] ];
    XCTAssertTrue(packet.type == packet2.type, @"type");
    XCTAssertTrue([packet.data isEqual:packet2.data], @"data");
    
}

- (void)testEncodeAndDecodeSocketIOPacketStringWithNameSpace
{
    SISocketIOPacket *packet = [[SISocketIOPacket alloc] init];
    packet.nsp = @"/";
    packet.type = SISocketIOPacketTypeEvent;
    packet.data = @{@"hoge":@"hoge"};
    SISocketIOParser *parser = [[SISocketIOParser alloc] init];
    
    NSArray *result = [parser encodeData:packet ];
    
    SISocketIOPacket *packet2 = [parser decodeData:[result objectAtIndex:0] ];
    XCTAssertTrue(packet.type == packet2.type, @"type");
    XCTAssertTrue([packet.data isEqual:packet2.data], @"data");
    
    
    packet.nsp = @"/hoge";
    result = [parser encodeData:packet ];
    
    packet2 = [parser decodeData:[result objectAtIndex:0] ];
    XCTAssertTrue(packet.type == packet2.type, @"type");
    XCTAssertTrue([packet.data isEqual:packet2.data], @"data");
    
}

- (void)testEncodeAndDecodeSocketIOPacketStringWithId
{
    SISocketIOPacket *packet = [[SISocketIOPacket alloc] init];
    packet.id = @1;
    packet.type = SISocketIOPacketTypeEvent;
    packet.data = @{@"hoge":@"hoge"};
    
    SISocketIOParser *parser = [[SISocketIOParser alloc] init];
    
    NSArray *result = [parser encodeData:packet ];
    
    SISocketIOPacket *packet2 = [parser decodeData:[result objectAtIndex:0] ];
    XCTAssertTrue(packet.type == packet2.type, @"type");
    XCTAssertTrue([packet.data isEqual:packet2.data], @"data");
    
    
    packet.id = @11111;
    result = [parser encodeData:packet ];
    
    packet2 = [parser decodeData:[result objectAtIndex:0] ];
    XCTAssertTrue(packet.type == packet2.type, @"type");
    XCTAssertTrue([packet.data isEqual:packet2.data], @"data");
    
}



- (void)testEncodeAndDecodeSocketIOPacketBinary
{
    SISocketIOPacket *packet = [[SISocketIOPacket alloc] init];
    
    packet.type = SISocketIOPacketTypeBinaryEvent;
    packet.data = [@"test" dataUsingEncoding:NSUTF8StringEncoding];
    
    SISocketIOParser *parser = [[SISocketIOParser alloc] init];
    
    NSArray *result = [parser encodeData:packet ];
    
    SISocketIOPacket *packet2 = [parser decodeData:[result objectAtIndex:0] ];
    XCTAssertTrue(packet.type == packet2.type, @"type");
    XCTAssertTrue([packet.data isEqualToString:packet2.data], @"data");
    
}

- (void)testEncodeAndDecodeSocketIOPacketBinaryWithNameSpace
{
    SISocketIOPacket *packet = [[SISocketIOPacket alloc] init];
    packet.nsp = @"/";
    packet.type = SISocketIOPacketTypeBinaryEvent;
    packet.data = @"{\"sid\":\"ovKLLn-wzqb85FGSAAAN\",\"upgrades\":[],\"pingInterval\":25000,\"pingTimeout\":60000}" ;
    
    SISocketIOParser *parser = [[SISocketIOParser alloc] init];
    
    NSArray *result = [parser encodeData:packet ];
    
    SISocketIOPacket *packet2 = [parser decodeData:[result objectAtIndex:0] ];
    XCTAssertTrue(packet.type == packet2.type, @"type");
    XCTAssertTrue([packet.data isEqualToString:packet2.data], @"data");
    
    
    packet.nsp = @"/hoge";
    result = [parser encodeData:packet ];
    
    packet2 = [parser decodeData:[result objectAtIndex:0] ];
    XCTAssertTrue(packet.type == packet2.type, @"type");
    XCTAssertTrue([packet.data isEqualToString:packet2.data], @"data");
    
}

- (void)testEncodeAndDecodeSocketIOPacketBinaryWithId
{
    SISocketIOPacket *packet = [[SISocketIOPacket alloc] init];
    packet.id = @1;
    packet.type = SISocketIOPacketTypeBinaryEvent;
    packet.data = @"{\"sid\":\"ovKLLn-wzqb85FGSAAAN\",\"upgrades\":[],\"pingInterval\":25000,\"pingTimeout\":60000}" ;
    
    SISocketIOParser *parser = [[SISocketIOParser alloc] init];
    
    NSArray *result = [parser encodeData:packet ];
    
    SISocketIOPacket *packet2 = [parser decodeData:[result objectAtIndex:0] ];
    XCTAssertTrue(packet.type == packet2.type, @"type");
    XCTAssertTrue([packet.data isEqualToString:packet2.data], @"data");
    
    
    packet.id = @11111;
    result = [parser encodeData:packet ];
    
    packet2 = [parser decodeData:[result objectAtIndex:0] ];
    XCTAssertTrue(packet.type == packet2.type, @"type");
    XCTAssertTrue([packet.data isEqualToString:packet2.data], @"data");
    
}

@end
