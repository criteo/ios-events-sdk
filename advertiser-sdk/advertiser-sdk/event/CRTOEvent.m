//
//  CRTOEvent.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <CriteoAdvertiser/CRTOEvent.h>
#import "CRTOEvent+Internal.h"

#import "CRTODateConverter.h"
#import "CRTOExtraData.h"
#import "CRTOJSONConstants.h"

#define CRTO_USERSEGMENT_NONE (0);

@implementation CRTOEvent
{
    NSMutableDictionary* extraData;
}

#pragma mark - Initializers

- (instancetype) init
{
    return [self initWithStartDate:nil endDate:nil];
}

- (instancetype) initWithStartDate:(NSDateComponents*)start endDate:(NSDateComponents*)end
{
    NSAssert( ![self isMemberOfClass:[CRTOEvent class]], @"You must use a concrete subclass of CRTOEvent." );

    self = [super init];
    if ( self ) {
        extraData = [NSMutableDictionary new];

        self.startDate = start;
        self.endDate = end;
    }
    return self;
}

#pragma mark - Class Extension Initializers

- (instancetype) initWithEvent:(CRTOEvent*)event
{
    self = [self initWithStartDate:event.startDate
                           endDate:event.endDate];

    [extraData addEntriesFromDictionary:[event dictionaryWithAllExtraData]];

    _timestamp = [event.timestamp copy];

    return self;
}

#pragma mark - Properties

- (NSDateComponents*) endDate
{
    CRTOExtraData* endDateED = [self getExtraDataForKey:kCRTOJSONPropertyNameCheckout_DateKey];

    if ( endDateED.type == CRTOExtraDataTypeDate ) {
        NSDateComponents* endComponents = [CRTODateConverter convertUTCDateToYMDComponents:endDateED.value];

        return endComponents;
    }

    return nil;
}

- (void) setEndDate:(NSDateComponents*)endComponents
{
    NSDate* endDate = [CRTODateConverter convertYMDComponentsToUTCDate:endComponents];

    if ( endDate != nil ) {
        [self addExtraData:endDate forKey:kCRTOJSONPropertyNameCheckout_DateKey withType:CRTOExtraDataTypeDate];
    }
}

- (NSDateComponents*) startDate
{
    CRTOExtraData* startDateED = [self getExtraDataForKey:kCRTOJSONPropertyNameCheckin_DateKey];

    if ( startDateED.type == CRTOExtraDataTypeDate ) {
        NSDateComponents* startComponents = [CRTODateConverter convertUTCDateToYMDComponents:startDateED.value];

        return startComponents;
    }

    return nil;
}

- (void) setStartDate:(NSDateComponents*)startComponents
{
    NSDate* startDate = [CRTODateConverter convertYMDComponentsToUTCDate:startComponents];

    if ( startDate != nil ) {
        [self addExtraData:startDate forKey:kCRTOJSONPropertyNameCheckin_DateKey withType:CRTOExtraDataTypeDate];
    }
}

- (int) userSegment
{
    CRTOExtraData* segmentED = [self getExtraDataForKey:kCRTOJSONUniversalTagParametersHelperUser_SegmentKey];

    if ( segmentED.type == CRTOExtraDataTypeInteger ) {
        NSNumber* segmentValue = segmentED.value;

        return segmentValue.intValue;
    }

    return CRTO_USERSEGMENT_NONE;
}

- (void) setUserSegment:(int)userSegment
{
    [self setIntegerExtraData:userSegment ForKey:kCRTOJSONUniversalTagParametersHelperUser_SegmentKey];
}

#pragma mark - Class Extension Properties

- (BOOL) isValid
{
    BOOL validity = YES;

    return validity;
}

#pragma mark - Class Extension Methods

- (NSDictionary*) dictionaryWithAllExtraData
{
    return [NSDictionary dictionaryWithDictionary:extraData];
}

- (void) addExtraData:(id)value forKey:(NSString*)key withType:(CRTOExtraDataType)type
{
    BOOL isKeyValid = [self validateKeyParameter:key];

    if ( isKeyValid ) {
        NSString* keyCopy = [NSString stringWithString:key];

        CRTOExtraData* data = [CRTOExtraData extraDataWithKey:keyCopy value:value type:type];

        extraData[keyCopy] = data;
    }
}

