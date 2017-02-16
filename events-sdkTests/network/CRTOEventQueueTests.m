//
//  CRTOEventQueueTests.m
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
#import <Nocilla.h>

#import "CRTOEvent.h"
#import "CRTOEvent+Internal.h"
#import "CRTOEventQueue.h"
#import "CRTOAppLaunchEvent.h"
#import "CRTOHomeViewEvent.h"
#import "CRTOJSONEventSerializer.h"
#import "CRTONetworkDefines.h"

#define EXPECTED_SEND_URL (@"https://widget.criteo.com/m/event/")
#define FAKE_REDIRECT_LOCATION (@"https://someOtherWidget.criteo.com/m/event/")

@interface CRTOEventQueueTests : XCTestCase

@end

@implementation CRTOEventQueueTests
{
    CRTOEventQueue* queue;
    NSString* eventBody;
    NSString* eventBody2;
}

- (void) setUp
{
    [super setUp];

    queue = [CRTOEventQueue sharedEventQueue];
    queue.maxQueueItemAge = (60.0 * 60.0);

    eventBody = @"{ 'some' : 'sample', 'JSON' : 2 }";
    eventBody2 = @"{ 'some' : 'sample', 'JSON' : 'That is totally different' }";

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

    // Reset the widget environment variable override
    putenv("WIDGET_BASEURL=");

    [super tearDown];
}

- (void) testAddQueueItemCallsNetwork
{
    stubRequest(@"POST", EXPECTED_SEND_URL).
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

- (void) testEventQueueSendURLIsSecure
{
    XCTAssertTrue([CRTO_EVENTQUEUE_SEND_BASEURL.lowercaseString hasPrefix:@"https"]);
}

- (void) testRedirectFollowing
{
    stubRequest(@"POST", EXPECTED_SEND_URL).
    withBody(eventBody).
    andReturn(307).
    withHeader(@"Location", FAKE_REDIRECT_LOCATION);

    stubRequest(@"POST", FAKE_REDIRECT_LOCATION).
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
    stubRequest(@"POST", EXPECTED_SEND_URL).
    withBody(eventBody).
    andReturn(307).
    withHeader(@"Location", FAKE_REDIRECT_LOCATION);

    stubRequest(@"POST", FAKE_REDIRECT_LOCATION).
    withBody(eventBody).
    andReturn(307).
    withHeader(@"Location", EXPECTED_SEND_URL);

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

// This test adds two items to the queue. The first item will fall into an
// infinite redirect loop, which will be interrupted after 4 redirects,
// effectively stalling the item in queue.
//
// The second item contains a stubbed body, which the network testing framework
// *would* answer, if the queue attempts to deliver it.
//
// To test serial delivery, we stall out the queue with item1 and then see what
// happens when we enqueue item2. If item2 is delivered when item1 could not have
// been, then the queue would be violating the serial delivery constraint.
- (void) testQueueDeliversEventsSerially
{
    // These are item1's network stubs.  The form an infinite redirect loop,
    // which will be detected and interrupted after 4 redirects, effectively
    // stalling item1 in the queue.
    stubRequest(@"POST", EXPECTED_SEND_URL).
    withBody(eventBody).
    andReturn(307).
    withHeader(@"Location", FAKE_REDIRECT_LOCATION);

    stubRequest(@"POST", FAKE_REDIRECT_LOCATION).
    withBody(eventBody).
    andReturn(307).
    withHeader(@"Location", EXPECTED_SEND_URL);

    // This is item2's network stub; note that it has a different body, so it
    // will only match the second request.
    stubRequest(@"POST", EXPECTED_SEND_URL).
    withBody(eventBody2).
    andReturn(200);

    // Build item1
    CRTOAppLaunchEvent* appLaunch = [[CRTOAppLaunchEvent alloc] init];
    appLaunch.timestamp = [NSDate date];

    CRTOEventQueueItem* item1 = [[CRTOEventQueueItem alloc] initWithEvent:appLaunch requestBody:eventBody];

    // Build item2
    CRTOHomeViewEvent* homeEvent = [[CRTOHomeViewEvent alloc] init];
    homeEvent.timestamp = [NSDate date];

    CRTOEventQueueItem* item2 = [[CRTOEventQueueItem alloc] initWithEvent:homeEvent requestBody:eventBody2];

    // Setup the item delivery callback
    [queue onItemSent:^(CRTOEventQueueItem* item) {
        if ( item == item1 ) {
            XCTFail("First item should never be delivered. (See test comments).");
        }

        if ( item == item2 ) {
            XCTFail("Items were delivered out of order. Delivery was non-serial.");
        }
    }];

    // Stall the queue
    [queue addQueueItem:item1];

    // Wait a bit
    [NSThread sleepForTimeInterval:1.0];

    // Add the deliverable item
    [queue addQueueItem:item2];

    // Wait a bit more
    [NSThread sleepForTimeInterval:1.0];

    XCTAssertEqual(queue.currentQueueDepth, 2, "Queue should still contain 2 events.");
    XCTAssertTrue([queue containsItem:item1]);
    XCTAssertTrue([queue containsItem:item2]);
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
    stubRequest(@"POST", EXPECTED_SEND_URL).
    withBody(eventBody).
    andReturn(307).
    withHeader(@"Location", FAKE_REDIRECT_LOCATION);

    stubRequest(@"POST", FAKE_REDIRECT_LOCATION).
    withBody(eventBody).
    andReturn(307).
    withHeader(@"Location", EXPECTED_SEND_URL);

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
    stubRequest(@"POST", EXPECTED_SEND_URL).
    withBody(eventBody).
    andReturn(307).
    withHeader(@"Location", FAKE_REDIRECT_LOCATION);

    stubRequest(@"POST", FAKE_REDIRECT_LOCATION).
    withBody(eventBody).
    andReturn(307).
    withHeader(@"Location", EXPECTED_SEND_URL);

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

- (void) testWidgetEnvironmentOverride
{
    putenv("WIDGET_BASEURL=http://www.criteoTestFakeNotARealDomain.com");

    NSProcessInfo* process = [NSProcessInfo processInfo];
    NSDictionary* env = process.environment;

    NSString* envSendURLString = env[@"WIDGET_BASEURL"];
    XCTAssertNotNil(envSendURLString, @"putenv() failed: Can't test widget environment variable override");

    envSendURLString = [envSendURLString stringByAppendingString:@"/m/event/"];

    XCTestExpectation* eventTransmitted = [self expectationWithDescription:@"Env Override SENT"];

    CRTOEventQueue* localQueue = [[CRTOEventQueue alloc] init];

    [localQueue onItemSent:^(CRTOEventQueueItem* item) {
        [eventTransmitted fulfill];
    }];

    stubRequest(@"POST", envSendURLString).
    withHeader(@"Host", @"widget.criteo.com").
    withBody(eventBody).
    andReturn(200);

    CRTOHomeViewEvent* event = [[CRTOHomeViewEvent alloc] init];
    event.timestamp = [NSDate date];

    CRTOEventQueueItem* item = [[CRTOEventQueueItem alloc] initWithEvent:event requestBody:eventBody];
    [localQueue addQueueItem:item];

    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

@end
