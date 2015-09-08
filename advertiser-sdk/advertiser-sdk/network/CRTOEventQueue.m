//
//  CRTOEventQueue.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "CRTOEventQueue.h"
#import "CRTOJSONEventSerializer.h"
#import "CRTONetworkDefines.h"

#define CRTO_EVENTQUEUE_DELEGATEQUEUE_NAME (@"com.criteo.event.transmit.delegates")
#define CRTO_EVENTQUEUE_DISPATCHQUEUE_NAME ("com.criteo.event.transmit")

static NSMapTable* connections = nil;
static NSOperationQueue* delegateQueue = nil;
static dispatch_queue_t dispatchQueue = NULL;
static NSMutableArray* eventQueue = nil;
static NSMutableSet* itemsInFlight = nil;

static CRTOEventQueueItemBlock itemErroredBlock = NULL;
static CRTOEventQueueItemBlock itemSentBlock = NULL;

@interface CRTOEventQueue ()
{
@private
    NSURL* endpoint;
    NSString* endpointHostHeader;
}

- (NSURL*) getDefaultWidgetURL;
- (NSURL*) getEnvironmentWidgetURL;
- (void) setupEventQueueEndpoint;

- (void) notifyItemErrored:(CRTOEventQueueItem*)item;
- (void) notifyItemSent:(CRTOEventQueueItem*)item;
- (void) reapQueue;
- (void) sendQueue;
- (void) sendItem:(CRTOEventQueueItem*)item;

@end

@implementation CRTOEventQueue

#pragma mark - Initializers

- (instancetype) init
{
    self = [super init];
    if ( self ) {
        _maxQueueDepth   = CRTO_EVENTQUEUE_MAX_DEPTH;
        _maxQueueItemAge = CRTO_EVENTQUEUE_MAX_AGE;

        [self setupEventQueueEndpoint];
    }
    return self;
}

#pragma mark - Static Initializer

+ (void) initialize
{
    if ( self == [CRTOEventQueue class] )
    {
        connections = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory
                                                valueOptions:NSMapTableStrongMemory
                                                    capacity:CRTO_EVENTQUEUE_MAX_DEPTH];

        delegateQueue = [[NSOperationQueue alloc] init];
        delegateQueue.name = CRTO_EVENTQUEUE_DELEGATEQUEUE_NAME;

        dispatchQueue = dispatch_queue_create(CRTO_EVENTQUEUE_DISPATCHQUEUE_NAME, DISPATCH_QUEUE_SERIAL);

        eventQueue = [[NSMutableArray alloc] initWithCapacity:CRTO_EVENTQUEUE_MAX_DEPTH];

        itemsInFlight = [[NSMutableSet alloc] initWithCapacity:CRTO_EVENTQUEUE_MAX_DEPTH];
    }
}

#pragma mark - Static Methods

+ (instancetype) sharedEventQueue
{
    static dispatch_once_t onceToken;
    static CRTOEventQueue* sharedEventQueue;

    dispatch_once(&onceToken, ^{
        sharedEventQueue = [[CRTOEventQueue alloc] init];
    });

    return sharedEventQueue;
}

#pragma mark - Properties

- (NSUInteger) currentQueueDepth
{
    __block NSUInteger queueDepth;

    dispatch_sync(dispatchQueue, ^{
        queueDepth = eventQueue.count;
    });

    return queueDepth;
}

#pragma mark - Class Extension Methods

- (NSURL*) getDefaultWidgetURL
{
    NSURL* widgetURL = [NSURL URLWithString:CRTO_EVENTQUEUE_SEND_BASEURL];

    widgetURL = [NSURL URLWithString:CRTO_EVENTQUEUE_SEND_PATH
                       relativeToURL:widgetURL];

    return widgetURL;
}

