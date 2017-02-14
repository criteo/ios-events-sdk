//
//  CRTODateFormatterTests.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CRTODateFormatter.h"

@interface CRTODateFormatterTests : XCTestCase

@end

@implementation CRTODateFormatterTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testDateFormat
{
    NSDate* testDate = [NSDate dateWithTimeIntervalSince1970:1433347064];
    NSString* expectedResult = @"2015-06-03T15:57:44Z";

    NSString* actualResult = [CRTODateFormatter iso8601StringFromDate:testDate];

    XCTAssertEqualObjects(expectedResult, actualResult);
}

- (void) testNilDateReturnsNilOrAsserts
{
#ifdef NS_BLOCK_ASSERTIONS
    NSString* formattedDate = [CRTODateFormatter iso8601StringFromDate:nil];

    XCTAssertNil(formattedDate);
#else
    XCTAssertThrows([CRTODateFormatter iso8601StringFromDate:nil], @"nil parameter should assert in DEBUG mode");
#endif
}

- (void) testSystemDateFormatterReportsThreadSafe
{
    // Tests won't be run on versions of iOS where the date formatter isn't
    // thread safe, so this should always be true.
    XCTAssertTrue([CRTODateFormatter isSystemDateFormatterThreadSafe]);
}

@end
