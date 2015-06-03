//
//  CRTODateFormatter.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRTODateFormatter : NSObject

+ (NSString*) iso8601StringFromDate:(NSDate*)date;
+ (BOOL) isSystemDateFormatterThreadSafe;

@end
