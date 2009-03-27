//
//  UnknownMovieTitleCell.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UnknownMovieTitleCell.h"

#import "ImageCache.h"


@implementation UnknownMovieTitleCell


+ (NSString*) reuseIdentifier {
    return @"UnknownMovieTitleCell";
}

- (id) init {
    if (self = [super initWithReuseIdentifier:[[self class] reuseIdentifier]]) {
        self.image = [ImageCache unknownRatingImage];
        [scoreLabel removeFromSuperview];
    }
    
    return self;
}


- (void) setScore:(Score*) score {
}

@end
