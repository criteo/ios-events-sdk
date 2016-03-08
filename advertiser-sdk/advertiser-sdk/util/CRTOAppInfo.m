//
//  CRTOAppInfo.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "CRTOAppInfo.h"

@interface CRTOAppInfo ()

- (void) setupAppInfo;

@end

@implementation CRTOAppInfo
{
    NSLocale* locale;
    NSBundle* bundle;
}

#pragma mark - Initializers

- (instancetype) init
{
    return [self initWithLocale:nil andMainBundle:nil];
}

- (instancetype) initWithLocale:(NSLocale*)localeParam andMainBundle:(NSBundle*)bundleParam
{
    self = [super init];
    if ( self ) {
        [self setupAppInfo];

        locale = localeParam;
        bundle = bundleParam;
    }

    return self;
}

#pragma mark - Static Methods

+ (instancetype) sharedAppInfo
{
    static dispatch_once_t onceToken;
    static CRTOAppInfo* appInfo;

    dispatch_once(&onceToken, ^{
        appInfo = [[CRTOAppInfo alloc] init];
    });

    return appInfo;
}

#pragma mark - Properties

- (NSString*) appCountry
{
    NSLocale* currentLocale = locale ?: [NSLocale autoupdatingCurrentLocale];

    NSString* countryCode = [currentLocale objectForKey:NSLocaleCountryCode];

    return countryCode ?: @"";
}

- (NSString*) appLanguage
{
    NSBundle* mainBundle = bundle ?: [NSBundle mainBundle];

    NSArray* preferredLocalizations = mainBundle.preferredLocalizations;

    if ( preferredLocalizations.count > 0 ) {
        return preferredLocalizations[0];
    }

    NSLocale* currentLocale = locale ?: [NSLocale autoupdatingCurrentLocale];
    NSString* languageCode = [currentLocale objectForKey:NSLocaleLanguageCode];

    return languageCode ?: @"";
}

#pragma mark - Class Extension Methods

- (void) setupAppInfo
{
    NSBundle* mainBundle = [NSBundle mainBundle];

    _appId      = mainBundle.bundleIdentifier ?: @"";
    _appName    = [mainBundle objectForInfoDictionaryKey:@"CFBundleDisplayName"] ?: @"";
    _appVersion = [mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"] ?: @"";
}

@end
