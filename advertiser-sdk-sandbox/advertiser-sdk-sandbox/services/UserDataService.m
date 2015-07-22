//
//  UserDataService.m
//  advertiser-sdk-sandbox
//
//  Created by Paul Davis on 7/22/15.
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "UserDataService.h"
#import <AdSupport/AdSupport.h>

#define USERDATA_UIC_PATH  (@"/uic/get?uidInsteadOfContext=%@")
#define USERDATA_ACDC_PATH (@"/acdc/get?uidInsteadOfContext=%@")

@implementation UserDataService

#pragma mark - Methods

- (NSURL*) getUserDataURLForPath:(NSString*)path uid:(NSString*)uid
{
    NSProcessInfo* process = [NSProcessInfo processInfo];
    NSDictionary* env = process.environment;

    NSString* userDataBaseUrl = env[@"USERDATAWS_BASEURL"];

    NSAssert(userDataBaseUrl, @"USERDATAWS_BASEURL environment variable is not set.");
    NSAssert(userDataBaseUrl.length, @"USERDATAWS_BASEURL environment variable contains an empty string.");

    NSURL* baseURL = [NSURL URLWithString:userDataBaseUrl];

    NSString* pathWithUid = [NSString stringWithFormat:path, uid];

    NSURL* finalURL = [NSURL URLWithString:pathWithUid relativeToURL:baseURL];

    return finalURL;
}

- (NSURL*) getUserDataAcdcURLForUid:(NSString*)uid
{
    return [self getUserDataURLForPath:USERDATA_ACDC_PATH uid:uid];}

- (NSURL*) getUserDataUicURLForUid:(NSString*)uid
{
    return [self getUserDataURLForPath:USERDATA_UIC_PATH uid:uid];
}

- (void) performRequestForURL:(NSURL*)url
             returningRequest:(NSURLRequest**)request
                     response:(NSURLResponse**)response
                        error:(NSError**)error
                         data:(NSData**)data
                         body:(NSString**)body
{
    *request  = nil;
    *response = nil;
    *error    = nil;
    *data     = nil;
    *body     = nil;

    *request = [NSURLRequest requestWithURL:url];

    *data = [NSURLConnection sendSynchronousRequest:*request
                                  returningResponse:response
                                              error:error];

    if ( *data ) {
        *body = [[NSString alloc] initWithBytes:(*data).bytes
                                         length:(*data).length
                                       encoding:NSUTF8StringEncoding];
    }
}

- (id) getAcdcForUid:(NSString*)uid
{
    NSURL* requestURL = [self getUserDataAcdcURLForUid:uid];

    NSURLRequest* request = nil;
    NSURLResponse* resp = nil;
    NSError* error = nil;
    NSData* data = nil;
    NSString* body = nil;

    [self performRequestForURL:requestURL
              returningRequest:&request
                      response:&resp
                         error:&error
                          data:&data
                          body:&body];

    if ( error ) {
        NSLog(@"Error retrieving ACDC: %@\nRequest: %@\nResponse: %@", error, request, resp);
    }

    if ( body ) {
        NSLog(@"Got a response body while retrieving ACDC: %@", body);
    }

    if ( data ) {
        NSError* jsonError = nil;

        id resultObj = [NSJSONSerialization JSONObjectWithData:data
                                                       options:0
                                                         error:&jsonError];

        if ( jsonError ) {
            NSLog(@"Got an error while parsing ACDC body JSON: %@", jsonError);
        } else {
            NSLog(@"Parsed ACDC JSON object: %@", resultObj);

            return resultObj;
        }
    }

    return nil;
}

- (id) getUicForUid:(NSString*)uid
{
    NSURL* requestURL = [self getUserDataUicURLForUid:uid];

    NSURLRequest* request = nil;
    NSURLResponse* resp = nil;
    NSError* error = nil;
    NSData* data = nil;
    NSString* body = nil;

    [self performRequestForURL:requestURL
              returningRequest:&request
                      response:&resp
                         error:&error
                          data:&data
                          body:&body];

    if ( error ) {
        NSLog(@"Error retrieving UIC: %@\nRequest: %@\nResponse: %@", error, request, resp);
    }

    if ( body ) {
        NSLog(@"Got a response body while retrieving UIC: %@", body);
    }

    if ( data ) {
        NSError* jsonError = nil;

        id resultObj = [NSJSONSerialization JSONObjectWithData:data
                                                       options:0
                                                         error:&jsonError];

        if ( jsonError ) {
            NSLog(@"Got an error while parsing UIC body JSON: %@", jsonError);
        } else {
            NSLog(@"Parsed UIC JSON object: %@", resultObj);

            return resultObj;
        }
    }

    return nil;
}


@end
