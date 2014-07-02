//
//  SIViewController.m
//  Socket.IO-iOS
//
//  Created by masafumi yoshida on 2014/06/12.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "SIViewController.h"
#import "SISocketIOClient.h"
@interface SIViewController ()
@property(nonatomic )  SISocketIOClient *client;
@end

@implementation SIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.client = [[SISocketIOClient alloc] initWithHost:@"localhost" onPort:3000];
    self.client.delegate = self;
    [self.client open];
	// Do any additional setup after loading the view, typically from a nib.
}


-(IBAction)sendMessage:(id)sender{
    
    [self.client send:[@"[\"chat message\",\"dsfsdfd\"]" dataUsingEncoding:NSUTF8StringEncoding]];
    
}

-(void)socketIOClientOnOpen:(SISocketIOClient *)client{
    
   // [client send:[@"[\"chat message\",\"dsfsdfd\"]" dataUsingEncoding:NSUTF8StringEncoding]];
    
}


-(void)socketIOClientOnClose:(SISocketIOClient *)client{
    
}


-(void)socketIOClientOnPacket:(SISocketIOClient *)client packet:(SIEngineIOPacket *)packet{
    
    
}


-(void)socketIOClientOnError:(SISocketIOClient *)client error:(NSError *)error{
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
