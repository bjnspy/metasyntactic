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

@interface Model : NSObject<UIAlertViewDelegate> {
@private
    UserLocationCache* userLocationCache;
    BlurayCache* blurayCache;
    DVDCache* dvdCache;
    IMDbCache* imdbCache;
    AmazonCache* amazonCache;
    WikipediaCache* wikipediaCache;
    PersonPosterCache* personPosterCache;
    PosterCache* posterCache;
    LargePosterCache* largePosterCache;
    ScoreCache* scoreCache;
    TrailerCache* trailerCache;
    UpcomingCache* upcomingCache;
    MutableNetflixCache* netflixCache;

    NSInteger searchRadius;

    NSMutableSet* bookmarkedTitlesData;
    NSMutableDictionary* favoriteTheatersData;

    id<DataProvider> dataProvider;

    NSInteger cachedScoreProviderIndex;
}

@property (readonly, retain) UserLocationCache* userLocationCache;
@property (readonly, retain) BlurayCache* blurayCache;
@property (readonly, retain) DVDCache* dvdCache;
@property (readonly, retain) IMDbCache* imdbCache;
@property (readonly, retain) AmazonCache* amazonCache;
@property (readonly, retain) WikipediaCache* wikipediaCache;
@property (readonly, retain) PersonPosterCache* personPosterCache;
@property (readonly, retain) PosterCache* posterCache;
@property (readonly, retain) LargePosterCache* largePosterCache;
@property (readonly, retain) ScoreCache* scoreCache;
@property (readonly, retain) TrailerCache* trailerCache;
@property (readonly, retain) UpcomingCache* upcomingCache;
@property (readonly, retain) MutableNetflixCache* netflixCache;
@property (readonly, retain) id<DataProvider> dataProvider;

+ (Model*) model;

+ (NSString*) version;

- (void) update;
- (void) updateDVDCache;
- (void) updateUpcomingCache;

- (BOOL) screenRotationEnabled;
- (void) setScreenRotationEnabled:(BOOL) enabled;

- (BOOL) dvdBlurayEnabled;
- (BOOL) upcomingEnabled;
- (BOOL) netflixEnabled;
- (void) setDvdBlurayEnabled:(BOOL) value;
- (void) setUpcomingEnabled:(BOOL) value;
- (void) setNetflixEnabled:(BOOL) value;

- (NSString*) netflixTheme;
- (void) setNetflixTheme:(NSString*) theme;
- (NSArray*) netflixThemes;
- (BOOL) isIronManTheme;

- (NSString*) netflixKey;
- (NSString*) netflixSecret;
- (NSString*) netflixUserId;
- (NSString*) netflixFirstName;
- (NSString*) netflixLastName;
- (void) setNetflixKey:(NSString*) key secret:(NSString*) secret userId:(NSString*) userId;
- (void) setNetflixFirstName:(NSString*) firstName lastName:(NSString*) lastName canInstantWatch:(BOOL) canInstantWatch preferredFormats:(NSArray*) preferredFormats;

- (NSInteger) scoreProviderIndex;
- (void) setScoreProviderIndex:(NSInteger) index;
- (BOOL) rottenTomatoesScores;
- (BOOL) metacriticScores;
- (BOOL) googleScores;
- (BOOL) noScores;
- (NSString*) currentScoreProvider;
- (NSArray*) scoreProvider;

- (NSInteger) selectedTabBarViewControllerIndex;
- (void) setSelectedTabBarViewControllerIndex:(NSInteger) index;

- (NSInteger) allMoviesSelectedSegmentIndex;
- (void) setAllMoviesSelectedSegmentIndex:(NSInteger) index;

- (NSInteger) allTheatersSelectedSegmentIndex;
- (void) setAllTheatersSelectedSegmentIndex:(NSInteger) index;

- (NSInteger) upcomingMoviesSelectedSegmentIndex;
- (void) setUpcomingMoviesSelectedSegmentIndex:(NSInteger) index;

- (NSInteger) dvdMoviesSelectedSegmentIndex;
- (void) setDvdMoviesSelectedSegmentIndex:(NSInteger) index;

- (BOOL) allMoviesSortingByTitle;
- (BOOL) allMoviesSortingByScore;
- (BOOL) allMoviesSortingByReleaseDate;