- (NSURL*) getEnvironmentWidgetURL
{
    NSProcessInfo* process    = [NSProcessInfo processInfo];
    NSDictionary* environment = process.environment;

    NSString* WIDGET_URL_ENV = environment[CRTO_EVENTQUEUE_WIDGET_ENV];

    NSURL* widgetURL = nil;

    if ( WIDGET_URL_ENV.length > 0 ) {
        widgetURL = [NSURL URLWithString:WIDGET_URL_ENV];
    }

    if ( widgetURL != nil ) {
        widgetURL = [NSURL URLWithString:CRTO_EVENTQUEUE_SEND_PATH
                           relativeToURL:widgetURL];
    }

    return widgetURL;
}

- (void) setupEventQueueEndpoint
{
    NSURL* defaultURL = [self getDefaultWidgetURL];
    NSURL* envURL = [self getEnvironmentWidgetURL];

    if ( envURL != nil ) {
        endpoint = envURL;
        endpointHostHeader = defaultURL.host;
    } else {
        endpoint = defaultURL;
        endpointHostHeader = nil;
    }

    envURL = [self getEnvironmentWidgetURL];

#ifdef DEBUG
    NSLog(@"[SDK] Requests will be sent to: %@\n  Host Header: %@",
          endpoint.absoluteString, endpointHostHeader);
#endif
}

- (void) notifyItemErrored:(CRTOEventQueueItem*)item
{
    CRTOEventQueueItemBlock block = itemErroredBlock;

    if ( item == nil || block == NULL ) {
        return;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        block(item);
    });
}

- (void) notifyItemSent:(CRTOEventQueueItem*)item
{
    CRTOEventQueueItemBlock block = itemSentBlock;

    if ( item == nil || block == NULL ) {
        return;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        block(item);
    });
}

- (void) reapQueue
{
    dispatch_async(dispatchQueue, ^{

        NSIndexSet* expired = [eventQueue indexesOfObjectsPassingTest:^BOOL(CRTOEventQueueItem* item, NSUInteger idx, BOOL* stop) {
            return ( item.age >= self.maxQueueItemAge );
        }];

        [eventQueue removeObjectsAtIndexes:expired];

        NSUInteger maxQueueDepth = self.maxQueueDepth;

        if ( eventQueue.count > maxQueueDepth ) {
            NSRange overflowRange = NSMakeRange(0, eventQueue.count - maxQueueDepth);

            [eventQueue removeObjectsInRange:overflowRange];
        }
    });
}

- (void) sendItem:(CRTOEventQueueItem*)item
{
    NSMutableURLRequest* req = [[NSMutableURLRequest alloc] initWithURL:endpoint
                                                            cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                        timeoutInterval:CRTO_EVENTQUEUE_SEND_TIMEOUT];

    req.HTTPMethod = @"POST";

    if ( endpointHostHeader != nil ) {
        [req setValue:endpointHostHeader forHTTPHeaderField:@"Host"];
    }

    req.HTTPBody = item.requestBody;

    req.networkServiceType = NSURLNetworkServiceTypeBackground;

    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:NO];
    [connection setDelegateQueue:delegateQueue];

    [connections setObject:item forKey:connection];
    [itemsInFlight addObject:item];

    [connection start];
}

- (void) sendQueue
{
    dispatch_async(dispatchQueue, ^{

        NSIndexSet* notInFlight = [eventQueue indexesOfObjectsPassingTest:^BOOL(CRTOEventQueueItem* item, NSUInteger idx, BOOL* stop) {
            return ![itemsInFlight containsObject:item];
        }];

        // The backend currently fails to handle concurrent requests deterministically.
        // We work around this here by checking the "in-flight" set and only sending an
        // event when there's nothing else in flight. This effectively rate-limits event
        // delivery to one item at a time.
        [eventQueue enumerateObjectsAtIndexes:notInFlight
                                      options:0
                                   usingBlock:^(CRTOEventQueueItem* item, NSUInteger idx, BOOL* stop) {
                                       if ( itemsInFlight.count == 0 ) {
                                           [self sendItem:item];
                                       }
                                   }];
    });
}

#pragma mark - NSURLConnection Delegate Methods

- (BOOL) connectionShouldUseCredentialStorage:(NSURLConnection*)connection
{
    return NO;
}

