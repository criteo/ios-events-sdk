//
//  CRTODeviceInfo.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "CRTODeviceInfo.h"
#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>
#import <sys/utsname.h>

#define DEVICE_MANUFACTURER (@"apple")
#define DEVICE_OSNAME (@"iPhone OS")
#define DEVICE_PLATFORM (@"ios")

static NSString* deviceIdentifier = nil;

@interface CRTODeviceInfo ()

- (void) setupDeviceInfo;

@end

@implementation CRTODeviceInfo

#pragma mark - Initializers

- (instancetype) init
{
    self = [super init];
    if ( self ) {
        [self setupDeviceInfo];
    }
    return self;
}

#pragma mark - Static Methods

+ (instancetype) sharedDeviceInfo
{
    static dispatch_once_t onceToken;
    static CRTODeviceInfo* deviceInfo;

    dispatch_once(&onceToken, ^{
        deviceInfo = [[CRTODeviceInfo alloc] init];
    });

    return deviceInfo;
}

#pragma mark - Properties

- (NSString*) deviceIdentifier
{
    if ( deviceIdentifier != nil ) {
        return deviceIdentifier;
    }

    NSUUID* advertisingIdentifer = [ASIdentifierManager sharedManager].advertisingIdentifier;
    static dispatch_once_t onceToken;

    if ( advertisingIdentifer != nil ) {
        dispatch_once(&onceToken, ^{
            deviceIdentifier = advertisingIdentifer.UUIDString;
        });

        return deviceIdentifier;
    }

    return @"";
}

- (BOOL) isEventGatheringEnabled
{
    BOOL eventsEnabled = [ASIdentifierManager sharedManager].advertisingTrackingEnabled;

    return eventsEnabled;
}

#pragma mark - Class Extension Methods

- (void) setupDeviceInfo
{
    _deviceManufacturer = DEVICE_MANUFACTURER;
    _deviceModel        = @"";
    _osName             = DEVICE_OSNAME;
    _osVersion          = @"";
    _platform           = DEVICE_PLATFORM;

    struct utsname info;
    int result;

    result = uname(&info);

    if ( result ) {
        int error = errno;

        NSLog(@"Error %d retrieving utsname: %s", error, strerror(error));
        return;
    }

    _deviceModel = [NSString stringWithUTF8String:info.machine];
    _osName      = [UIDevice currentDevice].systemName;
    _osVersion   = [UIDevice currentDevice].systemVersion;
}

@end
