//
//  RTViewController.m
//  iOSRxTest
//
//  Created by Thomas Lundström on 2014-03-19.
//  Copyright (c) 2014 Thomas Lundström. All rights reserved.
//

#import "RTViewController.h"


@interface RTViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

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
    
    
    // Hook up subscription to the text field signal
    [self.textField.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"New value: %@", x);
    } error:^(NSError *error) {
        NSLog(@"Error: %@", error);
    } completed:^{
        NSLog(@"Completed");
    }];

    // Enable/disable the button based on the user having written an '@'
    RAC(self.button, enabled) = [self.textField.rac_textSignal map:^id(NSString*value){
        NSLog(@"rangeOfString: %lu", (unsigned long)[value rangeOfString:@"@"].location);
        return @([value rangeOfString:@"@"].location != NSNotFound);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
