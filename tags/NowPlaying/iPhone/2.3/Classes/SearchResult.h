// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

@interface SearchResult : NSObject {
@private
    NSInteger requestId;
    NSString* value;
    NSArray* movies;
    NSArray* theaters;
    NSArray* upcomingMovies;
    NSArray* dvds;
    NSArray* bluray;
}

@property (readonly) NSInteger requestId;
@property (readonly, copy) NSString* value;
@property (readonly, retain) NSArray* movies;
@property (readonly, retain) NSArray* theaters;
@property (readonly, retain) NSArray* upcomingMovies;
@property (readonly, retain) NSArray* dvds;
@property (readonly, retain) NSArray* bluray;

+ (SearchResult*) resultWithId:(NSInteger) requestId
                         value:(NSString*) value
                        movies:(NSArray*) movies
                      theaters:(NSArray*) theaters
                upcomingMovies:(NSArray*) upcomingMovies
                          dvds:(NSArray*) dvds
                        bluray:(NSArray*) bluray;


@end