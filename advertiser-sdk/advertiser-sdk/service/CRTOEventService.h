//
//  CRTOEventService.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "CRTOEvent.h"

/** Indicates the type of email values you will assign to the @c CRTOEventService.customerEmail property. */
typedef NS_ENUM(NSInteger, CRTOEventServiceEmailType) {
    /** Emails stored to the @c customerEmail property are cleartext values. */
    CRTOEventServiceEmailTypeCleartext,
    /** Emails stored to the @c customerEmail property are md5 hashes. */
    CRTOEventServiceEmailTypeHashedMd5
};

/**
 *  @c CRTOEventService is used to submit event objects to Criteo. You may set customized country, language, or CRM identifier values that will be sent with every event submitted through the event service.
 *
 *  Use this class to submit any subclass of @c CRTOEvent supplied in this SDK. If your app or your account configuration with Criteo requires the use of different country, language, or CRM identifiers, create a new instance of this class and set these properties as needed.
 */
@interface CRTOEventService : NSObject

/** The two letter ISO-3166-1 country code representing the country associated with events sent via this event service. */
@property (atomic,copy) NSString* country;

/** The two letter ISO-639-1 language code representing the language associated with events sent via this event service. */
@property (atomic,copy) NSString* language;

/**
 *  The account name associated with events sent via this event service.
 *
 *  If you do not assign a value to this property, the app's bundle id will be sent to Criteo, instead.
 */
@property (atomic, copy) NSString* accountName;

/**
 *  The customer email address associated with events sent via this event service.
 *
 *  You may choose to store either a cleartext or a prehashed value to this property. Before assigning this property a value, you must set the @c customerEmailType property to indicate the format of your email value.
 *
 *  If you store a cleartext value to this property, the SDK will convert it to lowercase, trim all whitespace, and compute the md5 hash of the resulting string. Only this hash will be stored and forwared to Criteo. You can verify the hash operation by retrieving the value of this property after assigning it a cleartext value.
 */
@property (atomic,copy) NSString* customerEmail;

/**
 *  The type of email value stored in the @c customerEmail property. Defaults to @c CRTOEventServiceEmailTypeCleartext.
 *
 *  Changing the value of this property will automatically reset the value of the @c customerEmail property to @a nil.
 */
@property (atomic) CRTOEventServiceEmailType customerEmailType;

/** The customer identifier associated with events sent via this event service. */
@property (atomic,copy) NSString* customerId;

/**
 *  Returns the shared event service.
 *
 *  @return A singleton instance of the shared event service.
 */
+ (instancetype) sharedEventService;

/**
 *  Initializes a newly allocated instance of @c CRTOEventService with default country, language, and CRM identifier values.
 *
 *  @return A @c CRTOEventService initialized with a @a nil country, a @a nil language, and a @a nil CRM identifier.
 */
- (instancetype) init;

/**
 *  Initializes a newly allocated instance of @c CRTOEventService with customized country and language values.
 *
 *  @param country  Two letter ISO-3166-1 country code associated with events sent using the event service.
 *  @param language Two letter ISO-639-1 language code associated with events sent using the event service.
 *
 *  @return A @c CRTOEventService initialized with custom @c country and @c language values.
 */
- (instancetype) initWithCountry:(NSString*)country language:(NSString*)language;

/**
 *  Initializes a newly allocated instance of @c CRTOEventService with customized country, language, and CRM identifier values.
 *
 *  @param country    Two letter ISO-3166-1 country code associated with events sent using the event service.
 *  @param language   Two letter ISO-639-1 language code associated with events sent using the event service.
 *  @param customerId The customer identifier associated with events send via this event service.
 *
 *  @return A @c CRTOEventService initialized with custom @c country,@c language, and @c customerId values.
 */
- (instancetype) initWithCountry:(NSString*)country language:(NSString*)language customerId:(NSString*)customerId;

/**
 *  Submits an event to Criteo's prediction platform.
 *
 *  @discussion Use this method to transmit instances of composed @c CRTOEvent subclasses to Criteo. Although you may submit events from multiple instances of @c CRTOEventService, they will be enqueued and submitted through a single background GCD dispatch queue. This method is thread-safe.
 *
 *  @param event The event to submit to Criteo. The event object is deep-copied as part of the send process. Changes made to @a event after this method returns do not affect the event that is submitted to Criteo.
 */
- (void) send:(CRTOEvent*)event;

@end
