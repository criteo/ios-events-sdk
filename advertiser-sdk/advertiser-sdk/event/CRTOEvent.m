//
//  CRTOEvent.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "CRTOEvent.h"
#import "CRTOEvent+Internal.h"
#import "CRTOExtraData.h"

@implementation CRTOEvent
{
    NSMutableDictionary* extraData;
}

#pragma mark - Initializers

- (instancetype) init
{
    return [self initWithStartDate:nil endDate:nil];
}

- (instancetype) initWithStartDate:(NSDate*)start endDate:(NSDate*)end
{
    NSAssert( ![self isMemberOfClass:[CRTOEvent class]], @"You must use a concrete subclass of CRTOEvent." );

    self = [super init];
    if ( self ) {
        if ( start ) {
            _startDate = [NSDate dateWithTimeIntervalSince1970:start.timeIntervalSince1970];
        }

        if ( end ) {
            _endDate = [NSDate dateWithTimeIntervalSince1970:end.timeIntervalSince1970];
        }

        extraData = [NSMutableDictionary new];
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

#pragma mark - Class Extension Properties

- (BOOL) isValid
{
    BOOL validity = YES;

    validity = validity && ((_startDate == nil && _endDate == nil) || (_startDate != nil && _endDate != nil));
    //validity = validity && /* All keys in extraData are valid */

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

- (BOOL) validateDateParamater:(id)value
{
    NSParameterAssert( value );
    NSAssert( [value isKindOfClass:[NSDate class]], @"Parameter 'value' must be an instance of NSDate." );

    return ( value != nil &&
            [value isKindOfClass:[NSDate class]] );
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

- (instancetype) setDateExtraData:(NSDate*)value ForKey:(NSString*)key
{
    BOOL isDateValid = [self validateDateParamater:value];

    if ( isDateValid ) {
        NSDate* dateCopy = [[NSDate alloc] initWithTimeIntervalSince1970:value.timeIntervalSince1970];

        [self addExtraData:dateCopy forKey:key withType:CRTOExtraDataTypeDate];
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

- (NSDate*) dateExtraDataForKey:(NSString*)key
{
    CRTOExtraData* data = [self getExtraDataForKey:key];

    if ( data.type == CRTOExtraDataTypeDate ) {
        return data.value;
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
