//
//  CRTOAppLaunchEvent.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "CRTOEvent.h"

/**
 *  Key used to store the app's initial launch state in @c [NSUserDefaults standardUserDefaults].
 */
FOUNDATION_EXPORT NSString* const kCRTOInitialLaunchKey;

/**
 *  @c CRTOAppLaunchEvent is a concrete subclass of @c CRTOEvent used to describe an App Launch event.
 */
@interface CRTOAppLaunchEvent : CRTOEvent <NSCopying>

/**
 *  Initializes a newly allocated app launch event.
 *
 *  @return A @c CRTOAppLaunchEvent.
 */
- (instancetype) init;

@end
