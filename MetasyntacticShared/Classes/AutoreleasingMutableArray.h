//
//  AutoreleasingMutableArray.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 11/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface AutoreleasingMutableArray : NSMutableArray {
@private
  NSMutableArray* underlyingArray;
}

+ (AutoreleasingMutableArray*) array;
+ (AutoreleasingMutableArray*) arrayWithArray:(NSArray*) values;

@end
