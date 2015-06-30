//
//  CRTOEventService+Internal.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#include "CRTOJSONEventSerializer.h"
#include "CRTOEventQueue.h"

@interface CRTOEventService ()

- (void) appendEventServiceParametersToEvent:(CRTOEvent*)event;
- (void) appendEventServiceParametersToSerializer:(CRTOJSONEventSerializer*)serializer;

- (void) customerEmailChanged:(NSString*)updatedEmail;

- (void) sendEvent:(CRTOEvent*)event withJSONSerializer:(CRTOJSONEventSerializer*)serializer eventQueue:(CRTOEventQueue*)queue;

@end
