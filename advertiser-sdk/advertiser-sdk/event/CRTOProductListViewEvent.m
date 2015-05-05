//
//  CRTOProductListViewEvent.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "CRTOProductListViewEvent.h"
#import "CRTOProductListViewEvent+Internal.h"
#import "CRTOEvent+Internal.h"

@implementation CRTOProductListViewEvent

#pragma mark - Initializers

- (instancetype) init
{
    return [self initWithProducts:nil currency:nil startDate:nil endDate:nil];
}

- (instancetype) initWithProducts:(NSArray*)products
{
    return [self initWithProducts:products currency:nil startDate:nil endDate:nil];
}

- (instancetype) initWithProducts:(NSArray*)products currency:(NSString*)currency
{
    return [self initWithProducts:products currency:currency startDate:nil endDate:nil];
}

- (instancetype) initWithProducts:(NSArray*)products currency:(NSString*)currency startDate:(NSDate*)start endDate:(NSDate*)end
{
    self = [super initWithStartDate:start endDate:end];
    if ( self ) {
        if ( products ) {
            _products = [NSArray arrayWithArray:products];
        }

        if ( currency ) {
            _currency = [NSString stringWithString:currency];
        }
    }
    return self;
}

#pragma mark - Class Extension Initializers

- (instancetype) initWithEvent:(CRTOProductListViewEvent*)event
{
    self = [super initWithEvent:event];
    if ( self ) {
        if ( event.products ) {
            _products = [NSArray arrayWithArray:event.products];
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
    CRTOProductListViewEvent* eventCopy = [[CRTOProductListViewEvent alloc] initWithEvent:self];

    return eventCopy;
}

#pragma mark - Class Extension Properties

- (BOOL) isValid
{
    BOOL validity = YES;

    validity = validity && ( _products.count > 0);
    validity = validity && (_currency == nil /*|| isValidCurrency(_currency) */ );
    validity = validity && [super isValid];

    return validity;
}

@end
