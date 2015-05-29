//
//  CRTOEventService.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <CriteoAdvertiser/CRTOEvent.h>

/**
 *  @c CRTOEventService is used to submit event objects to Criteo. You may set customized country, language, or CRM identifier values that will be sent with every event submitted through the event service.
 *
 *  Use this class to submit any subclass of @c CRTOEvent supplied in this SDK. If your app or your account configuration with Criteo requires the use of different country, language, or CRM identifiers, create a new instance of this class and set these properties as needed.
 */
@interface CRTOEventService : NSObject

/** The two letter ISO-3166-1 country code representing the country associated with events sent via this event service. */
@property (nonatomic,strong) NSString* country;

/** The two letter ISO-639-1 language code representing the language associated with events sent via this event service. */
@property (nonatomic,strong) NSString* language;

/** The customer identifier associated with events sent via this event service. */
@property (nonatomic,strong) NSString* crmId;

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
 *  @param country  Two letter ISO-3166-1 country code associated with events sent using the event service.
 *  @param language Two letter ISO-639-1 language code associated with events sent using the event service.
 *  @param crmId    The customer identifier associated with events send via this event service.
 *
 *  @return A @c CRTOEventService initialized with custom @c country,@c language, and @c crmId values.
 */
- (instancetype) initWithCountry:(NSString*)country language:(NSString*)language crmId:(NSString*)crmId;

/**
 *  Submits an event to Criteo's prediction platform.
 *
 *  @discussion Use this method to transmit instances of composed @c CRTOEvent subclasses to Criteo. Although you may submit events from multiple instances of @c CRTOEventService, they will be enqueued and submitted through a single background GCD dispatch queue. This method is thread-safe.
 *
 *  @param event The event to submit to Criteo. The event object is deep-copied as part of the send process. Changes made to @a event after this method returns do not affect the event that is submitted to Criteo.
 */
- (void) send:(CRTOEvent*)event;

@end
