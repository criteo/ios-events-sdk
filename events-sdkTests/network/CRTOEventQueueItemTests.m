//
//  CRTOEventQueueItemTests.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "CRTOEventQueueItem.h"
#import "CRTOEvent.h"
#import "CRTOEvent+Internal.h"
#import "CRTOHomeViewEvent.h"

@interface CRTOEventQueueItemTests : XCTestCase

@end

@implementation CRTOEventQueueItemTests
{
    NSString* requestBodyString;
    NSData* requestBodyData;
}

- (void)setUp
{
    [super setUp];

    requestBodyString = @"some string";

    requestBodyData = [NSData dataWithBytes:requestBodyString.UTF8String
                                     length:[requestBodyString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
}

- (void)tearDown
{

    [super tearDown];
}

- (void) testInit
{
    CRTOEventQueueItem* item = [[CRTOEventQueueItem alloc] init];

    XCTAssertNotNil(item);

    XCTAssertGreaterThan(item.age, 86400 * 365 * 10);

    XCTAssertNil(item.event);
    XCTAssertNil(item.requestBody);

    XCTAssertNotNil(item.responseData);
    XCTAssertEqual(item.responseData.length, 0);
}

- (void) testInitEventRequestBody
{
    CRTOHomeViewEvent* homeEvent = [[CRTOHomeViewEvent alloc] init];
    homeEvent.timestamp = [NSDate date];

    CRTOEventQueueItem* item = [[CRTOEventQueueItem alloc] initWithEvent:homeEvent
                                                             requestBody:requestBodyString];

    XCTAssertLessThan(item.age, 10);
    XCTAssertEqual(item.event, homeEvent);
    XCTAssertEqualObjects(item.requestBody, requestBodyData);

    XCTAssertNotNil(item.responseData);
    XCTAssertEqual(item.responseData.length, 0);
}

@end
