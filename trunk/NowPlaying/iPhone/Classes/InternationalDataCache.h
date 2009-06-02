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

@interface InternationalDataCache : AbstractCache {
@private
    DifferenceEngine* engine;
    BOOL updated;

    ThreadsafeValue*/*NSDictionary*/ indexData;
    NSMutableDictionary* movieMap;

    NSMutableDictionary* ratingAndRuntimeCache;
}

+ (InternationalDataCache*) cache;

+ (BOOL) isAllowableCountry;

- (void) update;

- (NSString*) synopsisForMovie:(Movie*) movie;
- (NSArray*) trailersForMovie:(Movie*) movie;
- (NSArray*) directorsForMovie:(Movie*) movie;
- (NSArray*) castForMovie:(Movie*) movie;
- (NSString*) imdbAddressForMovie:(Movie*) movie;
- (NSDate*) releaseDateForMovie:(Movie*) movie;
- (NSString*) ratingForMovie:(Movie*) movie;
- (NSInteger) lengthForMovie:(Movie*) movie;
- (NSString*) ratingAndRuntimeForMovie:(Movie*) movie;

@end