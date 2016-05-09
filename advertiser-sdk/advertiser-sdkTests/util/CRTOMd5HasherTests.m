//
//  CRTOMd5HasherTests.m
//  advertiser-sdk
//
//  Created by Paul Davis on 5/4/16.
//  Copyright © 2016 Criteo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CRTOMd5Hasher.h"

@interface CRTOMd5HasherTests : XCTestCase

@end

@implementation CRTOMd5HasherTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testHashOfNil
{
    CRTOMd5Hasher* hasher = [CRTOMd5Hasher new];

    XCTAssertNil([hasher computeHashForString:nil]);
}

- (void) testHashOfEmpty
{
    CRTOMd5Hasher* hasher = [CRTOMd5Hasher new];

    NSString* expected = @"d41d8cd98f00b204e9800998ecf8427e";

    NSString* result = [hasher computeHashForString:[NSString string]];

    XCTAssertEqualObjects(expected, result);
}

- (void) testHashOfUppper
{
    CRTOMd5Hasher* hasher = [CRTOMd5Hasher new];

    NSString* expected = @"5a3f2bbc4a48a3b65438890ecb202aba";

    NSString* result = [hasher computeHashForString:@"TOTO@GMAIL.COM"];

    XCTAssertEqualObjects(expected, result);
}

- (void) testHashOfLower
{
    CRTOMd5Hasher* hasher = [CRTOMd5Hasher new];

    NSString* expected = @"5a3f2bbc4a48a3b65438890ecb202aba";

    NSString* result = [hasher computeHashForString:@"toto@gmail.com"];

    XCTAssertEqualObjects(expected, result);
}

- (void) testHashOfMixed
{
    CRTOMd5Hasher* hasher = [CRTOMd5Hasher new];

    NSString* expected = @"5a3f2bbc4a48a3b65438890ecb202aba";

    NSString* result = [hasher computeHashForString:@"TOTO@gmail.com"];

    XCTAssertEqualObjects(expected, result);
}

- (void) testHashOfMixedWithWhitespace
{
    CRTOMd5Hasher* hasher = [CRTOMd5Hasher new];

    NSString* expected = @"5a3f2bbc4a48a3b65438890ecb202aba";

    NSString* result = [hasher computeHashForString:@" \t\t TOTO@gmail.com\n\r \r\n \t"];

    XCTAssertEqualObjects(expected, result);
}

- (void) testHashOfHugeStringFails
{
    CRTOMd5Hasher* hasher = [CRTOMd5Hasher new];

    NSString* expected = nil;

    NSUInteger testStringSize = (1024 * 1024 * 2);

    NSMutableString* testString = [[NSMutableString alloc] initWithCapacity:testStringSize];

    for (uint ii = 0; ii < testStringSize; ii++) {
        [testString appendFormat:@"z"];
    }

    NSString* result = [hasher computeHashForString:testString];

    XCTAssertEqual(expected, result);
}

@end
