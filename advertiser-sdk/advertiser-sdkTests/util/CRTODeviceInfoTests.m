//
//  CRTODeviceInfoTests.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

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

- (void) testDeviceIdentifier
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
