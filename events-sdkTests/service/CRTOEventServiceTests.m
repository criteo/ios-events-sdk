//
//  CRTOEventServiceTests.m
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

- (void) testAccountNameSetter
{
    NSMutableString* accountName = [NSMutableString stringWithString:@"com.account.super.my"];

    CRTOEventService* service = [[CRTOEventService alloc] init];

    XCTAssertNil(service.accountName);

    service.accountName = accountName;

    XCTAssertNotNil(service.accountName);

    XCTAssertNotEqual(accountName, service.accountName);
    XCTAssertEqualObjects(accountName, service.accountName);
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

- (void) testCustomerEmailSetterCleartext
{
    NSMutableString* custEmail = [NSMutableString stringWithString:@"foo@bar.com"];
    NSString* expected = @"f3ada405ce890b6f8204094deb12d8a8";

    CRTOEventService* service = [[CRTOEventService alloc] init];

    XCTAssertNil(service.customerEmail);
    XCTAssertEqual(CRTOEventServiceEmailTypeCleartext, service.customerEmailType);

    service.customerEmail = custEmail;

    XCTAssertNotNil(service.customerEmail);

    XCTAssertNotEqual(custEmail, service.customerEmail);
    XCTAssertEqualObjects(expected, service.customerEmail);
}

- (void) testCustomerEmailSetterCleartextNil
{
    CRTOEventService* service = [[CRTOEventService alloc] init];

    XCTAssertNil(service.customerEmail);
    XCTAssertEqual(CRTOEventServiceEmailTypeCleartext, service.customerEmailType);

    XCTAssertNoThrow( service.customerEmail = nil );

    XCTAssertNil(service.customerEmail);
}

- (void) testCustomerEmailSetterMd5
{
    NSMutableString* hashedCustEmail = [NSMutableString stringWithString:@"f3ada405ce890b6f8204094deb12d8a8"];

    CRTOEventService* service = [[CRTOEventService alloc] init];
    service.customerEmailType = CRTOEventServiceEmailTypeHashedMd5;

    XCTAssertNil(service.customerEmail);

    service.customerEmail = hashedCustEmail;

    XCTAssertNotNil(service.customerEmail);

    XCTAssertNotEqual(hashedCustEmail, service.customerEmail);
    XCTAssertEqualObjects(hashedCustEmail, service.customerEmail);
}

- (void) testCustomerEmailSetterMd5Nil
{
    CRTOEventService* service = [[CRTOEventService alloc] init];
    service.customerEmailType = CRTOEventServiceEmailTypeHashedMd5;

    XCTAssertNil(service.customerEmail);
    XCTAssertEqual(CRTOEventServiceEmailTypeHashedMd5, service.customerEmailType);

    XCTAssertNoThrow( service.customerEmail = nil );

    XCTAssertNil(service.customerEmail);
}

- (void) testCustomerEmailTypeSetter
{
    CRTOEventService* service = [[CRTOEventService alloc] init];

    XCTAssertEqual(service.customerEmailType, CRTOEventServiceEmailTypeCleartext);
    XCTAssertNil(service.customerEmail);

    service.customerEmail = @"blah@blah.com";

    XCTAssertNotNil(service.customerEmail);

    service.customerEmailType = CRTOEventServiceEmailTypeCleartext;

    XCTAssertEqual(service.customerEmailType, CRTOEventServiceEmailTypeCleartext);
    XCTAssertNotNil(service.customerEmail);

    service.customerEmailType = CRTOEventServiceEmailTypeHashedMd5;

    XCTAssertEqual(service.customerEmailType, CRTOEventServiceEmailTypeHashedMd5);
    XCTAssertNil(service.customerEmail);
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
    service.accountName = [NSMutableString stringWithString:@"com.account.super.my"];

    [service sendEvent:event withJSONSerializer:serializerMock eventQueue:queueMock];

    OCMVerify(serializerMock.countryCode = @"US");
    OCMVerify(serializerMock.languageCode = @"en");
    OCMVerify(serializerMock.customerEmail = @"f3ada405ce890b6f8204094deb12d8a8");
    OCMVerify(serializerMock.accountName = @"com.account.super.my");

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
