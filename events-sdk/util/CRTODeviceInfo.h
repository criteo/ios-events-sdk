//
//  CRTODeviceInfo.h
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
