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

@interface AbstractDataProvider : NSObject {
@private
    NSLock* gate;

    NowPlayingModel* model;
    NSArray* moviesData;
    NSArray* theatersData;
    NSDictionary* synchronizationInformationData;

    NSMutableDictionary* performancesData;
}

@property (readonly, retain) NowPlayingModel* model;

- (id) initWithModel:(NowPlayingModel*) model;

- (NSArray*) movies;
- (NSArray*) theaters;
- (NSArray*) moviePerformances:(Movie*) movie forTheater:(Theater*) theater;
- (NSDate*) synchronizationDateForTheater:(Theater*) theater;

- (void) markOutOfDate;
- (NSDate*) lastLookupDate;

- (BOOL) isStale:(Theater*) theater;

- (void) update:(NSDate*) searchDate delegate:(id<DataProviderUpdateDelegate>) delegate context:(id) context;
- (void) saveResult:(LookupResult*) result;

@end