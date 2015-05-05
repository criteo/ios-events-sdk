//
//  advertiser_sdkTests.m
//  advertiser-sdkTests
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CRTODataEvent.h"
#import "CRTOBasketViewEvent.h"

@interface advertiser_sdkTests : XCTestCase

@end

@implementation advertiser_sdkTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}



- (void)testExample {
    // This is an example of a functional test case.
    //CTAppLaunchEvent* ev1 = [[CTAppLaunchEvent alloc] init];
    //CTAppLaunchEvent* ev2 = [[CTAppLaunchEvent alloc] initWithEvent:ev1];

    CRTODataEvent* ev1 = [[CRTODataEvent alloc] init];
    //CRTOEvent* e2 = [[CRTOEvent alloc] initWithStartDate:[NSDate new] endDate:[NSDate new]];

    CRTOBasketViewEvent* event = [[CRTOBasketViewEvent alloc] initWithBasketProducts:@[ @"" ] currency:nil];
    //BOOL b = [event validate];


    //NSLog(@"%@",ev1);
    //NSLog(@"%@",ev2);

    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
