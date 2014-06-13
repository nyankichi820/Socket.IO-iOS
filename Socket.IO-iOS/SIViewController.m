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

@end

@implementation SIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SISocketIOClient *client = [[SISocketIOClient alloc] initWithHost:@"localhost" onPort:3000];
    [client connect];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
