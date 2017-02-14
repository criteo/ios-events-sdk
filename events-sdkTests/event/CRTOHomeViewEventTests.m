//
//  CRTOHomeViewEventTests.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

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
