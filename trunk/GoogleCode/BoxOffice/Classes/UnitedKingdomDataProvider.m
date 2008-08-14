// Copyright (c) 2008, Cyrus Najmabadi
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions are met:
//
//   Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
//
//   Redistributions in binary form must reproduce the above copyright notice, 
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
//   Neither the name 'Cyrus Najmabadi' nor the names of its contributors may be
//   used to endorse or promote products derived from this software without 
//   specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#import "UnitedKingdomDataProvider.h"

#import "Application.h"
#import "LookupResult.h"
#import "Movie.h"
#import "Utilities.h"
#import "XmlElement.h"
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
