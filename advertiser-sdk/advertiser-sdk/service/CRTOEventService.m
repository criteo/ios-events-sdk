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

#pragma mark - Class Extension Methods

- (CRTOEvent*) appendEventServiceParametersToEvent:(CRTOEvent*)event
{
    NSString* customerId = self.customerId;

    if ( customerId ) {
        [event setStringExtraData:customerId
                           ForKey:kCRTOJSONUniversalTagParametersHelperCustomer_IdKey];
    }

    return event;
}

/* Create and initialize a serializer with the _current_ state of the event service */
- (CRTOJSONEventSerializer*) createJSONSerializer
{
    CRTOJSONEventSerializer* serializer = [CRTOJSONEventSerializer new];

    serializer.countryCode = self.country;
    serializer.languageCode = self.language;

    return serializer;
}

#pragma mark - Public Methods

- (void) send:(CRTOEvent*)event
{
    CRTOEvent* eventCopy = [event copy];
    eventCopy.timestamp = [NSDate date];

    CRTOJSONEventSerializer* serializer = [self createJSONSerializer];

    eventCopy = [self appendEventServiceParametersToEvent:eventCopy];

    NSString* serializedEvent = [serializer serializeEventToJSONString:eventCopy];

    CRTOEventQueueItem* item = [[CRTOEventQueueItem alloc] initWithEvent:eventCopy
                                                             requestBody:serializedEvent];

    if ( [CRTODeviceInfo sharedDeviceInfo].isEventGatheringEnabled ) {
        [[CRTOEventQueue sharedEventQueue] addQueueItem:item];
    }
}

@end
