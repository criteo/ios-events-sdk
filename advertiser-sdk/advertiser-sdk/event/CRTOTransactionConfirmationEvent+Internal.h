//
//  CRTOTransactionConfirmationEvent+Internal.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

@interface CRTOTransactionConfirmationEvent ()

@property (nonatomic,readonly) BOOL isValid;

- (instancetype) initWithEvent:(CRTOTransactionConfirmationEvent*)event;

@end
