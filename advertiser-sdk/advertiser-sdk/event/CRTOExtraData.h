//
//  CRTOExtraData.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

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
