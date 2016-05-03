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

    NSDateComponents* extraDate;
    NSDateComponents* extraDate2;
    NSDateComponents* extraDate3;
    NSDate* timestamp;
}

- (void)setUp
{
    [super setUp];

    // CRTOAppInfo Mock
    mockAppInfo = [self mockAppInfoWithAppCountry:@"US"
                                            appId:@"com.criteo.sdktestapp"
                                      appLanguage:@"en"
                                          appName:@"Criteo Test App"
                                       appVersion:@"43.0.2357.61"];

    // CRTODeviceInfo Mock
    mockDeviceInfo = [self mockDeviceInfoWithDeviceId:@"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6"
                                   deviceManufacturer:@"apple"
                                          deviceModel:@"iPhone3,2"
                           advertisingTrackingEnabled:YES
                                               osName:@"iPhone OS"
                                            osVersion:@"4.9.1" platform:@"ios"];
    // CRTOSDKInfo Mock
    mockSDKInfo = OCMClassMock([CRTOSDKInfo class]);

    OCMStub([mockSDKInfo sdkVersion]).
    andReturn(@"1.0.0");

    // A test extradata timestamp
    extraDate = [NSDateComponents new];

    extraDate.year   = 2001;
    extraDate.month  = 9;
    extraDate.day    = 9;
    extraDate.hour   = 1;
    extraDate.minute = 46;
    extraDate.second = 40;

    // A second test extradata timestamp
    extraDate2 = [NSDateComponents new];

    extraDate2.year   = 2001;
    extraDate2.month  = 9;
    extraDate2.day    = 9;
    extraDate2.hour   = 1;
    extraDate2.minute = 46;
    extraDate2.second = 41;

    // A third test extradata timestamp
    extraDate3 = [NSDateComponents new];

    extraDate3.year   = 2001;
    extraDate3.month  = 10;
    extraDate3.day    = 1;
    extraDate3.hour   = 12;
    extraDate3.minute = 13;
    extraDate3.second = 14;

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

- (CRTOAppInfo*) mockAppInfoWithAppCountry:(NSString*)appCountry
                                     appId:(NSString*)appId
                               appLanguage:(NSString*)appLanguage
                                   appName:(NSString*)appName
                                appVersion:(NSString*)appVersion
{
    CRTOAppInfo* appInfo = OCMClassMock([CRTOAppInfo class]);

    OCMStub([appInfo appCountry]).
    andReturn(appCountry);

    OCMStub([appInfo appId]).
    andReturn(appId);

    OCMStub([appInfo appLanguage]).
    andReturn(appLanguage);

    OCMStub([appInfo appName]).
    andReturn(appName);

    OCMStub([appInfo appVersion]).
    andReturn(appVersion);

    return appInfo;
}

- (CRTODeviceInfo*) mockDeviceInfoWithDeviceId:(NSString*)deviceId
                            deviceManufacturer:(NSString*)manufacturer
                                   deviceModel:(NSString*)model
                         advertisingTrackingEnabled:(BOOL)advertisingTrackingEnabled
                                        osName:(NSString*)osName
                                     osVersion:(NSString*)osVersion
                                      platform:(NSString*)platform
{
    CRTODeviceInfo* deviceInfo = OCMClassMock([CRTODeviceInfo class]);
    OCMStub([deviceInfo deviceIdentifier]).
    andReturn(deviceId);

    OCMStub([deviceInfo deviceManufacturer]).
    andReturn(manufacturer);

    OCMStub([deviceInfo deviceModel]).
    andReturn(model);

    OCMStub([deviceInfo advertisingTrackingEnabled]).
    andReturn(advertisingTrackingEnabled);

    OCMStub([deviceInfo osName]).
    andReturn(osName);

    OCMStub([deviceInfo osVersion]).
    andReturn(osVersion);

    OCMStub([deviceInfo platform]).
    andReturn(platform);

    return deviceInfo;
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
                        appInfo:mockAppInfo
                     deviceInfo:mockDeviceInfo
                        sdkInfo:mockSDKInfo
              withCustomerEmail:nil
                    accountName:nil
                        country:nil
                       language:nil
              andExpectedResult:expected
             returningResultObj:resultObj
                 andExpectedObj:expectedObj];
}

