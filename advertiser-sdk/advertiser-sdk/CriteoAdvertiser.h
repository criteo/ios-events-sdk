//
//  CriteoAdvertiser.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@import AdSupport;

//! Project version number for advertiser-sdk.
FOUNDATION_EXPORT double advertiser_sdkVersionNumber;

//! Project version string for advertiser-sdk.
FOUNDATION_EXPORT const unsigned char advertiser_sdkVersionString[];

#import <CriteoAdvertiser/CRTOProduct.h>
#import <CriteoAdvertiser/CRTOBasketProduct.h>

#import <CriteoAdvertiser/CRTOEvent.h>
#import <CriteoAdvertiser/CRTOAppLaunchEvent.h>
#import <CriteoAdvertiser/CRTOBasketViewEvent.h>
#import <CriteoAdvertiser/CRTODataEvent.h>
#import <CriteoAdvertiser/CRTOHomeViewEvent.h>
#import <CriteoAdvertiser/CRTOProductListViewEvent.h>
#import <CriteoAdvertiser/CRTOProductViewEvent.h>
#import <CriteoAdvertiser/CRTOTransactionConfirmationEvent.h>

#import <CriteoAdvertiser/CRTOEventService.h>
