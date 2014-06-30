//
//  Socket_IO_iOSTests.m
//  Socket.IO-iOSTests
//
//  Created by masafumi yoshida on 2014/06/12.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import <XCTest/XCTest.h>
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

- (void)testPayload
{
    SISocketIOPacket *packet = [[SISocketIOPacket alloc] init];
    
    packet.type = SISocketIOPacketTypeOpen;
    packet.data = [@"{\"sid\":\"ovKLLn-wzqb85FGSAAAN\",\"upgrades\":[],\"pingInterval\":25000,\"pingTimeout\":60000}" dataUsingEncoding:NSUTF8StringEncoding];
    
    SISocketIOParser *parser = [[SISocketIOParser alloc] init];
    
    NSData *data = [parser encodePayloadBinary:packet];
    
   SISocketIOPacket *packet2 =  [parser parsePacketBinary:data];
   XCTAssertTrue(packet.type == packet2.type, @"type");
    XCTAssertTrue([packet.data isEqual:packet2.data], @"data");
}

- (void)testEncodeDecode
{
    SISocketIOPacket *packet = [[SISocketIOPacket alloc] init];
    
    packet.type = SISocketIOPacketTypeMessage;
    packet.data = [@"{\"sid\":\"ovKLLn-wzqb85FGSAAAN\",\"upgrades\":[],\"pingInterval\":25000,\"pingTimeout\":60000}" dataUsingEncoding:NSUTF8StringEncoding];
    
    SISocketIOParser *parser = [[SISocketIOParser alloc] init];
    
    [parser encodePayloads:@[packet] completion:^(NSData *data) {
        [parser parseData:data completion:^(SISocketIOPacket *packet2) {
            XCTAssertTrue(packet.type == packet2.type, @"type");
            XCTAssertTrue([packet.data isEqual:packet2.data], @"data");
        }];
        
        
    }];
    
  
}

@end
