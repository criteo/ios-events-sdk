//
//  CRTOEventQueueTests.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Nocilla.h"

#import "CRTOEvent.h"
#import "CRTOEvent+Internal.h"
#import "CRTOEventQueue.h"
#import "CRTOHomeViewEvent.h"
#import "CRTOJSONEventSerializer.h"

@interface CRTOEventQueueTests : XCTestCase

@end

@implementation CRTOEventQueueTests
{
    CRTOEventQueue* queue;
    CRTOJSONEventSerializer* serializer;
}

- (void) setUp
{
    [super setUp];

    queue = [CRTOEventQueue sharedEventQueue];
    serializer = [CRTOJSONEventSerializer new];

    [[LSNocilla sharedInstance] start];
}

- (void) tearDown
{
    [queue onItemSent:NULL];

    [[LSNocilla sharedInstance] stop];

    [super tearDown];
}

// This is a basic test; It will be refactored in the (near) future.
// I think there are some larger issues that need to be addressed:
//
// 1) The web address is hardcoded.  This should probably be retrieved from some mock config?
//    Or from some unified config?
//
// 2) The onItemSent callback pattern is a little unusual, both in ObjC and in the SDK.
//    Maybe this can be refactored into a delegate pattern, or an alternate send method
//    that takes a callback block as an arg.
//
// 3) Is CRTOHomeViewEvent supposed to be mocked?
//
// 4) There is a dependency on TIME WRT our use of CRTOHomeViewEvent.  This may need to
//    be addressed, too.
- (void) testAddQueueItemCallsNetwork
{
    NSString* eventBody = @"{ 'some' : 'sample', 'JSON' : 2 }";

    stubRequest(@"POST", @"http://widget.criteo.com/m/event/").
    withBody(eventBody).
    andReturn(200);

    XCTestExpectation* eventTransmitted = [self expectationWithDescription:@"Home View Event SENT"];

    [queue onItemSent:^(CRTOEventQueueItem* item) {
        [eventTransmitted fulfill];
    }];

    CRTOHomeViewEvent* homeEvent = [[CRTOHomeViewEvent alloc] init];
    homeEvent.timestamp = [NSDate date];

    CRTOEventQueueItem* item = [[CRTOEventQueueItem alloc] initWithEvent:homeEvent requestBody:eventBody];

    [queue addQueueItem:item];

    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

@end
