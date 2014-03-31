//
//  RTFormValidationViewController.m
//  iOSRxTest
//
//  Created by Thomas Lundström on 2014-03-29.
//  Copyright (c) 2014 Softhouse. All rights reserved.
//

#import "RTFormValidationViewController.h"

#import "RACEXTScope.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RTFormValidationViewController()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *button;


@end

@implementation RTFormValidationViewController

-(void)viewDidLoad
{
    // Hook up subscription to the text field signal
    [self.textField.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"new textField value: %@", x);
    } error:^(NSError *error) {
        NSLog(@"Error: %@", error);
    } completed:^{
        NSLog(@"Completed");
    }];
    
    RACSignal *validEmailSignal = [self.textField.rac_textSignal map:^id(id value) {
        return @([value rangeOfString:@"@"].location != NSNotFound);
    }];
    
    // Enable/disable the button based on the user having written an '@'
    //    RAC(self.button, enabled) = validEmailSignal;
    self.button.rac_command = [[RACCommand alloc] initWithEnabled:validEmailSignal signalBlock:^RACSignal *(id input) {
        NSLog(@"Button was pressed");
        return [RACSignal empty];
    }];

}

@end
