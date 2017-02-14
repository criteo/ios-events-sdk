//
//  CRTODeeplinkEventTests.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "CRTOEvent.h"
#import "CRTOEvent+Internal.h"
#import "CRTODeeplinkEvent.h"

@interface CRTODeeplinkEventTests : XCTestCase

@end

@implementation CRTODeeplinkEventTests

- (void) setUp
{
    [super setUp];

}

- (void) tearDown
{

    [super tearDown];
}

- (void) testDeeplinkInit
{
    CRTODeeplinkEvent* event = [[CRTODeeplinkEvent alloc] init];

    XCTAssertNil(event.deeplinkLaunchUrl);
}

- (void) testDeeplinkInitWithNilURL
{
    CRTODeeplinkEvent* event = [[CRTODeeplinkEvent alloc] initWithDeeplinkLaunchUrl:nil];

    XCTAssertNotNil(event);
    XCTAssertNil(event.deeplinkLaunchUrl);
}

- (void) testDeeplinkInitWithNonNilURL
{
    NSMutableString* exampleUrl = [NSMutableString stringWithString:@"some string"];

    CRTODeeplinkEvent* event = [[CRTODeeplinkEvent alloc] initWithDeeplinkLaunchUrl:exampleUrl];

    XCTAssertNotNil(event);
    XCTAssertEqualObjects(exampleUrl, event.deeplinkLaunchUrl);
    XCTAssertNotEqual(exampleUrl, event.deeplinkLaunchUrl, @"Mutable string argument wasn't copied");
}

- (void) testDeeplinkEventCopy
{
    NSMutableString* exampleUrl = [NSMutableString stringWithString:@"some string"];

    CRTODeeplinkEvent* event = [[CRTODeeplinkEvent alloc] initWithDeeplinkLaunchUrl:exampleUrl];
    CRTODeeplinkEvent* eventCopy = [event copy];

    XCTAssertEqualObjects(event.deeplinkLaunchUrl, eventCopy.deeplinkLaunchUrl);
    XCTAssertNotEqual(event, eventCopy);
}

@end
