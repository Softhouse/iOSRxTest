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
    
    // nytt försök
//    RAC(self.nextLabel, text) = RACObserve(self, nextLabelValue);
    
    @weakify(self);
    __block NSNumber *iterCount = [NSNumber numberWithInt:0];
    
//    RACSignal *fetchSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
////        @strongify(self);
//        
//        int value = [iterCount intValue];
//        iterCount = [NSNumber numberWithInt:value + 1];
//
//        NSLog(@"Sleeping for %@ seconds", iterCount);
//        [NSThread sleepForTimeInterval:[iterCount integerValue]];
//
//        BOOL error = [iterCount integerValue] == 9;
//
//        if(error){
//            NSInteger errorCode = -42;
//            NSString *errorDomain = @"domain";
//            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"No data was received from the server."};
//            NSError *error = [NSError errorWithDomain:errorDomain code:errorCode
//                                             userInfo:userInfo];
//            [subscriber sendError: error];
//        } else {
//            [subscriber sendNext:iterCount];
//        }
//        
//        return [RACDisposable disposableWithBlock:^{
//            NSLog(@"dispose");
//        }];
//    }] deliverOn: [RACScheduler scheduler]];
    
//    RACSignal *fetchFromRepositorySignal = [fetchSignal deliverOn:[RACScheduler mainThreadScheduler]];
//    _runNext = [RACSubject subject];
    
    self.nextButton.rac_command = [[RACCommand alloc] initWithSignalBlock: ^RACSignal *(id input) {
        NSLog(@"Next button Button was pressed");
        @strongify(self);
        
        [self.viewModel fetchValue];

        return [RACSignal empty];
    }];

//    [_runNext subscribeNext:^(id x) {
//        @strongify(self);
//        NSLog(@"_runNext subscribeNext");
//        [fetchFromRepositorySignal subscribeNext:^(id x) {
//            NSLog(@"Fetch done for value: %@", x);
//            self.nextLabelValue = [x stringValue];
//        } error:^(NSError *error) {
//            NSLog(@"Error in fetch");
//        } completed:^{
//            NSLog(@"Fetch completed");
//        }];
//    }];
    
    
    
   
    // end nytt försök
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
