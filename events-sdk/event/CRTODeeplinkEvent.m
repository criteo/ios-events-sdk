//
//  CRTODeeplinkEvent.m
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

#import "CRTODeeplinkEvent.h"
#import "CRTODeeplinkEvent+Internal.h"
#import "CRTOEvent+Internal.h"

@implementation CRTODeeplinkEvent

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
        }
    }
    return self;
}

#pragma mark - NSCopying

- (instancetype) copyWithZone:(NSZone*)zone
{
    CRTODeeplinkEvent* eventCopy = [[CRTODeeplinkEvent alloc] initWithEvent:self];

    eventCopy->_deeplinkLaunchUrl = self.deeplinkLaunchUrl;

    return eventCopy;
}

#pragma mark - Class Extension Properties

- (BOOL) isValid
{
    BOOL valid = YES;

    valid = valid && [super isValid];

    return valid;
}

@end
