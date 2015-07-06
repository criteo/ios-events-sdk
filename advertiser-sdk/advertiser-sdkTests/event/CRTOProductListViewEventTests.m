//
//  CRTOProductListViewEventTests.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

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
    NSDate* startDate;
    NSDate* endDate;
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

    startDate = [NSDate dateWithTimeIntervalSince1970:1000000000];
    endDate   = [NSDate dateWithTimeIntervalSince1970:1000086401];
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

@end
