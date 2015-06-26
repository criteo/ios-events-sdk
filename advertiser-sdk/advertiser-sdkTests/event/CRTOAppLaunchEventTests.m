//
//  CRTOAppLaunchEventTests.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

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

@end
