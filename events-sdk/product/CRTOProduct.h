//
//  CRTOProduct.h
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

#import <Foundation/Foundation.h>

/**
 *  @c CRTOProduct is used to describe individual products containted in the @c CRTOProductViewEvent and @c CRTOProductListViewEvent events.
 */
@interface CRTOProduct : NSObject <NSCopying>

/** A string containing the product ID used to initialize the receiver. (read-only) */
@property (nonatomic,strong,readonly) NSString* productId;

/** A double value representing the approximate price used to initialize the receiver. (read-only) */
@property (nonatomic,readonly) double price;

/**
 *  Initializes a newly allocated instance of @c CRTOProduct with an empty product ID and zero-valued price.
 *
 *  @return A @c CRTOProduct initialized with @a nil product ID and a price of 0.0f.
 */
- (instancetype) init;

/**
 *  Initializes a newly allocated instance of @c CRTOProduct with a product ID and a price.
 *
 *  @param productId A string containing the product ID of the product. This value must match the product ID supplied to Criteo in your organization's catalog feed.
 *  @param price     The unit price of the product, represented as a double-precision floating-point value.
 *
 *  @note The loss of precision associated with representing price as a floating-point value does not impact Criteo's ability to process your event data.
 *
 *  @return A @c CRTOProduct initialized with a product ID and a price.
 */
- (instancetype) initWithProductId:(NSString*)productId price:(double)price;

@end
