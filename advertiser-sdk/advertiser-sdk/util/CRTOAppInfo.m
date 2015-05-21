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

#pragma mark - Initializers

- (instancetype) init
{
    self = [super init];
    if ( self ) {
        [self setupAppInfo];
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
    NSLocale* currentLocale = [NSLocale currentLocale];

    return [currentLocale objectForKey:NSLocaleCountryCode];
}

- (NSString*) appLanguage
{
    NSArray* preferredLocalizations = [NSBundle mainBundle].preferredLocalizations;

    if ( preferredLocalizations.count > 0 ) {
        return preferredLocalizations[0];
    }

    NSLocale* currentLocale = [NSLocale currentLocale];

    return [currentLocale objectForKey:NSLocaleLanguageCode];
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
