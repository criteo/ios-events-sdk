//
//  CRTOEvent+Internal.h
//  advertiser-sdk
//
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import "CRTOExtraData.h"

@interface CRTOEvent ()

@property (nonatomic,readonly) BOOL isValid;
@property (nonatomic,copy) NSDate* timestamp;

- (instancetype) initWithEvent:(CRTOEvent*)event;

- (NSDictionary*) dictionaryWithAllExtraData;

- (void) addExtraData:(id)value forKey:(NSString*)key withType:(CRTOExtraDataType)type;
- (id) getExtraDataForKey:(NSString*)key;

- (BOOL) validateKeyParameter:(NSString*)key;
- (BOOL) validateStringParameter:(id)value;
- (BOOL) validateDateComponentsParamater:(id)value;

@end
