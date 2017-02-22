//
//  CRTOHomeViewEventTests.m
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

#import "CRTOHomeViewEvent.h"

@interface CRTOHomeViewEventTests : XCTestCase

@end

@implementation CRTOHomeViewEventTests

- (void)setUp
{
    [super setUp];

}

- (void)tearDown
{

    [super tearDown];
}

- (void) testInit
{
    CRTOHomeViewEvent* event = [[CRTOHomeViewEvent alloc] init];

    XCTAssertNotNil(event);
}

- (void) testHomeViewEventCopy
{
    CRTOHomeViewEvent* event = [[CRTOHomeViewEvent alloc] init];

    CRTOHomeViewEvent* eventCopy = [event copy];

    XCTAssertNotEqual(event, eventCopy);
}

@end
