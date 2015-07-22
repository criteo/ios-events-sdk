//
//  WidgetService.m
//  advertiser-sdk-sandbox
//
//  Created by Paul Davis on 7/22/15.
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "WidgetService.h"
#import <AdSupport/AdSupport.h>

#define WIDGET_PATH (@"/m/event?a=5854&idfa=%@&p0=e%%3Dvh&debug=1")

@implementation WidgetService

- (NSString*) getIdfa
{
    ASIdentifierManager* mgr = [ASIdentifierManager sharedManager];
    NSUUID* idfa = mgr.advertisingIdentifier;

    NSAssert(idfa != nil, @"Nothing can run because the idfa is nil. Try again?");

    return idfa.UUIDString.uppercaseString;
}

- (NSURL*) getWidgetEventURLForIdfa:(NSString*)idfa
{
    NSProcessInfo* process = [NSProcessInfo processInfo];
    NSDictionary* env = process.environment;

    NSString* widgetBaseURL = env[@"WIDGET_BASEURL"];

    NSAssert(widgetBaseURL, @"WIDGET_BASEURL environment variable is not set.");
    NSAssert(widgetBaseURL.length, @"WIDGET_BASEURL environment variable contains an empty string.");

    NSURL* baseURL = [NSURL URLWithString:widgetBaseURL];

    NSString* path = [NSString stringWithFormat:WIDGET_PATH, idfa];

    NSURL* finalURL = [NSURL URLWithString:path relativeToURL:baseURL];

    return finalURL;
}

- (NSString*) readCriteoIdFromDebugHeaderValue:(NSString*)value
{
    NSError* error = nil;

    NSRegularExpression* pattern = [NSRegularExpression regularExpressionWithPattern:@"^.*\"uid\":\"([-a-f0-9]+)\".*$"
                                                                             options:0
                                                                               error:&error];

    if ( error ) {
        NSLog(@"Error creating regular expression for matching CriteoId: %@", error);
    }

    NSTextCheckingResult* result = [pattern firstMatchInString:value
                                                       options:0
                                                         range:NSMakeRange(0, value.length)];

    if ( result && result.numberOfRanges > 1 ) {
        NSRange range = [result rangeAtIndex:1];
        NSString* criteoId = [value substringWithRange:range];
        return criteoId;
    }

    return nil;
}

- (NSString*) getCriteoId
{
    NSString* idfa = [self getIdfa];

    NSURL* requestURL = [self getWidgetEventURLForIdfa:idfa];

    NSURLRequest* request = [NSURLRequest requestWithURL:requestURL];

    NSURLResponse* resp = nil;
    NSError* error = nil;
    NSData* respBody = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:&resp
                                                         error:&error];

    if ( error ) {
        NSLog(@"Error retrieving CriteoId: %@\nRequest: %@\nResponse: %@", error, request, resp);
    }

    if ( respBody ) {
        NSString* respBodyString = [[NSString alloc] initWithBytes:respBody.bytes length:respBody.length encoding:NSUTF8StringEncoding];
        NSLog(@"Got a response body while retrieving CriteoId: %@", respBodyString);
    }

    if ( resp ) {
        NSHTTPURLResponse* httpResp = (NSHTTPURLResponse*)resp;
        NSString* debugValue = httpResp.allHeaderFields[@"debug"];

        if ( debugValue ) {
            NSLog(@"Found debug header while retrieving CriteoId: %@", debugValue);
            NSString* uid = [self readCriteoIdFromDebugHeaderValue:debugValue];
            return uid;
        }
    }

    return nil;
}


@end
