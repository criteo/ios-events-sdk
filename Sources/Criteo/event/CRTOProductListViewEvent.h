//
//  CRTOProductListViewEvent.h
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

#import "CRTOEvent.h"
#import "CRTOProduct.h"

/**
 *  @c CRTOProductListViewEvent is a concrete subclass of @c CRTOEvent used to describe a product list view event.
 */
@interface CRTOProductListViewEvent : CRTOEvent <NSCopying>

/** Array of @c CRTOProduct containing the products viewed during this event. */
@property (nonatomic,copy) NSArray* products;

/** The 3 letter ISO-4217 code representing the currency of products in this event. */
@property (nonatomic,copy) NSString* currency;

/**
 *  Initializes a newly allocated product list view event with the @c products and @c currency properties set to nil.
 *
 *  @return A @c CRTOProductListViewEvent with an nil product array and a nil currency.
 */
- (instancetype) init;

/**
 *  Initializes a newly allocated product list view event with an array of @c CRTOProduct.
 *
 *  @param products An array of @c CRTOProduct that will be copied into the event.
 *
 *  @return A @c CRTOProductListViewEvent initialized with an array of @c CRTOProduct and a nil currency.
 */
- (instancetype) initWithProducts:(NSArray*)products;

/**
 *  Initializes a newly allocated product list view event with an array of @c CRTOProduct and a currency.
 *
 *  @param products An array of @c CRTOProduct that will be copied into the event.
 *  @param currency Three letter ISO-4217 currency code representing the currency of list.
 *
 *  @return A @c CRTOProductListViewEvent initialized with an array of @c CRTOProduct and a currency.
 */
- (instancetype) initWithProducts:(NSArray*)products currency:(NSString*)currency;

/**
 *  Initializes a newly allocated product list view event with an array of @c CRTOProduct, a currency, a start date, and an end date.
 *
 *  @param products An array of @c CRTOProduct that will be copied into the event.
 *  @param currency Three letter ISO-4217 currency code representing the currency of the list.
 *  @param start    Optional start date parameter. Pass nil if there is no start date associated with this list.
 *  @param end      Optional end date parameter. Pass nil if there is no end date associated with this list.
 *
 *  @return A @c CRTOProductListViewEvent initialized with an array of @c CRTOProduct, a currency, a start date, and an end date.
 */
- (instancetype) initWithProducts:(NSArray*)products currency:(NSString*)currency startDate:(NSDateComponents*)start endDate:(NSDateComponents*)end;

@end
