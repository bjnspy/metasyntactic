//
//  NoScoreMovieTitleCell.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NoScoreMovieTitleCell.h"


@implementation NoScoreMovieTitleCell


+ (NSString*) reuseIdentifier {
    return @"NoScoreMovieTitleCell";
}

- (id) init {
    if (self = [super initWithReuseIdentifier:[[self class] reuseIdentifier]]) {
        [scoreLabel removeFromSuperview];
    }

    return self;
}


- (void) setScore:(Score*) score {
}

@end
