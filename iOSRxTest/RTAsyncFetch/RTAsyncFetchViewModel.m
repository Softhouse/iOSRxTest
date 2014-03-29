//
//  RTFetchViewModel.m
//  iOSRxTest
//
//  Created by Thomas Lundström on 2014-03-21.
//  Copyright (c) 2014 Thomas Lundström. All rights reserved.
//

#import "RTAsyncFetchViewModel.h"
#import<ReactiveCocoa/ReactiveCocoa.h>
#import "RACEXTScope.h"
#import "RTAsyncFetchRepository.h"


@interface RTAsyncFetchViewModel(){
    RACSubject *_runNext;
}

// re-declared as readwrite
@property (nonatomic, strong, readwrite) NSString *nextLabelValue;
@property (nonatomic, strong, readwrite) RTAsyncFetchRepository *repository;

@end

@implementation RTAsyncFetchViewModel

- (instancetype) init
{
    self = [super init];
    
    if (!self){ return nil; }
    
    _runNext = [RACSubject subject];
    
    self.repository = [[RTAsyncFetchRepository alloc] init];
    
    
    RACSignal *fetchFromRepositorySignal = [self.repository.fetchSignal deliverOn:[RACScheduler mainThreadScheduler]];

    // we need to make a weak ref out of self, otherwise we'd get
    // a retain cycle in the blocks below
    @weakify(self);

    [_runNext subscribeNext:^(id x) {
        @strongify(self);
        NSLog(@"_runNext subscribeNext, thread: %@", [NSThread currentThread]);
        [fetchFromRepositorySignal subscribeNext:^(id x) {
            NSLog(@"Fetch done, thread: %@", [NSThread currentThread]);
            self.nextLabelValue = [x stringValue];
        } error:^(NSError *error) {
            NSLog(@"Error in fetch");
            self.nextLabelValue = @"Error";
        } completed:^{
            NSLog(@"Fetch completed");
        }];
    }];

    
    return self;
}

- (void)fetchValue
{
    [_runNext sendNext: @""];
}

@end
