//
//  CRTOMd5Hasher.m
//  advertiser-sdk
//
//  Copyright © 2016 Criteo. All rights reserved.
//

#import "CRTOMd5Hasher.h"

#include <CommonCrypto/CommonCrypto.h>

#define MAX_HASHABLE_STRLEN (1024 * 1024)   // 1 MB

@interface CRTOMd5Hasher ()

- (NSString*) convertMd5BufferToHexString:(unsigned char*)md5Buffer;
- (NSString*) validateAndFormatInputString:(NSString*)input;

@end

@implementation CRTOMd5Hasher

#pragma mark - Class Extension Methods

- (NSString*) convertMd5BufferToHexString:(unsigned char*)md5Buffer
{
    if ( NULL == md5Buffer ) {
        return nil;
    }

    NSMutableString* hex = [[NSMutableString alloc] initWithCapacity:(CC_MD5_DIGEST_LENGTH * 2)];

    for (CC_LONG ii = 0; ii < CC_MD5_DIGEST_LENGTH; ii++) {
        [hex appendFormat:@"%02x", md5Buffer[ii]];
    }

    return [[NSString alloc] initWithString:hex];
}

- (NSString*) validateAndFormatInputString:(NSString*)string
{
    if ( string == nil ) {
        return nil;
    }

    NSString* lowercase = string.lowercaseString;
    NSString* trimmed = [lowercase stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSUInteger inputLen = [trimmed lengthOfBytesUsingEncoding:NSUTF8StringEncoding];

    // Two rules here:
    //
    // First, you should never be larger than the max size we can specify in the CC_MD5 API
    // (NEVER EVER EVER CHANGE THIS)
    if ( inputLen > UINT32_MAX ) {  // CC_LONG is typedef uint32_t
        return nil;
    }

    // Second, we refuse to hash anything larger than MAX_HASHABLE_STRLEN
    // (ALWAYS ALWAYS CHANGE MAX_HASHABLE_STRLEN)
    if ( inputLen > MAX_HASHABLE_STRLEN ) {
        return nil;
    }

    return trimmed;
}

#pragma mark - Public Methods

- (NSString*) computeHashForString:(NSString*)string
{
    // Sanitize and validate input
    NSString* input = [self validateAndFormatInputString:string];

    if ( input == nil ) {
        return nil;
    }

    // Set up input buffer
    size_t inputSize = ([input lengthOfBytesUsingEncoding:NSUTF8StringEncoding] + 1);
    void* inputBuffer = malloc(inputSize);

    if ( NULL == inputBuffer ) {
        return nil;
    }

    memset(inputBuffer, 0, inputSize);

    // Get input bytes
    if ( ![input getCString:inputBuffer maxLength:inputSize encoding:NSUTF8StringEncoding] ) {
        free(inputBuffer);
        return nil;
    }

    // Prep the md5 buffer
    CC_LONG ccInputLen = (CC_LONG)(inputSize - 1);
    unsigned char output[CC_MD5_DIGEST_LENGTH];

    memset(output, 0, sizeof(output));

    // Hash
    CC_MD5(inputBuffer, ccInputLen, output);
    free(inputBuffer);

    // Render the md5 buffer as hex and send it back
    NSString* result = [self convertMd5BufferToHexString:output];

    return result;
}

@end
