//
//  CRTOSDKInfoTests.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CRTOSDKInfo.h"

@interface CRTOSDKInfoTests : XCTestCase

@end

@implementation CRTOSDKInfoTests
{
    CRTOSDKInfo* sdkInfo;
}

- (void)setUp {
    [super setUp];

    sdkInfo = [[CRTOSDKInfo alloc] init];
}

- (void)tearDown {

    [super tearDown];
}

- (void) testSharedSdkInfo
{
    CRTOSDKInfo* sharedInfo = [CRTOSDKInfo sharedSDKInfo];

    XCTAssertNotNil(sharedInfo, @"Can't get shared sdk info instance");
}

- (void) testSdkVersion
{
    NSString* sdkVersion = sdkInfo.sdkVersion;

    XCTAssertNotNil(sdkVersion, @"sdkVersion was nil");
    XCTAssertGreaterThan(sdkVersion.length, 0, @"sdkVersion should have length > 0");
}

@end
