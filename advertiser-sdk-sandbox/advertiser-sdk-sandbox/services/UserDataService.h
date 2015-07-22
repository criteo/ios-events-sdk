//
//  UserDataService.h
//  advertiser-sdk-sandbox
//
//  Created by Paul Davis on 7/22/15.
//  Copyright (c) 2015 Criteo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataService : NSObject

- (id) getAcdcForUid:(NSString*)uid;
- (id) getUicForUid:(NSString*)uid;

@end
