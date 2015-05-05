//
//  CRTOJSONEventSerializer.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "CRTOJSONEventSerializer.h"
#import "CRTOEvent.h"
#import "CRTOEvent+Internal.h"
#import "CRTOAppLaunchEvent.h"
#import "CRTOAppLaunchEvent+Internal.h"
#import "CRTODataEvent.h"
#import "CRTODataEvent+Internal.h"
#import "CRTOBasketViewEvent.h"
#import "CRTOBasketViewEvent+Internal.h"
#import "CRTOHomeViewEvent.h"
#import "CRTOHomeViewEvent+Internal.h"
#import "CRTOProductListViewEvent.h"
#import "CRTOProductListViewEvent+Internal.h"
#import "CRTOProductViewEvent.h"
#import "CRTOProductViewEvent+Internal.h"
#import "CRTOTransactionConfirmationEvent.h"
#import "CRTOTransactionConfirmationEvent+Internal.h"
#import "CRTOBasketProduct.h"
#import "CRTOProduct.h"


@interface CRTOJSONEventSerializer ()

+ (NSString*) serializeAppLaunchEvent:(CRTOAppLaunchEvent*)event;
+ (NSString*) serializeBasketViewEvent:(CRTOBasketViewEvent*)event;
+ (NSString*) serializeHomeViewEvent:(CRTOHomeViewEvent*)event;
+ (NSString*) serializeProductListViewEvent:(CRTOProductListViewEvent*)event;
+ (NSString*) serializeProductViewEvent:(CRTOProductViewEvent*)event;
+ (NSString*) serializeTransactionConfirmationEvent:(CRTOTransactionConfirmationEvent*)event;

@end

@implementation CRTOJSONEventSerializer

#pragma mark - Public Static Methods

+ (NSString*) serializeEventToJSONString:(CRTOEvent*)event
{
    NSParameterAssert(event);

    if ( [event isMemberOfClass:[CRTOAppLaunchEvent class]] ) {
        return [CRTOJSONEventSerializer serializeAppLaunchEvent:(CRTOAppLaunchEvent*)event];
    }

    if ( [event isMemberOfClass:[CRTOBasketViewEvent class]] ) {
        return [CRTOJSONEventSerializer serializeBasketViewEvent:(CRTOBasketViewEvent*)event];
    }

    if ( [event isMemberOfClass:[CRTOHomeViewEvent class]] ) {
        return [CRTOJSONEventSerializer serializeHomeViewEvent:(CRTOHomeViewEvent*)event];
    }

    if ( [event isMemberOfClass:[CRTOProductListViewEvent class]] ) {
        return [CRTOJSONEventSerializer serializeProductListViewEvent:(CRTOProductListViewEvent*)event];
    }

    if ( [event isMemberOfClass:[CRTOProductViewEvent class]] ) {
        return [CRTOJSONEventSerializer serializeProductViewEvent:(CRTOProductViewEvent*)event];
    }

    if ( [event isMemberOfClass:[CRTOTransactionConfirmationEvent class]] ) {
        return [CRTOJSONEventSerializer serializeTransactionConfirmationEvent:(CRTOTransactionConfirmationEvent*)event];
    }

    return nil;
}

#pragma mark - Static Class Extension Methods

+ (NSString*) serializeAppLaunchEvent:(CRTOAppLaunchEvent*)event
{
    // TODO: serialize this type of event
    @throw [NSException exceptionWithName:@"NotImplementedException"
                                   reason:@"It's not implemented"
                                 userInfo:nil];
}

+ (NSString*) serializeBasketViewEvent:(CRTOBasketViewEvent*)event
{
    // TODO: serialize this type of event
    @throw [NSException exceptionWithName:@"NotImplementedException"
                                   reason:@"It's not implemented"
                                 userInfo:nil];
}

+ (NSString*) serializeHomeViewEvent:(CRTOHomeViewEvent*)event
{
    // TODO: serialize this type of event
    @throw [NSException exceptionWithName:@"NotImplementedException"
                                   reason:@"It's not implemented"
                                 userInfo:nil];
}

+ (NSString*) serializeProductListViewEvent:(CRTOProductListViewEvent*)event
{
    // TODO: serialize this type of event
    @throw [NSException exceptionWithName:@"NotImplementedException"
                                   reason:@"It's not implemented"
                                 userInfo:nil];
}

+ (NSString*) serializeProductViewEvent:(CRTOProductViewEvent*)event
{
    // TODO: serialize this type of event
    @throw [NSException exceptionWithName:@"NotImplementedException"
                                   reason:@"It's not implemented"
                                 userInfo:nil];
}

+ (NSString*) serializeTransactionConfirmationEvent:(CRTOTransactionConfirmationEvent*)event
{
    // TODO: serialize this type of event
    @throw [NSException exceptionWithName:@"NotImplementedException"
                                   reason:@"It's not implemented"
                                 userInfo:nil];
}

@end