- (CRTOExtraData*) getExtraDataForKey:(NSString*)key
{
    BOOL isKeyValid = [self validateKeyParameter:key];

    if ( isKeyValid ) {
        return extraData[key];
    }

    return nil;
}

- (BOOL) validateDateComponentsParamater:(id)value
{
    NSParameterAssert( value );
    NSAssert( [value isKindOfClass:[NSDateComponents class]], @"Parameter 'value' must be an instance of NSDateComponents." );

    return ( value != nil &&
            [value isKindOfClass:[NSDateComponents class]] );
}

- (BOOL) validateKeyParameter:(NSString*)key
{
    NSParameterAssert( key );
    NSAssert( [self validateStringParameter:key], @"Paramemter 'key' must be an instance of NSString or a class that inherits from NSString." );

    return ( key != nil &&
            [self validateStringParameter:key] );
}

- (BOOL) validateStringParameter:(id)value
{
    NSParameterAssert( value );
    NSAssert( [value isKindOfClass:[NSString class]], @"Parameter 'value' must be an instance of NSString or a class that inherits from NSString." );

    return ( value != nil &&
            [value isKindOfClass:[NSString class]] );
}

#pragma mark - Public Methods

- (NSString*) debugDescription
{
    // TODO: Better debug description
    return [NSString stringWithFormat:@"CTEvent (%p)", self];
}

- (NSString*) description
{
    // TODO: Better description
    return [NSString stringWithFormat:@"CTEvent (%p)", self];
}

- (instancetype) setDateExtraData:(NSDateComponents*)value ForKey:(NSString*)key
{
    BOOL isDateValid = [self validateDateComponentsParamater:value];

    NSDate* convertedDate = [CRTODateConverter convertYMDHMSComponentsToUTCDate:value];

    if ( isDateValid && convertedDate != nil ) {
        [self addExtraData:convertedDate forKey:key withType:CRTOExtraDataTypeDate];
    }

    return self;
}

- (instancetype) setFloatExtraData:(float)value ForKey:(NSString*)key
{
    [self addExtraData:@(value) forKey:key withType:CRTOExtraDataTypeFloat];

    return self;
}

- (instancetype) setIntegerExtraData:(NSInteger)value ForKey:(NSString*)key
{
    [self addExtraData:@(value) forKey:key withType:CRTOExtraDataTypeInteger];

    return self;
}

- (instancetype) setStringExtraData:(NSString*)value ForKey:(NSString*)key
{
    BOOL isStringValid = [self validateStringParameter:value];

    if ( isStringValid ) {
        NSString* stringCopy = [NSString stringWithString:value];

        [self addExtraData:stringCopy forKey:key withType:CRTOExtraDataTypeText];
    }

    return self;
}

- (NSDateComponents*) dateExtraDataForKey:(NSString*)key
{
    CRTOExtraData* data = [self getExtraDataForKey:key];

    if ( data.type == CRTOExtraDataTypeDate ) {
        NSDateComponents* components = [CRTODateConverter convertUTCDateToYMDHMSComponents:data.value];

        return components;
    }

    return nil;
}

- (float) floatExtraDataForKey:(NSString*)key
{
    CRTOExtraData* data = [self getExtraDataForKey:key];

    if ( data.type == CRTOExtraDataTypeFloat ) {
        NSNumber* value = data.value;

        return value.floatValue;
    }

    return 0.0f;
}

- (NSInteger) integerExtraDataForKey:(NSString*)key
{
    CRTOExtraData* data = [self getExtraDataForKey:key];

    if ( data.type == CRTOExtraDataTypeInteger ) {
        NSNumber* value = data.value;

        return value.integerValue;
    }

    return 0;
}

- (NSString*) stringExtraDataForKey:(NSString*)key
{
    CRTOExtraData* data = [self getExtraDataForKey:key];

    if ( data.type == CRTOExtraDataTypeText ) {
        return data.value;
    }

    return nil;
}

@end
