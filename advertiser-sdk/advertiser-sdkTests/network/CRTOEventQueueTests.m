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
    NSString* eventBody;
}

- (void) setUp
{
    [super setUp];

    queue = [CRTOEventQueue sharedEventQueue];
    queue.maxQueueItemAge = (60.0 * 60.0);

    eventBody = @"{ 'some' : 'sample', 'JSON' : 2 }";

    [[LSNocilla sharedInstance] start];
}

- (void) tearDown
{
    [queue onItemError:NULL];
    [queue onItemSent:NULL];

    [queue removeAllItems];

    // There is a race condition between when we cancel requests and when they stop
    // hitting the network mocking library. Adding a little bit of breathing room
    // here fixes the problem nicely.
    [NSThread sleepForTimeInterval:0.1];

    [[LSNocilla sharedInstance] stop];

    [super tearDown];
}

- (void) testAddQueueItemCallsNetwork
{
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

- (void) testRedirectFollowing
{
    stubRequest(@"POST", @"http://widget.criteo.com/m/event/").
    withBody(eventBody).
    andReturn(307).
    withHeader(@"Location", @"http://someOtherWidget.criteo.com/m/event/");

    stubRequest(@"POST", @"http://someOtherWidget.criteo.com/m/event/").
    withBody(eventBody).
    andReturn(200);

    XCTestExpectation* eventTransmitted = [self expectationWithDescription:@"Redirected Home View Event SENT"];

    CRTOHomeViewEvent* homeEvent = [[CRTOHomeViewEvent alloc] init];
    homeEvent.timestamp = [NSDate date];

    CRTOEventQueueItem* local_item = [[CRTOEventQueueItem alloc] initWithEvent:homeEvent requestBody:eventBody];

    [queue onItemSent:^(CRTOEventQueueItem* sent_item) {
        if ( local_item == sent_item ) {
            [eventTransmitted fulfill];
        }
    }];

    [queue addQueueItem:local_item];

    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

- (void) testRedirectFollowingStops
{
    stubRequest(@"POST", @"http://widget.criteo.com/m/event/").
    withBody(eventBody).
    andReturn(307).
    withHeader(@"Location", @"http://someOtherWidget.criteo.com/m/event/");

    stubRequest(@"POST", @"http://someOtherWidget.criteo.com/m/event/").
    withBody(eventBody).
    andReturn(307).
    withHeader(@"Location", @"http://widget.criteo.com/m/event/");

    XCTestExpectation* eventFails = [self expectationWithDescription:@"Redirect Loop Fails Item"];

    CRTOHomeViewEvent* homeEvent = [[CRTOHomeViewEvent alloc] init];
    homeEvent.timestamp = [NSDate date];

    CRTOEventQueueItem* local_item = [[CRTOEventQueueItem alloc] initWithEvent:homeEvent requestBody:eventBody];

    [queue onItemError:^(CRTOEventQueueItem* failed_item) {
        if ( local_item == failed_item ) {
            [eventFails fulfill];
        }
    }];

    [queue addQueueItem:local_item];

    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

- (void) testQueueMaxDepthIsSetTo15
{
    XCTAssertEqual(queue.maxQueueDepth, 15);
}

- (void) testQueueMaxDepthIs15
{
    NSUInteger expectedMaxQueueDepth = 15;
    NSUInteger numberOfEventsToTest = 32;

    XCTAssert(numberOfEventsToTest >= expectedMaxQueueDepth, @"You can't test max queue depth if you don't fill the queue");

    // In order to build up a queue for testing, put requests into an infinite redirect loop.
    // Requests fail after 4 redirects, but they remain enqueued.
    stubRequest(@"POST", @"http://widget.criteo.com/m/event/").
    withBody(eventBody).
    andReturn(307).
    withHeader(@"Location", @"http://someOtherWidget.criteo.com/m/event/");

    stubRequest(@"POST", @"http://someOtherWidget.criteo.com/m/event/").
    withBody(eventBody).
    andReturn(307).
    withHeader(@"Location", @"http://widget.criteo.com/m/event/");

    NSMutableArray* events = [NSMutableArray new];

    for (int ii = 0; ii < numberOfEventsToTest; ii++) {
        CRTOHomeViewEvent* event = [[CRTOHomeViewEvent alloc] init];
        event.timestamp = [NSDate date];

        CRTOEventQueueItem* item = [[CRTOEventQueueItem alloc] initWithEvent:event requestBody:eventBody];
        [queue addQueueItem:item];

        [events addObject:item];
    }

    NSUInteger numberOfEventsDropped = events.count - expectedMaxQueueDepth;
    NSUInteger numberOfEventsRemaining = events.count - numberOfEventsDropped;

    NSArray* expectDropped  = [events subarrayWithRange:NSMakeRange(0, numberOfEventsDropped)];
    NSArray* expectEnqueued = [events subarrayWithRange:NSMakeRange(numberOfEventsDropped, numberOfEventsRemaining)];

    // The real tests
    XCTAssertEqual(queue.currentQueueDepth, 15);

    for ( CRTOEventQueueItem* item in expectDropped ) {
        XCTAssertFalse([queue containsItem:item]);
    }

    for ( CRTOEventQueueItem* item in expectEnqueued ) {
        XCTAssertTrue([queue containsItem:item]);
    }
}

- (void) testQueueExpiresItems
{
    NSTimeInterval maxItemAge = 5.0;

    queue.maxQueueItemAge = maxItemAge;

    // In order to build up a queue for testing, put requests into an infinite redirect loop.
    // Requests fail after 4 redirects, but they remain enqueued.
    stubRequest(@"POST", @"http://widget.criteo.com/m/event/").
    withBody(eventBody).
    andReturn(307).
    withHeader(@"Location", @"http://someOtherWidget.criteo.com/m/event/");

    stubRequest(@"POST", @"http://someOtherWidget.criteo.com/m/event/").
    withBody(eventBody).
    andReturn(307).
    withHeader(@"Location", @"http://widget.criteo.com/m/event/");

    NSMutableArray* expiredEvents = [NSMutableArray new];

    for (int ii = 0; ii < 15; ii++) {
        CRTOHomeViewEvent* event = [[CRTOHomeViewEvent alloc] init];
        event.timestamp = [NSDate date];

        CRTOEventQueueItem* item = [[CRTOEventQueueItem alloc] initWithEvent:event requestBody:eventBody];
        [queue addQueueItem:item];

        [expiredEvents addObject:item];
    }

    [NSThread sleepForTimeInterval:maxItemAge];

    CRTOHomeViewEvent* event = [[CRTOHomeViewEvent alloc] init];
    event.timestamp = [NSDate date];

    CRTOEventQueueItem* item = [[CRTOEventQueueItem alloc] initWithEvent:event requestBody:eventBody];
    [queue addQueueItem:item];

    XCTAssertEqual(queue.currentQueueDepth, 1);

    XCTAssertTrue([queue containsItem:item]);

    for ( CRTOEventQueueItem* item in expiredEvents ) {
        XCTAssertFalse([queue containsItem:item]);
    }
}

@end
