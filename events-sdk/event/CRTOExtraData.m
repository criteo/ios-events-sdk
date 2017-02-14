//
//  CRTOExtraData.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "CRTOExtraData.h"

@implementation CRTOExtraData

#pragma mark - Initializers

- (instancetype) init
{
    self = [super init];
    if (self) {
        _key   = @"";
        _value = @"";
        _type  = CRTOExtraDataTypeText;
    }
    return self;
}

- (instancetype) initWithKey:(NSString*)key value:(id)value type:(CRTOExtraDataType)type
{
    self = [self init];

    _key   = [NSString stringWithString:key];
    _value = value;
    _type  = type;

    return self;
}

#pragma mark - Static Methods

+ (instancetype) extraDataWithKey:(NSString*)key value:(id)value type:(CRTOExtraDataType)type
{
    return [[CRTOExtraData alloc] initWithKey:key value:value type:type];
}

@end
