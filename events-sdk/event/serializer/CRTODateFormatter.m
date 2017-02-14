//
//  CRTODateFormatter.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CRTODateFormatter.h"

#define IOS_VER_THREADSAFE_FORMATTER (7)

static BOOL formatterIsThreadSafe = NO;
static dispatch_queue_t formatterQueue = NULL;
static NSDateFormatter* iso8601DateFormatter = nil;

@implementation CRTODateFormatter

#pragma mark - Static Initializer

+ (void) initialize
{
    if ( self == [CRTODateFormatter class] )
    {
        formatterIsThreadSafe = [CRTODateFormatter isSystemDateFormatterThreadSafe];

        formatterQueue = dispatch_queue_create("com.criteo.event.serializer.date", DISPATCH_QUEUE_SERIAL);

        iso8601DateFormatter = [[NSDateFormatter alloc] init];
        iso8601DateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        iso8601DateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
        iso8601DateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    }
}

#pragma mark - Static Class Methods

+ (NSString*) iso8601StringFromDate:(NSDate*)date
{
    NSParameterAssert(date);

    if ( date == nil ) {
        return nil;
    }

    if ( formatterIsThreadSafe ) {
        return [iso8601DateFormatter stringFromDate:date];
    }

    __block NSString* result = nil;

    dispatch_sync(formatterQueue, ^{
        result = [iso8601DateFormatter stringFromDate:date];
    });

    return result;
}

+ (BOOL) isSystemDateFormatterThreadSafe
{
    NSString* systemVersion = [[UIDevice currentDevice] systemVersion];
    NSArray* versionArray   = [systemVersion componentsSeparatedByString:@"."];

    if ( versionArray.count > 0 ) {
        NSString* majorString  = versionArray[0];
        NSInteger majorInteger = majorString.integerValue;

        return (majorInteger >= IOS_VER_THREADSAFE_FORMATTER);
    }

    // If systemVersion didn't parse correctly, we can assume iOS version > 8
    return YES;
}

@end
