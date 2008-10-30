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

@interface DVDCache : NSObject {
    NSLock* gate;
    
    PointerSet* dvdSet;
    PointerSet* bluraySet;
    NSArray* dvdData;
    NSArray* blurayData;
    
    LinkedSet* prioritizedMovies;
}

@property (retain) NSLock* gate;
@property (retain) PointerSet* dvdSet;
@property (retain) PointerSet* bluraySet;
@property (retain) NSArray* dvdData;
@property (retain) NSArray* blurayData;
@property (retain) LinkedSet* prioritizedMovies;

+ (DVDCache*) cache;

- (void) update;
- (void) prioritizeMovie:(Movie*) movie;

- (NSArray*) dvdMovies;
- (NSArray*) blurayMovies;
- (NSArray*) allMovies;

- (DVD*) dvdDetailsForMovie:(Movie*) movie;
- (UIImage*) posterForMovie:(Movie*) movie;
- (NSString*) imdbAddressForMovie:(Movie*) movie;

@end