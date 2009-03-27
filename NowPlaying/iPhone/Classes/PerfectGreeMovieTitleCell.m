//
//  PerfectGreeMovieTitleCell.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PerfectGreeMovieTitleCell.h"

#import "ColorCache.h"
#import "ImageCache.h"

@implementation PerfectGreenMovieTitleCell


+ (NSString*) reuseIdentifier {
    return @"PerfectGreenMovieTitleCell";
}

- (id) init {
    if (self = [super initWithReuseIdentifier:[[self class] reuseIdentifier]]) {
        self.image = [ImageCache greenRatingImage];
        
        scoreLabel.font = [UIFont boldSystemFontOfSize:15];
        scoreLabel.text = @"100";
    }
    
    return self;
}


- (void) setScore:(Score*) score {
}

@end
