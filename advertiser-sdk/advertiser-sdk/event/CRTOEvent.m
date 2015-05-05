//
//  CRTOEvent.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "CRTOEvent.h"
#import "CRTOEvent+Internal.h"

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

- (void) addExtraData:(id)value forKey:(NSString*)key;
{
    BOOL isKeyValid = [self validateKeyParameter:key];

    if ( isKeyValid ) {
        NSString* keyCopy = [NSString stringWithString:key];

        extraData[keyCopy] = value;
    }
}

- (id) getExtraDataForKey:(NSString*)key
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
    NSAssert( [value isMemberOfClass:[NSDate class]], @"Parameter 'value' must be an instance of NSDate." );

    return ( value != nil &&
            [value isMemberOfClass:[NSDate class]] );
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

- (instancetype) setBoolExtraData:(BOOL)value ForKey:(NSString*)key
{
    [self addExtraData:@(value) forKey:key];

    return self;
}

- (instancetype) setDateExtraData:(NSDate*)value ForKey:(NSString*)key
{
    BOOL isDateValid = [self validateDateParamater:value];

    if ( isDateValid ) {
        NSDate* dateCopy = [[NSDate alloc] initWithTimeIntervalSince1970:value.timeIntervalSince1970];

        [self addExtraData:dateCopy forKey:key];
    }

    return self;
}

- (instancetype) setIntExtraData:(int64_t)value ForKey:(NSString*)key
{
    [self addExtraData:@(value) forKey:key];

    return self;
}

- (instancetype) setStringExtraData:(NSString*)value ForKey:(NSString*)key
{
    BOOL isStringValid = [self validateStringParameter:value];

    if ( isStringValid ) {
        NSString* stringCopy = [NSString stringWithString:value];

        [self addExtraData:stringCopy forKey:key];
    }

    return self;
}

- (BOOL) boolExtraDataForKey:(NSString*)key
{
    NSNumber* value = [self getExtraDataForKey:key];

    return [value boolValue];
}

- (int64_t) intExtraDataForKey:(NSString*)key
{
    NSNumber* value = [self getExtraDataForKey:key];

    return [value longLongValue];
}

- (NSDate*) dateExtraDataForKey:(NSString*)key
{
    id value = [self getExtraDataForKey:key];

    if ( [value isKindOfClass:[NSDate class]] ) {
        return value;
    }

    return nil;
}

- (NSString*) stringExtraDataForKey:(NSString*)key
{
    id value = [self getExtraDataForKey:key];

    if ( [value isKindOfClass:[NSString class]] ) {
        return value;
    }

    return nil;
}

@end
