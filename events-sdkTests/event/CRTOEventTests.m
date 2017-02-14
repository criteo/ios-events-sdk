//
//  CRTOEventTests.m
//  advertiser-sdk
//
//  Created by Paul Davis on 5/24/16.
//  Copyright © 2016 Criteo. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "CRTOEvent.h"
#import "CRTODataEvent.h"

@interface CRTOEventTests : XCTestCase

@end

@implementation CRTOEventTests

- (void) setUp
{
    [super setUp];

}

- (void) tearDown
{

    [super tearDown];
}

- (void) testUnassignedUserSegmentIsZero
{
    CRTODataEvent* event = [CRTODataEvent new];

    XCTAssertEqual(event.userSegment, 0);
}

- (void) testUserSegmentAssignment
{
    CRTODataEvent* event = [CRTODataEvent new];

    event.userSegment = 0xdeadbeef;

    XCTAssertEqual(event.userSegment, 0xdeadbeef);
}

@end
