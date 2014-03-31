//
//  RTFetchViewModel.m
//  iOSRxTest
//
//  Created by Thomas Lundström on 2014-03-21.
//  Copyright (c) 2014 Softhouse. All rights reserved.
//

#import "RTAsyncFetchViewModel.h"
#import<ReactiveCocoa/ReactiveCocoa.h>
#import "RACEXTScope.h"

@interface RTAsyncFetchViewModel(){
    RACSubject *_runNext;
}

// re-declared as readwrite
@property (nonatomic, strong, readwrite) NSString *nextLabelValue;

@property (nonatomic, readonly) RTAsyncFetchRepository *repository;

@end

@implementation RTAsyncFetchViewModel

- (instancetype) initWithRepository:(RTAsyncFetchRepository *)repository
                          scheduler:(RACScheduler *) scheduler
{
    self = [super init];
    
    if (!self){ return nil; }
    
    _runNext = [RACSubject subject];
    
    RACSignal *fetchFromRepositorySignal = [repository.fetchSignal deliverOn: scheduler];

    // we need to make a weak ref out of self, otherwise we'd get
    // a retain cycle in the blocks below
    @weakify(self);

    [_runNext subscribeNext:^(id _) {
        @strongify(self);
        [fetchFromRepositorySignal subscribeNext:^(id x) {
            self.nextLabelValue = [x stringValue];
        } error:^(NSError *error) {
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
