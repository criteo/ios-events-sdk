//
//  CRTOProductListViewEvent.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "CRTOEvent.h"
#import "CRTOProduct.h"

@interface CRTOProductListViewEvent : CRTOEvent <NSCopying>

@property (nonatomic,copy) NSString* currency;
@property (nonatomic,copy) NSArray* products;

- (instancetype) init;
- (instancetype) initWithProducts:(NSArray*)products;
- (instancetype) initWithProducts:(NSArray*)products currency:(NSString*)currency;
- (instancetype) initWithProducts:(NSArray*)products currency:(NSString*)currency startDate:(NSDate*)start endDate:(NSDate*)end;

@end
