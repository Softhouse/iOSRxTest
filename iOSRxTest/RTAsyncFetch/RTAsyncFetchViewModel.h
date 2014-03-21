//
//  RTFetchViewModel.h
//  iOSRxTest
//
//  Created by Thomas Lundström on 2014-03-21.
//  Copyright (c) 2014 Thomas Lundström. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTAsyncFetchViewModel : NSObject

@property (nonatomic, strong, readonly) NSString *nextLabelValue;

- (void)fetchValue;
@end
