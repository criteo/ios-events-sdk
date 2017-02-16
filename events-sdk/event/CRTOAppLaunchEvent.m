//
//  CRTOAppLaunchEvent.m
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

#import "CRTOAppLaunchEvent.h"
#import "CRTOAppLaunchEvent+Internal.h"
#import "CRTOEvent+Internal.h"

NSString* const kCRTOInitialLaunchKey = @"CRTOInitialLaunchKey";

@implementation CRTOAppLaunchEvent

#pragma mark - Initializers

- (instancetype) init
{
    self = [super init];
    if ( self ) {
        [self detectFirstLaunch];
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

- (instancetype) initWithEvent:(CRTOAppLaunchEvent*)event
{
    self = [super initWithEvent:event];
    if ( self ) {
        _isFirstLaunch = event.isFirstLaunch;
    }
    return self;
}

- (instancetype) initWithFirstLaunchFlagOverride:(BOOL)isFirstLaunch
{
    self = [self init];

    _isFirstLaunch = isFirstLaunch;

    return self;
}

#pragma mark - Class Extension Properties

- (BOOL) isValid
{
    BOOL valid = YES;

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
