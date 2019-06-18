//
//  CRTODeeplinkEventTests.m
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

#import "CRTOEvent.h"
#import "CRTOEvent+Internal.h"
#import "CRTODeeplinkEvent.h"

@interface CRTODeeplinkEventTests : XCTestCase

@end

@implementation CRTODeeplinkEventTests

- (void) setUp
{
    [super setUp];

}

- (void) tearDown
{
    [super tearDown];
}

- (void) testFacebookAccessTokenRemoval {

    NSArray *testCases = @[
                           @[@"",                                                                    @""],
                           @[@"bestapp://deeplinks-are-cool",                                        @"bestapp://deeplinks-are-cool"],
                           @[@"bestapp://deeplinks-are-cool&access_token=EAAZDGZIUD153Z",            @"bestapp://deeplinks-are-cool&access_token=__REDACTED_ACCESS_TOKEN__"],
                           @[@"bestapp://access_token=EAAZDGZIUD153Z&deeplinks-are-cool",            @"bestapp://access_token=__REDACTED_ACCESS_TOKEN__&deeplinks-are-cool"],
                           @[@"bestapp://blabla=42&access_token=EAAZDGZIUD153Z&deeplinks-are-cool",  @"bestapp://blabla=42&access_token=__REDACTED_ACCESS_TOKEN__&deeplinks-are-cool"],
                           @[@"bestapp://deeplinks-are-cool&paccess_token=EAAZDGZIUD153Z",           @"bestapp://deeplinks-are-cool&paccess_token=EAAZDGZIUD153Z"],
                           @[@"bestapp://paccess_token=EAAZDGZIUD153Z&deeplinks-are-cool",           @"bestapp://paccess_token=EAAZDGZIUD153Z&deeplinks-are-cool"],
                           @[@"bestapp://blabla=42&paccess_token=EAAZDGZIUD153Z&deeplinks-are-cool", @"bestapp://blabla=42&paccess_token=EAAZDGZIUD153Z&deeplinks-are-cool"],
                           @[@"bestapp://access_token=EAAZDGZIUD153Z",                               @"bestapp://access_token=__REDACTED_ACCESS_TOKEN__"],
                           @[@"access_token=EAAZDGZIUD153Z",                                         @"access_token=__REDACTED_ACCESS_TOKEN__"],
                           @[@"access_token=EAAZDGZIUD153Z&access_token=EAAZDGZIUD153Z",             @"access_token=__REDACTED_ACCESS_TOKEN__&access_token=__REDACTED_ACCESS_TOKEN__"],

                        @[@"access_token=EAAZDGZIUD153Z&access_token=EAAZDGZIUD153Z&access_token=EAAZDGZIUD153Z",             @"access_token=__REDACTED_ACCESS_TOKEN__&access_token=__REDACTED_ACCESS_TOKEN__&access_token=__REDACTED_ACCESS_TOKEN__"]
                           ];

    for (NSArray *testCase in testCases) {
        NSString *input = [testCase objectAtIndex:0];
        NSString *expected = [testCase objectAtIndex:1];

        CRTODeeplinkEvent* event = [[CRTODeeplinkEvent alloc] initWithDeeplinkLaunchUrl:input];

        XCTAssertEqualObjects(expected, event.deeplinkLaunchUrl);
    }
}

- (void) testDeeplinkInit
{
    CRTODeeplinkEvent* event = [[CRTODeeplinkEvent alloc] init];

    XCTAssertNil(event.deeplinkLaunchUrl);
}

- (void) testDeeplinkInitWithNilURL
{
    CRTODeeplinkEvent* event = [[CRTODeeplinkEvent alloc] initWithDeeplinkLaunchUrl:nil];

    XCTAssertNotNil(event);
    XCTAssertNil(event.deeplinkLaunchUrl);
}

- (void) testDeeplinkInitWithNonNilURL
{
    NSMutableString* exampleUrl = [NSMutableString stringWithString:@"some string"];

    CRTODeeplinkEvent* event = [[CRTODeeplinkEvent alloc] initWithDeeplinkLaunchUrl:exampleUrl];

    XCTAssertNotNil(event);
    XCTAssertEqualObjects(exampleUrl, event.deeplinkLaunchUrl);
    XCTAssertNotEqual(exampleUrl, event.deeplinkLaunchUrl, @"Mutable string argument wasn't copied");
}

- (void) testDeeplinkEventCopy
{
    NSMutableString* exampleUrl = [NSMutableString stringWithString:@"some string"];

    CRTODeeplinkEvent* event = [[CRTODeeplinkEvent alloc] initWithDeeplinkLaunchUrl:exampleUrl];
    CRTODeeplinkEvent* eventCopy = [event copy];

    XCTAssertEqualObjects(event.deeplinkLaunchUrl, eventCopy.deeplinkLaunchUrl);
    XCTAssertNotEqual(event, eventCopy);
}

@end
