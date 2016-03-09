//
//  CRTOEventServiceTests.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "CRTOEventService.h"
#import "CRTOEventService+Internal.h"
#import "CRTOEvent.h"
#import "CRTOEvent+Internal.h"
#import "CRTOEventQueue.h"
#import "CRTOHomeViewEvent.h"
#import "CRTOJSONEventSerializer.h"

@interface CRTOEventServiceTests : XCTestCase

@end

@implementation CRTOEventServiceTests
{
@private
    NSDate* theTimestamp;
}

- (void)setUp
{
    [super setUp];

    theTimestamp = [NSDate dateWithTimeIntervalSince1970:1000000000];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testInit
{
    CRTOEventService* service = [[CRTOEventService alloc] init];

    XCTAssertNotNil(service);

    XCTAssertNil(service.country);
    XCTAssertNil(service.language);
    XCTAssertNil(service.customerEmail);
    XCTAssertNil(service.customerId);
}

- (void) testInitWithCountryLanguage
{
    NSMutableString* country = [NSMutableString stringWithString:@"US"];
    NSMutableString* lang    = [NSMutableString stringWithString:@"en"];

    CRTOEventService* service = [[CRTOEventService alloc] initWithCountry:country language:lang];

    XCTAssertNotNil(service);

    XCTAssertNil(service.customerEmail);
    XCTAssertNil(service.customerId);

    XCTAssertNotEqual(country, service.country);
    XCTAssertNotEqual(lang, service.language);

    XCTAssertEqualObjects(country, service.country);
    XCTAssertEqualObjects(lang, service.language);
}

- (void) testInitWithCountryLanguageCustomerId
{
    NSMutableString* country = [NSMutableString stringWithString:@"US"];
    NSMutableString* lang    = [NSMutableString stringWithString:@"en"];
    NSMutableString* custId  = [NSMutableString stringWithString:@"Some Data (test test test)"];

    CRTOEventService* service = [[CRTOEventService alloc] initWithCountry:country language:lang customerId:custId];

    XCTAssertNotNil(service);

    XCTAssertNil(service.customerEmail);

    XCTAssertNotEqual(country, service.country);
    XCTAssertNotEqual(lang, service.language);
    XCTAssertNotEqual(custId, service.customerId);

    XCTAssertEqualObjects(country, service.country);
    XCTAssertEqualObjects(lang, service.language);
    XCTAssertEqualObjects(custId, service.customerId);
}

- (void) testSharedInit
{
    CRTOEventService* sharedService = [CRTOEventService sharedEventService];
    CRTOEventService* myService = [[CRTOEventService alloc] init];

    XCTAssertNotNil(sharedService);
    XCTAssertNotEqual(sharedService, myService, @"Instances created via alloc-init should different from the shared instance");
}

- (void) testCountrySetter
{
    NSMutableString* country = [NSMutableString stringWithString:@"US"];

    CRTOEventService* service = [[CRTOEventService alloc] init];

    XCTAssertNil(service.country);

    service.country = country;

    XCTAssertNotNil(service.country);

    XCTAssertNotEqual(country, service.country);
    XCTAssertEqualObjects(country, service.country);
}

- (void) testLanguageSetter
{
    NSMutableString* language = [NSMutableString stringWithString:@"en"];

    CRTOEventService* service = [[CRTOEventService alloc] init];

    XCTAssertNil(service.language);

    service.language = language;

    XCTAssertNotNil(service.language);

    XCTAssertNotEqual(language, service.language);
    XCTAssertEqualObjects(language, service.language);
}

- (void) testCustomerEmailKVO
{
    CRTOEventService* service = [[CRTOEventService alloc] init];

    XCTAssertNoThrow(service.customerEmail = nil);
    XCTAssertNoThrow(service.customerEmail = @"test");
    XCTAssertNoThrow(service.customerEmail = @"@");
    XCTAssertNoThrow(service.customerEmail = @"bar.com");
    XCTAssertNoThrow(service.customerEmail = @"@bar.com");
    XCTAssertNoThrow(service.customerEmail = @"test@bar.");
    XCTAssertNoThrow(service.customerEmail = @"test@barcom");
    XCTAssertNoThrow(service.customerEmail = @"test@bar.com");
    XCTAssertNoThrow(service.customerEmail = @"test@bar.com.");
    XCTAssertNoThrow(service.customerEmail = nil);
}

- (void) testCustomerEmailSetter
{
    NSMutableString* custEmail = [NSMutableString stringWithString:@"foo@bar.com"];

    CRTOEventService* service = [[CRTOEventService alloc] init];

    XCTAssertNil(service.customerEmail);

    service.customerEmail = custEmail;

    XCTAssertNotNil(service.customerEmail);

    XCTAssertNotEqual(custEmail, service.customerEmail);
    XCTAssertEqualObjects(custEmail, service.customerEmail);
}

- (void) testCustomerIdSetter
{
    NSMutableString* custId = [NSMutableString stringWithString:@"The Quick Brown Fox"];

    CRTOEventService* service = [[CRTOEventService alloc] init];

    XCTAssertNil(service.customerId);

    service.customerId = custId;

    XCTAssertNotNil(service.customerId);

    XCTAssertNotEqual(custId, service.customerId);
    XCTAssertEqualObjects(custId, service.customerId);
}

- (void) testSendEvent
{
    CRTOHomeViewEvent* event = [CRTOHomeViewEvent new];
    event.timestamp = theTimestamp;

    CRTOJSONEventSerializer* serializer = [CRTOJSONEventSerializer new];
    CRTOJSONEventSerializer* serializerMock = OCMPartialMock(serializer);

    CRTOEventQueue* queueMock = OCMStrictClassMock([CRTOEventQueue class]);
    OCMStub([queueMock addQueueItem:[OCMArg isKindOfClass:[CRTOEventQueueItem class]]]);

    CRTOEventService* service = [CRTOEventService new];
    service.country = [NSMutableString stringWithString:@"US"];
    service.language = [NSMutableString stringWithString:@"en"];
    service.customerEmail = [NSMutableString stringWithString:@"foo@bar.com"];

    [service sendEvent:event withJSONSerializer:serializerMock eventQueue:queueMock];

    OCMVerify(serializerMock.countryCode = @"US");
    OCMVerify(serializerMock.languageCode = @"en");
    OCMVerify(serializerMock.customerEmail = @"foo@bar.com");

    // [OCMArg isKindOfClass:...] causes this test to randomly fail
    // so we can only verify with [OCMArg any].  Maybe we can change this in
    // the future.
    OCMVerify([queueMock addQueueItem:[OCMArg any]]);
}

- (void) testSendNilEvent
{
    CRTOEventService* service = [CRTOEventService new];

    XCTAssertNoThrow([service send:nil]);
}

@end
