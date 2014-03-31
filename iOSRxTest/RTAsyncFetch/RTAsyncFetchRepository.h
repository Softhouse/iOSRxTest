//
//  RTAsyncFetchRepository.h
//  iOSRxTest
//
//  Created by Thomas Lundström on 2014-03-21.
//  Copyright (c) 2014 Softhouse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RTAsyncFetchRepository : NSObject

@property (nonatomic, strong, readonly) RACSignal *fetchSignal;

@end
