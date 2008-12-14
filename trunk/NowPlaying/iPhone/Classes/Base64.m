//
//  Base64.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Base64.h"


@implementation Base64

+ (NSString*) encode:(const uint8_t*) input length:(NSInteger) length {
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    for (NSInteger i = 0, index = 0; i < length; i += 3, index += 4) {
        NSInteger val = 0;
        for (NSInteger j = i; j < (i + 3); j++) {
            val <<= 8;
            
            if (j < length) {
                val |= (0xFF & input[j]);
            }
        }
        
        output[index + 3] = (i + 2) < length ? table[(val >> 0) & 0x3F] : '=';
        output[index + 2] = (i + 1) < length ? table[(val >> 6) & 0x3F] : '=';
        output[index + 1] =                    table[(val >> 12) & 0x3F];
        output[index + 0] =                    table[(val >> 18) & 0x3F];
    }

    return [[[NSString alloc] initWithData:data
                                  encoding:NSASCIIStringEncoding] autorelease]; 
}

+ (NSString*) encode:(NSData*) rawBytes {
    return [Base64 encode:(const uint8_t*)rawBytes.bytes length:rawBytes.length];
}

@end
