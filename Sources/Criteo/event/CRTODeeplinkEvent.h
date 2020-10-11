//
//  CRTODeeplinkEvent.h
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
 *  @c CRTODeeplinkEvent is a concrete subclass of @c CRTOEvent used to describe deeplink events that occur in your app.
 */
@interface CRTODeeplinkEvent : CRTOEvent <NSCopying>

/**
 *  A string containing the Deeplink launch URL supplied to the @c initWithDeeplinkLaunchUrl: initializer.
 */
@property (nonatomic,strong,readonly) NSString* deeplinkLaunchUrl;

/**
 *  Initializes a newly allocated deeplink event with the @c deeplinkLaunchUrl property set to @i nil.
 *
 *  @return A @c CRTODeeplinkEvent initialized with a nil @c deeplinkLaunchUrl.
 */
- (instancetype) init;

/**
 *  Initializes a newly allocated deeplink event with a deeplink launch URL.
 *
 *  @param url An instance of @c NSString containing the deeplink sent to your app.
 *
 *  @return A @c CRTODeeplinkEvent containing a deeplink launch URL.
 */
- (instancetype) initWithDeeplinkLaunchUrl:(NSString*)url;

@end
