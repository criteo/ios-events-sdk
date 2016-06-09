//
//  CRTOSDKInfo.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "CRTOSDKInfo.h"

#define CRTOSDKVersionString_1_0_0   (@"1.0.0")
#define CRTOSDKVersionString_1_0_4   (@"1.0.4")
#define CRTOSDKVersionString_1_1_0   (@"1.1.0")
//#define CRTOSDKVersionString_1_0_0   (@"YourSDK.VersionString.Here")

#define CRTOSDKVersionString_Current CRTOSDKVersionString_1_1_0

@interface CRTOSDKInfo ()

- (void) setupSDKInfo;

@end

@implementation CRTOSDKInfo

#pragma mark - Initializers

- (instancetype) init
{
    self = [super init];
    if ( self ) {
        [self setupSDKInfo];
    }
    return self;
}

#pragma mark - Static Methods

+ (instancetype) sharedSDKInfo
{
    static dispatch_once_t onceToken;
    static CRTOSDKInfo* sdkInfo;

    dispatch_once(&onceToken, ^{
        sdkInfo = [[CRTOSDKInfo alloc] init];
    });

    return sdkInfo;
}

#pragma mark - Class Extension Methods

- (void) setupSDKInfo
{
    _sdkVersion = CRTOSDKVersionString_Current;
}

@end
