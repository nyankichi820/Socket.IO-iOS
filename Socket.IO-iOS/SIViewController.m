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
    self.client.delegate;
    [self.client open];
	// Do any additional setup after loading the view, typically from a nib.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