- (void) runSerializerForEvent:(CRTOEvent*)event
                       appInfo:(CRTOAppInfo*)appInfo
                    deviceInfo:(CRTODeviceInfo*)deviceInfo
                       sdkInfo:(CRTOSDKInfo*)sdkInfo
             andExpectedResult:(NSString*)expected
            returningResultObj:(id*)resultObj
                andExpectedObj:(id*)expectedObj
{
    [self runSerializerForEvent:event
                        appInfo:appInfo
                     deviceInfo:deviceInfo
                        sdkInfo:sdkInfo
              withCustomerEmail:nil
                    accountName:nil
                        country:nil
                       language:nil
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
    [self runSerializerForEvent:event
                        appInfo:mockAppInfo
                     deviceInfo:mockDeviceInfo
                        sdkInfo:mockSDKInfo
              withCustomerEmail:email
                    accountName:nil
                        country:nil
                       language:nil
              andExpectedResult:expected
             returningResultObj:resultObj
                 andExpectedObj:expectedObj];
}

- (void) runSerializerForEvent:(CRTOEvent*)event
                       appInfo:(CRTOAppInfo*)appInfo
                    deviceInfo:(CRTODeviceInfo*)deviceInfo
                       sdkInfo:(CRTOSDKInfo*)sdkInfo
             withCustomerEmail:(NSString*)email
                   accountName:(NSString*)accountName
                       country:(NSString*)country
                      language:(NSString*)language
             andExpectedResult:(NSString*)expected
            returningResultObj:(id*)resultObj
                andExpectedObj:(id*)expectedObj
{
    CRTOJSONEventSerializer* serializer = [[CRTOJSONEventSerializer alloc] initWithAppInfo:appInfo
                                                                                deviceInfo:deviceInfo
                                                                                   sdkInfo:sdkInfo];

    serializer.customerEmail = email;
    serializer.accountName   = accountName;
    serializer.countryCode   = country;
    serializer.languageCode  = language;

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

- (void) testAccountCountrySerialization
{
    CRTOAppLaunchEvent* appLaunch = [[CRTOAppLaunchEvent alloc] init];
    appLaunch.timestamp = timestamp;

    NSString* expected = @"{"
                          "  \"account\" : {"
                          "    \"app_name\" : \"com.criteo.sdktestapp\","
                          "    \"country_code\" : \"US\""
                          "  },"
                          "  \"events\" : ["
                          "    {"
                          "      \"event\" : \"appLaunch\","
                          "      \"timestamp\" : \"2015-06-26T14:57:25Z\""
                          "    }"
                          "  ],"
                          "  \"id\" : {"
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\","
                          "    \"limit_ad_tracking\" : false"
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
                        appInfo:mockAppInfo
                     deviceInfo:mockDeviceInfo
                        sdkInfo:mockSDKInfo
              withCustomerEmail:nil
                    accountName:nil
                        country:@"US"
                       language:nil
              andExpectedResult:expected
             returningResultObj:&resultObj
                 andExpectedObj:&expectedObj];

    XCTAssertEqualObjects(resultObj, expectedObj);
}

- (void) testAccountLanguageSerialization
{
    CRTOAppLaunchEvent* appLaunch = [[CRTOAppLaunchEvent alloc] init];
    appLaunch.timestamp = timestamp;

    NSString* expected = @"{"
                          "  \"account\" : {"
                          "    \"app_name\" : \"com.criteo.sdktestapp\","
                          "    \"language_code\" : \"en\""
                          "  },"
                          "  \"events\" : ["
                          "    {"
                          "      \"event\" : \"appLaunch\","
                          "      \"timestamp\" : \"2015-06-26T14:57:25Z\""
                          "    }"
                          "  ],"
                          "  \"id\" : {"
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\","
                          "    \"limit_ad_tracking\" : false"
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
                        appInfo:mockAppInfo
                     deviceInfo:mockDeviceInfo
                        sdkInfo:mockSDKInfo
              withCustomerEmail:nil
                    accountName:nil
                        country:nil
                       language:@"en"
              andExpectedResult:expected
             returningResultObj:&resultObj
                 andExpectedObj:&expectedObj];

    XCTAssertEqualObjects(resultObj, expectedObj);
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
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\","
                          "    \"limit_ad_tracking\" : false"
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
                          "      \"hash_method\" : \"md5\""
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
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\","
                          "    \"limit_ad_tracking\" : false"
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
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\","
                          "    \"limit_ad_tracking\" : false"
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

- (void) testAppLaunchEventSerializationWithCustomAccountName
{
    CRTOAppLaunchEvent* appLaunch = [[CRTOAppLaunchEvent alloc] init];
    appLaunch.timestamp = timestamp;

    NSString* expected = @"{"
    "  \"account\" : {"
    "    \"app_name\" : \"com.criteo.sdktestapp.custom\""
    "  },"
    "  \"events\" : ["
    "    {"
    "      \"event\" : \"appLaunch\","
    "      \"timestamp\" : \"2015-06-26T14:57:25Z\""
    "    }"
    "  ],"
    "  \"id\" : {"
    "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\","
    "    \"limit_ad_tracking\" : false"
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
                        appInfo:mockAppInfo
                     deviceInfo:mockDeviceInfo
                        sdkInfo:mockSDKInfo
              withCustomerEmail:nil
                    accountName:@"com.criteo.sdktestapp.custom"
                        country:nil
                       language:nil
              andExpectedResult:expected
             returningResultObj:&resultObj
                 andExpectedObj:&expectedObj];

    XCTAssertEqualObjects(resultObj, expectedObj);
}

