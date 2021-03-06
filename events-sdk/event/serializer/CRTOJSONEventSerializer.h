//
//  CRTOJSONEventSerializer.h
//  events-sdk
//
//  Copyright (c) 2017 Criteo
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import <Foundation/Foundation.h>

#import "CRTOAppInfo.h"
#import "CRTODeviceInfo.h"
#import "CRTOEvent.h"
#import "CRTOSDKInfo.h"

@interface CRTOJSONEventSerializer : NSObject

@property (nonatomic,strong) NSString* accountName;
@property (nonatomic,strong) NSString* countryCode;
@property (nonatomic,strong) NSString* customerEmail;
@property (nonatomic,strong) NSString* languageCode;

- (instancetype) init;
- (instancetype) initWithAppInfo:(CRTOAppInfo*)app deviceInfo:(CRTODeviceInfo*)device sdkInfo:(CRTOSDKInfo*)sdk;

- (NSString*) serializeEventToJSONString:(CRTOEvent*)event;

@end
