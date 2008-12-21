//
//  BackgroundInvocation2.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BackgroundInvocation.h"

@interface BackgroundInvocation2 : BackgroundInvocation {
@private
    id argument2;
}

+ (BackgroundInvocation2*) invocationWithTarget:(id) target
                                       selector:(SEL) selector
                                       argument:(id) argument1
                                       argument:(id) argument2
                                           gate:(NSLock*) gate
                                        visible:(BOOL) visible;

@end