- (void) connection:(NSURLConnection*)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge
{
    [challenge.sender performDefaultHandlingForAuthenticationChallenge:challenge];
}

- (NSURLRequest*) connection:(NSURLConnection*)connection
             willSendRequest:(NSURLRequest*)request
            redirectResponse:(NSURLResponse*)response
{
    if ( response == nil ) {
        return request;
    }

    if ( [response isKindOfClass:[NSHTTPURLResponse class]] ) {
        NSHTTPURLResponse* httpResp = (NSHTTPURLResponse*)response;

        __block BOOL maxRedirects;

        dispatch_sync(dispatchQueue, ^{
            CRTOEventQueueItem* item = [connections objectForKey:connection];
            maxRedirects = (item.redirectCount >= CRTO_EVENTQUEUE_MAX_REDIRECTS);
        });

        if ( maxRedirects ) {
            return nil;
        }

        if ( httpResp.statusCode >= 300 && httpResp.statusCode < 400 ) {
            NSMutableURLRequest* newRequest = [connection.originalRequest mutableCopy];

            newRequest.URL = request.URL;

            dispatch_async(dispatchQueue, ^{
                CRTOEventQueueItem* item = [connections objectForKey:connection];
                item.redirectCount++;
            });

            return newRequest;
        }
    }

    return request;
}

- (void) connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    if ( [response isKindOfClass:[NSHTTPURLResponse class]] ) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;

        NSLog(@"Queue item got response: %lld", (int64_t)httpResponse.statusCode);
    } else {
        NSLog(@"Queue item got a weird response type: %@", [response class]);
    }
}

- (void) connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    dispatch_async(dispatchQueue, ^{
        CRTOEventQueueItem* item = [connections objectForKey:connection];

        [item.responseData appendData:data];

        NSLog(@"Queue item got data (%llu bytes)", (uint64_t)data.length);
    });
}

- (void) connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    dispatch_async(dispatchQueue, ^{
        CRTOEventQueueItem* item = [connections objectForKey:connection];

        if ( item != nil ) {
            [itemsInFlight removeObject:item];
        }

        [connections removeObjectForKey:connection];

        NSLog(@"Errored queue item.");

        [self notifyItemErrored:item];
    });
}

- (void) connectionDidFinishLoading:(NSURLConnection*)connection
{
    dispatch_async(dispatchQueue, ^{
        CRTOEventQueueItem* item = [connections objectForKey:connection];

        if ( item != nil ) {
            [itemsInFlight removeObject:item];
        }

        [connections removeObjectForKey:connection];

        [eventQueue removeObject:item];

        NSLog(@"Finished queue item. (if=%llu,con=%llu,qd=%llu)",
              (uint64_t)itemsInFlight.count, (uint64_t)connections.count, (uint64_t)eventQueue.count);

        [self notifyItemSent:item];

        [self sendQueue];
    });
}

#pragma mark - Public Methods

- (void) addQueueItem:(CRTOEventQueueItem*)item
{
    if ( item == nil ) {
        return;
    }

    dispatch_async(dispatchQueue, ^{
        [eventQueue addObject:item];
        NSLog(@"Added queue item.");
    });

    [self reapQueue];
    [self sendQueue];
}

- (BOOL) containsItem:(CRTOEventQueueItem*)item
{
    if ( item == nil ) {
        return NO;
    }

    __block BOOL containsItem;

    dispatch_sync(dispatchQueue, ^{
        containsItem = [eventQueue containsObject:item];
    });

    return containsItem;
}

- (void) onItemError:(CRTOEventQueueItemBlock)errorBlock
{
    itemErroredBlock = errorBlock;
}

- (void) onItemSent:(CRTOEventQueueItemBlock)sentBlock
{
    itemSentBlock = sentBlock;
}

- (void) removeAllItems
{
    dispatch_sync(dispatchQueue, ^{
        for ( NSURLConnection* connection in connections ) {
            [connection cancel];
        }

        [eventQueue removeAllObjects];
        [connections removeAllObjects];
        [itemsInFlight removeAllObjects];
    });
}

@end
