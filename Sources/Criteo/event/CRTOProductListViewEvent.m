//
//  CRTOProductListViewEvent.m
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

#import "CRTOProductListViewEvent.h"
#import "CRTOProductListViewEvent+Internal.h"
#import "CRTOEvent+Internal.h"

@implementation CRTOProductListViewEvent

#pragma mark - Properties

- (void) setProducts:(NSArray*)products
{
    if ( products ) {
        NSArray* productsCopy = [NSArray arrayWithArray:products];
        _products = [self arrayOfProductsFromArray:productsCopy];
    } else {
        _products = nil;
    }
}

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

- (instancetype) initWithProducts:(NSArray*)products currency:(NSString*)currency startDate:(NSDateComponents*)start endDate:(NSDateComponents*)end
{
    self = [super initWithStartDate:start endDate:end];
    if ( self ) {
        if ( products ) {
            self.products = products;
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

#pragma mark - Class Extension Methods

- (NSArray*) arrayOfProductsFromArray:(NSArray*)array
{
    NSIndexSet* indexes = [array indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL* stop) {
        return [obj isKindOfClass:[CRTOProduct class]];
    }];

    NSArray* result = [array objectsAtIndexes:indexes];

    return result;
}

@end
