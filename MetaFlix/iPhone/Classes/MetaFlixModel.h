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

enum ViewControllerType {
    MovieDetails = 1,
    TheaterDetails = 2,
    Reviews = 3,
    Tickets = 4
};

@interface MetaFlixModel : NSObject {
@private
    IMDbCache* imdbCache;
    AmazonCache* amazonCache;
    WikipediaCache* wikipediaCache;
    PosterCache* posterCache;
    LargePosterCache* largePosterCache;
    TrailerCache* trailerCache;
    MutableNetflixCache* netflixCache;

    NSMutableSet* bookmarkedTitlesData;
}

@property (readonly, retain) IMDbCache* imdbCache;
@property (readonly, retain) AmazonCache* amazonCache;
@property (readonly, retain) WikipediaCache* wikipediaCache;
@property (readonly, retain) PosterCache* posterCache;
@property (readonly, retain) LargePosterCache* largePosterCache;
@property (readonly, retain) TrailerCache* trailerCache;
@property (readonly, retain) MutableNetflixCache* netflixCache;

+ (MetaFlixModel*) model;

+ (NSString*) version;

- (NSString*) netflixKey;
- (NSString*) netflixSecret;
- (NSString*) netflixUserId;
- (NSString*) netflixFirstName;
- (NSString*) netflixLastName;
- (void) setNetflixKey:(NSString*) key secret:(NSString*) secret userId:(NSString*) userId;
- (void) setNetflixFirstName:(NSString*) firstName lastName:(NSString*) lastName canInstantWatch:(BOOL) canInstantWatch preferredFormats:(NSArray*) preferredFormats;

- (BOOL) prioritizeBookmarks;
- (void) setPrioritizeBookmarks:(BOOL) value;

- (NSArray*) directorsForMovie:(Movie*) movie;
- (NSArray*) castForMovie:(Movie*) movie;
- (NSString*) imdbAddressForMovie:(Movie*) movie;
- (NSString*) amazonAddressForMovie:(Movie*) movie;
- (NSString*) wikipediaAddressForMovie:(Movie*) movie;
- (NSArray*) genresForMovie:(Movie*) movie;
- (NSDate*) releaseDateForMovie:(Movie*) movie;
- (UIImage*) posterForMovie:(Movie*) movie;
- (UIImage*) smallPosterForMovie:(Movie*) movie;

NSInteger compareMoviesByReleaseDateAscending(id t1, id t2, void* context);
NSInteger compareMoviesByReleaseDateDescending(id t1, id t2, void* context);
NSInteger compareMoviesByTitle(id t1, id t2, void* context);

- (void) prioritizeMovie:(Movie*) movie;

- (NSString*) synopsisForMovie:(Movie*) movie;
- (NSArray*) trailersForMovie:(Movie*) movie;

- (NSSet*) bookmarkedTitles;
- (BOOL) isBookmarked:(Movie*) movie;
- (void) addBookmark:(Movie*) movie;
- (void) removeBookmark:(Movie*) movie;

- (NSArray*) bookmarkedMovies;
- (NSArray*) bookmarkedUpcoming;
- (NSArray*) bookmarkedDVD;
- (NSArray*) bookmarkedBluray;
- (void) setBookmarkedMovies:(NSArray*) array;
- (void) setBookmarkedUpcoming:(NSArray*) array;
- (void) setBookmarkedDVD:(NSArray*) array;
- (void) setBookmarkedBluray:(NSArray*) array;

- (NSString*) noInformationFound;
- (NSString*) feedbackUrl;

@end