//
//  CRTOJSONEventSerializerTests.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "CRTOAppInfo.h"
#import "CRTOAppLaunchEvent.h"
#import "CRTOAppLaunchEvent+Internal.h"
#import "CRTOBasketProduct.h"
#import "CRTOBasketViewEvent.h"
#import "CRTODataEvent.h"
#import "CRTODeepLinkEvent.h"
#import "CRTODeviceInfo.h"
#import "CRTOEvent.h"
#import "CRTOEvent+Internal.h"
#import "CRTOHomeViewEvent.h"
#import "CRTOJSONEventSerializer.h"
#import "CRTOProduct.h"
#import "CRTOProductListViewEvent.h"
#import "CRTOProductViewEvent.h"
#import "CRTOSDKInfo.h"
#import "CRTOTransactionConfirmationEvent.h"

@interface CRTOJSONEventSerializerTests : XCTestCase

@end

@implementation CRTOJSONEventSerializerTests
{
    CRTOAppInfo* mockAppInfo;
    CRTODeviceInfo* mockDeviceInfo;
    CRTOSDKInfo* mockSDKInfo;

    NSDate* timestamp;
}

- (void)setUp
{
    [super setUp];

    // CRTOAppInfo Mock
    mockAppInfo = OCMClassMock([CRTOAppInfo class]);

    OCMStub([mockAppInfo appCountry]).
    andReturn(@"US");

    OCMStub([mockAppInfo appId]).
    andReturn(@"com.criteo.sdktestapp");

    OCMStub([mockAppInfo appLanguage]).
    andReturn(@"en");

    OCMStub([mockAppInfo appName]).
    andReturn(@"Criteo Test App");

    OCMStub([mockAppInfo appVersion]).
    andReturn(@"43.0.2357.61");

    // CRTODeviceInfo Mock
    mockDeviceInfo = OCMClassMock([CRTODeviceInfo class]);

    OCMStub([mockDeviceInfo deviceIdentifier]).
    andReturn(@"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6");

    OCMStub([mockDeviceInfo deviceManufacturer]).
    andReturn(@"apple");

    OCMStub([mockDeviceInfo deviceModel]).
    andReturn(@"iPhone3,2");

    OCMStub([mockDeviceInfo isEventGatheringEnabled]).
    andReturn(NO);

    OCMStub([mockDeviceInfo osName]).
    andReturn(@"iPhone OS");

    OCMStub([mockDeviceInfo osVersion]).
    andReturn(@"4.9.1");

    OCMStub([mockDeviceInfo platform]).
    andReturn(@"ios");

    // CRTOSDKInfo Mock
    mockSDKInfo = OCMClassMock([CRTOSDKInfo class]);

    OCMStub([mockSDKInfo sdkVersion]).
    andReturn(@"1.0.0");

    // A single point in time
    timestamp = [NSDate dateWithTimeIntervalSince1970:1435330645];
}

- (void)tearDown
{
    mockAppInfo    = nil;
    mockDeviceInfo = nil;
    mockSDKInfo    = nil;

    [super tearDown];
}

// Why do we bother returning resultObj and expectedObj via out paramaters?
// Why don't we just run an XCTAssertEqualObjects test in this method?
//
// Great questions! You're very bright, aren't you?
//
// Xcode marks the line containing the XCTAssertEqualObjects macro as the point
// of failure for each test. So, if you test for failure in this method, the IDE
// won't give any useful visual information about failed tests.
//
// In order to keep things sane for developers running these tests in Xcode, we
// just return the deserialization results to the caller and expect them to run
// the test macro inside the test method.
- (void) runSerializerForEvent:(CRTOEvent*)event
             andExpectedResult:(NSString*)expected
            returningResultObj:(id*)resultObj
                andExpectedObj:(id*)expectedObj
{
    [self runSerializerForEvent:event
              withCustomerEmail:nil
              andExpectedResult:expected
             returningResultObj:resultObj
                 andExpectedObj:expectedObj];
}

