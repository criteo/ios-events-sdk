//
//  CRTOBasketProduct.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRTOBasketProduct : NSObject <NSCopying>

@property (nonatomic,strong,readonly) NSString* productId;
@property (nonatomic,readonly) float price;
@property (nonatomic,readonly) int64_t quantity;

- (instancetype) init;
- (instancetype) initWithProductId:(NSString*)productId price:(float)price quantity:(int64_t)quantity;

@end
