//
//  Base64.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Base64.h"


@implementation Base64

+ (NSString*) encode:(NSData*) rawBytes {
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

    NSMutableData* out = [NSMutableData dataWithLength:((rawBytes.length + 2) / 3) * 4];
  
    for (NSInteger i = 0, index = 0; i < rawBytes.length; i += 3, index += 4) {
        BOOL four_bytes = NO;
        BOOL three_bytes = NO;
        
        NSInteger val = (0xFF & ((const uint8_t*)rawBytes.bytes)[i]);
        val <<= 8;
        if ((i + 1) < rawBytes.length) {
            val |= (0xFF & ((const uint8_t*)rawBytes.bytes)[i + 1]);
            three_bytes = YES;
        }
        val <<= 8;
        if ((i + 2) < rawBytes.length) {
            val |= (0xFF & ((const uint8_t*)rawBytes.bytes)[i + 2]);
            four_bytes = YES;
        }
        
        ((uint8_t*)out.mutableBytes)[index + 3] = table[(four_bytes ? (val & 0x3F) : 64)];
        val >>= 6;
        ((uint8_t*)out.mutableBytes)[index + 2] = table[(three_bytes ? (val & 0x3F) : 64)];
        val >>= 6;
        ((uint8_t*)out.mutableBytes)[index + 1] = table[val & 0x3F];
        val >>= 6;
        ((uint8_t*)out.mutableBytes)[index + 0] = table[val & 0x3F];
    }

    return [[[NSString alloc] initWithData:out encoding:NSASCIIStringEncoding] autorelease]; 
}

@end
