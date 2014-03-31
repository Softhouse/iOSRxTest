//
//  RTViewController.m
//  iOSRxTest
//
//  Created by Thomas Lundström on 2014-03-19.
//  Copyright (c) 2014 Softhouse. All rights reserved.
//

#import "RTViewController.h"
#import "RACEXTScope.h"

#import "RTAsyncFetch/RTAsyncFetchViewModel.h"

@implementation RTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Hook up a regular array
    NSArray *array=@[@(1),@(2),@(3)];
    RACSequence *stream = [array rac_sequence];
    [stream map:^id(id value) {
        return @(pow([value integerValue], 2));
    }];
    
    NSLog(@"Sequence'd array: %@", [stream array]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
