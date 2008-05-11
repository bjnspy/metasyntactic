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

@interface BoxOfficeModel : NSObject {
    PosterCache* posterCache;
    AddressLocationCache* addressLocationCache;
}

@property (retain) PosterCache* posterCache;
@property (retain) AddressLocationCache* addressLocationCache;

+ (BoxOfficeModel*) model;

- (NSString*) zipcode;
- (void) setZipcode:(NSString*) zipcode;

- (NSInteger) searchRadius;
- (void) setSearchRadius:(NSInteger) searchRadius;

- (NSArray*) movies;
- (void) setMovies:(NSArray*) movies;

- (NSArray*) theaters;
- (void) setTheaters:(NSArray*) theaters;

- (XmlElement*) tickets;
- (void) setTickets:(XmlElement*) tickets;

- (UIImage*) posterForMovie:(Movie*) movie;
- (Location*) locationForAddress:(NSString*) address;
- (Location*) locationForZipcode:(NSString*) zipcode;

- (NSArray*) theatersShowingMovie:(Movie*) movie;
- (NSArray*) moviesAtTheater:(Theater*) theater;
- (NSArray*) movieShowtimes:(Movie*) movie
                 forTheater:(Theater*) theater;

@end
