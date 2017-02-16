//
//  CRTOEventQueue.h
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

#import <Foundation/Foundation.h>
#import "CRTOEventQueueItem.h"

typedef void(^CRTOEventQueueItemBlock)(CRTOEventQueueItem* item);

@interface CRTOEventQueue : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic,readonly) NSUInteger currentQueueDepth;
@property (atomic) NSUInteger maxQueueDepth;
@property (atomic) NSTimeInterval maxQueueItemAge;

+ (instancetype) sharedEventQueue;

- (void) addQueueItem:(CRTOEventQueueItem*)item;
- (BOOL) containsItem:(CRTOEventQueueItem*)item;
- (void) onItemError:(CRTOEventQueueItemBlock)errorBlock;
- (void) onItemSent:(CRTOEventQueueItemBlock)sentBlock;
- (void) removeAllItems;

@end
