//
//  advertiser_sdk_sandboxTests.m
//  advertiser-sdk-sandboxTests
//
//  Created by Paul Davis on 7/20/15.
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "EventSender.h"
#import "UserDataService.h"
#import "WidgetService.h"

#define SPECIAL_TEST_PARTNER_ID (@"5854")

typedef void(^TestResultsCallback)(id item,
                                   BOOL transmitSuccess,
                                   NSNumber* prevAcdcDate,
                                   NSNumber* currentAcdcDate,
                                   NSNumber* prevUicValue,
                                   NSNumber* currentUicValue,
                                   XCTestExpectation* expectation);

static NSString* uid = nil;

@interface advertiser_sdk_sandboxTests : XCTestCase

@end

@implementation advertiser_sdk_sandboxTests
{
    EventSender* sender;
    UserDataService* user;
    WidgetService* widget;
}

- (void)setUp
{
    [super setUp];

    sender = [EventSender new];
    user = [UserDataService new];
    widget = [WidgetService new];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uid = [widget getCriteoId];
        [NSThread sleepForTimeInterval:5.0];
    });
}

- (void)tearDown
{

    [super tearDown];
}

- (NSNumber*) getDateFromAcDcResponse:(id)response
{
    NSAssert([response isKindOfClass:[NSDictionary class]], @"ACDC Response was not a dictionary");

    NSDictionary* acdc = (NSDictionary*)response;
    NSAssert([acdc.allKeys containsObject:@"userdata"], @"ACDC Response is missing \"userdata\" key");

    NSDictionary* userdata = acdc[@"userdata"];
    NSAssert([userdata.allKeys containsObject:@"data"], @"ACDC Response is missing \"data\" key");

    NSDictionary* data = userdata[@"data"];
    NSAssert([data.allKeys containsObject:SPECIAL_TEST_PARTNER_ID], @"ACDC Response is missing \"%@\" key", SPECIAL_TEST_PARTNER_ID);

    NSArray* partnerIdValue = data[SPECIAL_TEST_PARTNER_ID];
    NSAssert(partnerIdValue.count, @"ACDC Response has empty or invalid \"%@\" value", SPECIAL_TEST_PARTNER_ID);

    NSDictionary* partnerDictionary = partnerIdValue[0];
    NSAssert([partnerDictionary.allKeys containsObject:@"Date"], @"ACDC \"%@\" dictionary is missing \"Date\" key", SPECIAL_TEST_PARTNER_ID);

    NSNumber* date = partnerDictionary[@"Date"];
    NSAssert([date isKindOfClass:[NSNumber class]], @"\"Date\" value in \"%@\" dictionary is not a number.", SPECIAL_TEST_PARTNER_ID);

    return date;
}

- (NSNumber*) getNumberForKey:(NSString*)key fromUicResponse:(id)response
{
    NSAssert([response isKindOfClass:[NSDictionary class]], @"UIC Response was not a dictionary");

    NSDictionary* uic = (NSDictionary*)response;
    NSAssert([uic.allKeys containsObject:@"userdata"], @"UIC Response is missing \"userdata\" key");

    NSDictionary* userdata = uic[@"userdata"];
    NSAssert([userdata.allKeys containsObject:@"data"], @"UIC Response is missing \"data\" key");

    NSDictionary* data = userdata[@"data"];
    NSAssert([data.allKeys containsObject:@"Info"], @"UIC Response is missing \"Info\" key");

    NSDictionary* info = data[@"Info"];
    NSAssert([info.allKeys containsObject:SPECIAL_TEST_PARTNER_ID], @"UIC Response is missing \"%@\" key", SPECIAL_TEST_PARTNER_ID);

    NSDictionary* partnerDictionary = info[SPECIAL_TEST_PARTNER_ID];
    NSAssert([partnerDictionary.allKeys containsObject:key], @"UIC \"%@\" dictionary is missing \"%@\" key", SPECIAL_TEST_PARTNER_ID, key);

    NSNumber* value = partnerDictionary[key];
    NSAssert([value isKindOfClass:[NSNumber class]], @"\"%@\" value in \"%@\" dictionary is not a number.", key, SPECIAL_TEST_PARTNER_ID);

    return value;
}

- (void) getUserDataForEvent:(CRTOEvent*)event
                 description:(NSString*)description
                      uicKey:(NSString*)key
          testResultCallback:(TestResultsCallback)testResultCallback
{
    NSString* expectationName = [NSString stringWithFormat:@"%@ Tx Completed", description];
    XCTestExpectation* expect = [self expectationWithDescription:expectationName];

    id prevAcdc = [user getAcdcForUid:uid];
    id prevUic  = [user getUicForUid:uid];

    NSNumber* prevAcdcDate = [self getDateFromAcDcResponse:prevAcdc];
    NSNumber* prevUicValue = [self getNumberForKey:key fromUicResponse:prevUic];

    [sender sendEvent:event
         withCallback:^(id item, BOOL success)
    {
        if ( !success ) {
            testResultCallback(item, success, prevAcdcDate, nil, prevUicValue, nil, expect);
            return;
        }

        // It takes a little bit of time for the userdata web service to see the event we just sent
        [NSThread sleepForTimeInterval:1.0];

        id currentAcdc = [user getAcdcForUid:uid];
        id currentUic  = [user getUicForUid:uid];

        NSNumber* currentAcdcDate = [self getDateFromAcDcResponse:currentAcdc];
        NSNumber* currentUicValue = [self getNumberForKey:key fromUicResponse:currentUic];

        testResultCallback(item, success, prevAcdcDate, currentAcdcDate, prevUicValue, currentUicValue, expect);
    }];
}

