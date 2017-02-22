//
//  CRTOMd5HasherTests.m
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
