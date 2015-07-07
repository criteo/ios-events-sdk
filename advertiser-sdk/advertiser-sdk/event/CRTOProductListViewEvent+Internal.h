//
//  CRTOProductListViewEvent+Internal.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

@interface CRTOProductListViewEvent ()

@property (nonatomic,readonly) BOOL isValid;

- (instancetype) initWithEvent:(CRTOProductListViewEvent*)event;

- (NSArray*) arrayOfProductsFromArray:(NSArray*)array;

@end