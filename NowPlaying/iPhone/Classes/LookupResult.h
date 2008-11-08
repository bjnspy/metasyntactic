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

@interface LookupResult : NSObject {
    NSMutableArray* movies;
    NSMutableArray* theaters;

    // theater name -> movie name -> [ { showtime, showid } ]
    NSMutableDictionary* performances;

    // theater name -> date
    NSMutableDictionary* synchronizationData;
}

@property (retain) NSMutableArray* movies;
@property (retain) NSMutableArray* theaters;
@property (retain) NSMutableDictionary* performances;
@property (retain) NSMutableDictionary* synchronizationData;

+ (LookupResult*) resultWithMovies:(NSMutableArray*) movies
                          theaters:(NSMutableArray*) theaters
                      performances:(NSMutableDictionary*) performances
              synchronizationData:(NSMutableDictionary*) synchronizationData;

@end