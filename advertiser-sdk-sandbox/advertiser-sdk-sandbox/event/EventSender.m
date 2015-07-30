//
//  EventSender.m
//  advertiser-sdk-sandbox
//
//  Created by Paul Davis on 7/23/15.
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "EventSender.h"

#import <objc/objc.h>
#import <objc/objc-runtime.h>
#import <CriteoAdvertiser/CriteoAdvertiser.h>

id (*typed_msgSend)(id, SEL) = (void *)objc_msgSend;
void (*typed_msgSend_block)(id, SEL, CRTOEventQueueItemBlock) = (void *)objc_msgSend;

@implementation EventSender
{
    id eventQueue;
}

- (instancetype) init
{
    self = [super init];
    if ( self ) {
        [self setupSharedEventQueue];
        [self HACKswizzleAppInfo];
        [self HACKswizzleAppName];
        [self HACKswizzleAppVersion];
        [self HACKswizzleDeviceIdentifier];
    }
    return self;
}

- (NSString*) HACK_swizzled_appId
{
    return @"com.criteo.sdktestapp";
}

- (NSString*) HACK_swizzled_deviceIdentifier
{
    return @"FCCCFB5F-4CF1-489F-AC16-8E2FB2292EF6";
}

- (NSString*) HACK_swizzled_appVersion
{
    return @"1.2.3";
}

- (NSString*) HACK_swizzled_appName
{
    return @"Blah App";
}

- (void) HACKswizzleDeviceIdentifier
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class clsCRTODeviceInfo = objc_getClass("CRTODeviceInfo");

        SEL origDvcIdSelector = sel_registerName("deviceIdentifier");
        SEL newDvcIdSelector = @selector(HACK_swizzled_deviceIdentifier);

        Method originalMethod = class_getInstanceMethod(clsCRTODeviceInfo, origDvcIdSelector);
        Method newMethod = class_getInstanceMethod([self class], newDvcIdSelector);

        BOOL didAddMethod = class_addMethod(clsCRTODeviceInfo,
                                            origDvcIdSelector,
                                            method_getImplementation(newMethod),
                                            method_getTypeEncoding(newMethod));

        if ( didAddMethod ) {
            class_replaceMethod(clsCRTODeviceInfo,
                                newDvcIdSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, newMethod);
        }
    });
}

- (void) HACKswizzleAppInfo
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class clsCRTOAppInfo = objc_getClass("CRTOAppInfo");

        SEL origAppIdSelector = sel_registerName("appId");
        SEL newAppIdSelector = @selector(HACK_swizzled_appId);

        Method originalMethod = class_getInstanceMethod(clsCRTOAppInfo, origAppIdSelector);
        Method newMethod = class_getInstanceMethod([self class], newAppIdSelector);

        BOOL didAddMethod = class_addMethod(clsCRTOAppInfo,
                                            origAppIdSelector,
                                            method_getImplementation(newMethod),
                                            method_getTypeEncoding(newMethod));

        if ( didAddMethod ) {
            class_replaceMethod(clsCRTOAppInfo,
                                newAppIdSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, newMethod);
        }
    });
}

- (void) HACKswizzleAppVersion
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class clsCRTOAppInfo = objc_getClass("CRTOAppInfo");

        SEL origAppVersionSelector = sel_registerName("appVersion");
        SEL newAppVersionSelector = @selector(HACK_swizzled_appVersion);

        Method originalMethod = class_getInstanceMethod(clsCRTOAppInfo, origAppVersionSelector);
        Method newMethod = class_getInstanceMethod([self class], newAppVersionSelector);

        BOOL didAddMethod = class_addMethod(clsCRTOAppInfo,
                                            origAppVersionSelector,
                                            method_getImplementation(newMethod),
                                            method_getTypeEncoding(newMethod));

        if ( didAddMethod ) {
            class_replaceMethod(clsCRTOAppInfo,
                                newAppVersionSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, newMethod);
        }
    });
}

- (void) HACKswizzleAppName
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class clsCRTOAppInfo = objc_getClass("CRTOAppInfo");

        SEL origAppNameSelector = sel_registerName("appName");
        SEL newAppNameSelector = @selector(HACK_swizzled_appName);

        Method originalMethod = class_getInstanceMethod(clsCRTOAppInfo, origAppNameSelector);
        Method newMethod = class_getInstanceMethod([self class], newAppNameSelector);

        BOOL didAddMethod = class_addMethod(clsCRTOAppInfo,
                                            origAppNameSelector,
                                            method_getImplementation(newMethod),
                                            method_getTypeEncoding(newMethod));

        if ( didAddMethod ) {
            class_replaceMethod(clsCRTOAppInfo,
                                newAppNameSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, newMethod);
        }
    });
}

