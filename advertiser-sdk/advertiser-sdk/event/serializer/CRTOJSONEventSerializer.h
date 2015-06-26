//
//  CRTOJSONEventSerializer.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CRTOAppInfo.h"
#import "CRTODeviceInfo.h"
#import "CRTOEvent.h"
#import "CRTOSDKInfo.h"

@interface CRTOJSONEventSerializer : NSObject

@property (nonatomic,strong) NSString* countryCode;
@property (nonatomic,strong) NSString* languageCode;

- (instancetype) init;
- (instancetype) initWithAppInfo:(CRTOAppInfo*)app deviceInfo:(CRTODeviceInfo*)device sdkInfo:(CRTOSDKInfo*)sdk;

- (NSString*) serializeEventToJSONString:(CRTOEvent*)event;

@end
