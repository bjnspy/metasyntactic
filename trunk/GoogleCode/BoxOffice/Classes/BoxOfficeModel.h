// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
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

@interface BoxOfficeModel : NSObject {
    NotificationCenter* notificationCenter;

    PosterCache* posterCache;
    TrailerCache* trailerCache;
    AddressLocationCache* addressLocationCache;
    ReviewCache* reviewCache;
    RatingsCache* ratingsCache;

    NSInteger backgroundTaskCount;
    UIActivityIndicatorView* activityIndicatorView;
    UIView* activityView;

    NSInteger searchRadius;

    NSDictionary* movieMap;

    NSMutableArray* favoriteTheatersData;

    NSArray* dataProviders;
}

@property (retain) NotificationCenter* notificationCenter;

@property (retain) PosterCache* posterCache;
@property (retain) TrailerCache* trailerCache;
@property (retain) ReviewCache* reviewCache;
@property (retain) AddressLocationCache* addressLocationCache;
@property (retain) RatingsCache* ratingsCache;

@property (retain) UIActivityIndicatorView* activityIndicatorView;
@property (retain) UIView* activityView;
@property NSInteger backgroundTaskCount;

@property (retain) NSDictionary* movieMap;
@property (retain) NSMutableArray* favoriteTheatersData;
@property (retain) NSArray* dataProviders;

+ (BoxOfficeModel*) modelWithCenter:(NotificationCenter*) notificationCenter;

+ (NSString*) version;

- (void) addBackgroundTask:(NSString*) description;
- (void) removeBackgroundTask:(NSString*) description;

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

- (BOOL) useKilometers;

- (NSInteger) selectedTabBarViewControllerIndex;
- (void) setSelectedTabBarViewControllerIndex:(NSInteger) index;

- (NSInteger) allMoviesSelectedSegmentIndex;
- (void) setAllMoviesSelectedSegmentIndex:(NSInteger) index;

- (BOOL) sortingMoviesByTitle;
- (BOOL) sortingMoviesByScore;
- (BOOL) sortingMoviesByReleaseDate;

- (NSInteger) allTheatersSelectedSegmentIndex;
- (void) setAllTheatersSelectedSegmentIndex:(NSInteger) index;

- (void) saveNavigationStack:(AbstractNavigationController*) controller;
- (NSArray*) navigationStackTypes;
- (NSArray*) navigationStackValues;

- (BOOL) autoUpdateLocation;
- (void) setAutoUpdateLocation:(BOOL) value;

- (NSString*) postalCode;
- (void) setPostalCode:(NSString*) postalCode;

- (NSInteger) searchRadius;
- (void) setSearchRadius:(NSInteger) searchRadius;

- (NSDate*) searchDate;
- (void) setSearchDate:(NSDate*) date;

- (NSArray*) movies;
- (NSArray*) theaters;

- (void) onProviderUpdated;
- (void) onRatingsUpdated;

- (UIImage*) posterForMovie:(Movie*) movie;
- (Location*) locationForAddress:(NSString*) address;

- (NSMutableArray*) theatersShowingMovie:(Movie*) movie;
- (NSArray*) moviesAtTheater:(Theater*) theater;
- (NSArray*) moviePerformances:(Movie*) movie forTheater:(Theater*) theater;
- (NSString*) simpleAddressForTheater:(Theater*) theater;

- (NSDictionary*) theaterDistanceMap;
- (NSArray*) theatersInRange:(NSArray*) theaters;

NSInteger compareMoviesByScore(id t1, id t2, void *context);
NSInteger compareMoviesByReleaseDate(id t1, id t2, void *context);
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

+ (NSString*) SEARCH_DATES;
+ (NSString*) SEARCH_RESULTS;
+ (NSString*) SEARCH_RADIUS;
+ (NSString*) POSTAL_CODE;
+ (NSString*) SELECTED_TAB_BAR_VIEW_CONTROLLER_INDEX;
+ (NSString*) ALL_MOVIES_SELECTED_SEGMENT_INDEX;
+ (NSString*) ALL_THEATERS_SELECTED_SEGMENT_INDEX;
+ (NSString*) FAVORITE_THEATERS;
+ (NSString*) SEARCH_DATE;
+ (NSString*) AUTO_UPDATE_LOCATION;
+ (NSString*) DATA_PROVIDER_INDEX;
+ (NSString*) RATINGS_PROVIDER_INDEX;
+ (NSString*) USE_NORMAL_FONTS;

@end
