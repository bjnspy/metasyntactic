// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

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

static UIImage* imageNotAvailable = nil;

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

        imageNotAvailable   = [[UIImage imageNamed:@"ImageNotAvailable.png"] retain];
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


+ (UIImage*) imageNotAvailable {
    return imageNotAvailable;
}


@end
