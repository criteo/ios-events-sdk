//
//  CRTOAppLaunchEvent.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <CriteoAdvertiser/CRTOAppLaunchEvent.h>
#import "CRTOAppLaunchEvent+Internal.h"
#import "CRTOEvent+Internal.h"

NSString* const kCRTOInitialLaunchKey = @"CRTOInitialLaunchKey";

@implementation CRTOAppLaunchEvent

#pragma mark - Initializers

- (instancetype) init
{
    return [self initWithDeeplinkLaunchUrl:nil];
}

- (instancetype) initWithDeeplinkLaunchUrl:(NSString*)url
{
    self = [super init];
    if ( self ) {
        if ( url ) {
            _deeplinkLaunchUrl = [NSString stringWithString:url];

            [self detectFirstLaunch];
        }
    }
    return self;
}

#pragma mark - NSCopying

- (instancetype) copyWithZone:(NSZone*)zone
{
    CRTOAppLaunchEvent* eventCopy = [[CRTOAppLaunchEvent alloc] initWithEvent:self];

    return eventCopy;
}

#pragma mark - Class Extension Initializers

- (instancetype) initWithFirstLaunchFlagOverride:(BOOL)isFirstLaunch
{
    self = [self initWithDeeplinkLaunchUrl:nil];

    _isFirstLaunch = isFirstLaunch;

    return self;
}

#pragma mark - Class Extension Properties

- (BOOL) isValid
{
    BOOL valid = YES;

    //valid = valid && (_deeplinkLaunchUrl == nil || _deeplinkLaunchUrl.length > 0);
    valid = valid && [super isValid];

    return valid;
}

#pragma mark - Class Extension Methods

- (void) detectFirstLaunch
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

    BOOL firstLaunchPref = [defaults boolForKey:kCRTOInitialLaunchKey];

    if ( !firstLaunchPref ) {
        _isFirstLaunch = YES;

        [defaults setBool:YES forKey:kCRTOInitialLaunchKey];
        [defaults synchronize];
    } else {
        _isFirstLaunch = NO;
    }
}

@end
