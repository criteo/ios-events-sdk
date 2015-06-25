//
//  CRTOEventQueue.m
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "CRTOEventQueue.h"
#import "CRTOJSONEventSerializer.h"

#define CRTO_EVENTQUEUE_DELEGATEQUEUE_NAME (@"com.criteo.event.transmit.delegates")
#define CRTO_EVENTQUEUE_DISPATCHQUEUE_NAME ("com.criteo.event.transmit")

#define CRTO_EVENTQUEUE_MAX_AGE      (60.0 * 60.0)
#define CRTO_EVENTQUEUE_MAX_DEPTH    (15)
#define CRTO_EVENTQUEUE_SEND_TIMEOUT (60.0)
#define CRTO_EVENTQUEUE_SEND_URL     (@"http://widget.criteo.com/m/event/")

static NSMapTable* connections = nil;
static NSOperationQueue* delegateQueue = nil;
static dispatch_queue_t dispatchQueue = NULL;
static NSMutableArray* eventQueue = nil;
static NSMutableSet* itemsInFlight = nil;

static CRTOEventQueueItemBlock itemSentBlock = NULL;

@interface CRTOEventQueue ()
{
@private
    NSURL* endpoint;
}

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

        endpoint = [NSURL URLWithString:CRTO_EVENTQUEUE_SEND_URL];
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

#pragma mark - Class Extension Methods

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

        if ( eventQueue.count > self.maxQueueDepth ) {
            NSRange overflowRange = NSMakeRange(0, eventQueue.count - self.maxQueueDepth);

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

        [eventQueue enumerateObjectsAtIndexes:notInFlight
                                      options:0
                                   usingBlock:^(CRTOEventQueueItem* item, NSUInteger idx, BOOL* stop) {
                                       [self sendItem:item];
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
    [challenge.sender cancelAuthenticationChallenge:challenge];
}

- (NSURLRequest*) connection:(NSURLConnection*)connection
             willSendRequest:(NSURLRequest*)request
            redirectResponse:(NSURLResponse*)response
{
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

- (void) onItemSent:(CRTOEventQueueItemBlock)sentBlock
{
    itemSentBlock = sentBlock;
}

@end