- (BOOL) upcomingMoviesSortingByTitle;
- (BOOL) upcomingMoviesSortingByReleaseDate;

- (BOOL) dvdMoviesSortingByTitle;
- (BOOL) dvdMoviesSortingByReleaseDate;
- (BOOL) dvdMoviesShowDVDs;
- (BOOL) dvdMoviesShowBluray;
- (BOOL) dvdMoviesShowBoth;
- (BOOL) dvdMoviesShowOnlyDVDs;
- (BOOL) dvdMoviesShowOnlyBluray;
- (void) setDvdMoviesShowDVDs:(BOOL) value;
- (void) setDvdMoviesShowBluray:(BOOL) value;

- (BOOL) upcomingAndDVDShowUpcoming;
- (void) setUpcomingAndDVDShowUpcoming:(BOOL) value;

- (void) saveNavigationStack:(UINavigationController*) controller;
- (NSArray*) navigationStackTypes;
- (NSArray*) navigationStackValues;

- (BOOL) prioritizeBookmarks;
- (void) setPrioritizeBookmarks:(BOOL) value;

- (BOOL) delayPosterLoading;
- (void) setDelayPosterLoading:(BOOL) value;

- (BOOL) autoUpdateLocation;
- (void) setAutoUpdateLocation:(BOOL) value;

- (NSString*) userAddress;
- (void) setUserAddress:(NSString*) userAddress;

- (NSInteger) searchRadius;
- (void) setSearchRadius:(NSInteger) searchRadius;

- (NSDate*) searchDate;
- (void) setSearchDate:(NSDate*) date;

- (NSArray*) movies;
- (NSArray*) theaters;

- (NSArray*) directorsForMovie:(Movie*) movie;
- (NSArray*) castForMovie:(Movie*) movie;
- (NSString*) imdbAddressForMovie:(Movie*) movie;
- (NSString*) amazonAddressForMovie:(Movie*) movie;
- (NSString*) wikipediaAddressForMovie:(Movie*) movie;
- (NSArray*) genresForMovie:(Movie*) movie;
- (NSDate*) releaseDateForMovie:(Movie*) movie;
- (DVD*) dvdDetailsForMovie:(Movie*) movie;
- (UIImage*) posterForMovie:(Movie*) movie;
- (UIImage*) smallPosterForMovie:(Movie*) movie;

- (NSMutableArray*) theatersShowingMovie:(Movie*) movie;
- (NSArray*) moviesAtTheater:(Theater*) theater;
- (NSArray*) moviePerformances:(Movie*) movie forTheater:(Theater*) theater;
- (NSString*) simpleAddressForTheater:(Theater*) theater;
- (NSDate*) synchronizationDateForTheater:(Theater*) theater;

- (BOOL) isStale:(Theater*) theater;
- (NSString*) showtimesRetrievedOnString:(Theater*) theater;

- (NSDictionary*) theaterDistanceMap;
- (NSArray*) theatersInRange:(NSArray*) theaters;

NSInteger compareMoviesByScore(id t1, id t2, void* context);
NSInteger compareMoviesByReleaseDateAscending(id t1, id t2, void* context);
NSInteger compareMoviesByReleaseDateDescending(id t1, id t2, void* context);
NSInteger compareMoviesByTitle(id t1, id t2, void* context);
NSInteger compareTheatersByName(id t1, id t2, void* context);
NSInteger compareTheatersByDistance(id t1, id t2, void* context);

- (void) prioritizeMovie:(Movie*) movie;

- (NSString*) synopsisForMovie:(Movie*) movie;
- (Score*) scoreForMovie:(Movie*) movie;
- (Score*) rottenTomatoesScoreForMovie:(Movie*) movie;
- (Score*) metacriticScoreForMovie:(Movie*) movie;
- (NSInteger) scoreValueForMovie:(Movie*) movie;

- (NSArray*) trailersForMovie:(Movie*) movie;
- (NSArray*) reviewsForMovie:(Movie*) movie;

- (NSArray*) favoriteTheaters;
- (BOOL) isFavoriteTheater:(Theater*) theater;
- (void) addFavoriteTheater:(Theater*) theater;
- (void) removeFavoriteTheater:(Theater*) theater;

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

- (BOOL) useSmallFonts;
- (void) setUseSmallFonts:(BOOL) useSmallFonts;

@end