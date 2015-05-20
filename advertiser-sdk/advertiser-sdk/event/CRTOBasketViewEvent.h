//
//  CRTOBasketViewEvent.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "CRTOEvent.h"

/**
 *  @c CRTOBasketViewEvent is a concrete subclass of @c CRTOEvent used to describe a Basket View event.
 */
@interface CRTOBasketViewEvent : CRTOEvent <NSCopying>

/** Array of @c CRTOBasketProduct containing the products viewed during this event. */
@property (nonatomic,copy) NSArray* basketProducts;

/** The 3 letter ISO-4217 code representing the currency of products in this basket. */
@property (nonatomic,copy) NSString* currency;

/**
 *  Initializes a newly allocated basket view event with the @c basketProducts and @c currency properties set to nil.
 *
 *  @return A @c CRTOBasketViewEvent initialized with a nil product array and a nil currency.
 */
- (instancetype) init;

/**
 *  Initializes a newly allocated basket view event with an array of @c CRTOBasketProduct.
 *
 *  @param basketProducts An array of @c CRTOBasketProduct that will be copied into the event.
 *
 *  @return A @c CRTOBasketViewEvent initialized with an array of @c CRTOBasketProduct and a nil currency.
 */
- (instancetype) initWithBasketProducts:(NSArray*)basketProducts;

/**
 *  Initializes a newly allocated basket view event with an array of @c CRTOBasketProduct and a currency.
 *
 *  @param basketProducts An array of @c CRTOBasketProduct that will be copied into the event.
 *  @param currency       Three letter ISO-4217 currency code representing the currency of the basket.
 *
 *  @return A @c CRTOBasketViewEvent initialized with an array of @c CRTOBasketProduct and a currency.
 */
- (instancetype) initWithBasketProducts:(NSArray*)basketProducts currency:(NSString*)currency;

/**
 *  Initializes a newly allocated basket view event with an array of @c CRTOBasketProduct, a currency, a start date, and an end date.
 *
 *  @param basketProducts An array of @c CRTOBasketProduct that will be copied into the event.
 *  @param currency       Three letter ISO-4217 currency code representing the currency of the basket.
 *  @param start          Optional start date parameter. Pass nil if there is no start date associated with this basket.
 *  @param end            Optional end date parameter. Pass nil if there is no end date associated with this basket.
 *
 *  @return A @c CRTOBasketViewEvent initialized with an array of @c CRTOBasketProduct, a currency, a start date, and an end date.
 */
- (instancetype) initWithBasketProducts:(NSArray*)basketProducts currency:(NSString*)currency startDate:(NSDate*)start endDate:(NSDate*)end;

@end
