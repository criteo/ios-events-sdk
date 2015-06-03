//
//  CRTOEventService+Internal.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#include "CRTOJSONEventSerializer.h"

@interface CRTOEventService ()

- (CRTOEvent*) appendEventServiceParametersToEvent:(CRTOEvent*)event;
- (CRTOJSONEventSerializer*) createJSONSerializer;

@end
