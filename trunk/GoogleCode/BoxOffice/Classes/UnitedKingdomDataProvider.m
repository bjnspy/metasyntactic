//
//  UnitedKingdomDataProvider.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/28/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "UnitedKingdomDataProvider.h"
#import "Application.h"
#import "XmlElement.h"
#import "Utilities.h"
#import "XmlParser.h"

@implementation UnitedKingdomDataProvider

+ (UnitedKingdomDataProvider*) providerWithModel:(BoxOfficeModel*) model {
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
                             synopsis:synopsis];
}

- (NSArray*) processFilms:(XmlElement*) filmsElement {
    NSMutableArray* result = [NSMutableArray array];
    
    for (XmlElement* child in filmsElement.children) {
        Movie* movie = [self processFilm:child];
        if (movie != nil) {
            [result addObject:movie];
        }
    }
    
    return result;
}

- (NSArray*) processVenues:(XmlElement*) venuesElement {
    return nil;
}

- (NSDictionary*) processScreenings:(XmlElement*) screeningsElement {
    return nil;
}

- (LookupResult*) lookupWorker {
    XmlElement* filmsElement      = [XmlParser parseUrl:@"http://www.remotegoat.co.uk/f/11013/films.xml"];
    XmlElement* venuesElement     = [Utilities downloadXml:@"http://www.remotegoat.co.uk/f/11013/films_venues.xml"];
    XmlElement* screeningsElement = [Utilities downloadXml:@"http://www.remotegoat.co.uk/f/11013/films_screenings_today.xml"];

    //XmlElement* filmsElement      = [Utilities downloadXml:@"http://www.remotegoat.co.uk/f/11013/films.xml"];
    //XmlElement* venuesElement     = [Utilities downloadXml:@"http://www.remotegoat.co.uk/f/11013/films_venues.xml"];
    //XmlElement* screeningsElement = [Utilities downloadXml:@"http://www.remotegoat.co.uk/f/11013/films_screenings_today.xml"];

    NSArray* movies_            = [self processFilms:filmsElement];
    NSArray* theaters_          = [self processVenues:venuesElement];
    NSDictionary* performances_ = [self processScreenings:screeningsElement];

    return [LookupResult resultWithMovies:movies_
                                 theaters:theaters_
                             performances:performances_];
}

@end
