//
//  CRTOProductTests.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

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
