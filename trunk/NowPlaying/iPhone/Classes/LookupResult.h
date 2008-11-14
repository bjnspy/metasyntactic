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
@private
    Location* location;

    NSMutableArray* movies;
    NSMutableArray* theaters;

    // theater name -> movie name -> [ { showtime, showid } ]
    NSMutableDictionary* performances;

    // theater name -> date
    NSMutableDictionary* synchronizationInformation;
}

@property (readonly, retain) Location* location;
@property (readonly, retain) NSMutableArray* movies;
@property (readonly, retain) NSMutableArray* theaters;
@property (readonly, retain) NSMutableDictionary* performances;
@property (readonly, retain) NSMutableDictionary* synchronizationInformation;

+ (LookupResult*) resultWithLocation:(Location*) location
                              movies:(NSMutableArray*) movies
                            theaters:(NSMutableArray*) theaters
                        performances:(NSMutableDictionary*) performances
          synchronizationInformation:(NSMutableDictionary*) synchronizationInformation;

@end