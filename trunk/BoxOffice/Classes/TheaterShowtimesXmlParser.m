//
//  TheaterShowtimesXmlParser.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TheaterShowtimesXmlParser.h"
#import "Theater.h"
#import "Movie.h"

@implementation TheaterShowtimesXmlParser

@synthesize theaters;
@synthesize stringBuffer;
@synthesize theaterName;
@synthesize theaterAddress;
@synthesize movieName;
@synthesize showtimes;
@synthesize movieToShowtimeMap;

- (id) initWithData:(NSData*) data
{
    if (self = [super init])
    {
        NSXMLParser* parser = [[[NSXMLParser alloc] initWithData:data] autorelease];
        [parser setDelegate:self];
    
        self.theaters = [NSMutableArray array];
        self.stringBuffer = [NSMutableString string];
        self.movieToShowtimeMap = [NSMutableDictionary dictionary];
        self.showtimes = [NSMutableArray array];
        
        [parser parse];
    }
    
    return self;
}

- (void) dealloc
{
    self.theaters = nil;
    self.stringBuffer = nil;
    self.theaterName = nil;
    self.theaterAddress = nil;
    self.movieName = nil;
    self.showtimes = nil;
    self.movieToShowtimeMap = nil;
    [super dealloc];
}

- (void)        parser:(NSXMLParser*) parser
       didStartElement:(NSString*) elementName
          namespaceURI:(NSString*) namespaceURI
         qualifiedName:(NSString*) qName
            attributes:(NSDictionary*) attributeDict
{
    self.stringBuffer = [NSMutableString string]; 
}

- (void)        parser:(NSXMLParser*) parser
         didEndElement:(NSString*) elementName
          namespaceURI:(NSString*) namespaceURI
         qualifiedName:(NSString*) qName
{
    if ([elementName isEqual:@"ShowTimes"])
    {
        for (NSString* showtime in [self.stringBuffer componentsSeparatedByString:@" | "])
        {
            NSDate* date = [NSDate dateWithNaturalLanguageString:showtime];
            [self.showtimes addObject:date];
        }
        
        self.stringBuffer = [NSMutableString string];
    }
    else if ([elementName isEqual:@"Movie"])
    {
        [self.movieToShowtimeMap setValue:showtimes forKey:movieName];
        self.showtimes = [NSMutableArray array];
    }
    else if ([elementName isEqual:@"Address"])
    {
        self.theaterAddress = [NSString stringWithString:self.stringBuffer];
        self.stringBuffer = [NSMutableString string];
    }
    else if ([elementName isEqual:@"Name"])
    {
        if (self.theaterName == nil)
        {
            self.theaterName = [NSString stringWithString:self.stringBuffer];
            self.stringBuffer = [NSMutableString string];
        }
        else
        {
            self.movieName = [NSString stringWithString:self.stringBuffer];
            self.stringBuffer = [NSMutableString string];
        }
    }
    else if ([elementName isEqual:@"Theater"])
    {
        Theater* theater = [[Theater alloc] initWithName:self.theaterName
                                                 address:self.theaterAddress
                                     movieToShowtimesMap:self.movieToShowtimeMap];
        self.theaterName = nil;
        self.movieToShowtimeMap = [NSMutableDictionary dictionary];
        
        [self.theaters addObject:theater];
    }
}

- (void)        parser:(NSXMLParser*) parser
       foundCharacters:(NSString*) string
{
    [self.stringBuffer appendString:string];
}

@end
