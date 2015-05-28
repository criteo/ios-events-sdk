//
//  CRTOProduct.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "CRTOProduct.h"

@implementation CRTOProduct

#pragma mark - Initializers

- (instancetype) init
{
    return [self initWithProductId:nil price:0.0f];
}

- (instancetype) initWithProductId:(NSString*)productId price:(float)price
{
    self = [super init];
    if ( self ) {
        if ( productId ) {
            _productId = [NSString stringWithString:productId];
        }

        _price = price;
    }
    return self;
}

#pragma mark - NSCopying

- (instancetype) copyWithZone:(NSZone*)zone
{
    return self;
}

@end
