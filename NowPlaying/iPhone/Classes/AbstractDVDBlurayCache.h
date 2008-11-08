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

@interface AbstractDVDBlurayCache : NSObject {
    NowPlayingModel* model;
    
    NSLock* gate;
    
    PointerSet* moviesSetData;
    NSArray* moviesData;
    
    LinkedSet* prioritizedMovies;
}

@property (assign) NowPlayingModel* model;

@property (retain) NSLock* gate;
@property (retain) PointerSet* moviesSetData;
@property (retain) NSArray* moviesData;
@property (retain) LinkedSet* prioritizedMovies;

- (id) initWithModel:(NowPlayingModel*) model;

- (void) update;
- (void) prioritizeMovie:(Movie*) movie;

- (NSArray*) movies;

- (DVD*) detailsForMovie:(Movie*) movie;
- (UIImage*) posterForMovie:(Movie*) movie;
- (NSString*) imdbAddressForMovie:(Movie*) movie;

@end