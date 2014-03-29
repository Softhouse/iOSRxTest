//
//  RTAsyncFetchViewController.m
//  iOSRxTest
//
//  Created by Thomas Lundström on 2014-03-29.
//  Copyright (c) 2014 Thomas Lundström. All rights reserved.
//

#import "RTAsyncFetchViewController.h"
#import<ReactiveCocoa/ReactiveCocoa.h>
#import "RACEXTScope.h"
#import "RTAsyncFetchViewModel.h"

@interface RTAsyncFetchViewController (){
    RACSubject *_runNext;
}

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *nextLabel;

@property (nonatomic, strong) RTAsyncFetchViewModel *viewModel;
@end

@implementation RTAsyncFetchViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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

@end
