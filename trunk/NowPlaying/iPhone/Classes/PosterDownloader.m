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

#import "PosterDownloader.h"

#import "ApplePosterDownloader.h"
#import "ImdbPosterDownloader.h"
#import "Movie.h"
#import "NetworkUtilities.h"
#import "Utilities.h"

@implementation PosterDownloader

@synthesize movie;

- (void) dealloc {
    self.movie = nil;
    [super dealloc];
}


- (id) initWithMovie:(Movie*) movie_ {
    if (self = [super init]) {
        self.movie = movie_;
    }

    return self;
}


- (NSData*) go {
    NSData* data = [NetworkUtilities dataWithContentsOfAddress:movie.poster important:NO];
    if (data != nil) {
        return data;
    }

    data = [ApplePosterDownloader download:movie];
    if (data != nil) {
        return data;
    }

    data = [ImdbPosterDownloader download:movie];
    if (data != nil) {
        return data;
    }

    return nil;
}


+ (NSData*) download:(Movie*) movie {
    PosterDownloader* downloader = [[[PosterDownloader alloc] initWithMovie:movie] autorelease];
    return [downloader go];
}


@end