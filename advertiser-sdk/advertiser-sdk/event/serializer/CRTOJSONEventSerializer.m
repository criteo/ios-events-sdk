//
//  CRTOJSONEventSerializer.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "CRTOJSONEventSerializer.h"
#import "CRTOJSONConstants.h"
#import "CRTOEvent.h"
#import "CRTOEvent+Internal.h"
#import "CRTOExtraData.h"
#import "CRTOAppLaunchEvent.h"
#import "CRTOAppLaunchEvent+Internal.h"
#import "CRTODataEvent.h"
#import "CRTODataEvent+Internal.h"
#import "CRTOBasketViewEvent.h"
#import "CRTOBasketViewEvent+Internal.h"
#import "CRTOHomeViewEvent.h"
#import "CRTOHomeViewEvent+Internal.h"
#import "CRTOProductListViewEvent.h"
#import "CRTOProductListViewEvent+Internal.h"
#import "CRTOProductViewEvent.h"
#import "CRTOProductViewEvent+Internal.h"
#import "CRTOTransactionConfirmationEvent.h"
#import "CRTOTransactionConfirmationEvent+Internal.h"
#import "CRTOBasketProduct.h"
#import "CRTOProduct.h"
#import "CRTOAppInfo.h"
#import "CRTODeviceInfo.h"
#import "CRTOSDKInfo.h"

static NSDateFormatter* iso8601DateFormatter = nil;

@interface CRTOJSONEventSerializer ()

+ (NSDictionary*) accountDictionary;
+ (NSDictionary*) appInfoDictionary;
+ (NSDictionary*) deviceInfoDictionary;
+ (NSMutableDictionary*) eventDictionaryForBaseEvent:(CRTOEvent*)event;
+ (NSString*) eventValueForEvent:(CRTOEvent*)event;
+ (NSDictionary*) idDictionary;
+ (NSDictionary*) requestDictionaryWithEventDictionaries:(NSArray*)events;
+ (NSString*) serializeRequestDictionaryToJSON:(NSDictionary*)request;

+ (NSString*) serializeAppLaunchEvent:(CRTOAppLaunchEvent*)event;
+ (NSString*) serializeBasketViewEvent:(CRTOBasketViewEvent*)event;
+ (NSString*) serializeHomeViewEvent:(CRTOHomeViewEvent*)event;
+ (NSString*) serializeProductListViewEvent:(CRTOProductListViewEvent*)event;
+ (NSString*) serializeProductViewEvent:(CRTOProductViewEvent*)event;
+ (NSString*) serializeTransactionConfirmationEvent:(CRTOTransactionConfirmationEvent*)event;

@end

@implementation CRTOJSONEventSerializer

#pragma mark - Static Initializer

+ (void) initialize
{
    if ( self == [CRTOJSONEventSerializer class] )
    {
        iso8601DateFormatter = [[NSDateFormatter alloc] init];
        iso8601DateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        iso8601DateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
        iso8601DateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    }
}

#pragma mark - Public Static Methods

+ (NSString*) serializeEventToJSONString:(CRTOEvent*)event
{
    NSParameterAssert(event);

    if ( [event isMemberOfClass:[CRTOAppLaunchEvent class]] ) {
        return [CRTOJSONEventSerializer serializeAppLaunchEvent:(CRTOAppLaunchEvent*)event];
    }

    if ( [event isMemberOfClass:[CRTOBasketViewEvent class]] ) {
        return [CRTOJSONEventSerializer serializeBasketViewEvent:(CRTOBasketViewEvent*)event];
    }

    if ( [event isMemberOfClass:[CRTOHomeViewEvent class]] ) {
        return [CRTOJSONEventSerializer serializeHomeViewEvent:(CRTOHomeViewEvent*)event];
    }

    if ( [event isMemberOfClass:[CRTOProductListViewEvent class]] ) {
        return [CRTOJSONEventSerializer serializeProductListViewEvent:(CRTOProductListViewEvent*)event];
    }

    if ( [event isMemberOfClass:[CRTOProductViewEvent class]] ) {
        return [CRTOJSONEventSerializer serializeProductViewEvent:(CRTOProductViewEvent*)event];
    }

    if ( [event isMemberOfClass:[CRTOTransactionConfirmationEvent class]] ) {
        return [CRTOJSONEventSerializer serializeTransactionConfirmationEvent:(CRTOTransactionConfirmationEvent*)event];
    }

    return nil;
}

#pragma mark - Static Class Extension Methods

+ (NSDictionary*) accountDictionary
{
    CRTOAppInfo* appInfo = [CRTOAppInfo sharedAppInfo];

    NSDictionary* account = @{ kCRTOJSONPartnerAppDataPropertyApp_NameKey      : appInfo.appId,
                               kCRTOJSONPartnerAppDataPropertyCountry_CodeKey  : appInfo.appCountry,
                               kCRTOJSONPartnerAppDataPropertyLanguage_CodeKey : appInfo.appLanguage };

    return account;
}

