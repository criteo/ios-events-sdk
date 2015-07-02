//
//  CRTOBasketProduct.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @c CRTOBasketProduct is used to describe individual products contained in the @c CRTOBasketViewEvent and @c CRTOTransactionConfirmationEvent events.
 */
@interface CRTOBasketProduct : NSObject <NSCopying>

/** A string containing the product ID used to initialize the receiver. (read-only) */
@property (nonatomic,strong,readonly) NSString* productId;

/** A double value representing the approximate price used to initialize the receiver. (read-only) */
@property (nonatomic,readonly) double price;

/** A signed integer value representing the quantity of product used to initialize the receiver. (read-only) */
@property (nonatomic,readonly) NSInteger quantity;

/**
 *  Initializes a newly allocated instance of @c CRTOBasketProduct with an empty product ID and zero-valued price and quantity values.
 *
 *  @return A @c CRTOBasketProduct initialized with a @ nil product ID, a price of 0.0f, and a quantity of 0.
 */
- (instancetype) init;

/**
 *  Initializes a newly allocated instance of @c CRTOBasketProduct with a product ID, a price, and a quanity.
 *
 *  @param productId A string containing the product ID of the product. This value must match the product ID supplied to Criteo in your organization's catalog feed.
 *  @param price     The unit price of the product, represented as a double-precision floating-point value.
 *  @param quantity  An integer representing the number of units of product.
 *
 *  @note The loss of precision associated with representing price as a floating-point value does not impact Criteo's ability to process your event data.
 *
 *  @return A @c CRTOBasketProduct initialized with a product ID, a price, and a quantity.
 */
- (instancetype) initWithProductId:(NSString*)productId price:(double)price quantity:(NSInteger)quantity;

@end
