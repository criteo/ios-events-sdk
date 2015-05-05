//
//  CRTOEvent+Internal.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

@interface CRTOEvent ()

@property (nonatomic,readonly) BOOL isValid;
@property (nonatomic,copy) NSDate* timestamp;

- (instancetype) initWithEvent:(CRTOEvent*)event;

- (NSDictionary*) dictionaryWithAllExtraData;

- (void) addExtraData:(id)value forKey:(NSString*)key;
- (id) getExtraDataForKey:(NSString*)key;

- (BOOL) validateKeyParameter:(NSString*)key;
- (BOOL) validateStringParameter:(id)value;
- (BOOL) validateDateParamater:(id)value;

@end
