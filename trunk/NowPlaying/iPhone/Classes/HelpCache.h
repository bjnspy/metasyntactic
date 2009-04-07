//
//  HelpCache.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 4/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AbstractCache.h"

@interface HelpCache : AbstractCache {
@private
    BOOL updated;
    NSArray* questionsAndAnswersData;
}

+ (HelpCache*) cache;

- (void) update;

- (NSArray*) questionsAndAnswers;

@end
