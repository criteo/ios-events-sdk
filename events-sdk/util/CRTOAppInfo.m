//
//  CRTOAppInfo.m
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
