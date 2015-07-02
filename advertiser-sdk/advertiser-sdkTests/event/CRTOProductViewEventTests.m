//
//  CRTOProductViewEventTests.m
//  advertiser-sdk
//
//  Created by Paul Davis on 7/2/15.
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "CRTOProduct.h"
#import "CRTOProductViewEvent.h"

@interface CRTOProductViewEventTests : XCTestCase

@end

@implementation CRTOProductViewEventTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testInit
{
    CRTOProductViewEvent* event = [[CRTOProductViewEvent alloc] init];

    XCTAssertNotNil(event);

    XCTAssertNil(event.currency);
    XCTAssertNil(event.product);
}

- (void) testInitWithProduct
{
    NSString* productId = @"foo";
    double price = 999.85;

    CRTOProduct* product = [[CRTOProduct alloc] initWithProductId:productId price:price];

    CRTOProductViewEvent* event = [[CRTOProductViewEvent alloc] initWithProduct:product];

    XCTAssertNotNil(event);

    XCTAssertNil(event.currency);

    XCTAssertEqual(event.product, product);
    XCTAssert([event.product isKindOfClass:[CRTOProduct class]]);
    XCTAssertEqualObjects(event.product.productId, productId);
    XCTAssertEqual(event.product.price, price);
}

- (void) testInitWithProductCurrency
{
    NSString* productId = @"foo";
    double price = 999.85;
    NSString* currency = @"EUR";

    CRTOProduct* product = [[CRTOProduct alloc] initWithProductId:productId price:price];

    CRTOProductViewEvent* event = [[CRTOProductViewEvent alloc] initWithProduct:product currency:currency];

    XCTAssertNotNil(event);

    XCTAssertEqualObjects(currency, event.currency);

    XCTAssertEqual(event.product, product);
    XCTAssert([event.product isKindOfClass:[CRTOProduct class]]);
    XCTAssertEqualObjects(event.product.productId, productId);
    XCTAssertEqual(event.product.price, price);
}

- (void) testInitWithProductCurrencyDates
{
    NSString* productId = @"foo";
    double price = 999.85;
    NSString* currency = @"EUR";
    NSDate* startDate = [NSDate dateWithTimeIntervalSince1970:1000000000];
    NSDate* endDate = [NSDate dateWithTimeIntervalSince1970:1000086401];

    CRTOProduct* product = [[CRTOProduct alloc] initWithProductId:productId price:price];

    CRTOProductViewEvent* event = [[CRTOProductViewEvent alloc] initWithProduct:product
                                                                       currency:currency
                                                                      startDate:startDate
                                                                        endDate:endDate];

    XCTAssertNotNil(event);

    XCTAssertEqualObjects(currency, event.currency);

    XCTAssertEqual(event.product, product);
    XCTAssert([event.product isKindOfClass:[CRTOProduct class]]);
    XCTAssertEqualObjects(event.product.productId, productId);
    XCTAssertEqual(event.product.price, price);

    XCTAssertEqualObjects(event.startDate, startDate);
    XCTAssertEqualObjects(event.endDate, endDate);
}

@end
