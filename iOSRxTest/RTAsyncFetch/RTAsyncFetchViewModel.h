//
//  RTFetchViewModel.h
//  iOSRxTest
//
//  Created by Thomas Lundström on 2014-03-21.
//  Copyright (c) 2014 Softhouse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTAsyncFetchRepository.h"


@interface RTAsyncFetchViewModel : NSObject

@property (nonatomic, strong, readonly) NSString *nextLabelValue;

- (instancetype) initWithRepository:(RTAsyncFetchRepository *)repository
                          scheduler:(RACScheduler *) scheduler;

- (void)fetchValue;
@end
