//
//  CRTOTransactionConfirmationEvent.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "CRTOTransactionConfirmationEvent.h"
#import "CRTOTransactionConfirmationEvent+Internal.h"
#import "CRTOEvent+Internal.h"

@implementation CRTOTransactionConfirmationEvent

#pragma mark - Initializers

- (instancetype) init
{
    return [self initWithBasketProducts:nil transactionId:nil currency:nil startDate:nil endDate:nil];
}

- (instancetype) initWithBasketProducts:(NSArray*)basketProducts
{
    return [self initWithBasketProducts:basketProducts transactionId:nil currency:nil startDate:nil endDate:nil];
}

- (instancetype) initWithBasketProducts:(NSArray*)basketProducts transactionId:(NSString*)transactionId
{
    return [self initWithBasketProducts:basketProducts transactionId:transactionId currency:nil startDate:nil endDate:nil];
}

- (instancetype) initWithBasketProducts:(NSArray*)basketProducts
                          transactionId:(NSString*)transactionId
                               currency:(NSString*)currency
{
    return [self initWithBasketProducts:basketProducts transactionId:transactionId currency:currency startDate:nil endDate:nil];
}

- (instancetype) initWithBasketProducts:(NSArray*)basketProducts
                          transactionId:(NSString*)transactionId
                               currency:(NSString*)currency
                              startDate:(NSDate*)start
                                endDate:(NSDate*)end
{
    self = [super initWithStartDate:start endDate:end];
    if ( self ) {
        if ( basketProducts ) {
            _basketProducts = [NSArray arrayWithArray:basketProducts];
        }

        if ( currency ) {
            _currency = [NSString stringWithString:currency];
        }

        if ( transactionId ) {
            _transactionId = [NSString stringWithString:transactionId];
        }
    }
    return self;
}

#pragma mark - Class Extension Initializers

- (instancetype) initWithEvent:(CRTOTransactionConfirmationEvent*)event
{
    self = [super initWithEvent:event];
    if ( self ) {
        if ( event.basketProducts ) {
            _basketProducts = [NSArray arrayWithArray:event.basketProducts];
        }

        if ( event.currency ) {
            _currency = [NSString stringWithString:event.currency];
        }

        if ( event.transactionId ) {
            _transactionId = [NSString stringWithString:event.transactionId];
        }
    }
    return self;
}

#pragma mark - NSCopying

- (instancetype) copyWithZone:(NSZone*)zone
{
    CRTOTransactionConfirmationEvent* eventCopy = [[CRTOTransactionConfirmationEvent alloc] initWithEvent:self];

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
