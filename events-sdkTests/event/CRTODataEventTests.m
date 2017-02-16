//
//  CRTODataEventTests.m
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

#import "CRTODataEvent.h"

@interface CRTODataEventTests : XCTestCase

@end

@implementation CRTODataEventTests
{
    CRTODataEvent* dataEvent;

    NSMutableString* dateKey;
    NSMutableString* integerKey;
    NSMutableString* floatKey;
    NSMutableString* stringKey;
}

- (void)setUp
{
    [super setUp];

    dataEvent = [[CRTODataEvent alloc] init];

    dateKey    = [NSMutableString stringWithString:@"A_Date_Key"];
    integerKey = [NSMutableString stringWithString:@"An_Integer_Key"];
    floatKey   = [NSMutableString stringWithString:@"A_Float_Key"];
    stringKey  = [NSMutableString stringWithString:@"A_String_Key"];
}

- (void)tearDown
{

    [super tearDown];
}

- (void) testInit
{
    XCTAssertNotNil(dataEvent);
}

- (void) testDateExtraData
{
    NSDateComponents* someComponents = [NSDateComponents new];

    someComponents.year   = 2001;
    someComponents.month  = 9;
    someComponents.day    = 9;
    someComponents.hour   = 1;
    someComponents.minute = 46;
    someComponents.second = 40;

    [dataEvent setDateExtraData:someComponents ForKey:dateKey];

    NSDateComponents* resultComponents = [dataEvent dateExtraDataForKey:@"A_Date_Key"];

    XCTAssertEqualObjects(someComponents, resultComponents);
}

- (void) testDateExtraDataNoValue
{
    NSDateComponents* resultDate = [dataEvent dateExtraDataForKey:@"BadKey"];

    XCTAssertNil(resultDate);
}

- (void) testIntegerExtraData
{
    NSInteger someInteger = 0xdeadbeef;

    [dataEvent setIntegerExtraData:someInteger ForKey:integerKey];

    NSInteger resultInteger = [dataEvent integerExtraDataForKey:@"An_Integer_Key"];

    XCTAssertEqual(someInteger, resultInteger);
}

- (void) testIntegerExtraDataNoValue
{
    NSInteger resultInteger = [dataEvent integerExtraDataForKey:@"BadKey"];

    XCTAssertEqual(resultInteger, 0);
}

- (void) testFloatExtraData
{
    float someFloat = 999.85;

    [dataEvent setFloatExtraData:someFloat ForKey:floatKey];

    float resultFloat = [dataEvent floatExtraDataForKey:@"A_Float_Key"];

    XCTAssertEqual(someFloat, resultFloat);
}

- (void) testFloatExtraDataNoValue
{
    float resultFloat = [dataEvent floatExtraDataForKey:@"BadKey"];

    XCTAssertEqual(resultFloat, 0.0f);
}

- (void) testStringExtraData
{
    NSString* someString = @"Four score and seven years ago...";

    [dataEvent setStringExtraData:someString ForKey:stringKey];

    NSString* resultString = [dataEvent stringExtraDataForKey:@"A_String_Key"];

    XCTAssertEqualObjects(someString, resultString);
}

- (void) testStringExtraDataNoValue
{
    NSString* resultString = [dataEvent stringExtraDataForKey:@"BadKey"];

    XCTAssertNil(resultString);
}


@end
