//
//  CRTOJSONEventSerializer.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRTOEvent.h"

@interface CRTOJSONEventSerializer : NSObject

@property (nonatomic,strong) NSString* countryCode;
@property (nonatomic,strong) NSString* languageCode;

- (NSString*) serializeEventToJSONString:(CRTOEvent*)event;

@end
