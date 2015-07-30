//
//  WidgetService.m
//  advertiser-sdk-sandbox
//
//  Created by Paul Davis on 7/22/15.
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "WidgetService.h"
#import <AdSupport/AdSupport.h>
#import "LoaderDelegate.h"

#define WIDGET_PATH (@"/m/event?a=13963&idfa=%@&p0=e%%3Dvh&debug=1")

@implementation WidgetService

- (NSString*) getIdfa
{
    ASIdentifierManager* mgr = [ASIdentifierManager sharedManager];
    NSUUID* idfa = mgr.advertisingIdentifier;

    /* HACK HACK HACK */
    //if ( idfa == nil ) {
        return @"FCCCFB5F-4CF1-489F-AC16-8E2FB2292EF6";
    //}
    /* HACK HACK HACK */

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
    return [self getCriteoIdHACK];
}

- (NSString*) getCriteoIdHACK
{
    NSString* idfa = [self getIdfa];

    NSURL* requestURL = [self getWidgetEventURLForIdfa:idfa];

    dispatch_semaphore_t request_done = dispatch_semaphore_create(0);

    NSURLRequest* request = [NSURLRequest requestWithURL:requestURL];

    __block NSString* uid = nil;

    LoaderDelegate* localDelegate = [[LoaderDelegate alloc] initWithBlock:^(LoaderDelegate* delegate) {

        if ( delegate.error ) {
            NSLog(@"Error retrieving CriteoId: %@\nRequest: %@\nResponse: %@", delegate.error, request, delegate.response);
        }

        if ( delegate.responseData ) {
            NSLog(@"Got a response body while retrieving CriteoId: %@", delegate.responseString);
        }

        if ( delegate.response ) {
            NSHTTPURLResponse* httpResp = (NSHTTPURLResponse*)delegate.response;
            NSString* debugValue = httpResp.allHeaderFields[@"debug"];

            if ( debugValue ) {
                NSLog(@"Found debug header while retrieving CriteoId: %@", debugValue);
                uid = [self readCriteoIdFromDebugHeaderValue:debugValue];
            }
        }

        dispatch_semaphore_signal(request_done);
    }];

    NSOperationQueue* q = [[NSOperationQueue alloc] init];

    NSURLConnection* cxn = [[NSURLConnection alloc] initWithRequest:request delegate:localDelegate startImmediately:NO];
    [cxn setDelegateQueue:q];
    [cxn start];

    dispatch_semaphore_wait(request_done, DISPATCH_TIME_FOREVER);

    return uid;
}

- (NSString*) getCriteoIdNORMAL
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
