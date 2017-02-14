//
//  CRTOProductViewEvent+Internal.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

@interface CRTOProductViewEvent ()

@property (nonatomic,readonly) BOOL isValid;

- (instancetype) initWithEvent:(CRTOProductViewEvent*)event;

@end
