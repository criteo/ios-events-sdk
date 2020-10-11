//
//  CRTOProductViewEvent.h
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
 *  @c CRTOProductViewEvent is a concrete subclass of @c CRTOEvent used to describe a product view event.
 */
@interface CRTOProductViewEvent : CRTOEvent <NSCopying>

/** The 3 letter ISO-4217 code representing the currency of the product in this event. */
@property (nonatomic,copy) NSString* currency;

/** An instance of @c CRTOProduct describing the product viewed by the user. */
@property (nonatomic,copy) CRTOProduct* product;

/**
 *  Initializes a newly allocated instance of @c CRTOProductViewEvent with the @c currency and @c product properties set to @a nil.
 *
 *  @return A @c CRTOProductViewEvent initialized with a @a nil currency and a @a nil product.
 */
- (instancetype) init;

/**
 *  Initializes a newly allocated instance of @c CRTOProductViewEvent with a product.
 *
 *  @param product A @c CRTOProduct describing the product viewed by the user.
 *
 *  @return A @c CRTOProductViewEvent initialized with a product and a @a nil currency.
 */
- (instancetype) initWithProduct:(CRTOProduct*)product;

/**
 *  Initializes a newly allocated instance of @c CRTOProductViewEvent with a product and a currency.
 *
 *  @param product  A @c CRTOProduct describing the product viewed by the user.
 *  @param currency Three letter ISO-4217 currency code representing the currency of the product.
 *
 *  @return A @c CRTOProductViewEvent initialized with a product and a currency.
 */
- (instancetype) initWithProduct:(CRTOProduct*)product currency:(NSString*)currency;

/**
 *  Initializes a newly allocated instance of @c CRTOProductViewEvent with a product, a currency, a start date, and an end date.
 *
 *  @param product  A @c CRTOProduct describing the product viewed by the user.
 *  @param currency Three letter ISO-4217 currency code representing the currency of the product.
 *  @param start    Optional start date parameter. Pass nil if there is no start date associated with this event.
 *  @param end      Optional end date parameter. Pass nil if there is no end date associated with this event.
 *
 *  @return A @c CRTOProductViewEvent initialized with a product, a currency, a start date, and an end date.
 */
- (instancetype) initWithProduct:(CRTOProduct*)product currency:(NSString*)currency startDate:(NSDateComponents*)start endDate:(NSDateComponents*)end;

@end
