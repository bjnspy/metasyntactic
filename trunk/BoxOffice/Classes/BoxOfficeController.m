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
#import "IgnyteTheaterDownloader.h"
#import "FandangoTheaterDownloader.h"

@implementation BoxOfficeController

@synthesize movieLookupLock;
@synthesize theaterLookupLock;
@synthesize ticketLookupLock;

- (void) dealloc {
    self.movieLookupLock = nil;
    self.theaterLookupLock = nil;
    self.ticketLookupLock = nil;
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
    
    // same day, check if they're at least 4 hours apart.
    if ([nowDateComponents hour] >= ([lastDateComponents hour] + 4)) {
        return NO;
    }
    
    // it's been less than 4 hours.  it's too soon to refresh
    return YES;
}

- (void) spawnMovieLookupThread {
    if ([self tooSoon:[self.model lastMoviesUpdateTime]]) {
        return;
    }
    
    [self onBackgroundTaskStarted:NSLocalizedString(@"Downloading movie list", nil)];
    [self performSelectorInBackground:@selector(lookupMoviesBackgroundThreadEntryPoint:) withObject:nil];
}

- (void) spawnTheaterLookupThread {
    if ([Utilities isNilOrEmpty:self.model.zipcode]) {
        return;
    }
    
    if ([self tooSoon:[self.model lastTheatersUpdateTime]]) {
        return;
    }
    
    [self onBackgroundTaskStarted:NSLocalizedString(@"Downloading theater list", nil)];
    [self performSelectorInBackground:@selector(lookupTheatersBackgroundThreadEntryPoint:) withObject:nil];
}

- (void) spawnTicketLookupThread {
    if ([Utilities isNilOrEmpty:self.model.zipcode]) {
        return;
    }
    
    if ([self tooSoon:[self.model lastTicketsUpdateTime]]) {
        return;
    }
    
    [self onBackgroundTaskStarted:NSLocalizedString(@"Downloading ticketing data", nil)];
    [self performSelectorInBackground:@selector(lookupTicketsBackgroundThreadEntryPoint:) withObject:nil];
}

- (void) spawnBackgroundThreads {
    [self spawnMovieLookupThread];
    [self spawnTheaterLookupThread];
    [self spawnTicketLookupThread];
}

- (id) initWithAppDelegate:(BoxOfficeAppDelegate*) appDelegate_ {
    if (self = [super init]) {
        appDelegate = appDelegate_;
        self.movieLookupLock = [[[NSLock alloc] init] autorelease];
        self.theaterLookupLock = [[[NSLock alloc] init] autorelease];
        self.ticketLookupLock = [[[NSLock alloc] init] autorelease];
        
        [self spawnBackgroundThreads];
    }
    
    return self;
}

+ (BoxOfficeController*) controllerWithAppDelegate:(BoxOfficeAppDelegate*) appDelegate {
    return [[[BoxOfficeController alloc] initWithAppDelegate:appDelegate] autorelease];
}

- (NSArray*) lookupMovies {
    NSURL* url = [NSURL URLWithString:@"http://i.rottentomatoes.com/syndication/tab/in_theaters.txt"];
    NSError* httpError = nil;
    NSString* inTheaters = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&httpError];
    
    if (httpError == nil && inTheaters != nil) {    
        NSArray* rows = [inTheaters componentsSeparatedByString:@"\n"];
        NSMutableArray* movies = [NSMutableArray array];
        
        // first row are the column headers.  last row is empty.  skip both.
        for (NSInteger i = 1; i < [rows count] - 1; i++) {   
            NSArray* columns = [[rows objectAtIndex:i] componentsSeparatedByString:@"\t"];
            
            if ([columns count] >= 9) {
                Movie* movie = [Movie movieWithTitle:[columns objectAtIndex:1]
                                                link:[columns objectAtIndex:2]
                                            synopsis:[columns objectAtIndex:8]
                                              rating:[columns objectAtIndex:3]];
                [movies addObject:movie];
            }
        }
        
        return movies;
    }
    
    return nil;
}

- (void) lookupMoviesBackgroundThreadEntryPoint:(id) anObject {
    [self.movieLookupLock lock];
    {    
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
        
        NSArray* movies = [self lookupMovies];
        [self performSelectorOnMainThread:@selector(setMovies:) withObject:movies waitUntilDone:NO];
        
        [autoreleasePool release];
    }
    [self.movieLookupLock unlock];
}

