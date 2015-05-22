//
//  CRTOEvent.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  The @c CRTOEvent class and related classes provide an API for submitting events from your native iOS application to Criteo.
 */
@interface CRTOEvent : NSObject

@property (nonatomic,strong,readonly) NSDate* startDate;
@property (nonatomic,strong,readonly) NSDate* endDate;

- (instancetype) init;
- (instancetype) initWithStartDate:(NSDate*)start endDate:(NSDate*)end;

- (instancetype) setDateExtraData:(NSDate*)value ForKey:(NSString*)key;
- (instancetype) setFloatExtraData:(float)value ForKey:(NSString*)key;
- (instancetype) setIntegerExtraData:(NSInteger)value ForKey:(NSString*)key;
- (instancetype) setStringExtraData:(NSString*)value ForKey:(NSString*)key;

- (NSDate*) dateExtraDataForKey:(NSString*)key;
- (float) floatExtraDataForKey:(NSString*)key;
- (NSInteger) integerExtraDataForKey:(NSString*)key;
- (NSString*) stringExtraDataForKey:(NSString*)key;

@end
