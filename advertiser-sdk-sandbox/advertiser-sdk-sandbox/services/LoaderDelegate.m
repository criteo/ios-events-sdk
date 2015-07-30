//
//  LoaderDelegate.m
//  advertiser-sdk-sandbox
//
//  Created by Paul Davis on 7/30/15.
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "LoaderDelegate.h"

@implementation LoaderDelegate
{
    LoaderCallback _block;
}

- (instancetype) initWithBlock:(LoaderCallback)block
{
    self = [super init];
    if ( self ) {
        _responseData = [NSMutableData new];
        _block = block;
    }
    return self;
}

- (NSString*) responseString
{
    return [[NSString alloc] initWithBytes:_responseData.bytes length:_responseData.length encoding:NSUTF8StringEncoding];
}

- (void) connection:(NSURLConnection*)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge
{
    NSArray* trustedHosts = @[ @"widget.criteo.com", @"userdataws.criteo.com" ];

    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
        if ([trustedHosts containsObject:challenge.protectionSpace.host])
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];

    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (void) connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    _response = response;
}

- (void) connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    [_responseData appendData:data];
}

-(void) connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    _error = error;
    _finished = YES;
    _block(self);
}

- (NSURLRequest*) connection:(NSURLConnection*)connection willSendRequest:(NSURLRequest*)request redirectResponse:(NSURLResponse*)response
{
    if ( response == nil ) {
        return request;
    }

    return request;
}

- (void) connectionDidFinishLoading:(NSURLConnection*)connection
{
    _finished = YES;
    _block(self);
}

@end