+ (NSDictionary*) appInfoDictionary
{
    CRTOAppInfo* appInfo = [CRTOAppInfo sharedAppInfo];
    CRTOSDKInfo* sdkInfo = [CRTOSDKInfo sharedSDKInfo];

    NSDictionary* app = @{ kCRTOJSONPartnerAppDataPropertyApp_IdKey       : appInfo.appId,
                           kCRTOJSONPartnerAppDataPropertyApp_NameKey     : appInfo.appName,
                           kCRTOJSONPartnerAppDataPropertyApp_VersionKey  : appInfo.appVersion,
                           kCRTOJSONPartnerAppDataPropertySdk_VersionKey  : sdkInfo.sdkVersion,
                           kCRTOJSONPartnerAppDataPropertyApp_LanguageKey : appInfo.appLanguage,
                           kCRTOJSONPartnerAppDataPropertyApp_CountryKey  : appInfo.appCountry };

    return app;
}

+ (NSDictionary*) deviceInfoDictionary
{
    CRTODeviceInfo* deviceInfo = [CRTODeviceInfo sharedDeviceInfo];

    NSDictionary* device = @{ kCRTOJSONDeviceInfoPlatformKey            : deviceInfo.platform,
                              kCRTOJSONDeviceInfoOs_NameKey             : deviceInfo.osName,
                              kCRTOJSONDeviceInfoOs_VersionKey          : deviceInfo.osVersion,
                              kCRTOJSONDeviceInfoDevice_ModelKey        : deviceInfo.deviceModel,
                              kCRTOJSONDeviceInfoDevice_ManufacturerKey : deviceInfo.deviceManufacturer };

    return device;
}

+ (NSMutableDictionary*) eventDictionaryForBaseEvent:(CRTOEvent*)event
{
    NSMutableDictionary* eventDictionary = [NSMutableDictionary new];

    eventDictionary[kCRTOJSONPropertyNameEventKey]     = [CRTOJSONEventSerializer eventValueForEvent:event];
    eventDictionary[kCRTOJSONPropertyNameTimestampKey] = [iso8601DateFormatter stringFromDate:event.timestamp];

    NSDictionary* extraData = event.dictionaryWithAllExtraData;

    for (NSString* key in extraData) {
        CRTOExtraData* data = extraData[key];

        NSDictionary* dataDictionary = nil;

        switch ( data.type ) {
            case CRTOExtraDataTypeDate:
            {
                NSString* dateValue = [iso8601DateFormatter stringFromDate:data.value];
                dataDictionary = @{ kCRTOJSONExtraDataValueKey : dateValue,
                                    kCRTOJSONExtraDataTypeKey  : kCRTOJSONExtraDataTypeDateValue };
            }
                break;

            case CRTOExtraDataTypeFloat:
                dataDictionary = @{ kCRTOJSONExtraDataValueKey : data.value,
                                    kCRTOJSONExtraDataTypeKey  : kCRTOJSONExtraDataTypeFloatValue };
                break;

            case CRTOExtraDataTypeInteger:
                dataDictionary = @{ kCRTOJSONExtraDataValueKey : data.value,
                                    kCRTOJSONExtraDataTypeKey  : kCRTOJSONExtraDataTypeIntegerValue };
                break;

            case CRTOExtraDataTypeText:
                dataDictionary = @{ kCRTOJSONExtraDataValueKey : data.value,
                                    kCRTOJSONExtraDataTypeKey  : kCRTOJSONExtraDataTypeTextValue };
                break;

            case CRTOExtraDataTypeInvalid:
            default:
                NSLog(@"Invalid extra data type found during serialization: (key=%@,value=%@,type=%llu)",
                      data.key, data.value, (uint64_t)data.type);
                break;
        }

        if ( dataDictionary != nil ) {
            eventDictionary[data.key] = dataDictionary;
        }
    }

    return eventDictionary;
}

+ (NSString*) eventValueForEvent:(CRTOEvent*)event
{
    if ( [event isMemberOfClass:[CRTOAppLaunchEvent class]] ) {
        return kCRTOJSONEventTypeAppLaunchKey;
    }

    if ( [event isMemberOfClass:[CRTOBasketViewEvent class]] ) {
        return kCRTOJSONEventTypeViewBasketKey;
    }

    if ( [event isMemberOfClass:[CRTOHomeViewEvent class]] ) {
        return kCRTOJSONEventTypeViewHomeKey;
    }

    if ( [event isMemberOfClass:[CRTOProductListViewEvent class]] ) {
        return kCRTOJSONEventTypeViewListKey;
    }

    if ( [event isMemberOfClass:[CRTOProductViewEvent class]] ) {
        return kCRTOJSONEventTypeViewProductKey;
    }

    if ( [event isMemberOfClass:[CRTOTransactionConfirmationEvent class]] ) {
        return kCRTOJSONEventTypeTrackTransactionKey;
    }

    return @"invalidEvent";
}

