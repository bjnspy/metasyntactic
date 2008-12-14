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
        
        ((uint8_t*)out.mutableBytes)[index + 3] = four_bytes  ? table[(val >> 0) & 0x3F] : '=';
        ((uint8_t*)out.mutableBytes)[index + 2] = three_bytes ? table[(val >> 6) & 0x3F] : '=';
        ((uint8_t*)out.mutableBytes)[index + 1] =               table[(val >> 12) & 0x3F];
        ((uint8_t*)out.mutableBytes)[index + 0] =               table[(val >> 18) & 0x3F];
    }

    return [[[NSString alloc] initWithData:out encoding:NSASCIIStringEncoding] autorelease]; 
}

@end
