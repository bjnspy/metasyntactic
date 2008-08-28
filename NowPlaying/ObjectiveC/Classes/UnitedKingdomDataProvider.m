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

#import "UnitedKingdomDataProvider.h"

#import "Application.h"
#import "LookupResult.h"
#import "Movie.h"
#import "Utilities.h"
#import "XmlElement.h"
#import "XmlParser.h"

@implementation UnitedKingdomDataProvider

+ (UnitedKingdomDataProvider*) providerWithModel:(NowPlayingModel*) model {
    return [[[UnitedKingdomDataProvider alloc] initWithModel:model] autorelease];
}


- (NSString*) providerFolder {
    return [[Application dataFolder] stringByAppendingPathComponent:@"UnitedKingdom"];
}


- (NSString*) displayName {
    return @"United Kingdom";
}


- (Movie*) processFilm:(XmlElement*) filmElement {
    NSString* identifier = [filmElement element:@"film_uid"].text;
    NSString* title      = [filmElement element:@"film_title"].text;
    NSString* synopsis   = [filmElement element:@"film_url"].text;

    return [Movie movieWithIdentifier:identifier
                                title:title
                               rating:@"NR"
                               length:0
                          releaseDate:nil
                               poster:@""
                             synopsis:synopsis
                               studio:@""
                            directors:[NSArray array]
                                 cast:[NSArray array]
                               genres:[NSArray array]];
}


- (NSMutableArray*) processFilms:(XmlElement*) filmsElement {
    NSMutableArray* result = [NSMutableArray array];

    for (XmlElement* child in filmsElement.children) {
        Movie* movie = [self processFilm:child];
        if (movie != nil) {
            [result addObject:movie];
        }
    }

    return result;
}


- (NSMutableArray*) processVenues:(XmlElement*) venuesElement {
    return nil;
}


- (NSMutableDictionary*) processScreenings:(XmlElement*) screeningsElement {
    return nil;
}


- (LookupResult*) lookupWorker {
    XmlElement* filmsElement      = [XmlParser parseUrl:@"http://www.remotegoat.co.uk/f/11013/films.xml"];
    XmlElement* venuesElement     = [Utilities downloadXml:@"http://www.remotegoat.co.uk/f/11013/films_venues.xml"];
    XmlElement* screeningsElement = [Utilities downloadXml:@"http://www.remotegoat.co.uk/f/11013/films_screenings_today.xml"];

    //XmlElement* filmsElement      = [Utilities downloadXml:@"http://www.remotegoat.co.uk/f/11013/films.xml"];
    //XmlElement* venuesElement     = [Utilities downloadXml:@"http://www.remotegoat.co.uk/f/11013/films_venues.xml"];
    //XmlElement* screeningsElement = [Utilities downloadXml:@"http://www.remotegoat.co.uk/f/11013/films_screenings_today.xml"];

    NSMutableArray* movies_            = [self processFilms:filmsElement];
    NSMutableArray* theaters_          = [self processVenues:venuesElement];
    NSMutableDictionary* performances_ = [self processScreenings:screeningsElement];

    return [LookupResult resultWithMovies:movies_
                                 theaters:theaters_
                             performances:performances_];
}


- (NSString*) ticketingUrlForTheater:(Theater*) theater
                               movie:(Movie*) movie
                         performance:(Performance*) performance
                                date:(NSDate*) date {
    return nil;
}


@end