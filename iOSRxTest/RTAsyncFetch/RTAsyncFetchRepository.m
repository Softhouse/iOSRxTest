//
//  RTAsyncFetchRepository.m
//  iOSRxTest
//
//  Created by Thomas Lundström on 2014-03-21.
//  Copyright (c) 2014 Thomas Lundström. All rights reserved.
//

#import "RTAsyncFetchRepository.h"
#import "RACEXTScope.h"

@interface RTAsyncFetchRepository()

//redeclared readwrite
@property (nonatomic, strong, readwrite) RACSignal *fetchSignal;

@end

@implementation RTAsyncFetchRepository

- (instancetype)init
{
    self = [super init];
    
    if (!self) { return nil; }
    
    __block NSNumber *iterCount = [NSNumber numberWithInt:0];
    
//    @weakify(self);

    self.fetchSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //        @strongify(self);
        
        NSLog(@"Fetching, thread: %@", [NSThread currentThread]);
        
        int value = [iterCount intValue];
        iterCount = [NSNumber numberWithInt:value + 1];
        
        NSLog(@"Sleeping for 2 seconds");
        [NSThread sleepForTimeInterval:2];
        
        BOOL error = [iterCount integerValue] == 3;
        
        if(error){
            NSInteger errorCode = -42;
            NSString *errorDomain = @"domain";
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"No data was received from the server."};
            NSError *error = [NSError errorWithDomain:errorDomain code:errorCode
                                             userInfo:userInfo];
            [subscriber sendError: error];
        } else {
            [subscriber sendNext:iterCount];
        }
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"dispose");
        }];
    }] deliverOn: [RACScheduler scheduler]];
    
    return self;
}

@end
