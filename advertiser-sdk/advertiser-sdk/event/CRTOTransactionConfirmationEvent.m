//
//  CRTOTransactionConfirmationEvent.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <CriteoAdvertiser/CRTOTransactionConfirmationEvent.h>
#import <CriteoAdvertiser/CRTOBasketProduct.h>
#import "CRTOTransactionConfirmationEvent+Internal.h"
#import "CRTOEvent+Internal.h"

@implementation CRTOTransactionConfirmationEvent

#pragma mark - Properties

- (void) setBasketProducts:(NSArray*)basketProducts
{
    if ( basketProducts ) {
        NSArray* basketProductsCopy = [NSArray arrayWithArray:basketProducts];
        _basketProducts = [self arrayOfBasketProductsFromArray:basketProductsCopy];
    } else {
        _basketProducts = nil;
    }
}

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
                              startDate:(NSDateComponents*)start
                                endDate:(NSDateComponents*)end
{
    self = [super initWithStartDate:start endDate:end];
    if ( self ) {
        if ( basketProducts ) {
            self.basketProducts = basketProducts;
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

#pragma mark - Class Extension Methods

- (NSArray*) arrayOfBasketProductsFromArray:(NSArray*)array
{
    NSIndexSet* indexes = [array indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL* stop) {
        return [obj isKindOfClass:[CRTOBasketProduct class]];
    }];

    NSArray* result = [array objectsAtIndexes:indexes];

    return result;
}

@end
