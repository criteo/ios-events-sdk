//
//  CRTODateConverterTests.m
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

#import "CRTODateConverter.h"

@interface CRTODateConverterTests : XCTestCase

@end

@implementation CRTODateConverterTests
{
    NSDate* date;
}

- (void)setUp
{
    [super setUp];

    date = [NSDate dateWithTimeIntervalSince1970:1000000000];
}

- (void)tearDown
{

    [super tearDown];
}

- (void) testDateConvertsToYMDComponents
{
    NSDateComponents* components = [CRTODateConverter convertUTCDateToYMDComponents:date];

    XCTAssertEqual(components.year,  2001);
    XCTAssertEqual(components.month, 9);
    XCTAssertEqual(components.day,   9);

    XCTAssertEqual(components.era,               NSDateComponentUndefined);
    XCTAssertEqual(components.hour,              NSDateComponentUndefined);
    XCTAssertEqual(components.minute,            NSDateComponentUndefined);
    XCTAssertEqual(components.second,            NSDateComponentUndefined);
    XCTAssertEqual(components.nanosecond,        NSDateComponentUndefined);
    XCTAssertEqual(components.weekday,           NSDateComponentUndefined);
    XCTAssertEqual(components.weekdayOrdinal,    NSDateComponentUndefined);
    XCTAssertEqual(components.quarter,           NSDateComponentUndefined);
    XCTAssertEqual(components.weekOfMonth,       NSDateComponentUndefined);
    XCTAssertEqual(components.weekOfYear,        NSDateComponentUndefined);
    XCTAssertEqual(components.yearForWeekOfYear, NSDateComponentUndefined);
}

- (void) testDateConvertsToYMDHMSComponents
{
    NSDateComponents* components = [CRTODateConverter convertUTCDateToYMDHMSComponents:date];

    XCTAssertEqual(components.year,   2001);
    XCTAssertEqual(components.month,  9);
    XCTAssertEqual(components.day,    9);
    XCTAssertEqual(components.hour,   1);
    XCTAssertEqual(components.minute, 46);
    XCTAssertEqual(components.second, 40);

    XCTAssertEqual(components.era,               NSDateComponentUndefined);
    XCTAssertEqual(components.nanosecond,        NSDateComponentUndefined);
    XCTAssertEqual(components.weekday,           NSDateComponentUndefined);
    XCTAssertEqual(components.weekdayOrdinal,    NSDateComponentUndefined);
    XCTAssertEqual(components.quarter,           NSDateComponentUndefined);
    XCTAssertEqual(components.weekOfMonth,       NSDateComponentUndefined);
    XCTAssertEqual(components.weekOfYear,        NSDateComponentUndefined);
    XCTAssertEqual(components.yearForWeekOfYear, NSDateComponentUndefined);
}

- (void) testNilDateReturnsNil
{
    XCTAssertNil([CRTODateConverter convertUTCDateToYMDComponents:nil]);
    XCTAssertNil([CRTODateConverter convertUTCDateToYMDHMSComponents:nil]);
}

- (void) testYMDComponentsConvertsToDate
{
    NSDateComponents* components = [NSDateComponents new];

    components.year       = 2015;
    components.month      = 1;
    components.day        = 1;
    components.hour       = 23;
    components.minute     = 42;
    components.second     = 10;
    components.nanosecond = 100000;
    components.timeZone   = [NSTimeZone timeZoneForSecondsFromGMT:19800];

    NSDate* resultDate = [CRTODateConverter convertYMDComponentsToUTCDate:components];

    // (2015-01-01 00:00:00.000 UTC)
    NSDate* expectedDate = [NSDate dateWithTimeIntervalSince1970:1420070400];

    XCTAssertEqualObjects(resultDate, expectedDate);
}

- (void) testYMDHMSComponentsConvertsToDate
{
    NSDateComponents* components = [NSDateComponents new];

    components.year       = 2015;
    components.month      = 1;
    components.day        = 1;
    components.hour       = 23;
    components.minute     = 42;
    components.second     = 10;
    components.nanosecond = 100000;
    components.timeZone   = [NSTimeZone timeZoneForSecondsFromGMT:19800];

    NSDate* resultDate = [CRTODateConverter convertYMDHMSComponentsToUTCDate:components];

    // (2015-01-01 23:42:10.000 UTC)
    NSDate* expectedDate = [NSDate dateWithTimeIntervalSince1970:1420155730];

    XCTAssertEqualObjects(resultDate, expectedDate);
}

- (void) testNilComponentsReturnsNil
{
    XCTAssertNil([CRTODateConverter convertYMDComponentsToUTCDate:nil]);
    XCTAssertNil([CRTODateConverter convertYMDHMSComponentsToUTCDate:nil]);
}

@end
