//
//  CRTOAppLaunchEvent.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <CriteoAdvertiser/CRTOEvent.h>

/**
 *  Key used to store the app's initial launch state in @c [NSUserDefaults standardUserDefaults].
 */
FOUNDATION_EXPORT NSString* const kCRTOInitialLaunchKey;

/**
 *  @c CRTOAppLaunchEvent is a concrete subclass of @c CRTOEvent used to describe an App Launch event.
 */
@interface CRTOAppLaunchEvent : CRTOEvent <NSCopying>

/**
 *  A string containing the Deeplink launch URL supplied to the @c initWithDeeplinkLaunchUrl: initializer.
 */
@property (nonatomic,strong,readonly) NSString* deeplinkLaunchUrl;

/**
 *  Initializes a newly allocated app launch event with the @c deeplinkLaunchUrl property set to @i nil.
 *
 *  @return A @c CRTOAppLaunchEvent initialized with a nil @c deeplinkLaunchUrl.
 */
- (instancetype) init;

/**
 *  Initializes a newly allocated app launch event with a deeplink launch URL.
 *
 *  @param url An instance of @c NSString containing the deeplink used to invoke the app.
 *
 *  @return A @c CRTOAppLaunchEvent containing a deeplink launch URL.
 */
- (instancetype) initWithDeeplinkLaunchUrl:(NSString*)url;

@end
