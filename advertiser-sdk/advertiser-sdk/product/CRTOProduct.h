//
//  CRTOProduct.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @c CRTOProduct is used to describe individual products containted in the @c CRTOProductViewEvent and @c CRTOProductListViewEvent events.
 */
@interface CRTOProduct : NSObject <NSCopying>

/** A string containing the product ID used to initialize the receiver. (read-only) */
@property (nonatomic,strong,readonly) NSString* productId;

/** A float value representing the approximate price used to initialize the receiver. (read-only) */
@property (nonatomic,readonly) float price;

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
 *  @param price     The unit price of the product, represented as a single-precision floating-point value.
 *
 *  @note The loss of precision associated with representing price as a floating-point value does not impact Criteo's ability to process your event data.
 *
 *  @return A @c CRTOProduct initialized with a product ID and a price.
 */
- (instancetype) initWithProductId:(NSString*)productId price:(float)price;

@end
