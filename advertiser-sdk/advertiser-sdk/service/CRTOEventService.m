//
//  CRTOEventService.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <CriteoAdvertiser/CRTOEventService.h>
#import "CRTODeviceInfo.h"
#import "CRTOEventService+Internal.h"
#import "CRTOEvent+Internal.h"
#import "CRTOEventQueue.h"
#import "CRTOJSONConstants.h"
#import "CRTOJSONEventSerializer.h"

@implementation CRTOEventService
{
@private
    NSRegularExpression* emailRegex;
}

#pragma mark - Initializers

- (instancetype) init
{
    return [self initWithCountry:nil language:nil customerId:nil];
}

- (instancetype) initWithCountry:(NSString*)country language:(NSString*)language
{
    return [self initWithCountry:country language:language customerId:nil];
}

- (instancetype) initWithCountry:(NSString*)country language:(NSString*)language customerId:(NSString*)customerId
{
    self = [super init];
    if ( self ) {

        emailRegex = [NSRegularExpression regularExpressionWithPattern:@".+\\@.+\\..+"
                                                               options:NSRegularExpressionCaseInsensitive
                                                                 error:nil];

        [self addObserver:self
               forKeyPath:@"customerEmail"
                  options:NSKeyValueObservingOptionNew
                  context:nil];

        if ( country != nil ) {
            _country = [NSString stringWithString:country];
        }

        if ( language != nil ) {
            _language = [NSString stringWithString:language];
        }

        if ( customerId != nil ) {
            _customerId = [NSString stringWithString:customerId];
        }
    }
    return self;
}

#pragma mark - Deallocation

- (void) dealloc
{
    [self removeObserver:self forKeyPath:@"customerEmail"];
}

#pragma mark - Static Methods

+ (instancetype) sharedEventService
{
    static dispatch_once_t onceToken;
    static CRTOEventService* service;

    dispatch_once(&onceToken, ^{
        service = [[CRTOEventService alloc] init];
    });

    return service;
}

#pragma mark - Key/Value Observing

- (void) observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    if ( [keyPath isEqualToString:@"customerEmail"] ) {
        NSString* updatedEmail = change[NSKeyValueChangeNewKey];
        [self customerEmailChanged:updatedEmail];
    }
}

#pragma mark - Class Extension Methods

- (void) appendEventServiceParametersToEvent:(CRTOEvent*)event
{
    NSString* customerId = self.customerId;

    if ( customerId ) {
        [event setStringExtraData:customerId
                           ForKey:kCRTOJSONUniversalTagParametersHelperCustomer_IdKey];
    }
}

- (void) appendEventServiceParametersToSerializer:(CRTOJSONEventSerializer*)serializer
{
    serializer.countryCode = self.country;
    serializer.languageCode = self.language;
    serializer.accountName = self.accountName;
    serializer.customerEmail = self.customerEmail;
}

- (void) customerEmailChanged:(NSString*)updatedEmail
{
    if ( [[NSNull null] isEqual:updatedEmail] ) {
        return;
    }

    NSRange match = [emailRegex rangeOfFirstMatchInString:updatedEmail
                                                  options:0
                                                    range:NSMakeRange(0, updatedEmail.length)];

    if ( NSEqualRanges(match, NSMakeRange(NSNotFound, 0)) ) {
        NSLog(@"CRTO WARNING: Invalid customer email address \"%@\" set on event service instance %p.", updatedEmail, self);
    }
}

- (void) sendEvent:(CRTOEvent*)event withJSONSerializer:(CRTOJSONEventSerializer*)serializer eventQueue:(CRTOEventQueue*)queue
{
    [self appendEventServiceParametersToEvent:event];
    [self appendEventServiceParametersToSerializer:serializer];

    NSString* serializedEvent = [serializer serializeEventToJSONString:event];

    CRTOEventQueueItem* item = [[CRTOEventQueueItem alloc] initWithEvent:event
                                                             requestBody:serializedEvent];
    [queue addQueueItem:item];
}

#pragma mark - Public Methods

- (void) send:(CRTOEvent*)event
{
    if ( event == nil ) {
        return;
    }

    CRTOEvent* eventCopy = [event copy];
    eventCopy.timestamp = [NSDate date];

    CRTOJSONEventSerializer* serializer = [CRTOJSONEventSerializer new];
    CRTOEventQueue* queue = [CRTOEventQueue sharedEventQueue];

    [self sendEvent:eventCopy withJSONSerializer:serializer eventQueue:queue];
}

@end
