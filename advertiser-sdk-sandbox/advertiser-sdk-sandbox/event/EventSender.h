//
//  EventSender.h
//  advertiser-sdk-sandbox
//
//  Created by Paul Davis on 7/23/15.
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CRTOEventQueueItemBlock)(id item);
typedef void(^EventSendResult)(id item, BOOL success);

@interface EventSender : NSObject

- (void) sendAppLaunchEventWithCallback:(EventSendResult)testCallback;
- (void) sendBasketViewEventWithCallback:(EventSendResult)testCallback;
- (void) sendDataEventWithCallback:(EventSendResult)testCallback;
- (void) sendDeeplinkEventWithCallback:(EventSendResult)testCallback;
- (void) sendHomeViewEventWithCallback:(EventSendResult)testCallback;
- (void) sendProductListViewEventWithCallback:(EventSendResult)testCallback;
- (void) sendProductViewEventWithCallback:(EventSendResult)testCallback;
- (void) sendTransactionConfirmationEventWithCallback:(EventSendResult)testCallback;

@end