- (void) setupSharedEventQueue
{
    Class clsCRTOEventQueue = objc_getClass("CRTOEventQueue");
    SEL selSharedEventQueue = sel_registerName("sharedEventQueue");

    eventQueue = typed_msgSend(clsCRTOEventQueue, selSharedEventQueue);
}

- (void) registerErrorCallback:(CRTOEventQueueItemBlock)block
{
    SEL selOnItemError = sel_registerName("onItemError:");

    typed_msgSend_block(eventQueue, selOnItemError, block);
}

- (void) registerSuccessCallback:(CRTOEventQueueItemBlock)block
{
    SEL selOnItemSent = sel_registerName("onItemSent:");

    typed_msgSend_block(eventQueue, selOnItemSent, block);
}

- (void) sendEvent:(CRTOEvent*)event withCallback:(EventSendResult)sendCallbackBlock
{
    [self registerErrorCallback:^(id item) {
        if ( sendCallbackBlock ) {
            sendCallbackBlock(item, NO);
        }
    }];

    [self registerSuccessCallback:^(id item) {
        if ( sendCallbackBlock ) {
            sendCallbackBlock(item, YES);
        }
    }];

    [[CRTOEventService sharedEventService] send:event];
}

- (CRTOEvent*) getAppLaunchEvent
{
    CRTOAppLaunchEvent* appLaunch = [[CRTOAppLaunchEvent alloc] init];

    return appLaunch;
}

- (CRTOEvent*) getBasketViewEvent
{
    CRTOBasketProduct* product1 = [[CRTOBasketProduct alloc] initWithProductId:@"1" price:100 quantity:1];
    CRTOBasketProduct* product2 = [[CRTOBasketProduct alloc] initWithProductId:@"2" price:100 quantity:2];
    CRTOBasketProduct* product3 = [[CRTOBasketProduct alloc] initWithProductId:@"3" price:100 quantity:3];

    CRTOBasketViewEvent* basketView = [[CRTOBasketViewEvent alloc] initWithBasketProducts:@[ product1, product2, product3 ]
                                                                                 currency:@"USD"];

    return basketView;
}

- (CRTOEvent*) getDataEvent
{
    CRTODataEvent* data = [[CRTODataEvent alloc] init];

    NSDateComponents* date1 = [[NSDateComponents alloc] init];
    date1.year = 2014;
    date1.month = 12;
    date1.day = 31;
    date1.hour = 10;
    date1.minute = 30;
    date1.second = 59;

    [data setDateExtraData:date1 ForKey:@"my_date"];
    [data setFloatExtraData:100.0 ForKey:@"this_is_a_float"];
    [data setIntegerExtraData:65537 ForKey:@"this_is_an_integer"];
    [data setStringExtraData:@"some_string" ForKey:@"this_has_a_string_value"];

    return data;
}

- (CRTOEvent*) getDeeplinkEvent
{
    CRTODeeplinkEvent* deeplinkEvent = [[CRTODeeplinkEvent alloc] initWithDeeplinkLaunchUrl:@"sdkTestApp:SDKTESTAPP/thing1/thing2?foo=bar&bar=foo#bottom"];

    return deeplinkEvent;
}

- (CRTOEvent*) getHomeViewEvent
{
    CRTOHomeViewEvent* homeView = [CRTOHomeViewEvent new];

    return homeView;
}

- (CRTOEvent*) getProductListViewEvent
{
    CRTOProduct* product1 = [[CRTOProduct alloc] initWithProductId:@"1" price:100];
    CRTOProduct* product2 = [[CRTOProduct alloc] initWithProductId:@"2" price:100];
    CRTOProduct* product3 = [[CRTOProduct alloc] initWithProductId:@"3" price:100];

    CRTOProductListViewEvent* productListView = [[CRTOProductListViewEvent alloc] initWithProducts:@[ product1, product2, product3 ]
                                                                                          currency:@"USD"];

    return productListView;
}

- (CRTOEvent*) getProductViewEvent
{
    CRTOProduct* product1 = [[CRTOProduct alloc] initWithProductId:@"1" price:100];

    CRTOProductViewEvent* productView = [[CRTOProductViewEvent alloc] initWithProduct:product1 currency:@"USD"];

    return productView;
}

- (CRTOEvent*) getTransactionConfirmationEvent
{
    CRTOBasketProduct* product1 = [[CRTOBasketProduct alloc] initWithProductId:@"1" price:100 quantity:1];
    CRTOBasketProduct* product2 = [[CRTOBasketProduct alloc] initWithProductId:@"2" price:100 quantity:2];
    CRTOBasketProduct* product3 = [[CRTOBasketProduct alloc] initWithProductId:@"3" price:100 quantity:3];

    CRTOTransactionConfirmationEvent* transactionConfirm = [[CRTOTransactionConfirmationEvent alloc] initWithBasketProducts:@[ product1, product2, product3 ]
                                                                                                              transactionId:@"1234567890123"
                                                                                                                   currency:@"USD"];

    return transactionConfirm;
}

@end
