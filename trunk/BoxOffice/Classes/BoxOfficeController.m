//
//  BoxOfficeController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
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

- (void) spawnMovieLookupThread {
	[self onBackgroundTaskStarted:@"Downloading Movie List"];
    [self performSelectorInBackground:@selector(lookupMoviesBackgroundThreadEntryPoint:) withObject:nil];
}

- (void) spawnTheaterLookupThread {
    if ([Utilities isNilOrEmpty:self.model.zipcode]) {
        return;
    }
	
	[self onBackgroundTaskStarted:@"Downloading Theater List"];
    [self performSelectorInBackground:@selector(lookupTheatersBackgroundThreadEntryPoint:) withObject:nil];
}

- (void) spawnTicketLookupThread {
    if ([Utilities isNilOrEmpty:self.model.zipcode]) {
        return;
    }
	
	[self onBackgroundTaskStarted:@"Downloading Ticketing Data"];
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
	if (movies != nil) {
		if (![self areEqual:movies movies:[self.model movies]]) {
			[self.model setMovies:movies];
		}
	}
    
	[self onBackgroundTaskEnded:@"Finished Downloading Movie List"];
}

- (NSDictionary*) processMoviesElement:(XmlElement*) moviesElement {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    
    for (XmlElement* movieElement in moviesElement.children) {
        XmlElement* nameElement = [movieElement element:@"Name"];
        XmlElement* showtimesElement = [movieElement element:@"ShowTimes"];
        
        [dictionary setValue:[showtimesElement.text componentsSeparatedByString:@" | "]
                      forKey:nameElement.text];
    }
    
    return dictionary;
}

- (Theater*) processTheaterElement:(XmlElement*) theaterElement {
    XmlElement* nameElement = [theaterElement element:@"Name"];
    XmlElement* addressElement = [theaterElement element:@"Address"];
    XmlElement* moviesElement = [theaterElement element:@"Movies"];
    NSDictionary* moviesToShowtimeMap = [self processMoviesElement:moviesElement];
    
    Theater* theater = [Theater theaterWithName:nameElement.text
                                        address:addressElement.text
                            movieToShowtimesMap:moviesToShowtimeMap];
    
    return theater;
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
	if (theaters != nil) {
		if (![self areEqual:theaters theaters:[self.model theaters]]) {
			[self.model setTheaters:theaters];
		}
	}
    
	[self onBackgroundTaskEnded:@"Finished Downloading Theater List"];
}

- (NSArray*) lookupTheaters {
    if ([Utilities isNilOrEmpty:self.model.zipcode]) {
        return nil;
    }
    
    NSString* zipCode = self.model.zipcode;
    NSString* radius = [NSString stringWithFormat:@"%d", self.model.searchRadius];
    
    NSString* post =
    [XmlSerializer serializeDocument: 
     [XmlDocument documentWithRoot:
      [XmlElement
       elementWithName:@"SOAP-ENV:Envelope" 
       attributes: [NSDictionary dictionaryWithObjectsAndKeys:
                    @"http://www.w3.org/2001/XMLSchema", @"xmlns:xsd",
                    @"http://www.w3.org/2001/XMLSchema-instance", @"xmlns:xsi",
                    @"http://schemas.xmlsoap.org/soap/encoding/", @"xmlns:SOAP-ENC",
                    @"http://schemas.xmlsoap.org/soap/encoding/", @"SOAP-ENV:encodingStyle",
                    @"http://schemas.xmlsoap.org/soap/envelope/", @"xmlns:SOAP-ENV", nil]
       children: [NSArray arrayWithObject:
                  [XmlElement
                   elementWithName:@"SOAP-ENV:Body" 
                   children: [NSArray arrayWithObject:
                              [XmlElement
                               elementWithName:@"GetTheatersAndMovies"
                               attributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                            @"http://www.ignyte.com/whatsshowing", @"xmlns", nil]
                               children: [NSArray arrayWithObjects:
                                          [XmlElement
                                           elementWithName:@"zipCode"
                                           attributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                        @"xsd:string", @"xsi:type", nil]
                                           text:zipCode],
                                          [XmlElement
                                           elementWithName:@"radius"
                                           attributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                        @"xsd:int", @"xsi:type", nil]
                                           text:radius], nil]]]]]]]];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:@"http://www.ignyte.com/webservices/ignyte.whatsshowing.webservice/moviefunctions.asmx"]];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"http://www.ignyte.com/whatsshowing/GetTheatersAndMovies" forHTTPHeaderField:@"Soapaction"];
    [request setValue:@"www.ignyte.com" forHTTPHeaderField:@"Host"];
    
    [request setHTTPBody:postData];    
    
    NSURLResponse* response = nil;
    NSError* error = nil;
    NSData* result =
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&response
                                      error:&error];
    if (error == nil && result != nil) {
        XmlElement* envelopeElement = [XmlParser parse:result];
        XmlElement* bodyElement = [envelopeElement.children objectAtIndex:0];
        XmlElement* responseElement = [bodyElement.children objectAtIndex:0];
        XmlElement* resultElement = [responseElement.children objectAtIndex:0];
        
        NSMutableArray* theaters = [NSMutableArray array];
        
        for (XmlElement* theaterElement in resultElement.children) {
            [theaters addObject:[self processTheaterElement:theaterElement]];
        }
		
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
    
	[self onBackgroundTaskEnded:@"Finished Downloading Ticketing Data"];
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
    [self spawnBackgroundThreads];
    [appDelegate.tabBarController refresh];
}

@end