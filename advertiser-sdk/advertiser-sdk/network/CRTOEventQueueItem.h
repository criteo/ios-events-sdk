//
//  CRTOEventQueueItem.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRTOEvent.h"

@interface CRTOEventQueueItem : NSObject

@property (nonatomic,readonly) NSTimeInterval age;
@property (nonatomic,readonly) CRTOEvent* event;
@property (nonatomic)          NSUInteger redirectCount;
@property (nonatomic,readonly) NSData* requestBody;
@property (nonatomic,readonly) NSMutableData* responseData;

- (instancetype) initWithEvent:(CRTOEvent*)event requestBody:(NSString*)body;

@end
