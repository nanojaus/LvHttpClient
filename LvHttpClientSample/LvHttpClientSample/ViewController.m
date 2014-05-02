//
//  ViewController.m
//  LvHttpClientSample
//
//  Created by Juan Manuel Abrigo on 5/1/14.
//  Copyright (c) 2014 Lateral View. All rights reserved.
//

#import "ViewController.h"
#import "LvHttpClient.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)testAction:(id)sender{
    LvHttpClient *httpClient = [[LvHttpClient alloc]initWithBaseURL:[NSURL URLWithString:@""]];
    httpClient.jsonCompatible = TRUE;
    
    [httpClient setHeader:@"Authorization" withValue:@""];
    
    [httpClient getMethod:@"" withParams:nil response:^(id object, NSError *error) {
        if (!error) {
            NSLog(@"Response: %@", object);
        }
    }];
}

@end
