//
//  CRTOJSONEventSerializer.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRTOEvent.h"

@interface CRTOJSONEventSerializer : NSObject

+ (NSString*) serializeEventToJSONString:(CRTOEvent*)event;

@end
