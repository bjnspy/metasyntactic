//
//  BoxOfficeModel.h
//  BoxOfficeApplication
//
//  Created by Cyrus Najmabadi on 4/26/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "PosterCache.h"
#import "TrailerCache.h"
#import "AddressLocationCache.h"
#import "XmlElement.h"
#import "Theater.h"
#import "NotificationCenter.h"

@interface BoxOfficeModel : NSObject {
    NotificationCenter* notificationCenter;
    
    PosterCache* posterCache;
    TrailerCache* trailerCache;
    AddressLocationCache* addressLocationCache;
    
    NSInteger backgroundTaskCount;
    UIActivityIndicatorView* activityIndicatorView;
    UIView* activityView;
    
    NSInteger searchRadius;
    
    NSArray* moviesData;
    NSArray* theatersData;
    NSDictionary* supplementaryInformationData;
    NSDictionary* movieMap;
    
    NSMutableArray* favoriteTheatersData;
}

@property (retain) NotificationCenter* notificationCenter;
@property (retain) PosterCache* posterCache;
@property (retain) TrailerCache* trailerCache;
@property (retain) AddressLocationCache* addressLocationCache;
@property (retain) UIActivityIndicatorView* activityIndicatorView;
@property (retain) UIView* activityView;
@property (readonly) NSInteger backgroundTaskCount;

@property (retain) NSArray* moviesData;
@property (retain) NSArray* theatersData;
@property (retain) NSDictionary* supplementaryInformationData;
@property (retain) NSDictionary* movieMap;
@property (retain) NSMutableArray* favoriteTheatersData;

+ (BoxOfficeModel*) modelWithCenter:(NotificationCenter*) notificationCenter;

- (void) addBackgroundTask:(NSString*) description;
- (void) removeBackgroundTask:(NSString*) description;

- (NSInteger) selectedTabBarViewControllerIndex;
- (void) setSelectedTabBarViewControllerIndex:(NSInteger) index;

- (NSInteger) allMoviesSelectedSegmentIndex;
- (void) setAllMoviesSelectedSegmentIndex:(NSInteger) index;

- (NSInteger) allTheatersSelectedSegmentIndex;
- (void) setAllTheatersSelectedSegmentIndex:(NSInteger) index;

- (Movie*) currentlySelectedMovie;
- (Theater*) currentlySelectedTheater;

- (void) setCurrentlySelectedMovie:(Movie*) movie 
                           theater:(Theater*) theater;

- (NSString*) zipcode;
- (void) setZipcode:(NSString*) zipcode;

- (NSInteger) searchRadius;
- (void) setSearchRadius:(NSInteger) searchRadius;

- (NSDate*) lastQuickUpdateTime;
- (NSDate*) lastFullUpdateTime;

- (NSDictionary*) supplementaryInformation;
- (void) setSupplementaryInformation:(NSDictionary*) dictionary;

- (NSArray*) movies;
- (void) setMovies:(NSArray*) movies;

- (NSArray*) theaters;
- (void) setTheaters:(NSArray*) theaters;

- (UIImage*) posterForMovie:(Movie*) movie;
- (Location*) locationForAddress:(NSString*) address;
- (Location*) locationForZipcode:(NSString*) zipcode;

- (NSArray*) theatersShowingMovie:(Movie*) movie;
- (NSArray*) moviesAtTheater:(Theater*) theater;
- (NSArray*) movieShowtimes:(Movie*) movie
                 forTheater:(Theater*) theater;

- (NSDictionary*) theaterDistanceMap;
- (NSArray*) theatersInRange:(NSArray*) theaters;

NSInteger compareTheatersByName(id t1, id t2, void *context);
NSInteger compareTheatersByDistance(id t1, id t2, void *context);

- (XmlElement*) getPersonDetails:(NSString*) identifier;
- (void) setPersonDetails:(NSString*) identifier element:(XmlElement*) element;

- (XmlElement*) getMovieDetails:(NSString*) identifier;
- (void) setMovieDetails:(NSString*) identifier element:(XmlElement*) element;

- (NSMutableDictionary*) getSearchDates;
- (NSMutableDictionary*) getSearchResults;

- (NSString*) synopsisForMovie:(Movie*) movie;
- (NSInteger) rankingForMovie:(Movie*) movie;

- (NSArray*) trailersForMovie:(Movie*) movie;

- (void) applicationWillTerminate;

- (NSMutableArray*) favoriteTheaters;
- (BOOL) isFavoriteTheater:(Theater*) theater;
- (void) addFavoriteTheater:(Theater*) theater;
- (void) removeFavoriteTheater:(Theater*) theater;

@end
