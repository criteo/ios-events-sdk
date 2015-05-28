//
//  CRTOEventService.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <CriteoAdvertiser/CRTOEvent.h>

@interface CRTOEventService : NSObject

@property (nonatomic,strong) NSString* country;
@property (nonatomic,strong) NSString* language;
@property (nonatomic,strong) NSString* crmId;

+ (instancetype) sharedEventService;

- (instancetype) init;
- (instancetype) initWithCountry:(NSString*)country language:(NSString*)language;
- (instancetype) initWithCountry:(NSString*)country language:(NSString*)language crmId:(NSString*)crmId;

- (void) send:(CRTOEvent*)event;

@end
