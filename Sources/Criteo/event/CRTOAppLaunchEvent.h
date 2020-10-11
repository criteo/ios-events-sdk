//
//  CRTOAppLaunchEvent.h
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

#import "CRTOEvent.h"

/**
 *  Key used to store the app's initial launch state in @c [NSUserDefaults standardUserDefaults].
 */
FOUNDATION_EXPORT NSString* const kCRTOInitialLaunchKey;

/**
 *  @c CRTOAppLaunchEvent is a concrete subclass of @c CRTOEvent used to describe an App Launch event.
 */
@interface CRTOAppLaunchEvent : CRTOEvent <NSCopying>

/**
 *  Initializes a newly allocated app launch event.
 *
 *  @return A @c CRTOAppLaunchEvent.
 */
- (instancetype) init;

@end