+ (NSDictionary*) idDictionary
{
    CRTODeviceInfo* deviceInfo = [CRTODeviceInfo sharedDeviceInfo];

    NSDictionary* idDictionary = @{ kCRTOJSONPropertyNameIdfaKey : deviceInfo.deviceIdentifier };

    return idDictionary;
}

+ (NSDictionary*) requestDictionaryWithEventDictionaries:(NSArray*)events
{
    NSDictionary* account = [CRTOJSONEventSerializer accountDictionary];
    NSDictionary* device  = [CRTOJSONEventSerializer deviceInfoDictionary];
    NSDictionary* app     = [CRTOJSONEventSerializer appInfoDictionary];
    NSDictionary* idDict  = [CRTOJSONEventSerializer idDictionary];
    NSString* sdkVersion  = [CRTOSDKInfo sharedSDKInfo].sdkVersion;

    NSDictionary* request = @{ kCRTOJSONPropertyNameAccountKey     : account,
                               kCRTOJSONPropertyNameIdKey          : idDict,
                               kCRTOJSONPropertyNameDevice_InfoKey : device,
                               kCRTOJSONPropertyNameApp_InfoKey    : app,
                               kCRTOJSONPropertyNameEventsKey      : events,
                               kCRTOJSONPropertyNameVersionKey     : sdkVersion };

    return request;
}

+ (NSString*) serializeRequestDictionaryToJSON:(NSDictionary*)request
{
    BOOL isValid = [NSJSONSerialization isValidJSONObject:request];

    NSAssert(isValid, @"NSJSONSerialization refuses to serialize an object: %@", request);

    if ( isValid ) {
        NSError* error = nil;

        NSData* data = [NSJSONSerialization dataWithJSONObject:request
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];

        NSAssert(error == nil, @"Error converting object to JSON: %@", error);
        NSAssert(data != nil, @"Got nil data from JSON serializer?");

        if ( error ) {
            NSLog(@"Error converting object to JSON: %@", error);
            return nil;
        }

        if ( data ) {
            NSString* jsonStr = [[NSString alloc] initWithBytes:data.bytes
                                                         length:data.length
                                                       encoding:NSUTF8StringEncoding];

            return jsonStr;
        }
    } else {
        NSLog(@"NSJSONSerialization indicates that object cannot be serialized: %@", request);
    }

    return nil;
}

+ (NSString*) serializeAppLaunchEvent:(CRTOAppLaunchEvent*)event
{
    NSMutableDictionary* eventDictionary = [CRTOJSONEventSerializer eventDictionaryForBaseEvent:event];

    // Add App Launch specific keys
    if ( event.isFirstLaunch ) {
        eventDictionary[kCRTOJSONPropertyNameFirst_LaunchKey] = @(YES);
    }

    NSDictionary* request = [CRTOJSONEventSerializer requestDictionaryWithEventDictionaries:@[ eventDictionary ]];

    NSString* json = [CRTOJSONEventSerializer serializeRequestDictionaryToJSON:request];

    return json;
}

+ (NSString*) serializeBasketViewEvent:(CRTOBasketViewEvent*)event
{
    // TODO: serialize this type of event
    @throw [NSException exceptionWithName:@"NotImplementedException"
                                   reason:@"It's not implemented"
                                 userInfo:nil];
}

+ (NSString*) serializeHomeViewEvent:(CRTOHomeViewEvent*)event
{
    // TODO: serialize this type of event
    @throw [NSException exceptionWithName:@"NotImplementedException"
                                   reason:@"It's not implemented"
                                 userInfo:nil];
}

+ (NSString*) serializeProductListViewEvent:(CRTOProductListViewEvent*)event
{
    // TODO: serialize this type of event
    @throw [NSException exceptionWithName:@"NotImplementedException"
                                   reason:@"It's not implemented"
                                 userInfo:nil];
}

+ (NSString*) serializeProductViewEvent:(CRTOProductViewEvent*)event
{
    // TODO: serialize this type of event
    @throw [NSException exceptionWithName:@"NotImplementedException"
                                   reason:@"It's not implemented"
                                 userInfo:nil];
}

+ (NSString*) serializeTransactionConfirmationEvent:(CRTOTransactionConfirmationEvent*)event
{
    // TODO: serialize this type of event
    @throw [NSException exceptionWithName:@"NotImplementedException"
                                   reason:@"It's not implemented"
                                 userInfo:nil];
}

@end
