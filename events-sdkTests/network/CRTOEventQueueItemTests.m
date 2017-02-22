//
//  CRTOEventQueueItemTests.m
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

#import "CRTOEventQueueItem.h"
#import "CRTOEvent.h"
#import "CRTOEvent+Internal.h"
#import "CRTOHomeViewEvent.h"

@interface CRTOEventQueueItemTests : XCTestCase

@end

@implementation CRTOEventQueueItemTests
{
    NSString* requestBodyString;
    NSData* requestBodyData;
}

- (void)setUp
{
    [super setUp];

    requestBodyString = @"some string";

    requestBodyData = [NSData dataWithBytes:requestBodyString.UTF8String
                                     length:[requestBodyString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
}

- (void)tearDown
{

    [super tearDown];
}

- (void) testInit
{
    CRTOEventQueueItem* item = [[CRTOEventQueueItem alloc] init];

    XCTAssertNotNil(item);

    XCTAssertGreaterThan(item.age, 86400 * 365 * 10);

    XCTAssertNil(item.event);
    XCTAssertNil(item.requestBody);

    XCTAssertNotNil(item.responseData);
    XCTAssertEqual(item.responseData.length, 0);
}

- (void) testInitEventRequestBody
{
    CRTOHomeViewEvent* homeEvent = [[CRTOHomeViewEvent alloc] init];
    homeEvent.timestamp = [NSDate date];

    CRTOEventQueueItem* item = [[CRTOEventQueueItem alloc] initWithEvent:homeEvent
                                                             requestBody:requestBodyString];

    XCTAssertLessThan(item.age, 10);
    XCTAssertEqual(item.event, homeEvent);
    XCTAssertEqualObjects(item.requestBody, requestBodyData);

    XCTAssertNotNil(item.responseData);
    XCTAssertEqual(item.responseData.length, 0);
}

@end
