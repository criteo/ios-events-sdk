//
//  CRTOTransactionConfirmationEventTests.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "CRTOBasketProduct.h"
#import "CRTOTransactionConfirmationEvent.h"

@interface CRTOTransactionConfirmationEventTests : XCTestCase

@end

@implementation CRTOTransactionConfirmationEventTests
{
    NSString* productId1;
    NSString* productId2;
    NSString* productId3;

    double price1;
    double price2;
    double price3;

    NSInteger quantity1;
    NSInteger quantity2;
    NSInteger quantity3;

    NSString* currency;

    NSString* transactionId;

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

    quantity1  = 1;
    quantity2  = 10;
    quantity3  = -100;

    currency  = @"CAN";

    transactionId = @"TXID1234567890987654321";

    startDate = [NSDate dateWithTimeIntervalSince1970:1000000000];
    endDate   = [NSDate dateWithTimeIntervalSince1970:1000086401];
}

- (void)tearDown
{

    [super tearDown];
}

- (void) testInit
{
    CRTOTransactionConfirmationEvent* event = [[CRTOTransactionConfirmationEvent alloc] init];

    XCTAssertNotNil(event);

    XCTAssertNil(event.currency);
    XCTAssertNil(event.basketProducts);
    XCTAssertNil(event.transactionId);
}

- (void) testInitWithBasketProducts
{
    NSMutableArray* products_init = [NSMutableArray arrayWithArray:@[ [[CRTOBasketProduct alloc] initWithProductId:productId1 price:price1 quantity:quantity1],
                                                                      [[CRTOBasketProduct alloc] initWithProductId:productId2 price:price2 quantity:quantity2],
                                                                      [[CRTOBasketProduct alloc] initWithProductId:productId3 price:price3 quantity:quantity3] ]];

    CRTOTransactionConfirmationEvent* event = [[CRTOTransactionConfirmationEvent alloc] initWithBasketProducts:products_init];

    XCTAssertNotNil(event);

    XCTAssertNil(event.currency);

    XCTAssertNotNil(event.basketProducts);
    XCTAssertEqual(event.basketProducts.count, 3);
    XCTAssertNotEqual(event.basketProducts, products_init);
    XCTAssertEqualObjects(event.basketProducts, products_init);

    XCTAssertNil(event.transactionId);
}

- (void) testInitWithBasketProductsTransactionId
{
    NSMutableArray* products_init = [NSMutableArray arrayWithArray:@[ [[CRTOBasketProduct alloc] initWithProductId:productId1 price:price1 quantity:quantity1],
                                                                      [[CRTOBasketProduct alloc] initWithProductId:productId2 price:price2 quantity:quantity2],
                                                                      [[CRTOBasketProduct alloc] initWithProductId:productId3 price:price3 quantity:quantity3] ]];

    CRTOTransactionConfirmationEvent* event = [[CRTOTransactionConfirmationEvent alloc] initWithBasketProducts:products_init transactionId:transactionId];

    XCTAssertNotNil(event);

    XCTAssertNil(event.currency);

    XCTAssertNotNil(event.basketProducts);
    XCTAssertEqual(event.basketProducts.count, 3);
    XCTAssertNotEqual(event.basketProducts, products_init);
    XCTAssertEqualObjects(event.basketProducts, products_init);

    XCTAssertEqualObjects(event.transactionId, transactionId);
}

- (void) testInitWithBasketProductsTransactionIdCurrency
{
    NSMutableArray* products_init = [NSMutableArray arrayWithArray:@[ [[CRTOBasketProduct alloc] initWithProductId:productId1 price:price1 quantity:quantity1],
                                                                      [[CRTOBasketProduct alloc] initWithProductId:productId2 price:price2 quantity:quantity2],
                                                                      [[CRTOBasketProduct alloc] initWithProductId:productId3 price:price3 quantity:quantity3] ]];

    CRTOTransactionConfirmationEvent* event = [[CRTOTransactionConfirmationEvent alloc] initWithBasketProducts:products_init
                                                                                                 transactionId:transactionId
                                                                                                      currency:currency];

    XCTAssertNotNil(event);

    XCTAssertEqualObjects(event.currency, currency);

    XCTAssertNotNil(event.basketProducts);
    XCTAssertEqual(event.basketProducts.count, 3);
    XCTAssertNotEqual(event.basketProducts, products_init);
    XCTAssertEqualObjects(event.basketProducts, products_init);

    XCTAssertEqualObjects(event.transactionId, transactionId);
}

- (void) testInitWithBasketProductsTransactionIdCurrencyDates
{
    NSMutableArray* products_init = [NSMutableArray arrayWithArray:@[ [[CRTOBasketProduct alloc] initWithProductId:productId1 price:price1 quantity:quantity1],
                                                                      [[CRTOBasketProduct alloc] initWithProductId:productId2 price:price2 quantity:quantity2],
                                                                      [[CRTOBasketProduct alloc] initWithProductId:productId3 price:price3 quantity:quantity3] ]];

    CRTOTransactionConfirmationEvent* event = [[CRTOTransactionConfirmationEvent alloc] initWithBasketProducts:products_init
                                                                                                 transactionId:transactionId
                                                                                                      currency:currency
                                                                                                     startDate:startDate
                                                                                                       endDate:endDate];

    XCTAssertNotNil(event);

    XCTAssertEqualObjects(event.currency, currency);

    XCTAssertNotNil(event.basketProducts);
    XCTAssertEqual(event.basketProducts.count, 3);
    XCTAssertNotEqual(event.basketProducts, products_init);
    XCTAssertEqualObjects(event.basketProducts, products_init);

    XCTAssertEqualObjects(event.transactionId, transactionId);

    XCTAssertEqualObjects(event.startDate, startDate);
    XCTAssertEqualObjects(event.endDate, endDate);
}

- (void) testTransactionConfirmationEventCopy
{
    NSMutableArray* products_init = [NSMutableArray arrayWithArray:@[ [[CRTOBasketProduct alloc] initWithProductId:productId1 price:price1 quantity:quantity1],
                                                                      [[CRTOBasketProduct alloc] initWithProductId:productId2 price:price2 quantity:quantity2],
                                                                      [[CRTOBasketProduct alloc] initWithProductId:productId3 price:price3 quantity:quantity3] ]];

    CRTOTransactionConfirmationEvent* event = [[CRTOTransactionConfirmationEvent alloc] initWithBasketProducts:products_init
                                                                                                 transactionId:transactionId
                                                                                                      currency:currency
                                                                                                     startDate:startDate
                                                                                                       endDate:endDate];

    CRTOTransactionConfirmationEvent* eventCopy = [event copy];

    XCTAssertEqualObjects(event.basketProducts, eventCopy.basketProducts);
    XCTAssertEqualObjects(event.currency, eventCopy.currency);
    XCTAssertEqualObjects(event.transactionId, transactionId);
    XCTAssertEqualObjects(event.startDate, eventCopy.startDate);
    XCTAssertEqualObjects(event.endDate, eventCopy.endDate);
}

@end
