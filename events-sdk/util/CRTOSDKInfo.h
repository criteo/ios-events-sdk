//
//  CRTOSDKInfo.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRTOSDKInfo : NSObject

@property (nonatomic,readonly) NSString* sdkVersion;

+ (instancetype) sharedSDKInfo;

@end