- (void) testAppLaunchEvent
{
    NSString* description = @"App Launch";
    NSString* uicKey = @"LastEvt";

    CRTOEvent* appLaunch = [sender getAppLaunchEvent];

    [self getUserDataForEvent:appLaunch
                  description:description
                       uicKey:uicKey
           testResultCallback:^(id item, BOOL transmitSuccess,
                                NSNumber* prevAcdcDate, NSNumber* currentAcdcDate,
                                NSNumber* prevUicValue, NSNumber* currentUicValue,
                                XCTestExpectation* expectation)
     {
         XCTAssertTrue(transmitSuccess, @"%@ request failed", description);

         XCTAssertNotEqualObjects(prevAcdcDate, currentAcdcDate);
         XCTAssert(NSOrderedAscending == [prevAcdcDate compare:currentAcdcDate], @"Current ACDC date must be greater than the previous ACDC date");

         XCTAssertNotEqualObjects(prevUicValue, currentUicValue);
         XCTAssert(NSOrderedAscending == [prevUicValue compare:currentUicValue], @"Current UIC count must be greater than the previous UIC count");

         [expectation fulfill];
     }];

    [self waitForExpectationsWithTimeout:10.0f handler:nil];
}

- (void) testBasketViewEvent
{
    NSString* description = @"Basket View";
    NSString* uicKey = @"EvtBasket";

    CRTOEvent* basketView = [sender getBasketViewEvent];

    [self getUserDataForEvent:basketView
                  description:description
                       uicKey:uicKey
           testResultCallback:^(id item, BOOL transmitSuccess,
                                NSNumber* prevAcdcDate, NSNumber* currentAcdcDate,
                                NSNumber* prevUicValue, NSNumber* currentUicValue,
                                XCTestExpectation* expectation)
     {
         XCTAssertTrue(transmitSuccess, @"%@ request failed", description);

         XCTAssertNotEqualObjects(prevAcdcDate, currentAcdcDate);
         XCTAssert(NSOrderedAscending == [prevAcdcDate compare:currentAcdcDate], @"Current ACDC date must be greater than the previous ACDC date");

         XCTAssertNotEqualObjects(prevUicValue, currentUicValue);
         XCTAssert(NSOrderedAscending == [prevUicValue compare:currentUicValue], @"Current UIC count must be greater than the previous UIC count");

         [expectation fulfill];
     }];

    [self waitForExpectationsWithTimeout:10.0f handler:nil];
}

- (void) testDataEvent
{
    NSString* description = @"Data Event";
    NSString* uicKey = @"LastEvt";

    CRTOEvent* dataEvent = [sender getDataEvent];

    [self getUserDataForEvent:dataEvent
                  description:description
                       uicKey:uicKey
           testResultCallback:^(id item, BOOL transmitSuccess,
                                NSNumber* prevAcdcDate, NSNumber* currentAcdcDate,
                                NSNumber* prevUicValue, NSNumber* currentUicValue,
                                XCTestExpectation* expectation)
     {
         XCTAssertTrue(transmitSuccess, @"%@ request failed", description);

         XCTAssertNotEqualObjects(prevAcdcDate, currentAcdcDate);
         XCTAssert(NSOrderedAscending == [prevAcdcDate compare:currentAcdcDate], @"Current ACDC date must be greater than the previous ACDC date");

         XCTAssertNotEqualObjects(prevUicValue, currentUicValue);
         XCTAssert(NSOrderedAscending == [prevUicValue compare:currentUicValue], @"Current UIC count must be greater than the previous UIC count");

         [expectation fulfill];
     }];

    [self waitForExpectationsWithTimeout:10.0f handler:nil];
}

- (void) testDeeplinkEvent
{
    NSString* description = @"Deeplink Event";
    NSString* uicKey = @"LastEvt";

    CRTOEvent* deeplinkEvent = [sender getDeeplinkEvent];

    [self getUserDataForEvent:deeplinkEvent
                  description:description
                       uicKey:uicKey
           testResultCallback:^(id item, BOOL transmitSuccess,
                                NSNumber* prevAcdcDate, NSNumber* currentAcdcDate,
                                NSNumber* prevUicValue, NSNumber* currentUicValue,
                                XCTestExpectation* expectation)
     {
         XCTAssertTrue(transmitSuccess, @"%@ request failed", description);

         XCTAssertNotEqualObjects(prevAcdcDate, currentAcdcDate);
         XCTAssert(NSOrderedAscending == [prevAcdcDate compare:currentAcdcDate], @"Current ACDC date must be greater than the previous ACDC date");

         XCTAssertNotEqualObjects(prevUicValue, currentUicValue);
         XCTAssert(NSOrderedAscending == [prevUicValue compare:currentUicValue], @"Current UIC count must be greater than the previous UIC count");

         [expectation fulfill];
     }];

    [self waitForExpectationsWithTimeout:10.0f handler:nil];
}

