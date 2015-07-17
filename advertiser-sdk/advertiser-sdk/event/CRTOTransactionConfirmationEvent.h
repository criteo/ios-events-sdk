//
//  CRTOTransactionConfirmationEvent.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <CriteoAdvertiser/CRTOEvent.h>

/**
 *  @c CRTOTransactionConfirmationEvent is a concrete subclass of @c CRTOEvent used to confirm a purchase event.
 */
@interface CRTOTransactionConfirmationEvent : CRTOEvent <NSCopying>

/** Array of @c CRTOBasketProduct containing the products purchased during this transaction. */
@property (nonatomic,copy) NSArray* basketProducts;

/** The 3 letter ISO-4217 code representing the currency in which this transaction was made. */
@property (nonatomic,copy) NSString* currency;

/** A string containing your organization's unique identifier for this transaction. */
@property (nonatomic,copy) NSString* transactionId;

/**
 *  Initializes a newly allocated transaction confirmation event with the @c basketProducts, @c currency, and @c transactionId properties set to nil.
 *
 *  @return A @CRTOTransactionConfirmationEvent initialized with a nil product array, a nil currency, and a nil transaction identifier.
 */
- (instancetype) init;

/**
 *  Initializes a newly allocated transaction confirmation event with an array of @c CRTOBasketProduct.
 *
 *  @param basketProducts An array of @c CRTOBasketProduct that will be copied into the event.
 *
 *  @return A @c CRTOTransactionConfirmationEvent initialized with an array of @c CRTOBasketProduct, a nil currency, and a nil transaction identifier.
 */
- (instancetype) initWithBasketProducts:(NSArray*)basketProducts;

/**
 *  Initializes a newly allocated transaction confirmation event with an array of @c CRTOBasketProduct and a transaction identifier.
 *
 *  @param basketProducts An array of @c CRTOBasketProduct that will be copied into the event.
 *  @param transactionId  The unique identifier for this transaction.
 *
 *  @return A @c CRTOTransactionConfirmationEvent initialized with an array of @c CRTOBasketProduct, a transaction identifier, and a nil currency.
 */
- (instancetype) initWithBasketProducts:(NSArray*)basketProducts transactionId:(NSString*)transactionId;

/**
 *  Initializes a newly allocated transaction confirmation event with an array of @c CRTOBasketProduct, a transaction identifier, and a currency.
 *
 *  @param basketProducts An array of @c CRTOBasketProduct that will be copied into the event.
 *  @param transactionId  The unique identifier for this transaction.
 *  @param currency       Three letter ISO-4217 currency code representing the currency of this event.
 *
 *  @return A @c CRTOTransactionConfirmationEvent initialized with an array of @c CRTOBasketProduct, a transaction identifier, and a currency.
 */
- (instancetype) initWithBasketProducts:(NSArray*)basketProducts
                          transactionId:(NSString*)transactionId
                               currency:(NSString*)currency;

/**
 *  Initializes a newly allocated transaction confirmation event with an array of @c CRTOBasketProduct, a transaction identifier, a currency, a start date, and an end date.
 *
 *  @param basketProducts An array of @c CRTOBasketProduct that will be copied into the event.
 *  @param transactionId  The unique identifier for this transaction.
 *  @param currency       Three letter ISO-4217 currency code representing the currency of this event.
 *  @param start          Optional start date parameter. Pass nil if there is no start date associated with this transaction.
 *  @param end            Optional end date parameter. Pass nil if there is no end date associated with this transaction.
 *
 *  @return A @c CRTOTransactionConfirmationEvent initialized with an array of @c CRTOBasketProduct, a transaction identifier, a currency, a start date, and an end date.
 */
- (instancetype) initWithBasketProducts:(NSArray*)basketProducts
                          transactionId:(NSString*)transactionId
                               currency:(NSString*)currency
                              startDate:(NSDateComponents*)start
                                endDate:(NSDateComponents*)end;

@end
