//
//  CRTOProductViewEvent.m
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
