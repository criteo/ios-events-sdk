//
//  CRTODateConverter.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "CRTODateConverter.h"

@interface CRTODateConverter ()

+ (NSDateComponents*) convertUTCDate:(NSDate*)date toComponents:(NSCalendarUnit)unitFlags;

@end

@implementation CRTODateConverter

#pragma mark - Private Static Methods

+ (NSDateComponents*) convertUTCDate:(NSDate*)date toComponents:(NSCalendarUnit)unitFlags
{
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    gregorian.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];

    NSDateComponents* components = [gregorian components:unitFlags
                                                fromDate:date];

    return components;
}

#pragma mark - Public Static Methods

+ (NSDateComponents*) convertUTCDateToYMDComponents:(NSDate*)date
{
    if ( date == nil ) {
        return nil;
    }

    NSDateComponents* components = [CRTODateConverter convertUTCDate:date
                                                        toComponents:( NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay )];

    return components;
}

+ (NSDateComponents*) convertUTCDateToYMDHMSComponents:(NSDate*)date
{
    if ( date == nil ) {
        return nil;
    }

    NSDateComponents* components = [CRTODateConverter convertUTCDate:date
                                                        toComponents:( NSCalendarUnitYear | NSCalendarUnitMonth  | NSCalendarUnitDay |
                                                                       NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond )];

    return components;
}

+ (NSDate*) convertYMDComponentsToUTCDate:(NSDateComponents*)components
{
    if ( components == nil ) {
        return nil;
    }

    NSDateComponents* copy = [[NSDateComponents alloc] init];

    copy.year     = components.year;
    copy.month    = components.month;
    copy.day      = components.day;
    copy.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];

    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSDate* result = [gregorian dateFromComponents:copy];

    return result;
}

+ (NSDate*) convertYMDHMSComponentsToUTCDate:(NSDateComponents*)components
{
    if ( components == nil ) {
        return nil;
    }

    NSDateComponents* copy = [[NSDateComponents alloc] init];

    copy.year     = components.year;
    copy.month    = components.month;
    copy.day      = components.day;
    copy.hour     = components.hour;
    copy.minute   = components.minute;
    copy.second   = components.second;
    copy.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];

    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSDate* result = [gregorian dateFromComponents:copy];

    return result;
}

@end
