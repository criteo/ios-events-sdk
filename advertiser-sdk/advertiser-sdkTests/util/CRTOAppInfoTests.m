//
//  CRTOAppInfoTests.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CRTOAppInfo.h"

@interface CRTOAppInfoTests : XCTestCase

@end

@implementation CRTOAppInfoTests
{
    CRTOAppInfo* appInfo;
}

- (void)setUp {
    [super setUp];

    appInfo = [[CRTOAppInfo alloc] init];
}

- (void)tearDown {

    [super tearDown];
}

- (void) testSharedAppInfo
{
    CRTOAppInfo* sharedInfo = [CRTOAppInfo sharedAppInfo];

    XCTAssertNotNil(sharedInfo, @"Can't get shared app info instance");
}

- (void) testAppCountry
{
    NSUInteger expectedCountryLen = 2;

    NSString* appCountry = appInfo.appCountry;

    XCTAssertNotNil(appInfo.appCountry, @"App country was nil");

    XCTAssertEqual(appCountry.length, expectedCountryLen,
                   @"App country has invalid length %llu (Expected %llu)",
                   (uint64_t)appCountry.length, (uint64_t)expectedCountryLen);

    XCTAssert([appCountry isEqualToString:appCountry.uppercaseString],
              @"App country must not contain lowercase letters");
}

- (void) testAppId
{
    NSString* appId = appInfo.appId;

    XCTAssertNotNil(appId, @"App Id was nil");

    // App id doesn't exist at test time
    // This has to be unit tested in a test app that integrates this library
    //XCTAssertGreaterThan(appId.length, 0, @"App Id has length 0");
}

- (void) testAppLanguage
{
    NSUInteger expectedLangLen = 2;

    NSString* appLanguage = appInfo.appLanguage;

    XCTAssertNotNil(appLanguage, @"App language was nil.");

    XCTAssertEqual(appLanguage.length, expectedLangLen,
                   @"App language has invalid length %llu (Expected %llu)",
                   (uint64_t)appLanguage.length, (uint64_t)expectedLangLen);
}

- (void) testAppName
{
    NSString* appName = appInfo.appName;

    XCTAssertNotNil(appName, @"App name was nil");

    // App name doesn't exist at test time
    // This has to be unit tested in a test app that integrates this library
    //XCTAssertGreaterThan(appName.length, 0, @"App name has length 0");
}

- (void) testAppVersion
{
    NSString* appVersion = appInfo.appVersion;

    XCTAssertNotNil(appVersion, @"App version was nil");

    // App version doesn't exist at test time
    // This has to be unit tested in a test app that integrates this library
    //XCTAssertGreaterThan(appVersion.length, 0, @"App version has length 0");
}

@end
