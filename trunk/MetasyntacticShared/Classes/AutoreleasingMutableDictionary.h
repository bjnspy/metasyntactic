//
//  AutoreleasingMutableDictionary.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 11/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface AutoreleasingMutableDictionary : NSMutableDictionary {
@private
  NSMutableDictionary* underlyingDictionary;
}

+ (AutoreleasingMutableDictionary*) dictionary;
+ (AutoreleasingMutableDictionary*) dictionaryWithDictionary:(NSDictionary*) dictionary;

@end
