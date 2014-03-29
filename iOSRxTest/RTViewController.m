//
//  RTViewController.m
//  iOSRxTest
//
//  Created by Thomas Lundström on 2014-03-19.
//  Copyright (c) 2014 Thomas Lundström. All rights reserved.
//

#import "RTViewController.h"
#import "RACEXTScope.h"

#import "RTAsyncFetch/RTAsyncFetchViewModel.h"


@interface RTViewController (){
    RACSubject *_runNext;
}

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *nextLabel;

@property (nonatomic, strong, readwrite) NSString *nextLabelValue;

@property (nonatomic, strong) RTAsyncFetchViewModel *viewModel;

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
    

    
    self.viewModel = [[RTAsyncFetchViewModel alloc] init];
    
    RAC(self.nextLabel, text) = RACObserve(self.viewModel, nextLabelValue);

    @weakify(self);

    self.nextButton.rac_command = [[RACCommand alloc] initWithSignalBlock: ^RACSignal *(id input) {
        NSLog(@"Next button was pressed");
        @strongify(self);
        
        [self.viewModel fetchValue];

        return [RACSignal empty];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
