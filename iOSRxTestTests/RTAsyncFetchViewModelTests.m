//
//  RTAsyncFetchViewModelTests.m
//  iOSRxTest
//
//  Created by Thomas Lundström on 2014-03-31.
//  Copyright (c) 2014 Softhouse. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <OCMock/OCMock.h>

#import "RTAsyncFetchRepository.h"
#import "RTAsyncFetchViewModel.h"

@interface RTAsyncFetchViewModelTests : XCTestCase

@end

@implementation RTAsyncFetchViewModelTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFetchWithValidValue
{
    RACSubject *fakeSignal = [RACSubject subject];
    
    id repository = [OCMockObject mockForClass:[RTAsyncFetchRepository class]];
    [[[repository stub] andReturn: fakeSignal] fetchSignal];
    
    RTAsyncFetchViewModel *viewModel = [[RTAsyncFetchViewModel alloc] initWithRepository: repository
                                                                               scheduler:[RACScheduler immediateScheduler]];

    [viewModel fetchValue];
    
    [fakeSignal sendNext:@(159)];
    
    XCTAssertEqualObjects(viewModel.nextLabelValue, @"159");
}

@end