- (void) testHomeViewEvent
{
    NSString* description = @"Home View";
    NSString* uicKey = @"EvtHome";

    CRTOEvent* homeView = [sender getHomeViewEvent];

    [self getUserDataForEvent:homeView
                  description:description
                       uicKey:uicKey
           testResultCallback:^(id item, BOOL transmitSuccess,
                                NSNumber* prevAcdcDate, NSNumber* currentAcdcDate,
                                NSNumber* prevUicValue, NSNumber* currentUicValue,
                                XCTestExpectation* expectation)
     {
         XCTAssertTrue(transmitSuccess, @"%@ request failed", description);

         XCTAssertNotEqualObjects(prevAcdcDate, currentAcdcDate);
         XCTAssert(NSOrderedAscending == [prevAcdcDate compare:currentAcdcDate], @"Current ACDC date must be greater than the previous ACDC date");

         XCTAssertNotEqualObjects(prevUicValue, currentUicValue);
         XCTAssert(NSOrderedAscending == [prevUicValue compare:currentUicValue], @"Current UIC count must be greater than the previous UIC count");

         [expectation fulfill];
     }];

    [self waitForExpectationsWithTimeout:10.0f handler:nil];
}

- (void) testProductListViewEvent
{
    NSString* description = @"Product List";
    NSString* uicKey = @"EvtList";

    CRTOEvent* productList = [sender getProductListViewEvent];

    [self getUserDataForEvent:productList
                  description:description
                       uicKey:uicKey
           testResultCallback:^(id item, BOOL transmitSuccess,
                                NSNumber* prevAcdcDate, NSNumber* currentAcdcDate,
                                NSNumber* prevUicValue, NSNumber* currentUicValue,
                                XCTestExpectation* expectation)
     {
         XCTAssertTrue(transmitSuccess, @"%@ request failed", description);

         XCTAssertNotEqualObjects(prevAcdcDate, currentAcdcDate);
         XCTAssert(NSOrderedAscending == [prevAcdcDate compare:currentAcdcDate], @"Current ACDC date must be greater than the previous ACDC date");

         XCTAssertNotEqualObjects(prevUicValue, currentUicValue);
         XCTAssert(NSOrderedAscending == [prevUicValue compare:currentUicValue], @"Current UIC count must be greater than the previous UIC count");

         [expectation fulfill];
     }];

    [self waitForExpectationsWithTimeout:10.0f handler:nil];
}

- (void) testProductViewEvent
{
    NSString* description = @"Product View";
    NSString* uicKey = @"EvtProd";

    CRTOEvent* productView = [sender getProductViewEvent];

    [self getUserDataForEvent:productView
                  description:description
                       uicKey:uicKey
           testResultCallback:^(id item, BOOL transmitSuccess,
                                NSNumber* prevAcdcDate, NSNumber* currentAcdcDate,
                                NSNumber* prevUicValue, NSNumber* currentUicValue,
                                XCTestExpectation* expectation)
     {
         XCTAssertTrue(transmitSuccess, @"%@ request failed", description);

         XCTAssertNotEqualObjects(prevAcdcDate, currentAcdcDate);
         XCTAssert(NSOrderedAscending == [prevAcdcDate compare:currentAcdcDate], @"Current ACDC date must be greater than the previous ACDC date");

         XCTAssertNotEqualObjects(prevUicValue, currentUicValue);
         XCTAssert(NSOrderedAscending == [prevUicValue compare:currentUicValue], @"Current UIC count must be greater than the previous UIC count");

         [expectation fulfill];
     }];

    [self waitForExpectationsWithTimeout:10.0f handler:nil];
}

- (void) testTransactionConfirmationEvent
{
    NSString* description = @"Transaction Confirm";
    NSString* uicKey = @"EvtSale";

    CRTOEvent* transactionConfirm = [sender getTransactionConfirmationEvent];

    [self getUserDataForEvent:transactionConfirm
                  description:description
                       uicKey:uicKey
           testResultCallback:^(id item, BOOL transmitSuccess,
                                NSNumber* prevAcdcDate, NSNumber* currentAcdcDate,
                                NSNumber* prevUicValue, NSNumber* currentUicValue,
                                XCTestExpectation* expectation)
     {
         XCTAssertTrue(transmitSuccess, @"%@ request failed", description);

         XCTAssertNotEqualObjects(prevAcdcDate, currentAcdcDate);
         XCTAssert(NSOrderedAscending == [prevAcdcDate compare:currentAcdcDate], @"Current ACDC date must be greater than the previous ACDC date");

         XCTAssertNotEqualObjects(prevUicValue, currentUicValue);
         XCTAssert(NSOrderedAscending == [prevUicValue compare:currentUicValue], @"Current UIC count must be greater than the previous UIC count");

         [expectation fulfill];
     }];

    [self waitForExpectationsWithTimeout:10.0f handler:nil];
}

@end
