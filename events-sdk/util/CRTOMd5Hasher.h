//
//  CRTOMd5Hasher.h
//  advertiser-sdk
//
//  Copyright © 2016 Criteo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRTOMd5Hasher : NSObject

- (NSString*) computeHashForString:(NSString*)string;

@end
