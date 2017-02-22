//
//  CRTOTransactionConfirmationEvent.m
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

#import "CRTOTransactionConfirmationEvent.h"
#import "CRTOBasketProduct.h"
#import "CRTOTransactionConfirmationEvent+Internal.h"
#import "CRTOEvent+Internal.h"
#import "CRTOJSONConstants.h"

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

- (BOOL) deduplication
{
    CRTOExtraData* deduplication = [self getExtraDataForKey:kCRTOJSONUniversalTagParametersHelperDeduplicationKey];
    if(deduplication == nil)
    {
        return false;
    }
    if(deduplication.type != CRTOExtraDataTypeInteger)
    {
        return false;
    }
    NSNumber* ddValue = deduplication.value;
    return ddValue.boolValue;
}

- (void) setDeduplication:(BOOL)deduplication
{
    [self setIntegerExtraData:deduplication ForKey:kCRTOJSONUniversalTagParametersHelperDeduplicationKey];
}

- (BOOL) newCustomer
{
    CRTOExtraData* newCustomer = [self getExtraDataForKey:kCRTOJSONUniversalTagParametersHelperNew_CustomerKey];

    if (newCustomer == nil) {
        return false;
    }

    if (newCustomer.type != CRTOExtraDataTypeInteger) {
        return false;
    }

    NSNumber* newCustomerValue = newCustomer.value;

    return newCustomerValue.boolValue;
}

- (void) setNewCustomer:(BOOL)newCustomer
{
    [self setIntegerExtraData:newCustomer ForKey:kCRTOJSONUniversalTagParametersHelperNew_CustomerKey];
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
