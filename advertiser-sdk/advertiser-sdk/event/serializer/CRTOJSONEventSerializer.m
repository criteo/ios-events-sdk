//
//  CRTOJSONEventSerializer.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "CRTOJSONEventSerializer.h"

#import "CRTODateFormatter.h"
#import "CRTOJSONConstants.h"

#import "CRTOEvent.h"
#import "CRTOEvent+Internal.h"
#import "CRTOExtraData.h"
#import "CRTOAppLaunchEvent.h"
#import "CRTOAppLaunchEvent+Internal.h"
#import "CRTODataEvent.h"
#import "CRTODataEvent+Internal.h"
#import "CRTODeeplinkEvent.h"
#import "CRTODeeplinkEvent+Internal.h"
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

static NSString* jsonProtocolVersion = nil;

@interface CRTOJSONEventSerializer ()

- (NSDictionary*) accountDictionary;
- (NSArray*) alternateIdsArray;
- (NSDictionary*) appInfoDictionary;
- (NSDictionary*) deviceInfoDictionary;
- (NSMutableDictionary*) eventDictionaryForBaseEvent:(CRTOEvent*)event;
- (NSString*) eventValueForEvent:(CRTOEvent*)event;
- (NSDictionary*) idDictionary;
- (NSDictionary*) requestDictionaryWithEventDictionaries:(NSArray*)events;
- (NSString*) serializeRequestDictionaryToJSON:(NSDictionary*)request;

- (NSString*) serializeAppLaunchEvent:(CRTOAppLaunchEvent*)event;
- (NSString*) serializeBasketViewEvent:(CRTOBasketViewEvent*)event;
- (NSString*) serializeDataEvent:(CRTODataEvent*)event;
- (NSString*) serializeDeeplinkEvent:(CRTODeeplinkEvent*)event;
- (NSString*) serializeHomeViewEvent:(CRTOHomeViewEvent*)event;
- (NSString*) serializeProductListViewEvent:(CRTOProductListViewEvent*)event;
- (NSString*) serializeProductViewEvent:(CRTOProductViewEvent*)event;
- (NSString*) serializeTransactionConfirmationEvent:(CRTOTransactionConfirmationEvent*)event;

@end

@implementation CRTOJSONEventSerializer
{
@private
    CRTOAppInfo* appInfo;
    CRTODeviceInfo* deviceInfo;
    CRTOSDKInfo* sdkInfo;
}

#pragma mark - Static Initializer

+ (void) initialize
{
    if ( self == [CRTOJSONEventSerializer class] )
    {
        jsonProtocolVersion = kCRTOJSONProtocolVersionValue1_0_0;
    }
}

#pragma mark - Initializers

- (instancetype) init
{
    return [self initWithAppInfo:nil deviceInfo:nil sdkInfo:nil];
}

- (instancetype) initWithAppInfo:(CRTOAppInfo*)app deviceInfo:(CRTODeviceInfo*)device sdkInfo:(CRTOSDKInfo*)sdk
{
    self = [super init];
    if ( self != nil ) {
        appInfo    = app    ?: [CRTOAppInfo sharedAppInfo];
        deviceInfo = device ?: [CRTODeviceInfo sharedDeviceInfo];
        sdkInfo    = sdk    ?: [CRTOSDKInfo sharedSDKInfo];
    }
    return self;
}

#pragma mark - Public Methods

- (NSString*) serializeEventToJSONString:(CRTOEvent*)event
{
    NSParameterAssert(event);

    if ( [event isMemberOfClass:[CRTOAppLaunchEvent class]] ) {
        return [self serializeAppLaunchEvent:(CRTOAppLaunchEvent*)event];
    }

    if ( [event isMemberOfClass:[CRTOBasketViewEvent class]] ) {
        return [self serializeBasketViewEvent:(CRTOBasketViewEvent*)event];
    }

    if ( [event isMemberOfClass:[CRTODataEvent class]] ) {
        return [self serializeDataEvent:(CRTODataEvent*)event];
    }

    if ( [event isMemberOfClass:[CRTODeeplinkEvent class]] ) {
        return [self serializeDeeplinkEvent:(CRTODeeplinkEvent*)event];
    }

    if ( [event isMemberOfClass:[CRTOHomeViewEvent class]] ) {
        return [self serializeHomeViewEvent:(CRTOHomeViewEvent*)event];
    }

    if ( [event isMemberOfClass:[CRTOProductListViewEvent class]] ) {
        return [self serializeProductListViewEvent:(CRTOProductListViewEvent*)event];
    }

    if ( [event isMemberOfClass:[CRTOProductViewEvent class]] ) {
        return [self serializeProductViewEvent:(CRTOProductViewEvent*)event];
    }

    if ( [event isMemberOfClass:[CRTOTransactionConfirmationEvent class]] ) {
        return [self serializeTransactionConfirmationEvent:(CRTOTransactionConfirmationEvent*)event];
    }

    return nil;
}

