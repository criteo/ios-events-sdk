//
//  CRTOBasketViewEvent+Internal.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

@interface CRTOBasketViewEvent ()

@property (nonatomic,readonly) BOOL isValid;

- (instancetype) initWithEvent:(CRTOBasketViewEvent*)event;

- (NSArray*) arrayOfBasketProductsFromArray:(NSArray*)array;

@end
