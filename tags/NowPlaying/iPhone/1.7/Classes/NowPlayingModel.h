// Copyright (C) 2008 Cyrus Najmabadi
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

@interface NowPlayingModel : NSObject {
    AddressLocationCache* addressLocationCache;
    IMDbCache* imdbCache;
    NumbersCache* numbersCache;
    PosterCache* posterCache;
    ReviewCache* reviewCache;
    RatingsCache* ratingsCache;
    TrailerCache* trailerCache;
    UpcomingCache* upcomingCache;

    NSInteger searchRadius;

    NSDictionary* movieMap;

    NSMutableArray* favoriteTheatersData;

    NSArray* dataProviders;
}

@property (retain) AddressLocationCache* addressLocationCache;
@property (retain) IMDbCache* imdbCache;
@property (retain) NumbersCache* numbersCache;
@property (retain) PosterCache* posterCache;
@property (retain) ReviewCache* reviewCache;
@property (retain) RatingsCache* ratingsCache;
@property (retain) TrailerCache* trailerCache;
@property (retain) UpcomingCache* upcomingCache;

@property (retain) NSDictionary* movieMap;
@property (retain) NSMutableArray* favoriteTheatersData;
@property (retain) NSArray* dataProviders;

+ (NowPlayingModel*) model;

+ (NSString*) version;

- (id<DataProvider>) currentDataProvider;
- (NSInteger) dataProviderIndex;
- (void) setDataProviderIndex:(NSInteger) index;
- (BOOL) northAmericaDataProvider;
- (BOOL) unitedKingdomDataProvider;

- (NSInteger) ratingsProviderIndex;
- (void) setRatingsProviderIndex:(NSInteger) index;
- (BOOL) rottenTomatoesRatings;
- (BOOL) metacriticRatings;
- (BOOL) noRatings;
- (NSString*) currentRatingsProvider;
- (NSArray*) ratingsProviders;

- (NSInteger) selectedTabBarViewControllerIndex;
- (void) setSelectedTabBarViewControllerIndex:(NSInteger) index;

- (NSInteger) allMoviesSelectedSegmentIndex;
- (void) setAllMoviesSelectedSegmentIndex:(NSInteger) index;

- (NSInteger) allTheatersSelectedSegmentIndex;
- (void) setAllTheatersSelectedSegmentIndex:(NSInteger) index;

- (NSInteger) upcomingMoviesSelectedSegmentIndex;
- (void) setUpcomingMoviesSelectedSegmentIndex:(NSInteger) index;

- (NSInteger) numbersSelectedSegmentIndex;
- (void) setNumbersSelectedSegmentIndex:(NSInteger) index;

- (BOOL) allMoviesSortingByTitle;
- (BOOL) allMoviesSortingByScore;
- (BOOL) allMoviesSortingByReleaseDate;

- (BOOL) upcomingMoviesSortingByTitle;
- (BOOL) upcomingMoviesSortingByReleaseDate;

- (BOOL) numbersSortingByDailyGross;
- (BOOL) numbersSortingByWeekendGross;
- (BOOL) numbersSortingByTotalGross;

- (void) saveNavigationStack:(AbstractNavigationController*) controller;
- (NSArray*) navigationStackTypes;
- (NSArray*) navigationStackValues;

- (BOOL) autoUpdateLocation;
- (void) setAutoUpdateLocation:(BOOL) value;

- (NSString*) userLocation;
- (void) setUserLocation:(NSString*) userLocation;

- (NSInteger) searchRadius;
- (void) setSearchRadius:(NSInteger) searchRadius;

- (NSDate*) searchDate;
- (void) setSearchDate:(NSDate*) date;

- (NSArray*) movies;
- (NSArray*) theaters;

- (void) onProviderUpdated;
- (void) onRatingsUpdated;

- (NSArray*) directorsForMovie:(Movie*) movie;
- (NSArray*) castForMovie:(Movie*) movie;
- (NSString*) imdbAddressForMovie:(Movie*) movie;
- (NSArray*) genresForMovie:(Movie*) movie;
- (UIImage*) posterForMovie:(Movie*) movie;
- (Location*) locationForAddress:(NSString*) address;

- (NSMutableArray*) theatersShowingMovie:(Movie*) movie;
- (NSArray*) moviesAtTheater:(Theater*) theater;
- (NSArray*) moviePerformances:(Movie*) movie forTheater:(Theater*) theater;
- (NSString*) simpleAddressForTheater:(Theater*) theater;
- (NSDate*) synchronizationDateForTheater:(Theater*) theater;

- (BOOL) isStale:(Theater*) theater;
- (NSString*) showtimesRetrievedOnString:(Theater*) theater;

- (NSDictionary*) theaterDistanceMap;
- (NSArray*) theatersInRange:(NSArray*) theaters;

NSInteger compareMoviesByScore(id t1, id t2, void *context);
NSInteger compareMoviesByReleaseDateAscending(id t1, id t2, void *context);
NSInteger compareMoviesByReleaseDateDescending(id t1, id t2, void *context);
NSInteger compareMoviesByTitle(id t1, id t2, void *context);
NSInteger compareTheatersByName(id t1, id t2, void *context);
NSInteger compareTheatersByDistance(id t1, id t2, void *context);

- (NSString*) synopsisForMovie:(Movie*) movie;
- (NSInteger) scoreForMovie:(Movie*) movie;

- (NSArray*) trailersForMovie:(Movie*) movie;
- (NSArray*) reviewsForMovie:(Movie*) movie;

- (NSMutableArray*) favoriteTheaters;
- (BOOL) isFavoriteTheater:(Theater*) theater;
- (void) addFavoriteTheater:(Theater*) theater;
- (void) removeFavoriteTheater:(Theater*) theater;

- (NSString*) noLocationInformationFound;

- (BOOL) useSmallFonts;
- (void) setUseSmallFonts:(BOOL) useSmallFonts;

- (BOOL) hideEmptyTheaters;
- (void) setHideEmptyTheaters:(BOOL) hideEmptyTheaters;

@end