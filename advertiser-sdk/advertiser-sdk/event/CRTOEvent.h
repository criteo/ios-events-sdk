//
//  CRTOEvent.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  The @c CRTOEvent class and related classes provide an API for submitting events from your native iOS application to Criteo.
 *
 *  @warning This class provides base functionality for other event subclasses, and is not intended to be used directly from your code.  It is an error to submit instances of this class to @c CRTOEventService for transmission to Criteo.
 */
@interface CRTOEvent : NSObject

/**
 *  The start or travel checkin date associated with this event.
 *
 *  @discussion This date indicates the start or checkin time of the event in UTC.  The default value of this property is @c nil.
 */
@property (nonatomic,strong,readonly) NSDate* startDate;

/**
 *  The end or travel checkout date associated with this event.
 *
 *  @discussion This date indicates the end or checkout time of the event in UTC.  The default value of this property is @c nil.
 */
@property (nonatomic,strong,readonly) NSDate* endDate;

/**
 *  Returns an initialized @c CRTOEvent object that contains no data.
 *
 *  @return An initialized @c CRTOEvent object that contains no data.
 */
- (instancetype) init;

/**
 *  Returns an initialized @c CRTOEvent object that contains a start date and an end date.
 *
 *  @param start The start or checkin time of this event in UTC.
 *  @param end   The end or checkout time of this event in UTC.
 *
 *  @return An initialized @c CRTOEvent object that contains a start date and an end date.
 */
- (instancetype) initWithStartDate:(NSDate*)start endDate:(NSDate*)end;

/**
 *  Adds a given key-value pair to the event where the value is of type @c NSDate.
 *
 *  @discussion Use this method to append custom datetime data to this event before sending it to Criteo.
 *
 *  @warning Both the @a key and @a value parameters are validated before they are stored to the event. If a paramter is found to be invalid, the customized data will not be stored to the event. To meet the validity requirements, both key and value parameters must be non-nil instances of a datatype that passes the test: @code [param isKindOfClass:[ParamType class]] == YES; @endcode
 *
 *  @param value The date value for @a key.  This value must be an instance of @c NSDate and it must be non-nil.
 *  @param key   The key for @a value. The key must be an instance of @c NSString or one of its subclasses and it must be non-nil.
 */
- (instancetype) setDateExtraData:(NSDate*)value ForKey:(NSString*)key;

/**
 *  Adds a given key-value pair to the event where the value is of type @c float.
 *
 *  @discussion Use this method to append custom single-precision floating-point data to this event before sending it to Criteo.
 *
 *  @warning The @a key parameter is validated before the key-value pair is stored to the event. If the @a key parameter is found to be invalid, the customized data will not be stored to the event. To meet the validity requirements, the key parameter must be a non-nil instance of @c NSString or one of its subclasses that passes the test: @code [key isKindOfClass:[NSString class]] == YES; @endcode
 *
 *  @param value The floating-point value for @a key.
 *  @param key   The key for @a value. The key must be an instance of @c NSString or one of its subclasses and it must be non-nil.
 */
- (instancetype) setFloatExtraData:(float)value ForKey:(NSString*)key;

/**
 *  Adds a given key-value pair to the event where the value is of type @c NSInteger.
 *
 *  @discussion Use this method to append custom signed integer data to this event before sending it to Criteo.
 *
 *  @warning The @a key parameter is validated before the key-value pair is stored to the event. If the @a key parameter is found to be invalid, the customized data will not be stored to the event. To meet the validity requirements, the key parameter must be a non-nil instance of @c NSString or one of its subclasses that passes the test: @code [key isKindOfClass:[NSString class]] == YES; @endcode
 *
 *  @param value The signed integer value for @a key.
 *  @param key   The key for @a value. The key must be an instance of @c NSString or one of its subclasses and it must be non-nil.
 */
- (instancetype) setIntegerExtraData:(NSInteger)value ForKey:(NSString*)key;

/**
 *  Adds a given key-value pair to the event where the value is of type @c NSString.
 *
 *  @discussion Use this method to append custom text data to this event before sending it to Criteo.
 *
 *  @warning Both the @a key and @a value parameters are validated before they are stored to the event. If a paramter is found to be invalid, the customized data will not be stored to the event. To meet the validity requirements, both key and value parameters must be non-nil instances of @c NSString or one of its subclasses that passes the test: @code [param isKindOfClass:[NSString class]] == YES; @endcode
 *
 *  @param value The string value for @a key.  This value must be an instance of @c NSString or one of its subclasses and it must be non-nil.
 *  @param key   The key for @a value. The key must be an instance of @c NSString or one of its subclasses and it must be non-nil.
 */
- (instancetype) setStringExtraData:(NSString*)value ForKey:(NSString*)key;

/**
 *  Returns the @c NSDate value associated with a given key.
 *
 *  @param key The key for which to return the corresponding value.
 *
 *  @note This method only retrieves values stored with the @c setDateExtraData:ForKey: method. If you attempt to retrieve a value stored with one of the other set methods, this method returns @c nil.
 *
 *  @return The value associated with @a key, or @c nil if no value of type @c NSDate is associated with @a key.
 */
- (NSDate*) dateExtraDataForKey:(NSString*)key;

/**
 *  Returns the @c float value associated with a given key.
 *
 *  @param key The key for which to return the corresponding value.
 *
 *  @note This method only retrieves values stored with the @c setFloatExtraData:ForKey: method. If you attempt to retrieve a value stored with one of the other set methods, this method returns @c 0.0f.
 *
 *  @return The value associated with @a key, or @c 0.0f if no value of type @c float is associated with @a key.
 */
- (float) floatExtraDataForKey:(NSString*)key;

/**
 *  Returns the @c NSInteger value associated with a given key.
 *
 *  @param key The key for which to return the corresponding value.
 *
 *  @note This method only retrieves values stored with the @c setIntegerExtraData:ForKey: method. If you attempt to retrieve a value stored with one of the other set methods, this method returns @c 0.
 *
 *  @return The value associated with @a key, or @c 0 if no value of type @c NSInteger is associated with @a key.
 */
- (NSInteger) integerExtraDataForKey:(NSString*)key;

/**
 *  Returns the @c NSString value associated with a given key.
 *
 *  @param key The key for which to return the corresponding value.
 *
 *  @note This method only retrieves values stored with the @c setStringExtraData:ForKey: method. If you attempt to retrieve a value stored with one of the other set methods, this method returns @c nil.
 *
 *  @return The value associated with @a key, or @c nil if no value of type @c NSString is associated with @a key.
 */
- (NSString*) stringExtraDataForKey:(NSString*)key;

@end
