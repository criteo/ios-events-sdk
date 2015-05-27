//
//  CRTOEventQueueItem.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "CRTOEventQueueItem.h"
#import "CRTOEvent+Internal.h"

@implementation CRTOEventQueueItem

#pragma mark - Initializers

- (instancetype) init
{
    self = [super init];
    if ( self ) {
        _event = nil;
        _requestBody = nil;
        _responseData = [NSMutableData new];
    }
    return self;
}

- (instancetype) initWithEvent:(CRTOEvent*)event requestBody:(NSString*)body
{
    self = [self init];

    _event = event;
    _requestBody = [NSData dataWithBytes:body.UTF8String
                                  length:[body lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];

    return self;
}

#pragma mark - Properties

- (NSTimeInterval) age
{
    NSDate* now = [NSDate new];
    NSDate* timestamp = _event.timestamp;

    if ( timestamp != nil ) {
        return [now timeIntervalSinceDate:timestamp];
    }

    return [now timeIntervalSince1970];  // Expire quickly
}

@end
