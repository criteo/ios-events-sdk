//
//  CRTODeeplinkEvent.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "CRTOEvent.h"

/**
 *  @c CRTODeeplinkEvent is a concrete subclass of @c CRTOEvent used to describe deeplink events that occur in your app.
 */
@interface CRTODeeplinkEvent : CRTOEvent <NSCopying>

/**
 *  A string containing the Deeplink launch URL supplied to the @c initWithDeeplinkLaunchUrl: initializer.
 */
@property (nonatomic,strong,readonly) NSString* deeplinkLaunchUrl;

/**
 *  Initializes a newly allocated deeplink event with the @c deeplinkLaunchUrl property set to @i nil.
 *
 *  @return A @c CRTODeeplinkEvent initialized with a nil @c deeplinkLaunchUrl.
 */
- (instancetype) init;

/**
 *  Initializes a newly allocated deeplink event with a deeplink launch URL.
 *
 *  @param url An instance of @c NSString containing the deeplink sent to your app.
 *
 *  @return A @c CRTODeeplinkEvent containing a deeplink launch URL.
 */
- (instancetype) initWithDeeplinkLaunchUrl:(NSString*)url;

@end
