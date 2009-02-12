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

@interface Model : NSObject {
@private
    IMDbCache* imdbCache;
    AmazonCache* amazonCache;
    WikipediaCache* wikipediaCache;
    PosterCache* posterCache;
    PersonPosterCache* personPosterCache;
    LargePosterCache* largePosterCache;
    TrailerCache* trailerCache;
    MutableNetflixCache* netflixCache;
}

@property (readonly, retain) IMDbCache* imdbCache;
@property (readonly, retain) AmazonCache* amazonCache;
@property (readonly, retain) WikipediaCache* wikipediaCache;
@property (readonly, retain) PosterCache* posterCache;
@property (readonly, retain) PersonPosterCache* personPosterCache;
@property (readonly, retain) LargePosterCache* largePosterCache;
@property (readonly, retain) TrailerCache* trailerCache;
@property (readonly, retain) MutableNetflixCache* netflixCache;

+ (Model*) model;

+ (NSString*) version;

- (NSString*) netflixKey;
- (NSString*) netflixSecret;
- (NSString*) netflixUserId;
- (NSString*) netflixFirstName;
- (NSString*) netflixLastName;
- (NSArray*) netflixPreferredFormats;
- (BOOL) netflixCanInstantWatch;
- (void) setNetflixKey:(NSString*) key secret:(NSString*) secret userId:(NSString*) userId;
- (void) setNetflixFirstName:(NSString*) firstName lastName:(NSString*) lastName canInstantWatch:(BOOL) canInstantWatch preferredFormats:(NSArray*) preferredFormats;

- (NSArray*) directorsForMovie:(Movie*) movie;
- (NSArray*) castForMovie:(Movie*) movie;
- (NSString*) imdbAddressForMovie:(Movie*) movie;
- (NSString*) amazonAddressForMovie:(Movie*) movie;
- (NSString*) netflixAddressForMovie:(Movie*) movie;
- (NSString*) wikipediaAddressForMovie:(Movie*) movie;
- (NSArray*) genresForMovie:(Movie*) movie;
- (NSDate*) releaseDateForMovie:(Movie*) movie;
- (UIImage*) posterForMovie:(Movie*) movie;
- (UIImage*) smallPosterForMovie:(Movie*) movie;
- (UIImage*) smallPosterForPerson:(Person*) person;

NSInteger compareMoviesByReleaseDateAscending(id t1, id t2, void* context);
NSInteger compareMoviesByReleaseDateDescending(id t1, id t2, void* context);
NSInteger compareMoviesByTitle(id t1, id t2, void* context);

- (void) prioritizeMovie:(Movie*) movie;
- (void) prioritizePerson:(Person*) person;

- (NSString*) synopsisForMovie:(Movie*) movie;
- (NSArray*) trailersForMovie:(Movie*) movie;

- (NSString*) noInformationFound;
- (NSString*) feedbackUrl;

- (BOOL) isBookmarked:(Movie*) movie;

@end