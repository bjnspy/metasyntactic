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

#import "SearchRequest.h"

#import "NowPlayingModel.h"
#import "UpcomingCache.h"
#import "Utilities.h"

@implementation SearchRequest

@synthesize requestId;
@synthesize value;
@synthesize lowercaseValue;
@synthesize movies;
@synthesize theaters;
@synthesize upcomingMovies;

- (void) dealloc {
    self.requestId = 0;
    self.value = nil;
    self.lowercaseValue = nil;
    self.movies = nil;
    self.theaters = nil;
    self.upcomingMovies = nil;
    
    [super dealloc];
}


- (id) initWithId:(NSInteger) requestId_
            value:(NSString*) value_ 
            model:(NowPlayingModel*) model {
    if (self = [super init]) {
        self.requestId = requestId_;
        self.value = value_;
        self.movies = model.movies;
        self.theaters = model.theaters;
        self.upcomingMovies = model.upcomingCache.upcomingMovies;

        self.lowercaseValue = [[Utilities asciiString:value] lowercaseString]; 
    }
    
    return self;
}


+ (SearchRequest*) requestWithId:(NSInteger) requestId
                           value:(NSString*) value
                           model:(NowPlayingModel*) model{
    return [[[SearchRequest alloc] initWithId:requestId value:value model:model] autorelease];
}

@end