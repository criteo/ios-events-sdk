//
//  CRTOProductListViewEvent.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <CriteoAdvertiser/CRTOEvent.h>
#import <CriteoAdvertiser/CRTOProduct.h>

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
- (instancetype) initWithProducts:(NSArray*)products currency:(NSString*)currency startDate:(NSDate*)start endDate:(NSDate*)end;

@end
