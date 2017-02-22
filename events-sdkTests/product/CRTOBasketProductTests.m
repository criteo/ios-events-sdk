//
//  CRTOBasketProductTests.m
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

#import "CRTOBasketProduct.h"

@interface CRTOBasketProductTests : XCTestCase

@end

@implementation CRTOBasketProductTests
{
    NSMutableString* productId;
    double price;
    NSInteger quantity;
}

- (void)setUp
{
    [super setUp];

    productId = [NSMutableString stringWithString:@"111000999898 Test Product Identifier"];
    price = 0.1;
    quantity = 1000000;
}

- (void)tearDown
{

    [super tearDown];
}

- (void) testInit
{
    CRTOBasketProduct* basketProduct = [[CRTOBasketProduct alloc] init];

    XCTAssertNotNil(basketProduct);

    XCTAssertNil(basketProduct.productId);
    XCTAssertEqual(basketProduct.price, 0.0);
    XCTAssertEqual(basketProduct.quantity, 0);
}

- (void) testInitProductIdPriceQuantity
{
    CRTOBasketProduct* basketProduct = [[CRTOBasketProduct alloc] initWithProductId:productId price:price quantity:quantity];

    XCTAssertNotNil(basketProduct);

    XCTAssertNotEqual(basketProduct.productId, productId);
    XCTAssertEqualObjects(basketProduct.productId, productId);

    XCTAssertEqual(basketProduct.price, price);

    XCTAssertEqual(basketProduct.quantity, quantity);
}

- (void) testBasketProductCopy
{
    CRTOBasketProduct* basketProduct = [[CRTOBasketProduct alloc] initWithProductId:productId price:price quantity:quantity];

    CRTOBasketProduct* basketProduct2 = [basketProduct copy];

    XCTAssertNotNil(basketProduct2);

    XCTAssertEqualObjects(basketProduct2.productId, basketProduct.productId);

    XCTAssertEqual(basketProduct2.price, basketProduct.price);

    XCTAssertEqual(basketProduct2.quantity, basketProduct.quantity);
}

@end
