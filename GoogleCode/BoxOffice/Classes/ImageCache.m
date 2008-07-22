//
//  ImageCache.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ImageCache.h"


@implementation ImageCache

static UIImage* freshImage = nil;
static UIImage* rottenFadedImage = nil;
static UIImage* rottenFullImage = nil;
static UIImage* emptyStarImage = nil;
static UIImage* filledStarImage = nil;

static UIImage* redRatingImage = nil;
static UIImage* yellowRatingImage = nil;
static UIImage* greenRatingImage = nil;
static UIImage* unknownRatingImage = nil;

+ (void) initialize {
    if (self == [ImageCache class]) {        
        freshImage          = [[UIImage imageNamed:@"Fresh.png"] retain];
        rottenFadedImage    = [[UIImage imageNamed:@"Rotten-Faded.png"] retain];
        rottenFullImage     = [[UIImage imageNamed:@"Rotten-Full.png"] retain];
        emptyStarImage      = [[UIImage imageNamed:@"Empty Star.png"] retain];
        filledStarImage     = [[UIImage imageNamed:@"Filled Star.png"] retain];
        
        redRatingImage      = [[UIImage imageNamed:@"Rating-Red.png"] retain];
        yellowRatingImage   = [[UIImage imageNamed:@"Rating-Yellow.png"] retain];
        greenRatingImage    = [[UIImage imageNamed:@"Rating-Green.png"] retain];
        unknownRatingImage  = [[UIImage imageNamed:@"Rating-Unknown.png"] retain];
    }
}

+ (UIImage*) freshImage {
    return freshImage;
}

+ (UIImage*) rottenFadedImage {
    return rottenFadedImage;
}

+ (UIImage*) rottenFullImage {
    return rottenFullImage;
}

+ (UIImage*) redRatingImage {
    return redRatingImage;
}

+ (UIImage*) yellowRatingImage {
    return yellowRatingImage;
}

+ (UIImage*) greenRatingImage {
    return greenRatingImage;
}

+ (UIImage*) unknownRatingImage {
    return unknownRatingImage;
}

+ (UIImage*) emptyStarImage {
    return emptyStarImage;
}

+ (UIImage*) filledStarImage {
    return filledStarImage;
}

@end
