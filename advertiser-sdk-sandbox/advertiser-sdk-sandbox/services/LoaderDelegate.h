//
//  LoaderDelegate.h
//  advertiser-sdk-sandbox
//
//  Created by Paul Davis on 7/30/15.
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LoaderDelegate;

typedef void(^LoaderCallback)(LoaderDelegate* delegate);

@interface LoaderDelegate : NSObject <NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property (nonatomic,readonly) BOOL finished;
@property (nonatomic,readonly) NSError* error;
@property (nonatomic,readonly) NSURLResponse* response;
@property (nonatomic,readonly) NSMutableData* responseData;
@property (nonatomic,readonly) NSString* responseString;

- (instancetype) initWithBlock:(LoaderCallback)block;

@end
