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

@implementation BoxOfficeController

@synthesize appDelegate;
@synthesize movieLookupLock;
@synthesize theaterLookupLock;

- (void) spawnMovieLookupThread
{
    [self performSelectorInBackground:@selector(lookupMoviesBackgroundThreadEntryPoint:) withObject:nil];
}

- (void) spawnTheaterLookupThread
{
    [self performSelectorInBackground:@selector(lookupTheatersBackgroundThreadEntryPoint:) withObject:nil];
}

- (void) spawnBackgroundThreads
{
    NSLog(@"BoxOfficeController:spawnBackgroundThreads");
    
    [self spawnMovieLookupThread];
    [self spawnTheaterLookupThread];
}

- (id) initWithAppDelegate:(BoxOfficeAppDelegate*) appDel
{
    if (self = [super init])
    {
        self.appDelegate = appDel;
        self.movieLookupLock = [[[NSLock alloc] init] autorelease];
        self.theaterLookupLock = [[[NSLock alloc] init] autorelease];
        
        [self spawnBackgroundThreads];
    }
    
    return self;
}

- (void) dealloc
{
    self.appDelegate = nil;
    self.movieLookupLock = nil;
    self.theaterLookupLock = nil;
    [super dealloc];
}

- (BoxOfficeModel*) model
{
    return self.appDelegate.model;
}

- (void) lookupMovies
{
    NSLog(@"BoxOfficeController:lookupMovies");
    
    NSURL* url = [NSURL URLWithString:@"http://i.rottentomatoes.com/syndication/tab/in_theaters.txt"];
    NSError* httpError = nil;
    NSString* inTheaters = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&httpError];
    
    if (httpError == nil && inTheaters != nil)
    {    
        NSArray* rows = [inTheaters componentsSeparatedByString:@"\n"];
        NSMutableArray* movies = [NSMutableArray array];
        
        // first row are the column headers.  last row is empty.  skip both.
        for (NSInteger i = 1; i < [rows count] - 1; i++)
        {   
            NSArray* columns = [[rows objectAtIndex:i] componentsSeparatedByString:@"\t"];
            if ([columns count] >= 9)
            {
                Movie* movie = [Movie movieWithTitle:[columns objectAtIndex:1]
                                                link:[columns objectAtIndex:2]
                                            synopsis:[columns objectAtIndex:8]
                                              rating:[columns objectAtIndex:3]];
                [movies addObject:movie];
            }
        }
        
        [self performSelectorOnMainThread:@selector(setMovies:) withObject:movies waitUntilDone:NO];
    }
}


- (void) lookupMoviesBackgroundThreadEntryPoint:(id) anObject
{	
    NSLog(@"BoxOfficeController:lookupMoviesBackgroundThreadEntryPoint");
    [self.movieLookupLock lock];
    {    
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
        
        [self lookupMovies];
        
        [autoreleasePool release];
    }
    [self.movieLookupLock unlock];
}

- (BOOL) areEqual:(NSArray*) movies1
           movies:(NSArray*) movies2
{
    NSSet* set1 = [NSSet setWithArray:movies1];
    NSSet* set2 = [NSSet setWithArray:movies2];
    
    return [set1 isEqualToSet:set2];
}

- (void) setMovies:(NSArray*) movies
{
    if (movies == nil)
    {
        return;
    }
    
    if ([self areEqual:movies movies:[self.model movies]])
    {
        return;
    }
    
    [self.model setMovies:movies];
    [self.appDelegate.tabBarController.moviesNavigationController refresh];
}

- (NSDictionary*) processMoviesElement:(XmlElement*) moviesElement
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    
    for (XmlElement* movieElement in moviesElement.children)
    {
        XmlElement* nameElement = [movieElement element:@"Name"];
        XmlElement* showtimesElement = [movieElement element:@"ShowTimes"];
        
        NSMutableArray* array = [NSMutableArray array];
        
        for (NSString* showtime in [showtimesElement.text componentsSeparatedByString:@" | "])
        {
            [array addObject:showtime];
        }
        
        [dictionary setValue:array forKey:nameElement.text];
    }
    
    return dictionary;
}

- (Theater*) processTheaterElement:(XmlElement*) theaterElement
{
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
         theaters:(NSArray*) theaters2
{
    NSSet* set1 = [NSSet setWithArray:theaters1];
    NSSet* set2 = [NSSet setWithArray:theaters2];
    
    return [set1 isEqualToSet:set2];
}

- (void) setTheaters:(NSArray*) theaters
{
    if (theaters == nil)
    {
        return;
    }
    
    if ([self areEqual:theaters theaters:[self.model theaters]])
    {
        return;
    }
    
    [self.model setTheaters:theaters];
    [self.appDelegate.tabBarController.theatersNavigationController refresh];
}

- (void) lookupTheaters
{   
    NSLog(@"Looking up theaters");
    
    NSString* zipCode = @"10009";
    NSString* radius = @"5";
    
	NSString* post =
    [XmlSerializer serializeDocument: 
     [XmlDocument documentWithRoot:
      [XmlElement elementWithName:@"SOAP-ENV:Envelope" 
                       attributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"http://www.w3.org/2001/XMLSchema", @"xmlns:xsd",
                                    @"http://www.w3.org/2001/XMLSchema-instance", @"xmlns:xsi",
                                    @"http://schemas.xmlsoap.org/soap/encoding/", @"xmlns:SOAP-ENC",
                                    @"http://schemas.xmlsoap.org/soap/encoding/", @"SOAP-ENV:encodingStyle",
                                    @"http://schemas.xmlsoap.org/soap/envelope/", @"xmlns:SOAP-ENV", nil]
                         children: [NSArray arrayWithObject:
                                    [XmlElement elementWithName:@"SOAP-ENV:Body" 
                                                       children: [NSArray arrayWithObject:
                                                                  [XmlElement elementWithName:@"GetTheatersAndMovies"
                                                                                   attributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                @"http://www.ignyte.com/whatsshowing", @"xmlns", nil]
                                                                                     children: [NSArray arrayWithObjects:
                                                                                                [XmlElement elementWithName:@"zipCode"
                                                                                                                 attributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                                              @"xsd:string", @"xsi:type", nil]
                                                                                                                       text:zipCode],
                                                                                                [XmlElement elementWithName:@"radius"
                                                                                                                 attributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                                              @"xsd:int", @"xsi:type", nil]
                                                                                                                       text:radius], nil]]]]]]]];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:@"http://www.ignyte.com/webservices/ignyte.whatsshowing.webservice/moviefunctions.asmx"]];
    [request setHTTPMethod:@"POST"];
//    [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    
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
    if (error == nil && result != nil)
    {
        XmlElement* envelopeElement = [XmlParser parse:result];
        XmlElement* bodyElement = [envelopeElement.children objectAtIndex:0];
        XmlElement* responseElement = [bodyElement.children objectAtIndex:0];
        XmlElement* resultElement = [responseElement.children objectAtIndex:0];
        NSMutableArray* theaters = [NSMutableArray array];
        
        for (XmlElement* theaterElement in resultElement.children)
        {
            [theaters addObject:[self processTheaterElement:theaterElement]];
        }
        
        [self setTheaters:theaters];
    }
}

- (void) lookupTheatersBackgroundThreadEntryPoint:(id) anObject
{	
    [self.theaterLookupLock lock];
    {
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
        
        [self lookupTheaters];
        
        [autoreleasePool release];
    }
    [self.theaterLookupLock unlock];
}

@end
