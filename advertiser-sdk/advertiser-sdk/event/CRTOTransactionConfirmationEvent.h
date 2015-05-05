//
//  CRTOTransactionConfirmationEvent.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "CRTOEvent.h"

@interface CRTOTransactionConfirmationEvent : CRTOEvent <NSCopying>

@property (nonatomic,copy) NSString* currency;
@property (nonatomic,copy) NSArray* basketProducts;
@property (nonatomic,copy) NSString* transactionId;

- (instancetype) init;

- (instancetype) initWithBasketProducts:(NSArray*)basketProducts;

- (instancetype) initWithBasketProducts:(NSArray*)basketProducts transactionId:(NSString*)transactionId;

- (instancetype) initWithBasketProducts:(NSArray*)basketProducts
                          transactionId:(NSString*)transactionId
                               currency:(NSString*)currency;

- (instancetype) initWithBasketProducts:(NSArray*)basketProducts
                          transactionId:(NSString*)transactionId
                               currency:(NSString*)currency
                              startDate:(NSDate*)start
                                endDate:(NSDate*)end;

@end
