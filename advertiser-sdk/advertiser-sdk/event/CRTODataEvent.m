//
//  CRTODataEvent.m
//  advertiser-sdk
//
//  Created by Paul Davis on 5/5/15.
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "CRTODataEvent.h"
#import "CRTODataEvent+Internal.h"
#import "CRTOEvent+Internal.h"

@implementation CRTODataEvent

#pragma mark - NSCopying

- (instancetype) copyWithZone:(NSZone*)zone
{
    CRTODataEvent* eventCopy = [[CRTODataEvent alloc] initWithEvent:self];

    return eventCopy;
}

#pragma mark - Class Extension Properties

- (BOOL) isValid
{
    return [super isValid];
}

@end
