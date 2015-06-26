//
//  CRTODeeplinkEvent.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <CriteoAdvertiser/CRTODeeplinkEvent.h>
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
