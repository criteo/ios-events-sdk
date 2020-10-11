//
//  CRTOProductListViewEventTests.m
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

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "CRTOProduct.h"
#import "CRTOProductListViewEvent.h"

@interface CRTOProductListViewEventTests : XCTestCase

@end

@implementation CRTOProductListViewEventTests
{
    NSString* productId1;
    NSString* productId2;
    NSString* productId3;

    double price1;
    double price2;
    double price3;

    NSString* currency;

    NSDateComponents* startDate;
    NSDateComponents* endDate;
}

- (void)setUp
{
    [super setUp];

    productId1 = @"foo";
    productId2 = @"bar";
    productId3 = @"나는 유리를 먹을 수 있어요. 그래도 아프지 않아요";

    price1     = 999.85;
    price2     = 0.1;
    price3     = 0.1 + 0.1 + 0.1;

    currency  = @"CAN";

    startDate = [NSDateComponents new];
    startDate.year  = 2001;
    startDate.month = 9;
    startDate.day   = 9;

    endDate = [NSDateComponents new];
    endDate.year  = 2001;
    endDate.month = 9;
    endDate.day   = 10;
}

- (void)tearDown
{

    [super tearDown];
}

- (void) testInit
{
    CRTOProductListViewEvent* event = [[CRTOProductListViewEvent alloc] init];

    XCTAssertNotNil(event);

    XCTAssertNil(event.currency);
    XCTAssertNil(event.products);
}

- (void) testInitWithProducts
{
    NSMutableArray* products_init = [NSMutableArray arrayWithArray:@[ [[CRTOProduct alloc] initWithProductId:productId1 price:price1],
                                                                      [[CRTOProduct alloc] initWithProductId:productId2 price:price2],
                                                                      [[CRTOProduct alloc] initWithProductId:productId3 price:price3] ]];

    CRTOProductListViewEvent* event = [[CRTOProductListViewEvent alloc] initWithProducts:products_init];

    XCTAssertNotNil(event);

    XCTAssertNil(event.currency);

    XCTAssertNotNil(event.products);
    XCTAssertEqual(event.products.count, 3);
    XCTAssertNotEqual(event.products, products_init);
    XCTAssertEqualObjects(event.products, products_init);
}

- (void) testInitWithNilProducts
{
    CRTOProductListViewEvent* event = [[CRTOProductListViewEvent alloc] initWithProducts:nil];

    XCTAssertNotNil(event);
    XCTAssertNil(event.products);
}

- (void) testInitWithNonProducts
{
    NSArray* not_entirely_products = @[ [[CRTOProduct alloc] initWithProductId:productId1 price:price1],
                                        @"Not A Product",
                                        @"Also not a product",
                                        [NSNull null] ];

    CRTOProductListViewEvent* event = [[CRTOProductListViewEvent alloc] initWithProducts:not_entirely_products];

    XCTAssertNotNil(event.products);
    XCTAssertEqual(event.products.count, 1);
    XCTAssert([event.products containsObject:not_entirely_products[0]]);
}

- (void) testInitWithProductsCurrency
{
    NSMutableArray* products_init = [NSMutableArray arrayWithArray:@[ [[CRTOProduct alloc] initWithProductId:productId1 price:price1],
                                                                      [[CRTOProduct alloc] initWithProductId:productId2 price:price2],
                                                                      [[CRTOProduct alloc] initWithProductId:productId3 price:price3] ]];

    CRTOProductListViewEvent* event = [[CRTOProductListViewEvent alloc] initWithProducts:products_init currency:currency];

    XCTAssertNotNil(event);

    XCTAssertEqualObjects(event.currency, currency);

    XCTAssertNotNil(event.products);
    XCTAssertEqual(event.products.count, 3);
    XCTAssertNotEqual(event.products, products_init);
    XCTAssertEqualObjects(event.products, products_init);
}

- (void) testInitWithProductsCurrencyDates
{
    NSMutableArray* products_init = [NSMutableArray arrayWithArray:@[ [[CRTOProduct alloc] initWithProductId:productId1 price:price1],
                                                                      [[CRTOProduct alloc] initWithProductId:productId2 price:price2],
                                                                      [[CRTOProduct alloc] initWithProductId:productId3 price:price3] ]];

    CRTOProductListViewEvent* event = [[CRTOProductListViewEvent alloc] initWithProducts:products_init
                                                                                currency:currency
                                                                               startDate:startDate
                                                                                 endDate:endDate];

    XCTAssertNotNil(event);

    XCTAssertEqualObjects(event.currency, currency);

    XCTAssertNotNil(event.products);
    XCTAssertEqual(event.products.count, 3);
    XCTAssertNotEqual(event.products, products_init);
    XCTAssertEqualObjects(event.products, products_init);

    XCTAssertEqualObjects(event.startDate, startDate);
    XCTAssertEqualObjects(event.endDate, endDate);
}

- (void) testProductListViewEventCopy
{
    NSMutableArray* products_init = [NSMutableArray arrayWithArray:@[ [[CRTOProduct alloc] initWithProductId:productId1 price:price1],
                                                                      [[CRTOProduct alloc] initWithProductId:productId2 price:price2],
                                                                      [[CRTOProduct alloc] initWithProductId:productId3 price:price3] ]];

    CRTOProductListViewEvent* event = [[CRTOProductListViewEvent alloc] initWithProducts:products_init
                                                                                currency:currency
                                                                               startDate:startDate
                                                                                 endDate:endDate];

    CRTOProductListViewEvent* eventCopy = [event copy];

    XCTAssertEqualObjects(event.products, eventCopy.products);
    XCTAssertEqualObjects(event.currency, eventCopy.currency);
    XCTAssertEqualObjects(event.startDate, eventCopy.startDate);
    XCTAssertEqualObjects(event.endDate, eventCopy.endDate);
}

- (void) testSetProductsWithNonProducts
{
    NSArray* not_entirely_products = @[ [[CRTOProduct alloc] initWithProductId:productId1 price:price1],
                                        @"Not A Product",
                                        @"Also not a product",
                                        [NSNull null] ];

    CRTOProductListViewEvent* event = [[CRTOProductListViewEvent alloc] init];
    event.products = not_entirely_products;

    XCTAssertNotNil(event.products);
    XCTAssertEqual(event.products.count, 1);
    XCTAssert([event.products containsObject:not_entirely_products[0]]);
}

@end
