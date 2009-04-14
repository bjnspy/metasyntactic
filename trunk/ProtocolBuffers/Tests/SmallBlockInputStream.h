//
//  SmallBlockInputStream.h
//  ProtocolBuffers
//
//  Created by Cyrus Najmabadi on 10/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface SmallBlockInputStream : NSInputStream {
    NSInputStream* underlyingStream;
    int32_t blockSize;
}

@property (retain) NSInputStream* underlyingStream;

+ (SmallBlockInputStream*) streamWithData:(NSData*) data blockSize:(int32_t) blockSize;

@end