- (void) runSerializerForEvent:(CRTOEvent*)event
             withCustomerEmail:(NSString*)email
             andExpectedResult:(NSString*)expected
            returningResultObj:(id*)resultObj
                andExpectedObj:(id*)expectedObj
{
    CRTOJSONEventSerializer* serializer = [[CRTOJSONEventSerializer alloc] initWithAppInfo:mockAppInfo
                                                                                deviceInfo:mockDeviceInfo
                                                                                   sdkInfo:mockSDKInfo];
    if ( email ) {
        serializer.customerEmail = email;
    }

    NSString* result = [serializer serializeEventToJSONString:event];

    NSData* resultData   = [NSData dataWithBytes:result.UTF8String length:[result lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    NSData* expectedData = [NSData dataWithBytes:expected.UTF8String length:[expected lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];

    NSError* resultError = nil;
    *resultObj = [NSJSONSerialization JSONObjectWithData:resultData options:0 error:&resultError];

    if ( resultError ) {
        NSLog(@"Error deserializing result JSON: %@", resultError);
    }

    NSError* expectedError = nil;
    *expectedObj = [NSJSONSerialization JSONObjectWithData:expectedData options:0 error:&expectedError];

    if ( expectedError ) {
        NSLog(@"Error deserializing expected JSON: %@", expectedError);
    }
}

- (void) testAlternateIdIsSerialized
{
    CRTODeeplinkEvent* deeplinkEvent = [[CRTODeeplinkEvent alloc] initWithDeeplinkLaunchUrl:@"foo bar"];
    deeplinkEvent.timestamp = timestamp;

    NSString* expected = @"{"
                          "  \"account\" : {"
                          "    \"app_name\" : \"com.criteo.sdktestapp\""
                          "  },"
                          "  \"events\" : ["
                          "    {"
                          "      \"event\" : \"appDeeplink\","
                          "      \"deeplink_uri\" : \"foo bar\","
                          "      \"timestamp\" : \"2015-06-26T14:57:25Z\""
                          "    }"
                          "  ],"
                          "  \"id\" : {"
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\""
                          "  },"
                          "  \"device_info\" : {"
                          "    \"os_name\" : \"iPhone OS\","
                          "    \"device_model\" : \"iPhone3,2\","
                          "    \"device_manufacturer\" : \"apple\","
                          "    \"os_version\" : \"4.9.1\","
                          "    \"platform\" : \"ios\""
                          "  },"
                          "  \"app_info\" : {"
                          "    \"app_version\" : \"43.0.2357.61\","
                          "    \"app_name\" : \"Criteo Test App\","
                          "    \"sdk_version\" : \"1.0.0\","
                          "    \"app_language\" : \"en\","
                          "    \"app_id\" : \"com.criteo.sdktestapp\","
                          "    \"app_country\" : \"US\""
                          "  },"
                          "  \"version\" : \"sdk_1.0.0\","
                          "  \"alternate_ids\" : ["
                          "    {"
                          "      \"type\" : \"email\","
                          "      \"value\" : \"NotAReal Email\","
                          "      \"hash_method\" : \"none\""
                          "    }"
                          "  ]"
                          "}";

    id resultObj = nil;
    id expectedObj = nil;

    [self runSerializerForEvent:deeplinkEvent
              withCustomerEmail:@"NotAReal Email"
              andExpectedResult:expected
             returningResultObj:&resultObj
                 andExpectedObj:&expectedObj];

    XCTAssertEqualObjects(resultObj, expectedObj);
}

- (void) testAlternateIdMissingIsNotSerialized
{
    CRTODeeplinkEvent* deeplinkEvent = [[CRTODeeplinkEvent alloc] initWithDeeplinkLaunchUrl:@"foo bar"];
    deeplinkEvent.timestamp = timestamp;

    NSString* expected = @"{"
                          "  \"account\" : {"
                          "    \"app_name\" : \"com.criteo.sdktestapp\""
                          "  },"
                          "  \"events\" : ["
                          "    {"
                          "      \"event\" : \"appDeeplink\","
                          "      \"deeplink_uri\" : \"foo bar\","
                          "      \"timestamp\" : \"2015-06-26T14:57:25Z\""
                          "    }"
                          "  ],"
                          "  \"id\" : {"
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\""
                          "  },"
                          "  \"device_info\" : {"
                          "    \"os_name\" : \"iPhone OS\","
                          "    \"device_model\" : \"iPhone3,2\","
                          "    \"device_manufacturer\" : \"apple\","
                          "    \"os_version\" : \"4.9.1\","
                          "    \"platform\" : \"ios\""
                          "  },"
                          "  \"app_info\" : {"
                          "    \"app_version\" : \"43.0.2357.61\","
                          "    \"app_name\" : \"Criteo Test App\","
                          "    \"sdk_version\" : \"1.0.0\","
                          "    \"app_language\" : \"en\","
                          "    \"app_id\" : \"com.criteo.sdktestapp\","
                          "    \"app_country\" : \"US\""
                          "  },"
                          "  \"version\" : \"sdk_1.0.0\""
                          "}";

    id resultObj = nil;
    id expectedObj = nil;

    [self runSerializerForEvent:deeplinkEvent
              andExpectedResult:expected
             returningResultObj:&resultObj
                 andExpectedObj:&expectedObj];

    XCTAssertEqualObjects(resultObj, expectedObj);
}

- (void) testAppLaunchEventSerialization
{
    CRTOAppLaunchEvent* appLaunch = [[CRTOAppLaunchEvent alloc] init];
    appLaunch.timestamp = timestamp;

    NSString* expected = @"{"
                          "  \"account\" : {"
                          "    \"app_name\" : \"com.criteo.sdktestapp\""
                          "  },"
                          "  \"events\" : ["
                          "    {"
                          "      \"event\" : \"appLaunch\","
                          "      \"timestamp\" : \"2015-06-26T14:57:25Z\""
                          "    }"
                          "  ],"
                          "  \"id\" : {"
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\""
                          "  },"
                          "  \"device_info\" : {"
                          "    \"os_name\" : \"iPhone OS\","
                          "    \"device_model\" : \"iPhone3,2\","
                          "    \"device_manufacturer\" : \"apple\","
                          "    \"os_version\" : \"4.9.1\","
                          "    \"platform\" : \"ios\""
                          "  },"
                          "  \"app_info\" : {"
                          "    \"app_version\" : \"43.0.2357.61\","
                          "    \"app_name\" : \"Criteo Test App\","
                          "    \"sdk_version\" : \"1.0.0\","
                          "    \"app_language\" : \"en\","
                          "    \"app_id\" : \"com.criteo.sdktestapp\","
                          "    \"app_country\" : \"US\""
                          "  },"
                          "  \"version\" : \"sdk_1.0.0\""
                          "}";

    id resultObj = nil;
    id expectedObj = nil;

    [self runSerializerForEvent:appLaunch
              andExpectedResult:expected
             returningResultObj:&resultObj
                 andExpectedObj:&expectedObj];

    XCTAssertEqualObjects(resultObj, expectedObj);
}

- (void) testAppLaunchEventWithExtraDataSerialization
{
    CRTOAppLaunchEvent* appLaunch = [[CRTOAppLaunchEvent alloc] init];
    appLaunch.timestamp = timestamp;

    NSDate* extraDate = [NSDate dateWithTimeIntervalSince1970:1000000000];
    [appLaunch setDateExtraData:extraDate ForKey:@"my_date_extra_data"];

    float extraFloat = 0.1f;
    [appLaunch setFloatExtraData:extraFloat ForKey:@"FLOATDATA"];

    NSInteger extraInteger = -2000000000;
    [appLaunch setIntegerExtraData:extraInteger ForKey:@"The biggest number there is"];

    NSString* extraString = @"some Sample string";
    [appLaunch setStringExtraData:extraString ForKey:@"myStringData"];


    NSString* expected = @"{"
                          "  \"account\" : {"
                          "    \"app_name\" : \"com.criteo.sdktestapp\""
                          "  },"
                          "  \"events\" : ["
                          "    {"
                          "      \"event\" : \"appLaunch\","
                          "      \"my_date_extra_data\" : {"
                          "         \"value\" : \"2001-09-09T01:46:40Z\","
                          "         \"type\" : \"date\""
                          "      },"
                          "      \"FLOATDATA\" : {"
                          "         \"value\" : 0.1,"
                          "         \"type\" : \"float\""
                          "      },"
                          "      \"The biggest number there is\" : {"
                          "         \"value\" : -2000000000,"
                          "         \"type\" : \"integer\""
                          "      },"
                          "      \"myStringData\" : {"
                          "         \"value\" : \"some Sample string\","
                          "         \"type\" : \"text\""
                          "      },"
                          "      \"timestamp\" : \"2015-06-26T14:57:25Z\""
                          "    }"
                          "  ],"
                          "  \"id\" : {"
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\""
                          "  },"
                          "  \"device_info\" : {"
                          "    \"os_name\" : \"iPhone OS\","
                          "    \"device_model\" : \"iPhone3,2\","
                          "    \"device_manufacturer\" : \"apple\","
                          "    \"os_version\" : \"4.9.1\","
                          "    \"platform\" : \"ios\""
                          "  },"
                          "  \"app_info\" : {"
                          "    \"app_version\" : \"43.0.2357.61\","
                          "    \"app_name\" : \"Criteo Test App\","
                          "    \"sdk_version\" : \"1.0.0\","
                          "    \"app_language\" : \"en\","
                          "    \"app_id\" : \"com.criteo.sdktestapp\","
                          "    \"app_country\" : \"US\""
                          "  },"
                          "  \"version\" : \"sdk_1.0.0\""
                          "}";

    id resultObj = nil;
    id expectedObj = nil;

    [self runSerializerForEvent:appLaunch
              andExpectedResult:expected
             returningResultObj:&resultObj
                 andExpectedObj:&expectedObj];

    XCTAssertEqualObjects(resultObj, expectedObj);
}

- (void) testAppLaunchEventFirstLaunchSerialization
{
    CRTOAppLaunchEvent* appLaunch = [[CRTOAppLaunchEvent alloc] initWithFirstLaunchFlagOverride:YES];
    appLaunch.timestamp = timestamp;

    NSString* expected = @"{"
                          "  \"account\" : {"
                          "    \"app_name\" : \"com.criteo.sdktestapp\""
                          "  },"
                          "  \"events\" : ["
                          "    {"
                          "      \"event\" : \"appLaunch\","
                          "      \"first_launch\" : 1,"
                          "      \"timestamp\" : \"2015-06-26T14:57:25Z\""
                          "    }"
                          "  ],"
                          "  \"id\" : {"
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\""
                          "  },"
                          "  \"device_info\" : {"
                          "    \"os_name\" : \"iPhone OS\","
                          "    \"device_model\" : \"iPhone3,2\","
                          "    \"device_manufacturer\" : \"apple\","
                          "    \"os_version\" : \"4.9.1\","
                          "    \"platform\" : \"ios\""
                          "  },"
                          "  \"app_info\" : {"
                          "    \"app_version\" : \"43.0.2357.61\","
                          "    \"app_name\" : \"Criteo Test App\","
                          "    \"sdk_version\" : \"1.0.0\","
                          "    \"app_language\" : \"en\","
                          "    \"app_id\" : \"com.criteo.sdktestapp\","
                          "    \"app_country\" : \"US\""
                          "  },"
                          "  \"version\" : \"sdk_1.0.0\""
                          "}";

    id resultObj = nil;
    id expectedObj = nil;

    [self runSerializerForEvent:appLaunch
              andExpectedResult:expected
             returningResultObj:&resultObj
                 andExpectedObj:&expectedObj];

    XCTAssertEqualObjects(resultObj, expectedObj);
}

- (void) testBasketViewEventSerialization
{
    CRTOBasketProduct* product  = [[CRTOBasketProduct alloc] initWithProductId:@"PRODUCT11223344" price:999.85 quantity:1];
    CRTOBasketProduct* product2 = [[CRTOBasketProduct alloc] initWithProductId:@"PRODUCT56789101" price:10 quantity:100];
    CRTOBasketProduct* product3 = [[CRTOBasketProduct alloc] initWithProductId:@"나는 유리를 먹을 수 있어요. 그래도 아프지 않아요" price:0.1 quantity:-2500];

    CRTOBasketViewEvent* basketViewEvent = [[CRTOBasketViewEvent alloc] initWithBasketProducts:@[ product, product2, product3 ]];
    basketViewEvent.currency = @"USD";
    basketViewEvent.timestamp = timestamp;

    NSString* expected = @"{"
                          "  \"account\" : {"
                          "    \"app_name\" : \"com.criteo.sdktestapp\""
                          "  },"
                          "  \"events\" : ["
                          "    {"
                          "      \"event\" : \"viewBasket\","
                          "      \"currency\" : \"USD\","
                          "      \"product\" : ["
                          "        {"
                          "          \"id\" : \"PRODUCT11223344\","
                          "          \"price\" : 999.85,"
                          "          \"quantity\" : 1"
                          "        },"
                          "        {"
                          "          \"id\" : \"PRODUCT56789101\","
                          "          \"price\" : 10,"
                          "          \"quantity\" : 100"
                          "        },"
                          "        {"
                          "          \"id\" : \"나는 유리를 먹을 수 있어요. 그래도 아프지 않아요\","
                          "          \"price\" : 0.1,"
                          "          \"quantity\" : -2500"
                          "        }"
                          "      ],"
                          "      \"timestamp\" : \"2015-06-26T14:57:25Z\""
                          "    }"
                          "  ],"
                          "  \"id\" : {"
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\""
                          "  },"
                          "  \"device_info\" : {"
                          "    \"os_name\" : \"iPhone OS\","
                          "    \"device_model\" : \"iPhone3,2\","
                          "    \"device_manufacturer\" : \"apple\","
                          "    \"os_version\" : \"4.9.1\","
                          "    \"platform\" : \"ios\""
                          "  },"
                          "  \"app_info\" : {"
                          "    \"app_version\" : \"43.0.2357.61\","
                          "    \"app_name\" : \"Criteo Test App\","
                          "    \"sdk_version\" : \"1.0.0\","
                          "    \"app_language\" : \"en\","
                          "    \"app_id\" : \"com.criteo.sdktestapp\","
                          "    \"app_country\" : \"US\""
                          "  },"
                          "  \"version\" : \"sdk_1.0.0\","
                          "  \"alternate_ids\" : ["
                          "    {"
                          "      \"type\" : \"email\","
                          "      \"value\" : \"NotAReal Email\","
                          "      \"hash_method\" : \"none\""
                          "    }"
                          "  ]"
                          "}";

    id resultObj = nil;
    id expectedObj = nil;

    [self runSerializerForEvent:basketViewEvent
              withCustomerEmail:@"NotAReal Email"
              andExpectedResult:expected
             returningResultObj:&resultObj
                 andExpectedObj:&expectedObj];

    XCTAssertEqualObjects(resultObj, expectedObj);
}

- (void) testBasketViewEventSerializationWithNilProducts
{
    CRTOBasketViewEvent* basketViewEvent = [[CRTOBasketViewEvent alloc] initWithBasketProducts:nil];
    basketViewEvent.timestamp = timestamp;

    NSString* expected = @"{"
                          "  \"account\" : {"
                          "    \"app_name\" : \"com.criteo.sdktestapp\""
                          "  },"
                          "  \"events\" : ["
                          "    {"
                          "      \"event\" : \"viewBasket\","
                          "      \"product\" : [ ],"
                          "      \"timestamp\" : \"2015-06-26T14:57:25Z\""
                          "    }"
                          "  ],"
                          "  \"id\" : {"
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\""
                          "  },"
                          "  \"device_info\" : {"
                          "    \"os_name\" : \"iPhone OS\","
                          "    \"device_model\" : \"iPhone3,2\","
                          "    \"device_manufacturer\" : \"apple\","
                          "    \"os_version\" : \"4.9.1\","
                          "    \"platform\" : \"ios\""
                          "  },"
                          "  \"app_info\" : {"
                          "    \"app_version\" : \"43.0.2357.61\","
                          "    \"app_name\" : \"Criteo Test App\","
                          "    \"sdk_version\" : \"1.0.0\","
                          "    \"app_language\" : \"en\","
                          "    \"app_id\" : \"com.criteo.sdktestapp\","
                          "    \"app_country\" : \"US\""
                          "  },"
                          "  \"version\" : \"sdk_1.0.0\","
                          "  \"alternate_ids\" : ["
                          "    {"
                          "      \"type\" : \"email\","
                          "      \"value\" : \"NotAReal Email\","
                          "      \"hash_method\" : \"none\""
                          "    }"
                          "  ]"
                          "}";

    id resultObj = nil;
    id expectedObj = nil;

    [self runSerializerForEvent:basketViewEvent
              withCustomerEmail:@"NotAReal Email"
              andExpectedResult:expected
             returningResultObj:&resultObj
                 andExpectedObj:&expectedObj];

    XCTAssertEqualObjects(resultObj, expectedObj);
}

- (void) testBasketViewEventSerializationWithNilProductId
{
    CRTOBasketProduct* product  = [[CRTOBasketProduct alloc] initWithProductId:nil price:999.85 quantity:1];
    CRTOBasketProduct* product2 = [[CRTOBasketProduct alloc] initWithProductId:@"PRODUCT56789101" price:10 quantity:100];
    CRTOBasketProduct* product3 = [[CRTOBasketProduct alloc] initWithProductId:@"나는 유리를 먹을 수 있어요. 그래도 아프지 않아요" price:0.1 quantity:-2500];

    CRTOBasketViewEvent* basketViewEvent = [[CRTOBasketViewEvent alloc] initWithBasketProducts:@[ product, product2, product3 ]];
    basketViewEvent.timestamp = timestamp;

    NSString* expected = @"{"
                          "  \"account\" : {"
                          "    \"app_name\" : \"com.criteo.sdktestapp\""
                          "  },"
                          "  \"events\" : ["
                          "    {"
                          "      \"event\" : \"viewBasket\","
                          "      \"product\" : ["
                          "        {"
                          "          \"id\" : null,"
                          "          \"price\" : 999.85,"
                          "          \"quantity\" : 1"
                          "        },"
                          "        {"
                          "          \"id\" : \"PRODUCT56789101\","
                          "          \"price\" : 10,"
                          "          \"quantity\" : 100"
                          "        },"
                          "        {"
                          "          \"id\" : \"나는 유리를 먹을 수 있어요. 그래도 아프지 않아요\","
                          "          \"price\" : 0.1,"
                          "          \"quantity\" : -2500"
                          "        }"
                          "      ],"
                          "      \"timestamp\" : \"2015-06-26T14:57:25Z\""
                          "    }"
                          "  ],"
                          "  \"id\" : {"
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\""
                          "  },"
                          "  \"device_info\" : {"
                          "    \"os_name\" : \"iPhone OS\","
                          "    \"device_model\" : \"iPhone3,2\","
                          "    \"device_manufacturer\" : \"apple\","
                          "    \"os_version\" : \"4.9.1\","
                          "    \"platform\" : \"ios\""
                          "  },"
                          "  \"app_info\" : {"
                          "    \"app_version\" : \"43.0.2357.61\","
                          "    \"app_name\" : \"Criteo Test App\","
                          "    \"sdk_version\" : \"1.0.0\","
                          "    \"app_language\" : \"en\","
                          "    \"app_id\" : \"com.criteo.sdktestapp\","
                          "    \"app_country\" : \"US\""
                          "  },"
                          "  \"version\" : \"sdk_1.0.0\","
                          "  \"alternate_ids\" : ["
                          "    {"
                          "      \"type\" : \"email\","
                          "      \"value\" : \"NotAReal Email\","
                          "      \"hash_method\" : \"none\""
                          "    }"
                          "  ]"
                          "}";

    id resultObj = nil;
    id expectedObj = nil;

    [self runSerializerForEvent:basketViewEvent
              withCustomerEmail:@"NotAReal Email"
              andExpectedResult:expected
             returningResultObj:&resultObj
                 andExpectedObj:&expectedObj];

    XCTAssertEqualObjects(resultObj, expectedObj);
}

- (void) testBasketViewEventSerializationWithNonProducts
{
    CRTOBasketViewEvent* basketViewEvent = [[CRTOBasketViewEvent alloc] initWithBasketProducts: @[ [NSNull null], @(5000), @"foo not a product" ] ];
    basketViewEvent.timestamp = timestamp;

    NSString* expected = @"{"
                          "  \"account\" : {"
                          "    \"app_name\" : \"com.criteo.sdktestapp\""
                          "  },"
                          "  \"events\" : ["
                          "    {"
                          "      \"event\" : \"viewBasket\","
                          "      \"product\" : [ ],"
                          "      \"timestamp\" : \"2015-06-26T14:57:25Z\""
                          "    }"
                          "  ],"
                          "  \"id\" : {"
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\""
                          "  },"
                          "  \"device_info\" : {"
                          "    \"os_name\" : \"iPhone OS\","
                          "    \"device_model\" : \"iPhone3,2\","
                          "    \"device_manufacturer\" : \"apple\","
                          "    \"os_version\" : \"4.9.1\","
                          "    \"platform\" : \"ios\""
                          "  },"
                          "  \"app_info\" : {"
                          "    \"app_version\" : \"43.0.2357.61\","
                          "    \"app_name\" : \"Criteo Test App\","
                          "    \"sdk_version\" : \"1.0.0\","
                          "    \"app_language\" : \"en\","
                          "    \"app_id\" : \"com.criteo.sdktestapp\","
                          "    \"app_country\" : \"US\""
                          "  },"
                          "  \"version\" : \"sdk_1.0.0\","
                          "  \"alternate_ids\" : ["
                          "    {"
                          "      \"type\" : \"email\","
                          "      \"value\" : \"NotAReal Email\","
                          "      \"hash_method\" : \"none\""
                          "    }"
                          "  ]"
                          "}";

    id resultObj = nil;
    id expectedObj = nil;

    [self runSerializerForEvent:basketViewEvent
              withCustomerEmail:@"NotAReal Email"
              andExpectedResult:expected
             returningResultObj:&resultObj
                 andExpectedObj:&expectedObj];

    XCTAssertEqualObjects(resultObj, expectedObj);
}

- (void) testDataEventSerialization
{
    CRTODataEvent* dataEvent = [[CRTODataEvent alloc] init];
    dataEvent.timestamp = timestamp;

    NSDate* extraDate = [NSDate dateWithTimeIntervalSince1970:1000000000];
    [dataEvent setDateExtraData:extraDate ForKey:@"my_date_extra_data"];

    float extraFloat = 0.1f;
    [dataEvent setFloatExtraData:extraFloat ForKey:@"FLOATDATA"];

    NSInteger extraInteger = -2000000000;
    [dataEvent setIntegerExtraData:extraInteger ForKey:@"The biggest number there is"];

    NSString* extraString = @"some Sample string";
    [dataEvent setStringExtraData:extraString ForKey:@"myStringData"];

    NSDate* extraDate2 = [NSDate dateWithTimeIntervalSince1970:1000000001];
    [dataEvent setDateExtraData:extraDate2 ForKey:@"my_date_extra_data2"];

    float extraFloat2 = 0.2f;
    [dataEvent setFloatExtraData:extraFloat2 ForKey:@"FLOATDATA2"];

    NSInteger extraInteger2 = 2000000000;
    [dataEvent setIntegerExtraData:extraInteger2 ForKey:@"The biggest number there is2"];

    NSString* extraString2 = @"some Sample string2";
    [dataEvent setStringExtraData:extraString2 ForKey:@"myStringData2"];

    NSString* expected = @"{"
                          "  \"account\" : {"
                          "    \"app_name\" : \"com.criteo.sdktestapp\""
                          "  },"
                          "  \"events\" : ["
                          "    {"
                          "      \"event\" : \"setData\","
                          "      \"my_date_extra_data\" : {"
                          "         \"value\" : \"2001-09-09T01:46:40Z\","
                          "         \"type\" : \"date\""
                          "      },"
                          "      \"FLOATDATA\" : {"
                          "         \"value\" : 0.1,"
                          "         \"type\" : \"float\""
                          "      },"
                          "      \"The biggest number there is\" : {"
                          "         \"value\" : -2000000000,"
                          "         \"type\" : \"integer\""
                          "      },"
                          "      \"myStringData\" : {"
                          "         \"value\" : \"some Sample string\","
                          "         \"type\" : \"text\""
                          "      },"
                          "      \"my_date_extra_data2\" : {"
                          "         \"value\" : \"2001-09-09T01:46:41Z\","
                          "         \"type\" : \"date\""
                          "      },"
                          "      \"FLOATDATA2\" : {"
                          "         \"value\" : 0.2,"
                          "         \"type\" : \"float\""
                          "      },"
                          "      \"The biggest number there is2\" : {"
                          "         \"value\" : 2000000000,"
                          "         \"type\" : \"integer\""
                          "      },"
                          "      \"myStringData2\" : {"
                          "         \"value\" : \"some Sample string2\","
                          "         \"type\" : \"text\""
                          "      },"
                          "      \"timestamp\" : \"2015-06-26T14:57:25Z\""
                          "    }"
                          "  ],"
                          "  \"id\" : {"
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\""
                          "  },"
                          "  \"device_info\" : {"
                          "    \"os_name\" : \"iPhone OS\","
                          "    \"device_model\" : \"iPhone3,2\","
                          "    \"device_manufacturer\" : \"apple\","
                          "    \"os_version\" : \"4.9.1\","
                          "    \"platform\" : \"ios\""
                          "  },"
                          "  \"app_info\" : {"
                          "    \"app_version\" : \"43.0.2357.61\","
                          "    \"app_name\" : \"Criteo Test App\","
                          "    \"sdk_version\" : \"1.0.0\","
                          "    \"app_language\" : \"en\","
                          "    \"app_id\" : \"com.criteo.sdktestapp\","
                          "    \"app_country\" : \"US\""
                          "  },"
                          "  \"version\" : \"sdk_1.0.0\","
                          "  \"alternate_ids\" : ["
                          "    {"
                          "      \"type\" : \"email\","
                          "      \"value\" : \"test@foobar.com\","
                          "      \"hash_method\" : \"none\""
                          "    }"
                          "  ]"
                          "}";

    id resultObj = nil;
    id expectedObj = nil;

    [self runSerializerForEvent:dataEvent
              withCustomerEmail:@"test@foobar.com"
              andExpectedResult:expected
             returningResultObj:&resultObj
                 andExpectedObj:&expectedObj];

    XCTAssertEqualObjects(resultObj, expectedObj);
}

- (void) testDeeplinkEventSerialization
{
    CRTODeeplinkEvent* deeplinkEvent = [[CRTODeeplinkEvent alloc] initWithDeeplinkLaunchUrl:@"foo bar"];
    deeplinkEvent.timestamp = timestamp;

    NSString* expected = @"{"
                          "  \"account\" : {"
                          "    \"app_name\" : \"com.criteo.sdktestapp\""
                          "  },"
                          "  \"events\" : ["
                          "    {"
                          "      \"event\" : \"appDeeplink\","
                          "      \"deeplink_uri\" : \"foo bar\","
                          "      \"timestamp\" : \"2015-06-26T14:57:25Z\""
                          "    }"
                          "  ],"
                          "  \"id\" : {"
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\""
                          "  },"
                          "  \"device_info\" : {"
                          "    \"os_name\" : \"iPhone OS\","
                          "    \"device_model\" : \"iPhone3,2\","
                          "    \"device_manufacturer\" : \"apple\","
                          "    \"os_version\" : \"4.9.1\","
                          "    \"platform\" : \"ios\""
                          "  },"
                          "  \"app_info\" : {"
                          "    \"app_version\" : \"43.0.2357.61\","
                          "    \"app_name\" : \"Criteo Test App\","
                          "    \"sdk_version\" : \"1.0.0\","
                          "    \"app_language\" : \"en\","
                          "    \"app_id\" : \"com.criteo.sdktestapp\","
                          "    \"app_country\" : \"US\""
                          "  },"
                          "  \"version\" : \"sdk_1.0.0\""
                          "}";

    id resultObj = nil;
    id expectedObj = nil;

    [self runSerializerForEvent:deeplinkEvent
              andExpectedResult:expected
             returningResultObj:&resultObj
                 andExpectedObj:&expectedObj];

    XCTAssertEqualObjects(resultObj, expectedObj);
}

- (void) testDeeplinkEventSerializationWithNilUrl
{
    CRTODeeplinkEvent* deeplinkEvent = [[CRTODeeplinkEvent alloc] initWithDeeplinkLaunchUrl:nil];
    deeplinkEvent.timestamp = timestamp;

    NSString* expected = @"{"
                          "  \"account\" : {"
                          "    \"app_name\" : \"com.criteo.sdktestapp\""
                          "  },"
                          "  \"events\" : ["
                          "    {"
                          "      \"event\" : \"appDeeplink\","
                          "      \"timestamp\" : \"2015-06-26T14:57:25Z\""
                          "    }"
                          "  ],"
                          "  \"id\" : {"
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\""
                          "  },"
                          "  \"device_info\" : {"
                          "    \"os_name\" : \"iPhone OS\","
                          "    \"device_model\" : \"iPhone3,2\","
                          "    \"device_manufacturer\" : \"apple\","
                          "    \"os_version\" : \"4.9.1\","
                          "    \"platform\" : \"ios\""
                          "  },"
                          "  \"app_info\" : {"
                          "    \"app_version\" : \"43.0.2357.61\","
                          "    \"app_name\" : \"Criteo Test App\","
                          "    \"sdk_version\" : \"1.0.0\","
                          "    \"app_language\" : \"en\","
                          "    \"app_id\" : \"com.criteo.sdktestapp\","
                          "    \"app_country\" : \"US\""
                          "  },"
                          "  \"version\" : \"sdk_1.0.0\""
                          "}";

    id resultObj = nil;
    id expectedObj = nil;

    [self runSerializerForEvent:deeplinkEvent
              andExpectedResult:expected
             returningResultObj:&resultObj
                 andExpectedObj:&expectedObj];

    XCTAssertEqualObjects(resultObj, expectedObj);
}

- (void) testHomeViewEventSerialization
{
    CRTOHomeViewEvent* homeEvent = [[CRTOHomeViewEvent alloc] init];
    homeEvent.timestamp = timestamp;

    NSString* expected = @"{"
                          "  \"account\" : {"
                          "    \"app_name\" : \"com.criteo.sdktestapp\""
                          "  },"
                          "  \"events\" : ["
                          "    {"
                          "      \"event\" : \"viewHome\","
                          "      \"timestamp\" : \"2015-06-26T14:57:25Z\""
                          "    }"
                          "  ],"
                          "  \"id\" : {"
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\""
                          "  },"
                          "  \"device_info\" : {"
                          "    \"os_name\" : \"iPhone OS\","
                          "    \"device_model\" : \"iPhone3,2\","
                          "    \"device_manufacturer\" : \"apple\","
                          "    \"os_version\" : \"4.9.1\","
                          "    \"platform\" : \"ios\""
                          "  },"
                          "  \"app_info\" : {"
                          "    \"app_version\" : \"43.0.2357.61\","
                          "    \"app_name\" : \"Criteo Test App\","
                          "    \"sdk_version\" : \"1.0.0\","
                          "    \"app_language\" : \"en\","
                          "    \"app_id\" : \"com.criteo.sdktestapp\","
                          "    \"app_country\" : \"US\""
                          "  },"
                          "  \"version\" : \"sdk_1.0.0\""
                          "}";

    id resultObj = nil;
    id expectedObj = nil;

    [self runSerializerForEvent:homeEvent
              andExpectedResult:expected
             returningResultObj:&resultObj
                 andExpectedObj:&expectedObj];

    XCTAssertEqualObjects(resultObj, expectedObj);
}

- (void) testProductViewEventSerialization
{
    CRTOProduct* product = [[CRTOProduct alloc] initWithProductId:@"PRODUCT11223344" price:999.85];

    CRTOProductViewEvent* productViewEvent = [[CRTOProductViewEvent alloc] initWithProduct:product];
    productViewEvent.timestamp = timestamp;

    NSString* expected = @"{"
                          "  \"account\" : {"
                          "    \"app_name\" : \"com.criteo.sdktestapp\""
                          "  },"
                          "  \"events\" : ["
                          "    {"
                          "      \"event\" : \"viewProduct\","
                          "      \"product\" : { \"id\" : \"PRODUCT11223344\", \"price\" : 999.85 },"
                          "      \"timestamp\" : \"2015-06-26T14:57:25Z\""
                          "    }"
                          "  ],"
                          "  \"id\" : {"
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\""
                          "  },"
                          "  \"device_info\" : {"
                          "    \"os_name\" : \"iPhone OS\","
                          "    \"device_model\" : \"iPhone3,2\","
                          "    \"device_manufacturer\" : \"apple\","
                          "    \"os_version\" : \"4.9.1\","
                          "    \"platform\" : \"ios\""
                          "  },"
                          "  \"app_info\" : {"
                          "    \"app_version\" : \"43.0.2357.61\","
                          "    \"app_name\" : \"Criteo Test App\","
                          "    \"sdk_version\" : \"1.0.0\","
                          "    \"app_language\" : \"en\","
                          "    \"app_id\" : \"com.criteo.sdktestapp\","
                          "    \"app_country\" : \"US\""
                          "  },"
                          "  \"version\" : \"sdk_1.0.0\","
                          "  \"alternate_ids\" : ["
                          "    {"
                          "      \"type\" : \"email\","
                          "      \"value\" : \"NotAReal Email\","
                          "      \"hash_method\" : \"none\""
                          "    }"
                          "  ]"
                          "}";

    id resultObj = nil;
    id expectedObj = nil;

    [self runSerializerForEvent:productViewEvent
              withCustomerEmail:@"NotAReal Email"
              andExpectedResult:expected
             returningResultObj:&resultObj
                 andExpectedObj:&expectedObj];

    XCTAssertEqualObjects(resultObj, expectedObj);
}

- (void) testProductViewEventSerializationWithNilProduct
{
    CRTOProductViewEvent* productViewEvent = [[CRTOProductViewEvent alloc] initWithProduct:nil];
    productViewEvent.timestamp = timestamp;

    NSString* expected = @"{"
                          "  \"account\" : {"
                          "    \"app_name\" : \"com.criteo.sdktestapp\""
                          "  },"
                          "  \"events\" : ["
                          "    {"
                          "      \"event\" : \"viewProduct\","
                          "      \"timestamp\" : \"2015-06-26T14:57:25Z\""
                          "    }"
                          "  ],"
                          "  \"id\" : {"
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\""
                          "  },"
                          "  \"device_info\" : {"
                          "    \"os_name\" : \"iPhone OS\","
                          "    \"device_model\" : \"iPhone3,2\","
                          "    \"device_manufacturer\" : \"apple\","
                          "    \"os_version\" : \"4.9.1\","
                          "    \"platform\" : \"ios\""
                          "  },"
                          "  \"app_info\" : {"
                          "    \"app_version\" : \"43.0.2357.61\","
                          "    \"app_name\" : \"Criteo Test App\","
                          "    \"sdk_version\" : \"1.0.0\","
                          "    \"app_language\" : \"en\","
                          "    \"app_id\" : \"com.criteo.sdktestapp\","
                          "    \"app_country\" : \"US\""
                          "  },"
                          "  \"version\" : \"sdk_1.0.0\","
                          "  \"alternate_ids\" : ["
                          "    {"
                          "      \"type\" : \"email\","
                          "      \"value\" : \"NotAReal Email\","
                          "      \"hash_method\" : \"none\""
                          "    }"
                          "  ]"
                          "}";

    id resultObj = nil;
    id expectedObj = nil;

    [self runSerializerForEvent:productViewEvent
              withCustomerEmail:@"NotAReal Email"
              andExpectedResult:expected
             returningResultObj:&resultObj
                 andExpectedObj:&expectedObj];

    XCTAssertEqualObjects(resultObj, expectedObj);
}

- (void) testProductViewEventSerializationWithNilProductId
{
    CRTOProduct* product = [[CRTOProduct alloc] initWithProductId:nil price:10];

    CRTOProductViewEvent* productViewEvent = [[CRTOProductViewEvent alloc] initWithProduct:product];
    productViewEvent.timestamp = timestamp;

    NSString* expected = @"{"
                          "  \"account\" : {"
                          "    \"app_name\" : \"com.criteo.sdktestapp\""
                          "  },"
                          "  \"events\" : ["
                          "    {"
                          "      \"event\" : \"viewProduct\","
                          "      \"product\" : { \"id\" : null, \"price\" : 10 },"
                          "      \"timestamp\" : \"2015-06-26T14:57:25Z\""
                          "    }"
                          "  ],"
                          "  \"id\" : {"
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\""
                          "  },"
                          "  \"device_info\" : {"
                          "    \"os_name\" : \"iPhone OS\","
                          "    \"device_model\" : \"iPhone3,2\","
                          "    \"device_manufacturer\" : \"apple\","
                          "    \"os_version\" : \"4.9.1\","
                          "    \"platform\" : \"ios\""
                          "  },"
                          "  \"app_info\" : {"
                          "    \"app_version\" : \"43.0.2357.61\","
                          "    \"app_name\" : \"Criteo Test App\","
                          "    \"sdk_version\" : \"1.0.0\","
                          "    \"app_language\" : \"en\","
                          "    \"app_id\" : \"com.criteo.sdktestapp\","
                          "    \"app_country\" : \"US\""
                          "  },"
                          "  \"version\" : \"sdk_1.0.0\","
                          "  \"alternate_ids\" : ["
                          "    {"
                          "      \"type\" : \"email\","
                          "      \"value\" : \"NotAReal Email\","
                          "      \"hash_method\" : \"none\""
                          "    }"
                          "  ]"
                          "}";

    id resultObj = nil;
    id expectedObj = nil;

    [self runSerializerForEvent:productViewEvent
              withCustomerEmail:@"NotAReal Email"
              andExpectedResult:expected
             returningResultObj:&resultObj
                 andExpectedObj:&expectedObj];

    XCTAssertEqualObjects(resultObj, expectedObj);
}

- (void) testProductListViewEventSerialization
{
    CRTOProduct* product  = [[CRTOProduct alloc] initWithProductId:@"PRODUCT11223344" price:999.85];
    CRTOProduct* product2 = [[CRTOProduct alloc] initWithProductId:@"PRODUCT56789101" price:10];
    CRTOProduct* product3 = [[CRTOProduct alloc] initWithProductId:@"나는 유리를 먹을 수 있어요. 그래도 아프지 않아요" price:0.1];

    CRTOProductListViewEvent* productViewEvent = [[CRTOProductListViewEvent alloc] initWithProducts:@[ product, product2, product3 ]];
    productViewEvent.timestamp = timestamp;

    NSString* expected = @"{"
                          "  \"account\" : {"
                          "    \"app_name\" : \"com.criteo.sdktestapp\""
                          "  },"
                          "  \"events\" : ["
                          "    {"
                          "      \"event\" : \"viewListing\","
                          "      \"product\" : ["
                          "        {"
                          "          \"id\" : \"PRODUCT11223344\","
                          "          \"price\" : 999.85"
                          "        },"
                          "        {"
                          "          \"id\" : \"PRODUCT56789101\","
                          "          \"price\" : 10"
                          "        },"
                          "        {"
                          "          \"id\" : \"나는 유리를 먹을 수 있어요. 그래도 아프지 않아요\","
                          "          \"price\" : 0.1"
                          "        }"
                          "      ],"
                          "      \"timestamp\" : \"2015-06-26T14:57:25Z\""
                          "    }"
                          "  ],"
                          "  \"id\" : {"
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\""
                          "  },"
                          "  \"device_info\" : {"
                          "    \"os_name\" : \"iPhone OS\","
                          "    \"device_model\" : \"iPhone3,2\","
                          "    \"device_manufacturer\" : \"apple\","
                          "    \"os_version\" : \"4.9.1\","
                          "    \"platform\" : \"ios\""
                          "  },"
                          "  \"app_info\" : {"
                          "    \"app_version\" : \"43.0.2357.61\","
                          "    \"app_name\" : \"Criteo Test App\","
                          "    \"sdk_version\" : \"1.0.0\","
                          "    \"app_language\" : \"en\","
                          "    \"app_id\" : \"com.criteo.sdktestapp\","
                          "    \"app_country\" : \"US\""
                          "  },"
                          "  \"version\" : \"sdk_1.0.0\","
                          "  \"alternate_ids\" : ["
                          "    {"
                          "      \"type\" : \"email\","
                          "      \"value\" : \"NotAReal Email\","
                          "      \"hash_method\" : \"none\""
                          "    }"
                          "  ]"
                          "}";

    id resultObj = nil;
    id expectedObj = nil;

    [self runSerializerForEvent:productViewEvent
              withCustomerEmail:@"NotAReal Email"
              andExpectedResult:expected
             returningResultObj:&resultObj
                 andExpectedObj:&expectedObj];

    XCTAssertEqualObjects(resultObj, expectedObj);
}

- (void) testProductListViewEventSerializationWithNilProducts
{
    CRTOProductListViewEvent* productViewEvent = [[CRTOProductListViewEvent alloc] initWithProducts:nil];
    productViewEvent.timestamp = timestamp;

    NSString* expected = @"{"
                          "  \"account\" : {"
                          "    \"app_name\" : \"com.criteo.sdktestapp\""
                          "  },"
                          "  \"events\" : ["
                          "    {"
                          "      \"event\" : \"viewListing\","
                          "      \"product\" : [ ],"
                          "      \"timestamp\" : \"2015-06-26T14:57:25Z\""
                          "    }"
                          "  ],"
                          "  \"id\" : {"
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\""
                          "  },"
                          "  \"device_info\" : {"
                          "    \"os_name\" : \"iPhone OS\","
                          "    \"device_model\" : \"iPhone3,2\","
                          "    \"device_manufacturer\" : \"apple\","
                          "    \"os_version\" : \"4.9.1\","
                          "    \"platform\" : \"ios\""
                          "  },"
                          "  \"app_info\" : {"
                          "    \"app_version\" : \"43.0.2357.61\","
                          "    \"app_name\" : \"Criteo Test App\","
                          "    \"sdk_version\" : \"1.0.0\","
                          "    \"app_language\" : \"en\","
                          "    \"app_id\" : \"com.criteo.sdktestapp\","
                          "    \"app_country\" : \"US\""
                          "  },"
                          "  \"version\" : \"sdk_1.0.0\","
                          "  \"alternate_ids\" : ["
                          "    {"
                          "      \"type\" : \"email\","
                          "      \"value\" : \"NotAReal Email\","
                          "      \"hash_method\" : \"none\""
                          "    }"
                          "  ]"
                          "}";

    id resultObj = nil;
    id expectedObj = nil;

    [self runSerializerForEvent:productViewEvent
              withCustomerEmail:@"NotAReal Email"
              andExpectedResult:expected
             returningResultObj:&resultObj
                 andExpectedObj:&expectedObj];

    XCTAssertEqualObjects(resultObj, expectedObj);
}

- (void) testProductListViewEventSerializationWithNilProductId
{
    CRTOProduct* product  = [[CRTOProduct alloc] initWithProductId:@"PRODUCT11223344" price:999.85];
    CRTOProduct* product2 = [[CRTOProduct alloc] initWithProductId:nil price:10];
    CRTOProduct* product3 = [[CRTOProduct alloc] initWithProductId:@"나는 유리를 먹을 수 있어요. 그래도 아프지 않아요" price:0.1];

    CRTOProductListViewEvent* productViewEvent = [[CRTOProductListViewEvent alloc] initWithProducts:@[ product, product2, product3 ]];
    productViewEvent.timestamp = timestamp;

    NSString* expected = @"{"
                          "  \"account\" : {"
                          "    \"app_name\" : \"com.criteo.sdktestapp\""
                          "  },"
                          "  \"events\" : ["
                          "    {"
                          "      \"event\" : \"viewListing\","
                          "      \"product\" : ["
                          "        {"
                          "          \"id\" : \"PRODUCT11223344\","
                          "          \"price\" : 999.85"
                          "        },"
                          "        {"
                          "          \"id\" : null,"
                          "          \"price\" : 10"
                          "        },"
                          "        {"
                          "          \"id\" : \"나는 유리를 먹을 수 있어요. 그래도 아프지 않아요\","
                          "          \"price\" : 0.1"
                          "        }"
                          "      ],"
                          "      \"timestamp\" : \"2015-06-26T14:57:25Z\""
                          "    }"
                          "  ],"
                          "  \"id\" : {"
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\""
                          "  },"
                          "  \"device_info\" : {"
                          "    \"os_name\" : \"iPhone OS\","
                          "    \"device_model\" : \"iPhone3,2\","
                          "    \"device_manufacturer\" : \"apple\","
                          "    \"os_version\" : \"4.9.1\","
                          "    \"platform\" : \"ios\""
                          "  },"
                          "  \"app_info\" : {"
                          "    \"app_version\" : \"43.0.2357.61\","
                          "    \"app_name\" : \"Criteo Test App\","
                          "    \"sdk_version\" : \"1.0.0\","
                          "    \"app_language\" : \"en\","
                          "    \"app_id\" : \"com.criteo.sdktestapp\","
                          "    \"app_country\" : \"US\""
                          "  },"
                          "  \"version\" : \"sdk_1.0.0\","
                          "  \"alternate_ids\" : ["
                          "    {"
                          "      \"type\" : \"email\","
                          "      \"value\" : \"NotAReal Email\","
                          "      \"hash_method\" : \"none\""
                          "    }"
                          "  ]"
                          "}";

    id resultObj = nil;
    id expectedObj = nil;

    [self runSerializerForEvent:productViewEvent
              withCustomerEmail:@"NotAReal Email"
              andExpectedResult:expected
             returningResultObj:&resultObj
                 andExpectedObj:&expectedObj];

    XCTAssertEqualObjects(resultObj, expectedObj);
}

- (void) testProductListViewEventSerializationWithNonProducts
{
    CRTOProductListViewEvent* productViewEvent = [[CRTOProductListViewEvent alloc] initWithProducts: @[ @(100), @"Not actually a product" ] ];
    productViewEvent.timestamp = timestamp;

    NSString* expected = @"{"
                          "  \"account\" : {"
                          "    \"app_name\" : \"com.criteo.sdktestapp\""
                          "  },"
                          "  \"events\" : ["
                          "    {"
                          "      \"event\" : \"viewListing\","
                          "      \"product\" : [ ],"
                          "      \"timestamp\" : \"2015-06-26T14:57:25Z\""
                          "    }"
                          "  ],"
                          "  \"id\" : {"
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\""
                          "  },"
                          "  \"device_info\" : {"
                          "    \"os_name\" : \"iPhone OS\","
                          "    \"device_model\" : \"iPhone3,2\","
                          "    \"device_manufacturer\" : \"apple\","
                          "    \"os_version\" : \"4.9.1\","
                          "    \"platform\" : \"ios\""
                          "  },"
                          "  \"app_info\" : {"
                          "    \"app_version\" : \"43.0.2357.61\","
                          "    \"app_name\" : \"Criteo Test App\","
                          "    \"sdk_version\" : \"1.0.0\","
                          "    \"app_language\" : \"en\","
                          "    \"app_id\" : \"com.criteo.sdktestapp\","
                          "    \"app_country\" : \"US\""
                          "  },"
                          "  \"version\" : \"sdk_1.0.0\","
                          "  \"alternate_ids\" : ["
                          "    {"
                          "      \"type\" : \"email\","
                          "      \"value\" : \"NotAReal Email\","
                          "      \"hash_method\" : \"none\""
                          "    }"
                          "  ]"
                          "}";

    id resultObj = nil;
    id expectedObj = nil;

    [self runSerializerForEvent:productViewEvent
              withCustomerEmail:@"NotAReal Email"
              andExpectedResult:expected
             returningResultObj:&resultObj
                 andExpectedObj:&expectedObj];

    XCTAssertEqualObjects(resultObj, expectedObj);
}

- (void) testTransactionConfirmationEventSerialization
{
    CRTOBasketProduct* product  = [[CRTOBasketProduct alloc] initWithProductId:@"PRODUCT11223344" price:999.85 quantity:1];
    CRTOBasketProduct* product2 = [[CRTOBasketProduct alloc] initWithProductId:@"PRODUCT56789101" price:10 quantity:100];
    CRTOBasketProduct* product3 = [[CRTOBasketProduct alloc] initWithProductId:@"나는 유리를 먹을 수 있어요. 그래도 아프지 않아요" price:0.1 quantity:-2500];

    CRTOTransactionConfirmationEvent* confirmEvent = [[CRTOTransactionConfirmationEvent alloc] initWithBasketProducts:@[ product, product2, product3 ]];
    confirmEvent.currency = @"USD";
    confirmEvent.transactionId = @"8c085e9a-ae34-424b-bcfb-a702084ee2c3";
    confirmEvent.timestamp = timestamp;

    NSString* expected = @"{"
                          "  \"account\" : {"
                          "    \"app_name\" : \"com.criteo.sdktestapp\""
                          "  },"
                          "  \"events\" : ["
                          "    {"
                          "      \"event\" : \"trackTransaction\","
                          "      \"currency\" : \"USD\","
                          "      \"id\" : \"8c085e9a-ae34-424b-bcfb-a702084ee2c3\","
                          "      \"product\" : ["
                          "        {"
                          "          \"id\" : \"PRODUCT11223344\","
                          "          \"price\" : 999.85,"
                          "          \"quantity\" : 1"
                          "        },"
                          "        {"
                          "          \"id\" : \"PRODUCT56789101\","
                          "          \"price\" : 10,"
                          "          \"quantity\" : 100"
                          "        },"
                          "        {"
                          "          \"id\" : \"나는 유리를 먹을 수 있어요. 그래도 아프지 않아요\","
                          "          \"price\" : 0.1,"
                          "          \"quantity\" : -2500"
                          "        }"
                          "      ],"
                          "      \"timestamp\" : \"2015-06-26T14:57:25Z\""
                          "    }"
                          "  ],"
                          "  \"id\" : {"
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\""
                          "  },"
                          "  \"device_info\" : {"
                          "    \"os_name\" : \"iPhone OS\","
                          "    \"device_model\" : \"iPhone3,2\","
                          "    \"device_manufacturer\" : \"apple\","
                          "    \"os_version\" : \"4.9.1\","
                          "    \"platform\" : \"ios\""
                          "  },"
                          "  \"app_info\" : {"
                          "    \"app_version\" : \"43.0.2357.61\","
                          "    \"app_name\" : \"Criteo Test App\","
                          "    \"sdk_version\" : \"1.0.0\","
                          "    \"app_language\" : \"en\","
                          "    \"app_id\" : \"com.criteo.sdktestapp\","
                          "    \"app_country\" : \"US\""
                          "  },"
                          "  \"version\" : \"sdk_1.0.0\","
                          "  \"alternate_ids\" : ["
                          "    {"
                          "      \"type\" : \"email\","
                          "      \"value\" : \"NotAReal Email\","
                          "      \"hash_method\" : \"none\""
                          "    }"
                          "  ]"
                          "}";

    id resultObj = nil;
    id expectedObj = nil;

    [self runSerializerForEvent:confirmEvent
              withCustomerEmail:@"NotAReal Email"
              andExpectedResult:expected
             returningResultObj:&resultObj
                 andExpectedObj:&expectedObj];

    XCTAssertEqualObjects(resultObj, expectedObj);
}

- (void) testTransactionConfirmationEventSerializationWithNilProducts
{
    CRTOTransactionConfirmationEvent* confirmEvent = [[CRTOTransactionConfirmationEvent alloc] initWithBasketProducts:nil];
    confirmEvent.currency = @"USD";
    confirmEvent.transactionId = @"8c085e9a-ae34-424b-bcfb-a702084ee2c3";
    confirmEvent.timestamp = timestamp;

    NSString* expected = @"{"
                          "  \"account\" : {"
                          "    \"app_name\" : \"com.criteo.sdktestapp\""
                          "  },"
                          "  \"events\" : ["
                          "    {"
                          "      \"event\" : \"trackTransaction\","
                          "      \"currency\" : \"USD\","
                          "      \"id\" : \"8c085e9a-ae34-424b-bcfb-a702084ee2c3\","
                          "      \"product\" : [ ],"
                          "      \"timestamp\" : \"2015-06-26T14:57:25Z\""
                          "    }"
                          "  ],"
                          "  \"id\" : {"
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\""
                          "  },"
                          "  \"device_info\" : {"
                          "    \"os_name\" : \"iPhone OS\","
                          "    \"device_model\" : \"iPhone3,2\","
                          "    \"device_manufacturer\" : \"apple\","
                          "    \"os_version\" : \"4.9.1\","
                          "    \"platform\" : \"ios\""
                          "  },"
                          "  \"app_info\" : {"
                          "    \"app_version\" : \"43.0.2357.61\","
                          "    \"app_name\" : \"Criteo Test App\","
                          "    \"sdk_version\" : \"1.0.0\","
                          "    \"app_language\" : \"en\","
                          "    \"app_id\" : \"com.criteo.sdktestapp\","
                          "    \"app_country\" : \"US\""
                          "  },"
                          "  \"version\" : \"sdk_1.0.0\","
                          "  \"alternate_ids\" : ["
                          "    {"
                          "      \"type\" : \"email\","
                          "      \"value\" : \"NotAReal Email\","
                          "      \"hash_method\" : \"none\""
                          "    }"
                          "  ]"
                          "}";

    id resultObj = nil;
    id expectedObj = nil;

    [self runSerializerForEvent:confirmEvent
              withCustomerEmail:@"NotAReal Email"
              andExpectedResult:expected
             returningResultObj:&resultObj
                 andExpectedObj:&expectedObj];

    XCTAssertEqualObjects(resultObj, expectedObj);
}

- (void) testTransactionConfirmationEventSerializationWithNilProductId
{
    CRTOBasketProduct* product  = [[CRTOBasketProduct alloc] initWithProductId:@"PRODUCT11223344" price:999.85 quantity:1];
    CRTOBasketProduct* product2 = [[CRTOBasketProduct alloc] initWithProductId:@"PRODUCT56789101" price:10 quantity:100];
    CRTOBasketProduct* product3 = [[CRTOBasketProduct alloc] initWithProductId:nil price:0.1 quantity:-2500];

    CRTOTransactionConfirmationEvent* confirmEvent = [[CRTOTransactionConfirmationEvent alloc] initWithBasketProducts:@[ product, product2, product3 ]];
    confirmEvent.currency = @"USD";
    confirmEvent.transactionId = @"8c085e9a-ae34-424b-bcfb-a702084ee2c3";
    confirmEvent.timestamp = timestamp;

    NSString* expected = @"{"
                          "  \"account\" : {"
                          "    \"app_name\" : \"com.criteo.sdktestapp\""
                          "  },"
                          "  \"events\" : ["
                          "    {"
                          "      \"event\" : \"trackTransaction\","
                          "      \"currency\" : \"USD\","
                          "      \"id\" : \"8c085e9a-ae34-424b-bcfb-a702084ee2c3\","
                          "      \"product\" : ["
                          "        {"
                          "          \"id\" : \"PRODUCT11223344\","
                          "          \"price\" : 999.85,"
                          "          \"quantity\" : 1"
                          "        },"
                          "        {"
                          "          \"id\" : \"PRODUCT56789101\","
                          "          \"price\" : 10,"
                          "          \"quantity\" : 100"
                          "        },"
                          "        {"
                          "          \"id\" : null,"
                          "          \"price\" : 0.1,"
                          "          \"quantity\" : -2500"
                          "        }"
                          "      ],"
                          "      \"timestamp\" : \"2015-06-26T14:57:25Z\""
                          "    }"
                          "  ],"
                          "  \"id\" : {"
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\""
                          "  },"
                          "  \"device_info\" : {"
                          "    \"os_name\" : \"iPhone OS\","
                          "    \"device_model\" : \"iPhone3,2\","
                          "    \"device_manufacturer\" : \"apple\","
                          "    \"os_version\" : \"4.9.1\","
                          "    \"platform\" : \"ios\""
                          "  },"
                          "  \"app_info\" : {"
                          "    \"app_version\" : \"43.0.2357.61\","
                          "    \"app_name\" : \"Criteo Test App\","
                          "    \"sdk_version\" : \"1.0.0\","
                          "    \"app_language\" : \"en\","
                          "    \"app_id\" : \"com.criteo.sdktestapp\","
                          "    \"app_country\" : \"US\""
                          "  },"
                          "  \"version\" : \"sdk_1.0.0\","
                          "  \"alternate_ids\" : ["
                          "    {"
                          "      \"type\" : \"email\","
                          "      \"value\" : \"NotAReal Email\","
                          "      \"hash_method\" : \"none\""
                          "    }"
                          "  ]"
                          "}";

    id resultObj = nil;
    id expectedObj = nil;

    [self runSerializerForEvent:confirmEvent
              withCustomerEmail:@"NotAReal Email"
              andExpectedResult:expected
             returningResultObj:&resultObj
                 andExpectedObj:&expectedObj];

    XCTAssertEqualObjects(resultObj, expectedObj);
}

- (void) testTransactionConfirmationEventSerializationWithNonProducts
{
    CRTOTransactionConfirmationEvent* confirmEvent = [[CRTOTransactionConfirmationEvent alloc] initWithBasketProducts: @[ @(1000), [NSNull null], @"fooNotAProduct" ] ];
    confirmEvent.currency = @"USD";
    confirmEvent.transactionId = @"8c085e9a-ae34-424b-bcfb-a702084ee2c3";
    confirmEvent.timestamp = timestamp;

    NSString* expected = @"{"
                          "  \"account\" : {"
                          "    \"app_name\" : \"com.criteo.sdktestapp\""
                          "  },"
                          "  \"events\" : ["
                          "    {"
                          "      \"event\" : \"trackTransaction\","
                          "      \"currency\" : \"USD\","
                          "      \"id\" : \"8c085e9a-ae34-424b-bcfb-a702084ee2c3\","
                          "      \"product\" : [ ],"
                          "      \"timestamp\" : \"2015-06-26T14:57:25Z\""
                          "    }"
                          "  ],"
                          "  \"id\" : {"
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\""
                          "  },"
                          "  \"device_info\" : {"
                          "    \"os_name\" : \"iPhone OS\","
                          "    \"device_model\" : \"iPhone3,2\","
                          "    \"device_manufacturer\" : \"apple\","
                          "    \"os_version\" : \"4.9.1\","
                          "    \"platform\" : \"ios\""
                          "  },"
                          "  \"app_info\" : {"
                          "    \"app_version\" : \"43.0.2357.61\","
                          "    \"app_name\" : \"Criteo Test App\","
                          "    \"sdk_version\" : \"1.0.0\","
                          "    \"app_language\" : \"en\","
                          "    \"app_id\" : \"com.criteo.sdktestapp\","
                          "    \"app_country\" : \"US\""
                          "  },"
                          "  \"version\" : \"sdk_1.0.0\","
                          "  \"alternate_ids\" : ["
                          "    {"
                          "      \"type\" : \"email\","
                          "      \"value\" : \"NotAReal Email\","
                          "      \"hash_method\" : \"none\""
                          "    }"
                          "  ]"
                          "}";

    id resultObj = nil;
    id expectedObj = nil;

    [self runSerializerForEvent:confirmEvent
              withCustomerEmail:@"NotAReal Email"
              andExpectedResult:expected
             returningResultObj:&resultObj
                 andExpectedObj:&expectedObj];

    XCTAssertEqualObjects(resultObj, expectedObj);
}

- (void) testDeeplinkEventSerializationPerf
{
    CRTOJSONEventSerializer* serializer = [[CRTOJSONEventSerializer alloc] initWithAppInfo:mockAppInfo
                                                                                deviceInfo:mockDeviceInfo
                                                                                   sdkInfo:mockSDKInfo];

    CRTODeeplinkEvent* deeplinkEvent = [[CRTODeeplinkEvent alloc] initWithDeeplinkLaunchUrl:@"foo bar"];
    deeplinkEvent.timestamp = timestamp;

    [self measureBlock:^{
        NSString* result = [serializer serializeEventToJSONString:deeplinkEvent];
        result = nil;
    }];
}

@end
