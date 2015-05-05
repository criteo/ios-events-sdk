//
//  CRTOEvent.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRTOEvent : NSObject

@property (nonatomic,strong,readonly) NSDate* startDate;
@property (nonatomic,strong,readonly) NSDate* endDate;

- (instancetype) init;
- (instancetype) initWithStartDate:(NSDate*)start endDate:(NSDate*)end;

- (instancetype) setBoolExtraData:(BOOL)value ForKey:(NSString*)key;
- (instancetype) setDateExtraData:(NSDate*)value ForKey:(NSString*)key;
- (instancetype) setIntExtraData:(int64_t)value ForKey:(NSString*)key;
- (instancetype) setStringExtraData:(NSString*)value ForKey:(NSString*)key;

- (BOOL) boolExtraDataForKey:(NSString*)key;
- (int64_t) intExtraDataForKey:(NSString*)key;
- (NSDate*) dateExtraDataForKey:(NSString*)key;
- (NSString*) stringExtraDataForKey:(NSString*)key;

@end
