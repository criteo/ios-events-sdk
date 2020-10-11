//
//  CRTOEventService+Internal.h
//  events-sdk
//
//  Copyright (c) 2017 Criteo
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#include "CRTOJSONEventSerializer.h"
#include "CRTOEventQueue.h"

@interface CRTOEventService ()

- (void) appendEventServiceParametersToEvent:(CRTOEvent*)event;
- (void) appendEventServiceParametersToSerializer:(CRTOJSONEventSerializer*)serializer;

- (void) customerEmailChanged:(NSString*)updatedEmail;

- (void) sendEvent:(CRTOEvent*)event withJSONSerializer:(CRTOJSONEventSerializer*)serializer eventQueue:(CRTOEventQueue*)queue;

@end