- (void) testAppLaunchEventWithExtraDataSerialization
{
    CRTOAppLaunchEvent* appLaunch = [[CRTOAppLaunchEvent alloc] init];
    appLaunch.timestamp = timestamp;

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
                          "         \"type\" : \"string\""
                          "      },"
                          "      \"timestamp\" : \"2015-06-26T14:57:25Z\""
                          "    }"
                          "  ],"
                          "  \"id\" : {"
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\","
                          "    \"limit_ad_tracking\" : false"
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
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\","
                          "    \"limit_ad_tracking\" : false"
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
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\","
                          "    \"limit_ad_tracking\" : false"
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
                          "      \"hash_method\" : \"md5\""
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

- (void) testBasketViewEventSerializationWithDates
{
    CRTOBasketProduct* product  = [[CRTOBasketProduct alloc] initWithProductId:@"PRODUCT11223344" price:999.85 quantity:1];
    CRTOBasketProduct* product2 = [[CRTOBasketProduct alloc] initWithProductId:@"PRODUCT56789101" price:10 quantity:100];
    CRTOBasketProduct* product3 = [[CRTOBasketProduct alloc] initWithProductId:@"나는 유리를 먹을 수 있어요. 그래도 아프지 않아요" price:0.1 quantity:-2500];

    CRTOBasketViewEvent* basketViewEvent = [[CRTOBasketViewEvent alloc] initWithBasketProducts:@[ product, product2, product3 ]
                                                                                      currency:@"USD"
                                                                                     startDate:extraDate
                                                                                       endDate:extraDate3];
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
                          "      \"timestamp\" : \"2015-06-26T14:57:25Z\","
                          "      \"checkin_date\" : {"
                          "        \"value\" : \"2001-09-09T00:00:00Z\","
                          "        \"type\" : \"date\""
                          "      },"
                          "      \"checkout_date\" : {"
                          "        \"value\" : \"2001-10-01T00:00:00Z\","
                          "        \"type\" : \"date\""
                          "      }"
                          "    }"
                          "  ],"
                          "  \"id\" : {"
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\","
                          "    \"limit_ad_tracking\" : false"
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
                          "      \"hash_method\" : \"md5\""
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
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\","
                          "    \"limit_ad_tracking\" : false"
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
                          "      \"hash_method\" : \"md5\""
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
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\","
                          "    \"limit_ad_tracking\" : false"
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
                          "      \"hash_method\" : \"md5\""
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
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\","
                          "    \"limit_ad_tracking\" : false"
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
                          "      \"hash_method\" : \"md5\""
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

    [dataEvent setDateExtraData:extraDate ForKey:@"my_date_extra_data"];

    float extraFloat = 0.1f;
    [dataEvent setFloatExtraData:extraFloat ForKey:@"FLOATDATA"];

    NSInteger extraInteger = -2000000000;
    [dataEvent setIntegerExtraData:extraInteger ForKey:@"The biggest number there is"];

    NSString* extraString = @"some Sample string";
    [dataEvent setStringExtraData:extraString ForKey:@"myStringData"];

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
                          "         \"type\" : \"string\""
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
                          "         \"type\" : \"string\""
                          "      },"
                          "      \"timestamp\" : \"2015-06-26T14:57:25Z\""
                          "    }"
                          "  ],"
                          "  \"id\" : {"
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\","
                          "    \"limit_ad_tracking\" : false"
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
                          "      \"hash_method\" : \"md5\""
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
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\","
                          "    \"limit_ad_tracking\" : false"
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
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\","
                          "    \"limit_ad_tracking\" : false"
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
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\","
                          "    \"limit_ad_tracking\" : false"
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

- (void) testLATHomeViewEventSerialization
{
    CRTOHomeViewEvent* homeEvent = [[CRTOHomeViewEvent alloc] init];
    homeEvent.timestamp = timestamp;

    CRTODeviceInfo* mockDeviceInfo_local = [self mockDeviceInfoWithDeviceId:@"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6"
                                                         deviceManufacturer:@"apple"
                                                                deviceModel:@"iPhone3,2"
                                                 advertisingTrackingEnabled:NO
                                                                     osName:@"iPhone OS"
                                                                  osVersion:@"4.9.1"
                                                                   platform:@"ios"];

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
    "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\","
    "    \"limit_ad_tracking\" : true"
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
                        appInfo:mockAppInfo
                     deviceInfo:mockDeviceInfo_local
                        sdkInfo:mockSDKInfo
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
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\","
                          "    \"limit_ad_tracking\" : false"
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
                          "      \"hash_method\" : \"md5\""
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

- (void) testProductViewEventSerializationWithDates
{
    CRTOProduct* product = [[CRTOProduct alloc] initWithProductId:@"PRODUCT11223344" price:999.85];

    CRTOProductViewEvent* productViewEvent = [[CRTOProductViewEvent alloc] initWithProduct:product];
    productViewEvent.startDate = extraDate;
    productViewEvent.endDate   = extraDate3;
    productViewEvent.timestamp = timestamp;

    NSString* expected = @"{"
                          "  \"account\" : {"
                          "    \"app_name\" : \"com.criteo.sdktestapp\""
                          "  },"
                          "  \"events\" : ["
                          "    {"
                          "      \"event\" : \"viewProduct\","
                          "      \"product\" : { \"id\" : \"PRODUCT11223344\", \"price\" : 999.85 },"
                          "      \"checkin_date\" : {"
                          "        \"value\" : \"2001-09-09T00:00:00Z\","
                          "        \"type\" : \"date\""
                          "      },"
                          "      \"checkout_date\" : {"
                          "        \"value\" : \"2001-10-01T00:00:00Z\","
                          "        \"type\" : \"date\""
                          "      },"
                          "      \"timestamp\" : \"2015-06-26T14:57:25Z\""
                          "    }"
                          "  ],"
                          "  \"id\" : {"
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\","
                          "    \"limit_ad_tracking\" : false"
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
                          "      \"hash_method\" : \"md5\""
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
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\","
                          "    \"limit_ad_tracking\" : false"
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
                          "      \"hash_method\" : \"md5\""
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
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\","
                          "    \"limit_ad_tracking\" : false"
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
                          "      \"hash_method\" : \"md5\""
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
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\","
                          "    \"limit_ad_tracking\" : false"
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
                          "      \"hash_method\" : \"md5\""
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

- (void) testProductListViewEventSerializationWithDates
{
    CRTOProduct* product  = [[CRTOProduct alloc] initWithProductId:@"PRODUCT11223344" price:999.85];
    CRTOProduct* product2 = [[CRTOProduct alloc] initWithProductId:@"PRODUCT56789101" price:10];
    CRTOProduct* product3 = [[CRTOProduct alloc] initWithProductId:@"나는 유리를 먹을 수 있어요. 그래도 아프지 않아요" price:0.1];

    CRTOProductListViewEvent* productViewEvent = [[CRTOProductListViewEvent alloc] initWithProducts:@[ product, product2, product3 ]];
    productViewEvent.startDate = extraDate;
    productViewEvent.endDate   = extraDate3;

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
                          "      \"timestamp\" : \"2015-06-26T14:57:25Z\","
                          "      \"checkin_date\" : {"
                          "        \"value\" : \"2001-09-09T00:00:00Z\","
                          "        \"type\" : \"date\""
                          "      },"
                          "      \"checkout_date\" : {"
                          "        \"value\" : \"2001-10-01T00:00:00Z\","
                          "        \"type\" : \"date\""
                          "      }"
                          "    }"
                          "  ],"
                          "  \"id\" : {"
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\","
                          "    \"limit_ad_tracking\" : false"
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
                          "      \"hash_method\" : \"md5\""
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
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\","
                          "    \"limit_ad_tracking\" : false"
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
                          "      \"hash_method\" : \"md5\""
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
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\","
                          "    \"limit_ad_tracking\" : false"
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
                          "      \"hash_method\" : \"md5\""
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
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\","
                          "    \"limit_ad_tracking\" : false"
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
                          "      \"hash_method\" : \"md5\""
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
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\","
                          "    \"limit_ad_tracking\" : false"
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
                          "      \"hash_method\" : \"md5\""
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

- (void) testTransactionConfirmationEventSerializationWithDeduplicationSetToFalse
{
    CRTOBasketProduct* product  = [[CRTOBasketProduct alloc] initWithProductId:@"PRODUCT11223344" price:999.85 quantity:1];
    CRTOBasketProduct* product2 = [[CRTOBasketProduct alloc] initWithProductId:@"PRODUCT56789101" price:10 quantity:100];
    CRTOBasketProduct* product3 = [[CRTOBasketProduct alloc] initWithProductId:@"나는 유리를 먹을 수 있어요. 그래도 아프지 않아요" price:0.1 quantity:-2500];

    CRTOTransactionConfirmationEvent* confirmEvent = [[CRTOTransactionConfirmationEvent alloc] initWithBasketProducts:@[ product, product2, product3 ]];
    confirmEvent.currency = @"USD";
    confirmEvent.deduplication = false;
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
    "      \"deduplication\" : {"
    "         \"value\" : 0,"
    "         \"type\" : \"integer\""
    "      },"
    "      \"timestamp\" : \"2015-06-26T14:57:25Z\""
    "    }"
    "  ],"
    "  \"id\" : {"
    "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\","
    "    \"limit_ad_tracking\" : false"
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
    "      \"hash_method\" : \"md5\""
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

- (void) testTransactionConfirmationEventSerializationWithDeduplicationSetToTrue
{
    CRTOBasketProduct* product  = [[CRTOBasketProduct alloc] initWithProductId:@"PRODUCT11223344" price:999.85 quantity:1];
    CRTOBasketProduct* product2 = [[CRTOBasketProduct alloc] initWithProductId:@"PRODUCT56789101" price:10 quantity:100];
    CRTOBasketProduct* product3 = [[CRTOBasketProduct alloc] initWithProductId:@"나는 유리를 먹을 수 있어요. 그래도 아프지 않아요" price:0.1 quantity:-2500];

    CRTOTransactionConfirmationEvent* confirmEvent = [[CRTOTransactionConfirmationEvent alloc] initWithBasketProducts:@[ product, product2, product3 ]];
    confirmEvent.currency = @"USD";
    confirmEvent.deduplication = true;
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
    "      \"deduplication\" : {"
    "         \"value\" : 1,"
    "         \"type\" : \"integer\""
    "      },"
    "      \"timestamp\" : \"2015-06-26T14:57:25Z\""
    "    }"
    "  ],"
    "  \"id\" : {"
    "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\","
    "    \"limit_ad_tracking\" : false"
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
    "      \"hash_method\" : \"md5\""
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

- (void) testTransactionConfirmationEventSerializationWithDates
{
    CRTOBasketProduct* product  = [[CRTOBasketProduct alloc] initWithProductId:@"PRODUCT11223344" price:999.85 quantity:1];
    CRTOBasketProduct* product2 = [[CRTOBasketProduct alloc] initWithProductId:@"PRODUCT56789101" price:10 quantity:100];
    CRTOBasketProduct* product3 = [[CRTOBasketProduct alloc] initWithProductId:@"나는 유리를 먹을 수 있어요. 그래도 아프지 않아요" price:0.1 quantity:-2500];

    CRTOTransactionConfirmationEvent* confirmEvent = [[CRTOTransactionConfirmationEvent alloc] initWithBasketProducts:@[ product, product2, product3 ]
                                                                                                        transactionId:@"8c085e9a-ae34-424b-bcfb-a702084ee2c3"
                                                                                                             currency:@"USD"
                                                                                                            startDate:extraDate
                                                                                                              endDate:extraDate3];
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
                          "      \"checkin_date\" : {"
                          "        \"value\" : \"2001-09-09T00:00:00Z\","
                          "        \"type\" : \"date\""
                          "      },"
                          "      \"checkout_date\" : {"
                          "        \"value\" : \"2001-10-01T00:00:00Z\","
                          "        \"type\" : \"date\""
                          "      },"
                          "      \"timestamp\" : \"2015-06-26T14:57:25Z\""
                          "    }"
                          "  ],"
                          "  \"id\" : {"
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\","
                          "    \"limit_ad_tracking\" : false"
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
                          "      \"hash_method\" : \"md5\""
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
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\","
                          "    \"limit_ad_tracking\" : false"
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
                          "      \"hash_method\" : \"md5\""
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
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\","
                          "    \"limit_ad_tracking\" : false"
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
                          "      \"hash_method\" : \"md5\""
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
                          "    \"idfa\" : \"fcccfb5f-4cf1-489f-ac16-8e2fb2292ef6\","
                          "    \"limit_ad_tracking\" : false"
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
                          "      \"hash_method\" : \"md5\""
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