#pragma mark - Class Extension Methods

- (NSDictionary*) accountDictionary
{
    NSString* country = self.countryCode;
    NSString* language = self.languageCode;

    NSMutableDictionary* account = [NSMutableDictionary new];

    account[kCRTOJSONPartnerAppDataPropertyApp_NameKey] = appInfo.appId;

    if ( country != nil ) {
        account[kCRTOJSONPartnerAppDataPropertyCountry_CodeKey] = country;
    }

    if ( language != nil ) {
        account[kCRTOJSONPartnerAppDataPropertyLanguage_CodeKey] = language;
    }

    return [NSDictionary dictionaryWithDictionary:account];
}

- (NSArray*) alternateIdsArray
{
    NSString* customerEmail = self.customerEmail;

    NSMutableArray* alternateIds = [NSMutableArray new];

    if ( customerEmail.length > 0 ) {
        NSDictionary* nonHashedId = @{ kCRTOJSONAlternateIdTypeKey  : kCRTOJSONAlternateIdEmailValue,
                                       kCRTOJSONAlternateIdValueKey : customerEmail,
                                       kCRTOJSONAlternateIdHashKey  : kCRTOJSONAlternateIdNoneValue };

        [alternateIds addObject:nonHashedId];
    }

    return [NSArray arrayWithArray:alternateIds];
}

- (NSDictionary*) appInfoDictionary
{
    NSDictionary* app = @{ kCRTOJSONPartnerAppDataPropertyApp_IdKey       : appInfo.appId,
                           kCRTOJSONPartnerAppDataPropertyApp_NameKey     : appInfo.appName,
                           kCRTOJSONPartnerAppDataPropertyApp_VersionKey  : appInfo.appVersion,
                           kCRTOJSONPartnerAppDataPropertySdk_VersionKey  : sdkInfo.sdkVersion,
                           kCRTOJSONPartnerAppDataPropertyApp_LanguageKey : appInfo.appLanguage,
                           kCRTOJSONPartnerAppDataPropertyApp_CountryKey  : appInfo.appCountry };

    return app;
}

- (NSDictionary*) deviceInfoDictionary
{
    NSDictionary* device = @{ kCRTOJSONDeviceInfoPlatformKey            : deviceInfo.platform,
                              kCRTOJSONDeviceInfoOs_NameKey             : deviceInfo.osName,
                              kCRTOJSONDeviceInfoOs_VersionKey          : deviceInfo.osVersion,
                              kCRTOJSONDeviceInfoDevice_ModelKey        : deviceInfo.deviceModel,
                              kCRTOJSONDeviceInfoDevice_ManufacturerKey : deviceInfo.deviceManufacturer };

    return device;
}

