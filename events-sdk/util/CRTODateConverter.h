//
//  CRTODateConverter.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRTODateConverter : NSObject

+ (NSDateComponents*) convertUTCDateToYMDComponents:(NSDate*)date;
+ (NSDateComponents*) convertUTCDateToYMDHMSComponents:(NSDate*)date;

+ (NSDate*) convertYMDComponentsToUTCDate:(NSDateComponents*)components;
+ (NSDate*) convertYMDHMSComponentsToUTCDate:(NSDateComponents*)components;

@end
