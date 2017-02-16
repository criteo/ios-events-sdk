//
//  CRTODateConverter.m
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
