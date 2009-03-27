//
//  SquareMovieTitleCell.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SquareMovieTitleCell.h"

#import "ColorCache.h"
#import "FontCache.h"
#import "ImageCache.h"

@implementation SquareMovieTitleCell

- (id) initWithReuseIdentifier:(NSString*) reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        CGRect frame = CGRectMake(6, 6, 30, 30);
        scoreLabel.font = [FontCache boldSystem19];
        scoreLabel.textColor = [ColorCache darkDarkGray];
        scoreLabel.frame = frame;
    }
    
    return self;
}

@end
