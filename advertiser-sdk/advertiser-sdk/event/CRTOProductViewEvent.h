//
//  CRTOProductViewEvent.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "CRTOEvent.h"
#import "CRTOProduct.h"

@interface CRTOProductViewEvent : CRTOEvent <NSCopying>

@property (nonatomic,copy) NSString* currency;
@property (nonatomic,copy) CRTOProduct* product;

- (instancetype) init;
- (instancetype) initWithProduct:(CRTOProduct*)product;
- (instancetype) initWithProduct:(CRTOProduct*)product currency:(NSString*)currency;
- (instancetype) initWithProduct:(CRTOProduct*)product currency:(NSString*)currency startDate:(NSDate*)start endDate:(NSDate*)end;

@end
