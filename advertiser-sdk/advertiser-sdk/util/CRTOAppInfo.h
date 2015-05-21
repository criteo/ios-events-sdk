//
//  CRTOAppInfo.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRTOAppInfo : NSObject

@property (nonatomic,readonly) NSString* appCountry;
@property (nonatomic,readonly) NSString* appId;
@property (nonatomic,readonly) NSString* appLanguage;
@property (nonatomic,readonly) NSString* appName;
@property (nonatomic,readonly) NSString* appVersion;

+ (instancetype) sharedAppInfo;

@end
