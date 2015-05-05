//
//  CRTOAppLaunchEvent.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "CRTOEvent.h"

FOUNDATION_EXPORT NSString* const kCRTOInitialLaunchKey;

@interface CRTOAppLaunchEvent : CRTOEvent <NSCopying>

@property (nonatomic,strong,readonly) NSString* deeplinkLaunchUrl;

- (instancetype) init;
- (instancetype) initWithDeeplinkLaunchUrl:(NSString*)url;

@end
