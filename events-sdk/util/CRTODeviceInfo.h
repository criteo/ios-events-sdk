//
//  CRTODeviceInfo.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRTODeviceInfo : NSObject

@property (nonatomic,readonly) NSString* deviceIdentifier;
@property (nonatomic,readonly) NSString* deviceManufacturer;
@property (nonatomic,readonly) NSString* deviceModel;
@property (nonatomic,readonly) BOOL advertisingTrackingEnabled;
@property (nonatomic,readonly) NSString* osName;
@property (nonatomic,readonly) NSString* osVersion;
@property (nonatomic,readonly) NSString* platform;

+ (instancetype) sharedDeviceInfo;

@end
