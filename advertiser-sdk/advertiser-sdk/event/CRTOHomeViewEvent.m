//
//  CRTOHomeViewEvent.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "CRTOHomeViewEvent.h"
#import "CRTOHomeViewEvent+Internal.h"
#import "CRTOEvent+Internal.h"

@implementation CRTOHomeViewEvent

#pragma marl - NSCopying

- (instancetype) copyWithZone:(NSZone*)zone
{
    CRTOHomeViewEvent* eventCopy = [[CRTOHomeViewEvent alloc] initWithEvent:self];

    return eventCopy;
}

#pragma mark - Class Extension Properties

- (BOOL) isValid
{
    return [super isValid];
}

@end
