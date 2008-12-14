//
//  Base64.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface Base64 : NSObject {

}

+ (NSString*) encode:(NSData*) rawBytes;
+ (NSString*) encode:(const uint8_t*) rawBytes length:(NSInteger) length;

@end
