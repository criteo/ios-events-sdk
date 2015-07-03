//
//  CRTOAppLaunchEvent+Internal.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

@interface CRTOAppLaunchEvent ()

@property (nonatomic,readonly) BOOL isFirstLaunch;
@property (nonatomic,readonly) BOOL isValid;

- (instancetype) initWithEvent:(CRTOAppLaunchEvent*)event;
- (instancetype) initWithFirstLaunchFlagOverride:(BOOL)isFirstLaunch;

- (void) detectFirstLaunch;

@end
