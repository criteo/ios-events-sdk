//
//  CRTODeviceInfoTests.m
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
#import "CRTODeviceInfo.h"

@interface CRTODeviceInfoTests : XCTestCase

@end

@implementation CRTODeviceInfoTests
{
    CRTODeviceInfo* deviceInfo;
}

- (void)setUp {
    [super setUp];

    deviceInfo = [[CRTODeviceInfo alloc] init];
}

- (void)tearDown {

    [super tearDown];
}

- (void) testSharedDeviceInfo
{
    CRTODeviceInfo* sharedInfo = [CRTODeviceInfo sharedDeviceInfo];

    XCTAssertNotNil(sharedInfo, @"Can't get shared device info instance");
}

/* This test breaks because in logic tests we just can't retrieve the idfa.
   It should be enabled again once we have a test app so that we can relate thos test to the app
   and launch them as application tests. */
- (void) DISABLEDtestDeviceIdentifier
{
    NSString* deviceIdentifier = deviceInfo.deviceIdentifier;

    XCTAssertNotNil(deviceIdentifier, @"deviceIdentifier was nil");
    XCTAssertGreaterThan(deviceIdentifier.length, 0, @"deviceIdentifier should have length > 0");
}

- (void) testDeviceManufacturer
{
    NSString* deviceManufacturer = deviceInfo.deviceManufacturer;

    XCTAssertNotNil(deviceManufacturer, @"deviceManufacturer was nil");
    XCTAssertGreaterThan(deviceManufacturer.length, 0, @"deviceManufacturer should have length > 0");
}

- (void) testDeviceModel
{
    NSString* deviceModel = deviceInfo.deviceModel;

    XCTAssertNotNil(deviceModel, @"deviceModel was nil");
    XCTAssertGreaterThan(deviceModel.length, 0, @"deviceModel should have length > 0");
}

- (void) testOsName
{
    NSString* osName = deviceInfo.osName;

    XCTAssertNotNil(osName, @"osName was nil");
    XCTAssertGreaterThan(osName.length, 0, @"osName should have length > 0");
}

- (void) testOsVersion
{
    NSString* osVersion = deviceInfo.osVersion;

    XCTAssertNotNil(osVersion, @"osVersion was nil");
    XCTAssertGreaterThan(osVersion.length, 0, @"osVersion should have length > 0");
}

- (void) testPlatform
{
    NSString* platform = deviceInfo.platform;

    XCTAssertNotNil(platform, @"platform was nil");
    XCTAssertGreaterThan(platform.length, 0, @"platform should have length > 0");
}

@end
