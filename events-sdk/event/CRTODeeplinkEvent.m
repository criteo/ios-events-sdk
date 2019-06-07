//
//  CRTODeeplinkEvent.m
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

#import "CRTODeeplinkEvent.h"
#import "CRTODeeplinkEvent+Internal.h"
#import "CRTOEvent+Internal.h"

@implementation CRTODeeplinkEvent

#pragma mark - Initializers

- (instancetype) init
{
    return [self initWithDeeplinkLaunchUrl:nil];
}

- (instancetype) initWithDeeplinkLaunchUrl:(NSString*)url
{
    self = [super init];
    if ( self ) {
        if ( url ) {
            _deeplinkLaunchUrl = [CRTODeeplinkEvent deeplinkWithoutFacebookAccessToken:[NSString stringWithString:url]];
        }
    }
    return self;
}

#pragma mark - NSCopying

- (instancetype) copyWithZone:(NSZone*)zone
{
    CRTODeeplinkEvent* eventCopy = [[CRTODeeplinkEvent alloc] initWithEvent:self];

    eventCopy->_deeplinkLaunchUrl = self.deeplinkLaunchUrl;

    return eventCopy;
}

#pragma mark - Class Extension Properties

- (BOOL) isValid
{
    BOOL valid = YES;

    valid = valid && [super isValid];

    return valid;
}

#pragma mark - Facebook Access Token Filtering

- (void) setDeeplinkLaunchUrl:(NSString *)deeplinkLaunchUrl {
    _deeplinkLaunchUrl = [CRTODeeplinkEvent deeplinkWithoutFacebookAccessToken:deeplinkLaunchUrl];
}

+ (NSString *) deeplinkWithoutFacebookAccessToken:(NSString *)originalDeeplink {
    // Create regex just once to save compilation
    static dispatch_once_t onceToken;
    static NSRegularExpression *accessTokenRemoval;
    dispatch_once(&onceToken, ^{
        accessTokenRemoval = [NSRegularExpression regularExpressionWithPattern:@"((?<![A-Za-z])access_token=)[^&]*" options:0 error:nil];
    });

    NSArray *matches = [accessTokenRemoval matchesInString:originalDeeplink
                                               options:0
                                                 range:NSMakeRange(0, [originalDeeplink length])];


    NSString *result = originalDeeplink;
    int offset = 0;
    NSString *replacementString = @"__REDACTED_ACCESS_TOKEN__";
    for (NSTextCheckingResult *match in matches) {
        NSLog(@"-----------------------");
        NSRange firstRange = [match rangeAtIndex:0];
        NSRange secondRange = [match rangeAtIndex:1];

        NSRange replacementRange = NSMakeRange(secondRange.location + secondRange.length + offset, firstRange.length - secondRange.length);

        result = [result stringByReplacingCharactersInRange:replacementRange withString:replacementString];
        offset += replacementString.length - replacementRange.length;
    }

    return result;
}

@end
