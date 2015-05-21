//
//  CRTOSDKInfo.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "CRTOSDKInfo.h"

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
    _sdkVersion = [NSString stringWithUTF8String:"sdk_1.0.0"];
}

@end
