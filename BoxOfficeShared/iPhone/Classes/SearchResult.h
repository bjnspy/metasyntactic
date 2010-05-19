// Copyright 2010 Cyrus Najmabadi
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

@interface SearchResult : AbstractSearchResult {
@private
  NSArray* movies;
  NSArray* theaters;
  NSArray* upcomingMovies;
  NSArray* dvds;
  NSArray* bluray;
  NSArray* people;
}

@property (readonly, retain) NSArray* movies;
@property (readonly, retain) NSArray* theaters;
@property (readonly, retain) NSArray* upcomingMovies;
@property (readonly, retain) NSArray* dvds;
@property (readonly, retain) NSArray* bluray;
@property (readonly, retain) NSArray* people;

+ (SearchResult*) resultWithId:(NSInteger) requestId
                         value:(NSString*) value
                        movies:(NSArray*) movies
                      theaters:(NSArray*) theaters
                upcomingMovies:(NSArray*) upcomingMovies
                          dvds:(NSArray*) dvds
                        bluray:(NSArray*) bluray
                        people:(NSArray*) people;

@end