- (BOOL) areEqual:(NSArray*) movies1
           movies:(NSArray*) movies2 {
    if (movies1 == nil || movies2 == nil) {
        return NO;
    }
    
    NSSet* set1 = [NSSet setWithArray:movies1];
    NSSet* set2 = [NSSet setWithArray:movies2];
    
    return [set1 isEqualToSet:set2];
}

- (void) onBackgroundTaskEnded:(NSString*) description {
    [self.model removeBackgroundTask:description];
    [appDelegate.tabBarController refresh];    
}

- (void) setMovies:(NSArray*) movies {
    if ([movies count] > 0) {
        if (![self areEqual:movies movies:[self.model movies]]) {
            [self.model setMovies:movies];
        }
    }
    
    [self onBackgroundTaskEnded:NSLocalizedString(@"Finished downloading movie list", nil)];
}

- (BOOL) areEqual:(NSArray*) theaters1
         theaters:(NSArray*) theaters2 {
    if (theaters1 == nil || theaters2 == nil) {
        return NO;
    }
    
    NSSet* set1 = [NSSet setWithArray:theaters1];
    NSSet* set2 = [NSSet setWithArray:theaters2];
    
    return [set1 isEqualToSet:set2];
}

- (void) setTheaters:(NSArray*) theaters {
    if ([theaters count] > 0) {
        if (![self areEqual:theaters theaters:[self.model theaters]]) {
            [self.model setTheaters:theaters];
        }
    }
    
    [self onBackgroundTaskEnded:NSLocalizedString(@"Finished downloading theater list", nil)];
}

- (NSArray*) lookupTheaters {
    if ([Utilities isNilOrEmpty:self.model.zipcode]) {
        return nil;
    }
    
    NSArray* theaters;
    
    theaters = [FandangoTheaterDownloader download:self.model.zipcode];
    if (theaters != nil) {
        return theaters;
    }
    
    theaters = [IgnyteTheaterDownloader download:self.model.zipcode];
    if (theaters != nil) {
        return theaters;
    }
    
    return nil;
}

- (void) lookupTheatersBackgroundThreadEntryPoint:(id) anObject {    
    [self.theaterLookupLock lock];
    {
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
        
        NSArray* theaters = [self lookupTheaters];
        [self performSelectorOnMainThread:@selector(setTheaters:) withObject:theaters waitUntilDone:NO];

        [autoreleasePool release];
    }
    [self.theaterLookupLock unlock];
}

- (XmlElement*) lookupTickets {
    if ([Utilities isNilOrEmpty:self.model.zipcode]) {
        return nil;
    }
    
    NSString* urlString = [NSString stringWithFormat:@"http://www.fandango.com/frdi/?pid=A99D3D1A-774C-49149E&op=performancesbypostalcodesearch&verbosity=1&postalcode=%@", self.model.zipcode];
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSError* httpError = nil;
    NSURLResponse* response;
    NSData* ticketData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url]
                                               returningResponse:&response
                                                           error:&httpError];
    
    if (httpError == nil && ticketData != nil) {
        return [XmlParser parse:ticketData];
    }    
    
    return nil;
}

- (BOOL) areEqual:(XmlElement*) tickets1
          tickets:(XmlElement*) tickets2 {
    if (tickets1 == nil || tickets2 == nil) {
        return NO;
    }
    
    NSString* s1 = [XmlSerializer serializeElement:tickets1];
    NSString* s2 = [XmlSerializer serializeElement:tickets2];
    
    return [s1 isEqual:s2];
}

- (void) setTickets:(XmlElement*) tickets {
    if (tickets != nil) {
        if (![self areEqual:tickets tickets:[self.model tickets]]) {
            [self.model setTickets:tickets];
        }
    }
    
    [self onBackgroundTaskEnded:NSLocalizedString(@"Finished downloading ticketing data", nil)];
}

- (void) lookupTicketsBackgroundThreadEntryPoint:(id) anObject {    
    [self.theaterLookupLock lock];
    {
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
        
        XmlElement* element = [self lookupTickets];
        [self performSelectorOnMainThread:@selector(setTickets:) withObject:element waitUntilDone:NO];

        [autoreleasePool release];
    }
    [self.theaterLookupLock unlock];
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