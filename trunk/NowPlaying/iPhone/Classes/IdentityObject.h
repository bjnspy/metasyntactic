//
//  IdentityObject.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface IdentityObject : NSObject {
@private
    id value;
}

@property (readonly, retain) id value;

+ (IdentityObject*) objectWithValue:(id) value;

@end
