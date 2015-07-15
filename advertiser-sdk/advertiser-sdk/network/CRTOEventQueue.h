//
//  CRTOEventQueue.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

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
