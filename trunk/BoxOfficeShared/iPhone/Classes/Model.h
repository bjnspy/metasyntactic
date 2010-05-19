// Copyright 2010 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

enum ViewControllerType {
  MovieDetails = 1,
  TheaterDetails = 2,
  Reviews = 3,
  Tickets = 4
};

@interface Model : AbstractModel<UIAlertViewDelegate> {
@private
  PersonPosterCache* personPosterCache;

  id<DataProvider> dataProvider;

  NSInteger searchRadiusData;
  NSNumber* isSearchDateTodayData;

  NSInteger cachedScoreProviderIndex;
  NSInteger cachedAllMoviesSelectedSegmentIndex;
}

@property (readonly, retain) PersonPosterCache* personPosterCache;
@property (readonly, retain) id<DataProvider> dataProvider;

+ (Model*) model;

- (void) checkCountry;

- (BOOL) loadingIndicatorsEnabled;
- (void) setLoadingIndicatorsEnabled:(BOOL) value;

- (BOOL) notificationsEnabled;
- (void) setNotificationsEnabled:(BOOL) value;

- (BOOL) netflixNotificationsEnabled;
- (void) setNetflixNotificationsEnabled:(BOOL) value;

- (BOOL) dataProviderEnabled;

- (BOOL) scoreCacheEnabled;
- (BOOL) helpCacheEnabled;
- (BOOL) internationalDataCacheEnabled;
- (BOOL) largePosterCacheEnabled;
- (BOOL) dvdBlurayCacheEnabled;
- (BOOL) upcomingCacheEnabled;
- (BOOL) netflixCacheEnabled;
- (BOOL) trailerCacheEnabled;

- (void) setDvdBlurayCacheEnabled:(BOOL) value;
- (void) setUpcomingCacheEnabled:(BOOL) value;
- (void) setNetflixCacheEnabled:(BOOL) value;

- (NSInteger) scoreProviderIndex;
- (void) setScoreProviderIndex:(NSInteger) index;
- (BOOL) rottenTomatoesScores;
- (BOOL) metacriticScores;
- (BOOL) googleScores;
- (BOOL) noScores;
- (NSString*) currentScoreProvider;
- (NSArray*) scoreProviders;

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

- (NSInteger) localSearchSelectedScopeButtonIndex;
- (void) setLocalSearchSelectedScopeButtonIndex:(NSInteger) index;

- (NSInteger) netflixSearchSelectedScopeButtonIndex;
- (void) setNetflixSearchSelectedScopeButtonIndex:(NSInteger) index;

- (NSInteger) netflixFilterSelectedSegmentIndex;
- (void) setNetflixFilterSelectedSegmentIndex:(NSInteger) index;

- (BOOL) allMoviesSortingByTitle;
- (BOOL) allMoviesSortingByScore;
- (BOOL) allMoviesSortingByReleaseDate;
- (BOOL) allMoviesSortingByFavorite;

- (BOOL) upcomingMoviesSortingByTitle;
- (BOOL) upcomingMoviesSortingByReleaseDate;
- (BOOL) upcomingMoviesSortingByFavorite;

- (BOOL) dvdMoviesSortingByTitle;
- (BOOL) dvdMoviesSortingByReleaseDate;
- (BOOL) dvdMoviesSortingByFavorite;

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
- (void) clearNavigationStack;

- (BOOL) autoUpdateLocation;
- (void) setAutoUpdateLocation:(BOOL) value;

- (NSString*) userAddress;
- (void) setUserAddress:(NSString*) userAddress;

- (NSInteger) searchRadius;
- (void) setSearchRadius:(NSInteger) searchRadius;

- (NSDate*) searchDate;
- (void) setSearchDate:(NSDate*) date;
- (BOOL) isSearchDateToday;

- (NSArray*) movies;
- (NSArray*) theaters;

- (NSArray*) directorsForMovie:(Movie*) movie;
- (NSArray*) castForMovie:(Movie*) movie;
- (NSArray*) genresForMovie:(Movie*) movie;
- (NSDate*) releaseDateForMovie:(Movie*) movie;
- (NSString*) ratingForMovie:(Movie*) movie;
- (NSString*) ratingAndRuntimeForMovie:(Movie*) movie;
- (NSInteger) lengthForMovie:(Movie*) movie;
- (DVD*) dvdDetailsForMovie:(Movie*) movie;

- (NSString*) imdbAddressForMovie:(Movie*) movie;
- (NSString*) amazonAddressForMovie:(Movie*) movie;
- (NSString*) netflixAddressForMovie:(Movie*) movie;
- (NSString*) wikipediaAddressForMovie:(Movie*) movie;
- (NSString*) metacriticAddressForMovie:(Movie*) movie;
- (NSString*) rottenTomatoesAddressForMovie:(Movie*) movie;

- (NSString*) imdbAddressForPerson:(Person*) person;
- (NSString*) netflixAddressForPerson:(Person*) person;
- (NSString*) wikipediaAddressForPerson:(Person*) person;
- (NSString*) rottenTomatoesAddressForPerson:(Person*) person;

- (UIImage*) posterForMovie:(Movie*) movie;
- (UIImage*) smallPosterForMovie:(Movie*) movie;
- (UIImage*) posterForMovie:(Movie*) movie loadFromDisk:(BOOL) loadFromDisk;
- (UIImage*) smallPosterForMovie:(Movie*) movie loadFromDisk:(BOOL) loadFromDisk;

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

- (NSString*) synopsisForMovie:(Movie*) movie;
- (Score*) scoreForMovie:(Movie*) movie;
- (Score*) rottenTomatoesScoreForMovie:(Movie*) movie;
- (Score*) metacriticScoreForMovie:(Movie*) movie;
- (NSInteger) scoreValueForMovie:(Movie*) movie;

- (NSArray*) trailersForMovie:(Movie*) movie;
- (NSArray*) reviewsForMovie:(Movie*) movie;

- (NSString*) noInformationFound;

- (BOOL) useSmallFonts;
- (void) setUseSmallFonts:(BOOL) useSmallFonts;

- (BOOL) netflixTheming;
- (void) setNetflixTheming:(BOOL) netflixTheming;

- (void) setEventIdentifier:(NSString*) eventIdentifier
      forPerformanceIdentifier:(NSString*) performanceIdentifier;
- (NSString*) eventIdentifierForPerformanceIdentifier:(NSString*) performanceIdentifier;


@end
