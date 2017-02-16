//
//  CRTOExtraData.h
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

typedef NS_ENUM(NSUInteger, CRTOExtraDataType) {
    CRTOExtraDataTypeInvalid = 0,

    CRTOExtraDataTypeDate,
    CRTOExtraDataTypeFloat,
    CRTOExtraDataTypeInteger,
    CRTOExtraDataTypeText,
  //CRTOExtraDataTypeYourNewTypeHere,

};

@interface CRTOExtraData : NSObject

@property (nonatomic,readonly) NSString* key;
@property (nonatomic,readonly) id value;
@property (nonatomic,readonly) CRTOExtraDataType type;

+ (instancetype) extraDataWithKey:(NSString*)key value:(id)value type:(CRTOExtraDataType)type;

- (instancetype) initWithKey:(NSString*)key value:(id)value type:(CRTOExtraDataType)type;

@end
