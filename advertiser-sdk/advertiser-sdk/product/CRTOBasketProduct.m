//
//  CRTOBasketProduct.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "CRTOBasketProduct.h"

@implementation CRTOBasketProduct

#pragma mark - Initializers

- (instancetype) init
{
    return [self initWithProductId:nil price:0.0f quantity:0];
}

- (instancetype) initWithProductId:(NSString*)productId price:(float)price quantity:(NSInteger)quantity
{
    self = [super init];
    if ( self ) {
        if ( productId ) {
            _productId = [NSString stringWithString:productId];
        }

        _price = price;
        _quantity = quantity;
    }
    return self;
}

#pragma mark - NSCopying

- (instancetype) copyWithZone:(NSZone*)zone
{
    return self;
}

@end
