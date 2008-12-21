//
//  Invocation2.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Invocation.h";

@interface Invocation2 : Invocation {
@private
    id argument2;
}

+ (Invocation2*) invocationWithTarget:(id) target
                            selector:(SEL) selector
                            argument:(id) argument1
                            argument:(id) argument2;

@end
