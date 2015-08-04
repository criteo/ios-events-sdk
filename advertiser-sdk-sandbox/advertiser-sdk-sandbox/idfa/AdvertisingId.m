//
//  AdvertisingId.m
//  advertiser-sdk-sandbox
//
//  Created by Paul Davis on 8/4/15.
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "AdvertisingId.h"

static NSString* _constantId;

@implementation AdvertisingId

+ (NSString*) getRuntimeConstantId
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSUUID* uuid = [NSUUID UUID];
        _constantId = uuid.UUIDString.uppercaseString;
        NSLog(@"[TestApp] A new IDFA was made: %@", _constantId);
    });

    return _constantId;
}

@end