- (NSMutableDictionary*) eventDictionaryForBaseEvent:(CRTOEvent*)event
{
    NSMutableDictionary* eventDictionary = [NSMutableDictionary new];

    eventDictionary[kCRTOJSONPropertyNameEventKey]     = [self eventValueForEvent:event];
    eventDictionary[kCRTOJSONPropertyNameTimestampKey] = [CRTODateFormatter iso8601StringFromDate:event.timestamp];

    NSDictionary* extraData = event.dictionaryWithAllExtraData;

    for (NSString* key in extraData) {
        CRTOExtraData* data = extraData[key];

        NSDictionary* dataDictionary = nil;

        switch ( data.type ) {
            case CRTOExtraDataTypeDate:
            {
                NSString* dateValue = [CRTODateFormatter iso8601StringFromDate:data.value];
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

- (NSString*) eventValueForEvent:(CRTOEvent*)event
{
    if ( [event isMemberOfClass:[CRTOAppLaunchEvent class]] ) {
        return kCRTOJSONEventTypeAppLaunchKey;
    }

    if ( [event isMemberOfClass:[CRTOBasketViewEvent class]] ) {
        return kCRTOJSONEventTypeViewBasketKey;
    }

    if ( [event isMemberOfClass:[CRTODataEvent class]] ) {
        return kCRTOJSONEventTypeSetDataKey;
    }

    if ( [event isMemberOfClass:[CRTODeeplinkEvent class]] ) {
        return kCRTOJSONEventTypeAppDeeplinkKey;
    }

    if ( [event isMemberOfClass:[CRTOHomeViewEvent class]] ) {
        return kCRTOJSONEventTypeViewHomeKey;
    }

    if ( [event isMemberOfClass:[CRTOProductListViewEvent class]] ) {
        return kCRTOJSONEventTypeViewListingKey;
    }

    if ( [event isMemberOfClass:[CRTOProductViewEvent class]] ) {
        return kCRTOJSONEventTypeViewProductKey;
    }

    if ( [event isMemberOfClass:[CRTOTransactionConfirmationEvent class]] ) {
        return kCRTOJSONEventTypeTrackTransactionKey;
    }

    return @"invalidEvent";
}

- (NSDictionary*) idDictionary
{
    NSDictionary* idDictionary = @{ kCRTOJSONPropertyNameIdfaKey : deviceInfo.deviceIdentifier };

    return idDictionary;
}

- (NSDictionary*) requestDictionaryWithEventDictionaries:(NSArray*)events
{
    NSDictionary* account = [self accountDictionary];
    NSDictionary* device  = [self deviceInfoDictionary];
    NSDictionary* app     = [self appInfoDictionary];
    NSDictionary* idDict  = [self idDictionary];
    NSArray* alternateIds = [self alternateIdsArray];

    NSMutableDictionary* request = [NSMutableDictionary new];

    request[kCRTOJSONPropertyNameAccountKey]     = account;
    request[kCRTOJSONPropertyNameIdKey]          = idDict;
    request[kCRTOJSONPropertyNameDevice_InfoKey] = device;
    request[kCRTOJSONPropertyNameApp_InfoKey]    = app;
    request[kCRTOJSONPropertyNameEventsKey]      = events;
    request[kCRTOJSONPropertyNameVersionKey]     = jsonProtocolVersion;

    if ( alternateIds.count > 0 ) {
        request[kCRTOJSONPropertyNameAlternate_IdsKey] = alternateIds;
    }

    return [NSDictionary dictionaryWithDictionary:request];
}

- (NSString*) serializeRequestDictionaryToJSON:(NSDictionary*)request
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

- (NSString*) serializeAppLaunchEvent:(CRTOAppLaunchEvent*)event
{
    NSMutableDictionary* eventDictionary = [self eventDictionaryForBaseEvent:event];

    // Add App Launch specific keys
    if ( event.isFirstLaunch ) {
        eventDictionary[kCRTOJSONPropertyNameFirst_LaunchKey] = @(YES);
    }

    NSDictionary* request = [self requestDictionaryWithEventDictionaries:@[ eventDictionary ]];

    NSString* json = [self serializeRequestDictionaryToJSON:request];

    return json;
}

- (NSString*) serializeBasketViewEvent:(CRTOBasketViewEvent*)event
{
    NSMutableDictionary* eventDictionary = [self eventDictionaryForBaseEvent:event];

    // Add View Basket specific keys

    // Currency
    if ( event.currency != nil ) {
        eventDictionary[kCRTOJSONPropertyNameCurrencyKey] = event.currency;
    }

    // Product Array
    NSMutableArray* productArray = [NSMutableArray new];

    for ( CRTOBasketProduct* product in event.basketProducts ) {
        NSDictionary* productDictionary = @{ kCRTOJSONProductPropertyIdKey       : product.productId,
                                             kCRTOJSONProductPropertyPriceKey    : @(product.price),
                                             kCRTOJSONProductPropertyQuantityKey : @(product.quantity) };

        [productArray addObject:productDictionary];
    }

    eventDictionary[kCRTOJSONPropertyNameProductKey] = productArray;

    NSDictionary* request = [self requestDictionaryWithEventDictionaries:@[ eventDictionary ]];

    NSString* json = [self serializeRequestDictionaryToJSON:request];

    return json;
}

- (NSString*) serializeDataEvent:(CRTODataEvent*)event
{
    NSMutableDictionary* eventDictionary = [self eventDictionaryForBaseEvent:event];

    NSDictionary* request = [self requestDictionaryWithEventDictionaries:@[ eventDictionary ]];

    NSString* json = [self serializeRequestDictionaryToJSON:request];

    return json;
}

- (NSString*) serializeDeeplinkEvent:(CRTODeeplinkEvent*)event
{
    NSMutableDictionary* eventDictionary = [self eventDictionaryForBaseEvent:event];

    // Add Deeplink specific keys

    // Deeplink
    if ( event.deeplinkLaunchUrl != nil ) {
        eventDictionary[kCRTOJSONPropertyNameDeeplink_UriKey] = event.deeplinkLaunchUrl;
    }

    NSDictionary* request = [self requestDictionaryWithEventDictionaries:@[ eventDictionary ]];

    NSString* json = [self serializeRequestDictionaryToJSON:request];

    return json;
}

- (NSString*) serializeHomeViewEvent:(CRTOHomeViewEvent*)event
{
    NSMutableDictionary* eventDictionary = [self eventDictionaryForBaseEvent:event];

    NSDictionary* request = [self requestDictionaryWithEventDictionaries:@[ eventDictionary ]];

    NSString* json = [self serializeRequestDictionaryToJSON:request];

    return json;
}

- (NSString*) serializeProductListViewEvent:(CRTOProductListViewEvent*)event
{
    NSMutableDictionary* eventDictionary = [self eventDictionaryForBaseEvent:event];

    // Add View Listing specific keys

    // Currency
    if ( event.currency != nil ) {
        eventDictionary[kCRTOJSONPropertyNameCurrencyKey] = event.currency;
    }

    // Product Array
    NSMutableArray* productArray = [NSMutableArray new];

    for ( CRTOProduct* product in event.products ) {
        NSDictionary* productDictionary = @{ kCRTOJSONProductPropertyIdKey    : product.productId,
                                             kCRTOJSONProductPropertyPriceKey : @(product.price) };

        [productArray addObject:productDictionary];
    }

    eventDictionary[kCRTOJSONPropertyNameProductKey] = productArray;

    NSDictionary* request = [self requestDictionaryWithEventDictionaries:@[ eventDictionary ]];

    NSString* json = [self serializeRequestDictionaryToJSON:request];

    return json;
}

- (NSString*) serializeProductViewEvent:(CRTOProductViewEvent*)event
{
    NSMutableDictionary* eventDictionary = [self eventDictionaryForBaseEvent:event];

    // Add View Item specific keys

    // Currency
    if ( event.currency != nil ) {
        eventDictionary[kCRTOJSONPropertyNameCurrencyKey] = event.currency;
    }

    // One single, lonely product
    if ( event.product ) {
        eventDictionary[kCRTOJSONPropertyNameProductKey] = @{ kCRTOJSONProductPropertyIdKey : event.product.productId,
                                                              kCRTOJSONProductPropertyPriceKey : @(event.product.price) };
    }

    NSDictionary* request = [self requestDictionaryWithEventDictionaries:@[ eventDictionary ]];

    NSString* json = [self serializeRequestDictionaryToJSON:request];

    return json;
}

- (NSString*) serializeTransactionConfirmationEvent:(CRTOTransactionConfirmationEvent*)event
{
    NSMutableDictionary* eventDictionary = [self eventDictionaryForBaseEvent:event];

    // Add Track Transaction specific keys

    // Currency
    if ( event.currency != nil ) {
        eventDictionary[kCRTOJSONPropertyNameCurrencyKey] = event.currency;
    }

    // Transaction UID
    if ( event.transactionId ) {
        eventDictionary[kCRTOJSONPropertyNameIdKey] = event.transactionId;
    }

    // Product Array
    NSMutableArray* productArray = [NSMutableArray new];

    for ( CRTOBasketProduct* product in event.basketProducts ) {
        NSDictionary* productDictionary = @{ kCRTOJSONProductPropertyIdKey       : product.productId,
                                             kCRTOJSONProductPropertyPriceKey    : @(product.price),
                                             kCRTOJSONProductPropertyQuantityKey : @(product.quantity) };

        [productArray addObject:productDictionary];
    }

    eventDictionary[kCRTOJSONPropertyNameProductKey] = productArray;

    NSDictionary* request = [self requestDictionaryWithEventDictionaries:@[ eventDictionary ]];

    NSString* json = [self serializeRequestDictionaryToJSON:request];

    return json;
}

@end
