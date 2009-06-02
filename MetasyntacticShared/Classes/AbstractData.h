//
//  AbstractData.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 6/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface AbstractData : NSObject {
}

+ (NSArray*) encodeArray:(NSArray*) values;
+ (NSArray*) decodeArray:(NSArray*) values;

@end
