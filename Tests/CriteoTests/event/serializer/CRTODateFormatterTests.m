//
//  CRTODateFormatterTests.m
//  events-sdk
//
//  Copyright (c) 2017 Criteo
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

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
