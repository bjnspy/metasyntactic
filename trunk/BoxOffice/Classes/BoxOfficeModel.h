//
//  BoxOfficeModel.h
//  BoxOfficeApplication
//
//  Created by Cyrus Najmabadi on 4/26/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PosterCache.h"
#import "AddressLocationCache.h"
#import "XmlElement.h"
#import "Theater.h"
#import "NotificationCenter.h"

@interface BoxOfficeModel : NSObject {
    NotificationCenter* notificationCenter;
    
    PosterCache* posterCache;
    AddressLocationCache* addressLocationCache;
    
    NSInteger backgroundTaskCount;
    UIActivityIndicatorView* activityIndicatorView;
    UIView* activityView;
    
    XmlElement* ticketsElement;
}

@property (retain) NotificationCenter* notificationCenter;
@property (retain) PosterCache* posterCache;
@property (retain) AddressLocationCache* addressLocationCache;
@property (retain) UIActivityIndicatorView* activityIndicatorView;
@property (retain) UIView* activityView;
@property (readonly) NSInteger backgroundTaskCount;
@property (retain) XmlElement* ticketsElement;

+ (BoxOfficeModel*) modelWithCenter:(NotificationCenter*) notificationCenter;

- (void) addBackgroundTask:(NSString*) description;
- (void) removeBackgroundTask:(NSString*) description;

- (NSInteger) selectedTabBarViewControllerIndex;
- (void) setSelectedTabBarViewControllerIndex:(NSInteger) index;

- (NSInteger) allMoviesSelectedSegmentIndex;
- (void) setAllMoviesSelectedSegmentIndex:(NSInteger) index;

- (NSInteger) allTheatersSelectedSegmentIndex;
- (void) setAllTheatersSelectedSegmentIndex:(NSInteger) index;

- (NSString*) zipcode;
- (void) setZipcode:(NSString*) zipcode;

- (NSInteger) searchRadius;
- (void) setSearchRadius:(NSInteger) searchRadius;

- (NSArray*) movies;
- (void) setMovies:(NSArray*) movies;
- (NSDate*) lastMoviesUpdateTime;

- (NSArray*) theaters;
- (void) setTheaters:(NSArray*) theaters;
- (NSDate*) lastTheatersUpdateTime;

- (XmlElement*) tickets;
- (void) setTickets:(XmlElement*) tickets;
- (NSDate*) lastTicketsUpdateTime;

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

@end
