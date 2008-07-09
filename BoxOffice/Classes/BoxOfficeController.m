//
//  BoxOfficeController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "BoxOfficeController.h"
#import "Movie.h"
#import "Theater.h"
#import "BoxOfficeAppDelegate.h"
#import "XmlParser.h"
#import "XmlDocument.h"
#import "XmlElement.h"
#import "XmlSerializer.h"
#import "Application.h"
#import "Utilities.h"
#import "ExtraMovieInformation.h"
#import "Performance.h"

@implementation BoxOfficeController

@synthesize quickLookupLock;
@synthesize fullLookupLock;

- (void) dealloc {
    self.quickLookupLock = nil;
    self.fullLookupLock = nil;
    [super dealloc];
}

- (BoxOfficeModel*) model {
    return appDelegate.model;
}

- (void) onBackgroundTaskStarted:(NSString*) description {
    [[self model] addBackgroundTask:description];
}

- (BOOL) tooSoon:(NSDate*) lastDate {
    if (lastDate == nil) {
        return NO;
    }
    
    NSDate* now = [NSDate date];
    NSDateComponents* lastDateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSHourCalendarUnit fromDate:lastDate];
    NSDateComponents* nowDateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSHourCalendarUnit fromDate:now];
    
    if ([lastDateComponents day] != [nowDateComponents day]) {
        // different days.  we definitely need to refresh
        return NO;
    }
    
    // same day, check if they're at least 8 hours apart.
    if ([nowDateComponents hour] >= ([lastDateComponents hour] + 8)) {
        return NO;
    }
    
    // it's been less than 4 hours.  it's too soon to refresh
    return YES;
}


- (void) spawnQuickLookupThread {
    if ([self tooSoon:[self.model lastQuickUpdateTime]]) {
        return;
    }
    
    [self onBackgroundTaskStarted:NSLocalizedString(@"Downloading movie list", nil)];
    [self performSelectorInBackground:@selector(quickLookupBackgroundThreadEntryPoint:) withObject:nil];
}

- (void) spawnFullLookupThread {
    if ([Utilities isNilOrEmpty:self.model.zipcode]) {
        return;
    }
    
    if ([self tooSoon:[self.model lastFullUpdateTime]]) {
        return;
    }
    
    [self onBackgroundTaskStarted:NSLocalizedString(@"Downloading ticketing data", nil)];
    [self performSelectorInBackground:@selector(fullLookupBackgroundThreadEntryPoint:) withObject:nil];
}

- (void) spawnBackgroundThreads {
    [self spawnQuickLookupThread];
    [self spawnFullLookupThread];
}

- (id) initWithAppDelegate:(BoxOfficeAppDelegate*) appDelegate_ {
    if (self = [super init]) {
        appDelegate = appDelegate_;
        self.quickLookupLock = [[[NSLock alloc] init] autorelease];
        self.fullLookupLock = [[[NSLock alloc] init] autorelease];
        
        [self spawnBackgroundThreads];
    }
    
    return self;
}

+ (BoxOfficeController*) controllerWithAppDelegate:(BoxOfficeAppDelegate*) appDelegate {
    return [[[BoxOfficeController alloc] initWithAppDelegate:appDelegate] autorelease];
}

- (NSDictionary*) quickLookup {
    NSURL* url = [NSURL URLWithString:@"http://metaboxoffice2.appspot.com/LookupMovieListings"];
    NSError* httpError = nil;
    NSString* inTheaters = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&httpError];
    
    if (httpError == nil && inTheaters != nil) {    
        NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
        
        NSArray* rows = [inTheaters componentsSeparatedByString:@"\n"];
        
        // first row are the column headers.  last row is empty.  skip both.
        for (NSInteger i = 1; i < [rows count] - 1; i++) {   
            NSArray* columns = [[rows objectAtIndex:i] componentsSeparatedByString:@"\t"];
            
            if ([columns count] >= 9) {
                ExtraMovieInformation* extraInfo = [ExtraMovieInformation infoWithLink:[columns objectAtIndex:2]
                                                                              synopsis:[columns objectAtIndex:8]
                                                                               ranking:[columns objectAtIndex:3]];
                
                NSString* title = [columns objectAtIndex:1];
                
                [dictionary setObject:extraInfo forKey:title];
            }
        }
        
        return dictionary;
    }
    
    return nil;
}

- (void) quickLookupBackgroundThreadEntryPoint:(id) anObject {
    [self.quickLookupLock lock];
    {    
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
        
        NSDictionary* extraInformation = [self quickLookup];
        [self performSelectorOnMainThread:@selector(setSupplementaryData:) withObject:extraInformation waitUntilDone:NO];
        
        [autoreleasePool release];
    }
    [self.quickLookupLock unlock];
}

- (void) onBackgroundTaskEnded:(NSString*) description {
    [self.model removeBackgroundTask:description];
    [appDelegate.tabBarController refresh];    
}

- (void) setSupplementaryData:(NSDictionary*) extraInfo {
    if ([extraInfo count] > 0) {
        [self.model setSupplementaryInformation:extraInfo];
    }
    
    [self onBackgroundTaskEnded:NSLocalizedString(@"Finished downloading movie list", nil)];
}

