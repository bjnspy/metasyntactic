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

@interface SearchRequest : NSObject {
    NSInteger requestId;
    NSString* value;
    NSString* lowercaseValue;

    NSArray* movies;
    NSArray* theaters;
    NSArray* upcomingMovies;
}

@property NSInteger requestId;
@property (copy) NSString* value;
@property (copy) NSString* lowercaseValue;
@property (retain) NSArray* movies;
@property (retain) NSArray* theaters;
@property (retain) NSArray* upcomingMovies;

+ (SearchRequest*) requestWithId:(NSInteger) requestId
                           value:(NSString*) value
                           model:(NowPlayingModel*) model;


@end