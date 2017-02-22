//
//  CRTOProductTests.m
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

@interface CRTOProductTests : XCTestCase

@end

@implementation CRTOProductTests
{
    NSMutableString* productId;
    double price;
}

- (void)setUp
{
    [super setUp];

    productId = [NSMutableString stringWithString:@"Some Product Id111222333"];
    price = 999.85;
}

- (void)tearDown
{

    [super tearDown];
}

- (void) testProductInit
{
    CRTOProduct* product = [[CRTOProduct alloc] init];

    XCTAssertNotNil(product);

    XCTAssertNil(product.productId);
    XCTAssertEqual(product.price, 0.0);
}

- (void) testProductInitProductIdPrice
{
    CRTOProduct* product = [[CRTOProduct alloc] initWithProductId:productId price:price];

    XCTAssertNotNil(product);

    XCTAssertNotEqual(product.productId, productId);
    XCTAssertEqualObjects(product.productId, productId);

    XCTAssertEqual(product.price, price);
}

- (void) testProductCopy
{
    CRTOProduct* product = [[CRTOProduct alloc] initWithProductId:productId price:price];

    CRTOProduct* product2 = [product copy];

    XCTAssertNotNil(product2);

    XCTAssertEqualObjects(product2.productId, product.productId);

    XCTAssertEqual(product2.price, product.price);
}

@end
