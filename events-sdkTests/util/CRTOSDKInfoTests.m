//
//  CRTOSDKInfoTests.m
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
