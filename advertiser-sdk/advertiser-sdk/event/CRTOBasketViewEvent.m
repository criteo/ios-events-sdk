//
//  CRTOBasketViewEvent.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <CriteoAdvertiser/CRTOBasketViewEvent.h>
#import "CRTOBasketViewEvent+Internal.h"
#import "CRTOEvent+Internal.h"

@implementation CRTOBasketViewEvent

#pragma mark - Initializers

- (instancetype) init
{
    return [self initWithBasketProducts:nil currency:nil startDate:nil endDate:nil];
}

- (instancetype) initWithBasketProducts:(NSArray*)basketProducts
{
    return [self initWithBasketProducts:basketProducts currency:nil startDate:nil endDate:nil];
}

- (instancetype) initWithBasketProducts:(NSArray*)basketProducts currency:(NSString*)currency
{
    return [self initWithBasketProducts:basketProducts currency:currency startDate:nil endDate:nil];
}

- (instancetype) initWithBasketProducts:(NSArray*)basketProducts currency:(NSString*)currency startDate:(NSDate*)start endDate:(NSDate*)end
{
    self = [super initWithStartDate:start endDate:end];
    if ( self ) {
        if ( basketProducts ) {
            _basketProducts = [NSArray arrayWithArray:basketProducts];
        }

        if ( currency ) {
            _currency = [NSString stringWithString:currency];
        }
    }
    return self;
}

#pragma mark - Class Extension Initializers

- (instancetype) initWithEvent:(CRTOBasketViewEvent*)event
{
    self = [super initWithEvent:event];
    if ( self ) {
        if ( event.basketProducts ) {
            _basketProducts = [NSArray arrayWithArray:event.basketProducts];
        }

        if ( event.currency ) {
            _currency = [NSString stringWithString:event.currency];
        }
    }
    return self;
}

#pragma mark - NSCopying

- (instancetype) copyWithZone:(NSZone*)zone
{
    CRTOBasketViewEvent* eventCopy = [[CRTOBasketViewEvent alloc] initWithEvent:self];

    return eventCopy;
}

#pragma mark - Class Extension Properties

- (BOOL) isValid
{
    BOOL validity = YES;

    validity = validity && ( _basketProducts.count > 0);
    validity = validity && ( _currency == nil /* || isValidCurrency(_currency) */ );
    validity = validity && [super isValid];

    return validity;
}

@end
