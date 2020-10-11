//
//  CRTOBasketViewEvent.m
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

#import "CRTOBasketViewEvent.h"
#import "CRTOBasketProduct.h"
#import "CRTOBasketViewEvent+Internal.h"
#import "CRTOEvent+Internal.h"

@implementation CRTOBasketViewEvent

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

- (instancetype) initWithBasketProducts:(NSArray*)basketProducts currency:(NSString*)currency startDate:(NSDateComponents*)start endDate:(NSDateComponents*)end
{
    self = [super initWithStartDate:start endDate:end];
    if ( self ) {
        if ( basketProducts ) {
            self.basketProducts = basketProducts;
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
