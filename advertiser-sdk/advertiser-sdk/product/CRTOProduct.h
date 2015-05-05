//
//  CRTOCatalogProduct.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRTOProduct : NSObject <NSCopying>

@property (nonatomic,strong,readonly) NSString* productId;
@property (nonatomic,readonly) float price;

- (instancetype) init;
- (instancetype) initWithProductId:(NSString*)productId price:(float)price;

@end
