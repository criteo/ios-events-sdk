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
#import "CRTODeepLinkEvent.h"
#import "CRTODeviceInfo.h"
#import "CRTOEvent.h"
#import "CRTOEvent+Internal.h"
#import "CRTOJSONEventSerializer.h"
#import "CRTOSDKInfo.h"

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

- (void) testAlternateIdIsSerialized
{
    CRTOJSONEventSerializer* serializer = [[CRTOJSONEventSerializer alloc] initWithAppInfo:mockAppInfo
                                                                                deviceInfo:mockDeviceInfo
                                                                                   sdkInfo:mockSDKInfo];

    serializer.customerEmail = @"NotAReal Email";

    CRTODeeplinkEvent* deeplinkEvent = [[CRTODeeplinkEvent alloc] initWithDeeplinkLaunchUrl:@"foo bar"];
    deeplinkEvent.timestamp = timestamp;

    NSString* result = [serializer serializeEventToJSONString:deeplinkEvent];

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

    NSData* resultData   = [NSData dataWithBytes:result.UTF8String length:result.length];
    NSData* expectedData = [NSData dataWithBytes:expected.UTF8String length:expected.length];

    id resultObj = [NSJSONSerialization JSONObjectWithData:resultData options:0 error:nil];
    id expectedObj = [NSJSONSerialization JSONObjectWithData:expectedData options:0 error:nil];

    XCTAssertEqualObjects(resultObj, expectedObj);
}

- (void) testAlternateIdMissingIsNotSerialized
{
    CRTOJSONEventSerializer* serializer = [[CRTOJSONEventSerializer alloc] initWithAppInfo:mockAppInfo
                                                                                deviceInfo:mockDeviceInfo
                                                                                   sdkInfo:mockSDKInfo];

    CRTODeeplinkEvent* deeplinkEvent = [[CRTODeeplinkEvent alloc] initWithDeeplinkLaunchUrl:@"foo bar"];
    deeplinkEvent.timestamp = timestamp;

    NSString* result = [serializer serializeEventToJSONString:deeplinkEvent];

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

    NSData* resultData   = [NSData dataWithBytes:result.UTF8String length:result.length];
    NSData* expectedData = [NSData dataWithBytes:expected.UTF8String length:expected.length];

    id resultObj = [NSJSONSerialization JSONObjectWithData:resultData options:0 error:nil];
    id expectedObj = [NSJSONSerialization JSONObjectWithData:expectedData options:0 error:nil];

    XCTAssertEqualObjects(resultObj, expectedObj);
}

- (void) testDeeplinkEventSerialization
{
    CRTOJSONEventSerializer* serializer = [[CRTOJSONEventSerializer alloc] initWithAppInfo:mockAppInfo
                                                                                deviceInfo:mockDeviceInfo
                                                                                   sdkInfo:mockSDKInfo];

    CRTODeeplinkEvent* deeplinkEvent = [[CRTODeeplinkEvent alloc] initWithDeeplinkLaunchUrl:@"foo bar"];
    deeplinkEvent.timestamp = timestamp;

    NSString* result = [serializer serializeEventToJSONString:deeplinkEvent];

    NSString* expected =
@"{ \
  \"app_info\" : { \
    \"app_version\" : \"43.0.2357.61\", \
    \"app_name\" : \"Criteo Test App\", \
    \"sdk_version\" : \"1.0.0\", \
    \"app_language\" : \"en\", \
    \"app_id\" : \"com.criteo.sdktestapp\", \
    \"app_country\" : \"US\" \
  }, \
  \"account\" : { \
    \"app_name\" : \"com.criteo.sdktestapp\" \
  }, \
  \"id\" : { \
    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\" \
  }, \
  \"version\" : \"sdk_1.0.0\", \
  \"device_info\" : { \
    \"os_name\" : \"iPhone OS\", \
    \"device_model\" : \"iPhone3,2\", \
    \"device_manufacturer\" : \"apple\", \
    \"os_version\" : \"4.9.1\", \
    \"platform\" : \"ios\" \
  }, \
  \"events\" : [ \
    { \
      \"event\" : \"appDeeplink\", \
      \"deeplink_uri\" : \"foo bar\", \
      \"timestamp\" : \"2015-06-26T14:57:25Z\" \
    } \
  ] \
}";

    NSData* resultData   = [NSData dataWithBytes:result.UTF8String length:result.length];
    NSData* expectedData = [NSData dataWithBytes:expected.UTF8String length:expected.length];

    id resultObj = [NSJSONSerialization JSONObjectWithData:resultData options:0 error:nil];
    id expectedObj = [NSJSONSerialization JSONObjectWithData:expectedData options:0 error:nil];

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
