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

    NSMutableData* data = [NSMutableData dataWithLength:((rawBytes.length + 2) / 3) * 4];
    
    const uint8_t* in = (const uint8_t*)rawBytes.bytes;
    uint8_t* out = (uint8_t*)data.mutableBytes;
    
    for (NSInteger i = 0, index = 0; i < rawBytes.length; i += 3, index += 4) {
        NSInteger val = 0;
        for (NSInteger j = i; j < (i + 3); j++) {
            val <<= 8;
            
            if (j < rawBytes.length) {
                val |= (0xFF & in[j]);
            }
        }
        
        out[index + 3] = (i + 2) < rawBytes.length ? table[(val >> 0) & 0x3F] : '=';
        out[index + 2] = (i + 1) < rawBytes.length ? table[(val >> 6) & 0x3F] : '=';
        out[index + 1] =                             table[(val >> 12) & 0x3F];
        out[index + 0] =                             table[(val >> 18) & 0x3F];
    }

    return [[[NSString alloc] initWithData:data
                                  encoding:NSASCIIStringEncoding] autorelease]; 
}

@end
