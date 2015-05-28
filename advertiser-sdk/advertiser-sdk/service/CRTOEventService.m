//
//  CRTOEventService.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <CriteoAdvertiser/CRTOEventService.h>
#import "CRTOEventService+Internal.h"
#import "CRTOEvent+Internal.h"
#import "CRTOEventQueue.h"
#import "CRTOJSONEventSerializer.h"

@implementation CRTOEventService

#pragma mark - Initializers

- (instancetype) init
{
    return [self initWithCountry:nil language:nil crmId:nil];
}

- (instancetype) initWithCountry:(NSString*)country language:(NSString*)language
{
    return [self initWithCountry:country language:language crmId:nil];
}

- (instancetype) initWithCountry:(NSString*)country language:(NSString*)language crmId:(NSString*)crmId
{
    self = [super init];
    if ( self ) {
        _country = country ?: [self defaultCountry];
        _language = language ?: [self defaultLanguage];
        _crmId = crmId ?: [self defaultCrmId];
    }
    return self;
}

#pragma mark - Properties

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

- (NSString*) defaultCountry
{
    return @"";
}

- (NSString*) defaultLanguage
{
    return @"";
}

- (NSString*) defaultCrmId
{
    return nil;
}

#pragma mark - Public Methods

- (void) send:(CRTOEvent*)event
{
    CRTOEvent* eventCopy = [event copy];
    eventCopy.timestamp = [NSDate date];

    NSString* serializedEvent = [CRTOJSONEventSerializer serializeEventToJSONString:eventCopy];

    CRTOEventQueueItem* item = [[CRTOEventQueueItem alloc] initWithEvent:eventCopy
                                                             requestBody:serializedEvent];

    [[CRTOEventQueue sharedEventQueue] addQueueItem:item];
}

@end
