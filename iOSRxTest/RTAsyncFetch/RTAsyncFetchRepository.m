//
//  RTAsyncFetchRepository.m
//  iOSRxTest
//
//  Created by Thomas Lundström on 2014-03-21.
//  Copyright (c) 2014 Softhouse. All rights reserved.
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
    
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSLog(@"Fetching, thread: %@", [NSThread currentThread]);
        
        int value = [iterCount intValue];
        iterCount = [NSNumber numberWithInt:value + 1];
        
        NSLog(@"Sleeping for 2 seconds - here we'd normally fetch from network or file");
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
    }] subscribeOn:[RACScheduler scheduler]];
    
    self.fetchSignal = signal;
    
    return self;
}

@end
