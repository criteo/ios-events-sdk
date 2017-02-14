//
//  CRTOProductViewEvent.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "CRTOProductViewEvent.h"
#import "CRTOProductViewEvent+Internal.h"
#import "CRTOEvent+Internal.h"

@implementation CRTOProductViewEvent

#pragma mark - Initializers

- (instancetype) init
{
    return [self initWithProduct:nil currency:nil startDate:nil endDate:nil];
}

- (instancetype) initWithProduct:(CRTOProduct*)product
{
    return [self initWithProduct:product currency:nil startDate:nil endDate:nil];
}

- (instancetype) initWithProduct:(CRTOProduct*)product currency:(NSString*)currency
{
    return [self initWithProduct:product currency:currency startDate:nil endDate:nil];
}

- (instancetype) initWithProduct:(CRTOProduct*)product currency:(NSString*)currency startDate:(NSDateComponents*)start endDate:(NSDateComponents*)end
{
    self = [super initWithStartDate:start endDate:end];
    if ( self ) {
        _product = [product copy];

        if ( currency ) {
            _currency = [NSString stringWithString:currency];
        }
    }
    return self;
}

#pragma mark - Class Extension Initializers

- (instancetype) initWithEvent:(CRTOProductViewEvent*)event
{
    self = [super initWithEvent:event];
    if ( self ) {
        _product = [event.product copy];
        _currency = event.currency;
    }
    return self;
}

#pragma mark - NSCopying

- (instancetype) copyWithZone:(NSZone*)zone
{
    CRTOProductViewEvent* eventCopy = [[CRTOProductViewEvent alloc] initWithEvent:self];

    return eventCopy;
}

#pragma mark - Class Extension Properties

- (BOOL) isValid
{
    BOOL validity = YES;

    validity = validity && (_product != nil);
    validity = validity && (_currency == nil /*|| isValidCurrency(_currency) */ );
    validity = validity && [super isValid];

    return validity;
}

@end
