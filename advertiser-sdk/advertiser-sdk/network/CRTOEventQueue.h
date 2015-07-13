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

@property (nonatomic,readonly) NSUInteger maxQueueDepth;
@property (nonatomic,readonly) NSTimeInterval maxQueueItemAge;

+ (instancetype) sharedEventQueue;

- (void) addQueueItem:(CRTOEventQueueItem*)item;
- (void) onItemError:(CRTOEventQueueItemBlock)errorBlock;
- (void) onItemSent:(CRTOEventQueueItemBlock)sentBlock;

@end
