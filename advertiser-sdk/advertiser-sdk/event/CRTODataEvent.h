//
//  CRTODataEvent.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "CRTOEvent.h"

/**
 *  @CRTODataEvent is a concrete subclass of @c CRTOEvent used to describe custom data values.
 *
 *  @note You should only use this class to send Extra Data parameters to Criteo when they are not related to a more specific @c CRTOEvent subclass.
 */
@interface CRTODataEvent : CRTOEvent <NSCopying>

@end
