//
//  SmallBlockInputStream.m
//  ProtocolBuffers
//
//  Created by Cyrus Najmabadi on 10/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SmallBlockInputStream.h"


@implementation SmallBlockInputStream

@synthesize underlyingStream;

- (void) dealloc {
    self.underlyingStream = nil;
    [super dealloc];
}


- (id) initWithData:(NSData*) data_
          blockSize:(int32_t) blockSize_ {
    if (self = [super init]) {
        self.underlyingStream = [NSInputStream inputStreamWithData:data_];
        blockSize = blockSize_;
    }

    return self;
}


+ (SmallBlockInputStream*) streamWithData:(NSData*) data
                                blockSize:(int32_t) blockSize {
    return [[[SmallBlockInputStream alloc] initWithData:data
                                              blockSize:blockSize] autorelease];
}

- (void)open {
    [underlyingStream open];
}


- (void) close {
    [underlyingStream close];
}


- (NSInteger) read:(uint8_t*) buffer
         maxLength:(NSUInteger) len {
    return [underlyingStream read:buffer maxLength:MIN(len, blockSize)];
}


- (BOOL) getBuffer:(uint8_t**) buffer length:(NSUInteger*)len {
    return [underlyingStream getBuffer:buffer length:len];
}


- (BOOL) hasBytesAvailable {
    return underlyingStream.hasBytesAvailable;
}

@end