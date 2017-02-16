//
//  CRTOAppLaunchEventTests.m
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
#import "CRTOAppLaunchEvent.h"
#import "CRTOAppLaunchEvent+Internal.h"

@interface CRTOAppLaunchEventTests : XCTestCase

@end

@implementation CRTOAppLaunchEventTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) removeFirstLaunchSetting
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCRTOInitialLaunchKey];
}

- (void) testFirstLaunchDetectedWithDefaultInit
{
    [self removeFirstLaunchSetting];

    CRTOAppLaunchEvent* appLaunch = [CRTOAppLaunchEvent new];

    XCTAssertTrue(appLaunch.isFirstLaunch, @"Failed to detect first app launch");
}

- (void) testFirstLaunchFlagPreservedOnCopy
{
    [self removeFirstLaunchSetting];

    CRTOAppLaunchEvent* appLaunch = [CRTOAppLaunchEvent new];

    XCTAssertTrue(appLaunch.isFirstLaunch, @"Failed to detect first app launch");

    CRTOAppLaunchEvent* appLaunchCopy = [appLaunch copy];

    XCTAssertTrue(appLaunchCopy.isFirstLaunch, @"First launch flag was not preserved during copy");
}

@end
