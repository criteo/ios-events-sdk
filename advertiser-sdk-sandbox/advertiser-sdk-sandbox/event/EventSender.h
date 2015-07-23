//
//  EventSender.h
//  advertiser-sdk-sandbox
//
//  Created by Paul Davis on 7/23/15.
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CRTOEvent;

typedef void(^CRTOEventQueueItemBlock)(id item);
typedef void(^EventSendResult)(id item, BOOL success);

@interface EventSender : NSObject

- (CRTOEvent*) getAppLaunchEvent;
- (CRTOEvent*) getBasketViewEvent;
- (CRTOEvent*) getDataEvent;
- (CRTOEvent*) getDeeplinkEvent;
- (CRTOEvent*) getHomeViewEvent;
- (CRTOEvent*) getProductListViewEvent;
- (CRTOEvent*) getProductViewEvent;
- (CRTOEvent*) getTransactionConfirmationEvent;

- (void) sendEvent:(CRTOEvent*)event withCallback:(EventSendResult)testCallback;

@end