- (NSDictionary*) processShowtimes:(XmlElement*) moviesElement {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    
    for (XmlElement* movieElement in [moviesElement children]) {
        NSString* movieId = [movieElement attributeValue:@"id"];
        
        XmlElement* performancesElement = [movieElement element:@"performances"];
        
        NSMutableArray* performances = [NSMutableArray array];
        
        for (XmlElement* performanceElement in [performancesElement children]) {
            NSString* showId = [performanceElement attributeValue:@"showid"];
            NSString* time = [performanceElement attributeValue:@"showtime"];
            time = [Theater processShowtime:time];
            
            Performance* performance = [Performance performanceWithIdentifier:showId
                                                                         time:time];
            
            [performances addObject:performance];
        }
        
        [dictionary setObject:performances forKey:movieId];
    }
    
    return dictionary;
}

- (Theater*) processTheaterElement:(XmlElement*) theaterElement {
    NSString* identifier = [theaterElement attributeValue:@"id"];
    NSString* name = [[theaterElement element:@"name"] text];
    NSString* address = [[theaterElement element:@"address1"] text];
    NSString* city = [[theaterElement element:@"city"] text];
    NSString* state = [[theaterElement element:@"state"] text];
    NSString* zipcode = [[theaterElement element:@"postalcode"] text];
    NSString* phone = [[theaterElement element:@"phonenumber"] text];
    NSString* sellsTickets = [theaterElement attributeValue:@"iswired"];
    
    NSString* fullAddress;
    if ([address hasSuffix:@"."]) {
        fullAddress = [NSString stringWithFormat:@"%@ %@, %@ %@", address, city, state, zipcode];
    } else {
        fullAddress = [NSString stringWithFormat:@"%@. %@, %@ %@", address, city, state, zipcode];
    }
    
    XmlElement* moviesElement = [theaterElement element:@"movies"];
    NSDictionary* movieToShowtimesMap = [self processShowtimes:moviesElement];
    
    if ([movieToShowtimesMap count] == 0) {
        return nil;
    }
    
    return [Theater theaterWithIdentifier:identifier
                                     name:name
                                  address:fullAddress
                              phoneNumber:phone
                             sellsTickets:sellsTickets
                      movieToShowtimesMap:movieToShowtimesMap];
}

- (NSArray*) processTheatersElement:(XmlElement*) theatersElement {
    NSMutableArray* array = [NSMutableArray array];
    
    for (XmlElement* theaterElement in [theatersElement children]) {
        Theater* theater = [self processTheaterElement:theaterElement];
        
        if (theater != nil) {
            [array addObject:theater];
        }
    }
    
    return array;
}

- (NSArray*) processMoviesElement:(XmlElement*) moviesElement {
    NSMutableArray* array = [NSMutableArray array];
    
    for (XmlElement* movieElement in [moviesElement children]) {
        NSString* identifier = [movieElement attributeValue:@"id"];
        NSString* poster = [movieElement attributeValue:@"posterhref"];
        NSString* title = [[movieElement element:@"title"] text];
        NSString* rating = [[movieElement element:@"rating"] text];
        NSString* length = [[movieElement element:@"runtime"] text];
        NSString* synopsis = [[movieElement element:@"synopsis"] text];
    
        Movie* movie = [Movie movieWithIdentifier:identifier
                                            title:title
                                           rating:rating
                                           length:length
                                           poster:poster
                                   backupSynopsis:synopsis];
        
        [array addObject:movie];
    }
    
    return array;
}

- (NSArray*) processElement:(XmlElement*) element {
    XmlElement* dataElement = [element element:@"data"];
    XmlElement* moviesElement = [dataElement element:@"movies"];
    XmlElement* theatersElement = [dataElement element:@"theaters"];
    
    NSArray* theaters = [self processTheatersElement:theatersElement];
    NSArray* movies = [self processMoviesElement:moviesElement];
    
    return [NSArray arrayWithObjects:movies, theaters, nil];
}

- (NSArray*) fullLookup {
    if ([Utilities isNilOrEmpty:self.model.zipcode]) {
        return nil;
    }
    
    NSString* urlString = [NSString stringWithFormat:@"http://www.fandango.com/frdi/?pid=A99D3D1A-774C-49149E&op=performancesbypostalcodesearch&verbosity=1&postalcode=%@", self.model.zipcode];
    
    XmlElement* element = [Utilities downloadXml:urlString];
    
    NSArray* moviesAndTheaters = [self processElement:element];
    
    return moviesAndTheaters;
}

- (void) setMoviesAndTheaters:(NSArray*) moviesAndTheaters {
    [self.model setMovies:[moviesAndTheaters objectAtIndex:0]];
    [self.model setTheaters:[moviesAndTheaters objectAtIndex:1]];
    
    [self onBackgroundTaskEnded:NSLocalizedString(@"Finished downloading movie and theater data", nil)];
}

- (void) fullLookupBackgroundThreadEntryPoint:(id) anObject {    
    [self.fullLookupLock lock];
    {
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
        
        NSArray* moviesAndTheaters = [self fullLookup];
        [self performSelectorOnMainThread:@selector(setMoviesAndTheaters:) withObject:moviesAndTheaters waitUntilDone:NO];
        
        [autoreleasePool release];
    }
    [self.fullLookupLock unlock];
}

- (void) setZipcode:(NSString*) zipcode {
    [self.model setZipcode:zipcode];
    [self spawnBackgroundThreads];
    [appDelegate.tabBarController refresh];
}

- (void) setSearchRadius:(NSInteger) radius {
    [self.model setSearchRadius:radius];
    [appDelegate.tabBarController refresh];
}

@end