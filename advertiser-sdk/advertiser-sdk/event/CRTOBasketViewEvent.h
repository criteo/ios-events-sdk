//
//  CRTOBasketViewEvent.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "CRTOEvent.h"

@interface CRTOBasketViewEvent : CRTOEvent <NSCopying>

@property (nonatomic,copy) NSString* currency;
@property (nonatomic,copy) NSArray* basketProducts;

- (instancetype) init;
- (instancetype) initWithBasketProducts:(NSArray*)basketProducts;
- (instancetype) initWithBasketProducts:(NSArray*)basketProducts currency:(NSString*)currency;
- (instancetype) initWithBasketProducts:(NSArray*)basketProducts currency:(NSString*)currency startDate:(NSDate*)start endDate:(NSDate*)end;

@end
