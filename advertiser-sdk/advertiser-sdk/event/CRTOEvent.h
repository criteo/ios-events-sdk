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
 *  @discussion
 *  This date components object represents the start or checkin date associated
 *  with an event as it was displayed to the user in your UI. The default value
 *  of this property is @a nil.
 *
 *  The properties of this date components object are interpreted as absolute
 *  values (not quantities). Only the @c year, @c month, and @c day properties
 *  are read from this object.
 *
 *  Instances of NSDateComponents stored into this property must represent valid
 *  dates in the @c NSCalendarIdentifierGregorian calendar. If you attempt to
 *  store an invalid date into this property, the invalid date will be
 *  discarded, and the value of the property will not be changed.
 *
 *  @b Example:
 *
 *  If your user searches for a travel product with a start date of
 *  2015-12-31, you would compose an NSDateComponents object to represent this
 *  date with the following code:
 @code
 NSDateComponents *start = [[NSDateComponents alloc] init];

 start.year = 2015;
 start.month = 12;
 start.day = 31;

 event.startDate = start;
 @endcode
 *
 *  @warning
 *  You should only set the year, month, and day properties of the date
 *  components object you assign to this property. Other properties of the date
 *  components object, including @c timeZone, will be ignored when the event is
 *  sent to Criteo.
 */
@property (nonatomic,strong) NSDateComponents* startDate;

/**
 *  The end or travel checkout date associated with this event.
 *
 *  @discussion
 *  This date components object represents the end or checkout date associated
 *  with an event as it was displayed to the user in your UI. The default value
 *  of this property is @a nil.
 *
 *  The properties of this date components object are interpreted as absolute
 *  values (not quantities). Only the @c year, @c month, and @c day properties
 *  are read from this object.
 *
 *  Instances of NSDateComponents stored into this property must represent valid
 *  dates in the @c NSCalendarIdentifierGregorian calendar. If you attempt to
 *  store an invalid date into this property, the invalid date will be
 *  discarded, and the value of the property will not be changed.
 *
 *  @b Example:
 *
 *  If your user searches for a travel product with an end date of
 *  2015-12-31, you would compose an NSDateComponents object to represent this
 *  date with the following code:
 @code
 NSDateComponents *end = [[NSDateComponents alloc] init];

 end.year = 2015;
 end.month = 12;
 end.day = 31;

 event.endDate = end;
 @endcode
 *
 *  @warning
 *  You should only set the year, month, and day properties of the date
 *  components object you assign to this property. Other properties of the date
 *  components object, including @c timeZone, will be ignored when the event is
 *  sent to Criteo.
 */
@property (nonatomic,strong) NSDateComponents* endDate;

/**
 *  Returns an initialized @c CRTOEvent object that contains no data.
 *
 *  @return An initialized @c CRTOEvent object that contains no data.
 */
- (instancetype) init;

/**
 *  Returns an initialized @c CRTOEvent object that contains a start date and an end date.
 *
 *  @param start The start or checkin time of this event as it was shown in your UI. See notes for @c startDate property.
 *  @param end   The end or checkout time of this event as it was shown in your UI. See notes for @c endDate property.
 *
 *  @return An initialized @c CRTOEvent object that contains a start date and an end date.
 */
- (instancetype) initWithStartDate:(NSDateComponents*)start endDate:(NSDateComponents*)end;

/**
 *  Adds a given key-value pair to the event where the value is of type @c NSDateComponents.
 *
 *  @discussion
 *  Use this method to append custom datetime data to this event before sending
 *  it to Criteo. Date components are interpreted as absolute values (not
 *  quantities). The @c value argument must represent a valid date in the
 *  @c NSCalendarIdentifierGregorian calendar. If the @c value argument is not
 *  valid, this call is ignored, and no changes will be made to the event.
 *
 *  @warning Both the @a key and @a value parameters are validated before they are stored to the event. If a paramter is found to be invalid, the customized data will not be stored to the event. To meet the validity requirements, both key and value parameters must be non-nil instances of a datatype that passes the test: @code [param isKindOfClass:[ParamType class]] == YES; @endcode
 *
 *  @param value The date value for @a key.  This value must be an instance of @c NSDateComponents and it must be non-nil.
 *  @param key   The key for @a value. The key must be an instance of @c NSString or one of its subclasses and it must be non-nil.
 */
- (instancetype) setDateExtraData:(NSDateComponents*)value ForKey:(NSString*)key;

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
 *  Returns the @c NSDateComponents value associated with a given key.
 *
 *  @param key The key for which to return the corresponding value.
 *
 *  @note This method only retrieves values stored with the @c setDateExtraData:ForKey: method. If you attempt to retrieve a value stored with one of the other set methods, this method returns @c nil.
 *
 *  @return The value associated with @a key, or @c nil if no value of type @c NSDateComponents is associated with @a key.
 */
- (NSDateComponents*) dateExtraDataForKey:(NSString*)key;

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
