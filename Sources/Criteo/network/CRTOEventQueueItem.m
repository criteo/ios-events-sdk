//
//  CRTOEventQueueItem.m
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

#import "CRTOEventQueueItem.h"
#import "CRTOEvent+Internal.h"

@implementation CRTOEventQueueItem

#pragma mark - Initializers

- (instancetype) init
{
    self = [super init];
    if ( self ) {
        _event = nil;
        _requestBody = nil;
        _responseData = [NSMutableData new];
    }
    return self;
}

- (instancetype) initWithEvent:(CRTOEvent*)event requestBody:(NSString*)body
{
    self = [self init];

    _event = event;
    _requestBody = [NSData dataWithBytes:body.UTF8String
                                  length:[body lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];

    return self;
}

#pragma mark - Properties

- (NSTimeInterval) age
{
    NSDate* now = [NSDate new];
    NSDate* timestamp = _event.timestamp;

    if ( timestamp != nil ) {
        return [now timeIntervalSinceDate:timestamp];
    }

    return [now timeIntervalSince1970];  // Expire quickly
}

@end
