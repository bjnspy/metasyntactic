//
//  PosterDownloader.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PosterDownloader.h"
#import "XmlParser.h"
#import "XmlElement.h"
#import "DifferenceEngine.h"
#import "XmlSerializer.h"

@implementation PosterDownloader

@synthesize movie;
@synthesize identifiers;
@synthesize titleToPosterUrlMap;

- (id) initWithMovie:(Movie*) movie_
{
    if (self = [super init])
    {
        self.movie = movie_;
        self.identifiers = [NSMutableArray array];
        self.titleToPosterUrlMap = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void) dealloc
{
    self.movie = nil;
    self.identifiers = nil;
    self.titleToPosterUrlMap = nil;
    [super dealloc];
}

+ (NSData*) download:(Movie*) movie
{
    PosterDownloader* downloader = [[[PosterDownloader alloc] initWithMovie:movie] autorelease];
    return [downloader go];
}

- (void) sleep
{
    [NSThread sleepForTimeInterval:0.25];
}

- (NSData*) go
{
    [self searchForItems];
    [self sleep];
    [self lookupItems];
    [self sleep];
    return [self downloadBestPoster:[self findBestTitle]];
}

- (void) searchForItems
{
    XmlElement* element =
        [XmlElement elementWithName:
            @"s:Envelope"
            attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                @"http://schemas.xmlsoap.org/soap/envelope/", @"xmlns:s", nil]
            children:[NSArray arrayWithObject:
                [XmlElement elementWithName:
                    @"s:Body"
                    attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                        @"http://www.w3.org/2001/XMLSchema-instance", @"xmlns:xsi",
                        @"http://www.w3.org/2001/XMLSchema", @"xmlns:xsd", nil]
                    children:[NSArray arrayWithObject:[XmlElement elementWithName:
                        @"ItemSearch"
                        attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                            @"http://webservices.amazon.com/AWSECommerceService/2008-04-07", @"xmlns", nil]
                        children:[NSArray arrayWithObjects:
                            [XmlElement elementWithName:@"AWSAccessKeyId" text:@"1RRVC0BHDPKTXB98FCR2"],
                            [XmlElement elementWithName:@"AssociateTag" text:@"cyrusnajma-20"],
                            [XmlElement elementWithName:@"Request" children:[NSArray arrayWithObjects:
                                [XmlElement elementWithName:@"SearchIndex" text:@"DVD"],
                                [XmlElement elementWithName:@"Title" text:self.movie.title], nil]],
                            [XmlElement elementWithName:@"Request" children:[NSArray arrayWithObjects:
                                [XmlElement elementWithName:@"SearchIndex" text:@"All"],
                                [XmlElement elementWithName:@"Keywords" text:self.movie.title], nil]], nil]]]]]];
 
    NSString* post = [XmlSerializer serializeElement:element];

    NSData* postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:@"http://soap.amazon.com/onca/soap?Service=AWSECommerceService"]];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"http://soap.amazon.com" forHTTPHeaderField:@"Soapaction"];
    [request setValue:@"soap.amazon.com" forHTTPHeaderField:@"Host"];
    
    [request setHTTPBody:postData];    
    
    NSURLResponse* response = nil;
    NSError* error = nil;
    NSData* result =
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&response
                                      error:&error];
    if (error != nil || result == nil)
    {
        return;
    }
    
    XmlElement* envelopeElement = [XmlParser parse:result];
    XmlElement* bodyElement = [envelopeElement element:@"SOAP-ENV:Body"];
    XmlElement* responseElement = [bodyElement element:@"ItemSearchResponse"];
    XmlElement* itemsElement = [responseElement element:@"Items"];
    
    for (XmlElement* child in [itemsElement elements:@"Item"])
    {
        [identifiers addObject:[[child element:@"ASIN"] text]];
    }
}

- (void) lookupItems
{
    if ([identifiers count] % 2 == 1)
    {
        [identifiers addObject:@""];
    }
    
    for (NSInteger i = 0; i < [identifiers count]; i += 2)
    {
        [self lookupItem1:[identifiers objectAtIndex:i] item2:[identifiers objectAtIndex:(i + 1)]];
        [self sleep];
    }
}

- (void) addRequestItem:(NSString*) item
               elements:(NSMutableArray*) elements
{
    if (![@"" isEqual:item])
    {
        XmlElement* element = [XmlElement elementWithName:@"Request" children:[NSArray arrayWithObjects:
                                  [XmlElement elementWithName:@"ItemId" text:item],
                                  [XmlElement elementWithName:@"ResponseGroup" text:@"Images"],
                                  [XmlElement elementWithName:@"ResponseGroup" text:@"ItemAttributes"], nil]];

        [elements addObject:element];
    }
}

- (void) lookupItem1:(NSString*) item1
               item2:(NSString*) item2
{
    NSMutableArray* requestElements = [NSMutableArray array];
    
    [requestElements addObject:[XmlElement elementWithName:@"AWSAccessKeyId" text:@"1RRVC0BHDPKTXB98FCR2"]];
    [requestElements addObject:[XmlElement elementWithName:@"AssociateTag" text:@"cyrusnajma-20"]];
    
    [self addRequestItem:item1 elements:requestElements];
    [self addRequestItem:item2 elements:requestElements];
    
    XmlElement* element =
        [XmlElement elementWithName:
            @"s:Envelope"
            attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                @"http://schemas.xmlsoap.org/soap/envelope/", @"xmlns:s", nil]
            children:[NSArray arrayWithObject:
                [XmlElement elementWithName:
                    @"s:Body"
                    attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                        @"http://www.w3.org/2001/XMLSchema-instance", @"xmlns:xsi",
                        @"http://www.w3.org/2001/XMLSchema", @"xmlns:xsd", nil]
                    children:[NSArray arrayWithObject:[XmlElement elementWithName:
                        @"ItemLookup"
                        attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                            @"http://webservices.amazon.com/AWSECommerceService/2008-04-07", @"xmlns", nil]
                        children:requestElements]]]]];
                        
    NSString* post = [XmlSerializer serializeElement:element];
    
    NSData* postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:@"http://soap.amazon.com/onca/soap?Service=AWSECommerceService"]];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"http://soap.amazon.com" forHTTPHeaderField:@"Soapaction"];
    [request setValue:@"soap.amazon.com" forHTTPHeaderField:@"Host"];
    
    [request setHTTPBody:postData];    
    
    NSURLResponse* response = nil;
    NSError* error = nil;
    NSData* result =
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&response
                                      error:&error];
    if (error != nil || result == nil)
    {
        return;
    }
    
    XmlElement* envelopeElement = [XmlParser parse:result];
    XmlElement* bodyElement = [envelopeElement element:@"SOAP-ENV:Body"];
    XmlElement* responseElement = [bodyElement element:@"ItemLookupResponse"];
    XmlElement* itemsElement = [responseElement element:@"Items"];
    
    for (XmlElement* child in [itemsElement elements:@"Item"])
    {
        XmlElement* mediumImageElement = [child element:@"MediumImage"];
        XmlElement* urlElement = [mediumImageElement element:@"URL"];
        XmlElement* attributesElement = [child element:@"ItemAttributes"];
        XmlElement* titleElement = [attributesElement element:@"Title"];
        
        NSString* posterUrl = [urlElement text];
        NSString* title = [titleElement text];
        
        if (posterUrl != nil && title != nil)
        {
            [self.titleToPosterUrlMap setValue:posterUrl forKey:title];
        }
    }    
}

NSInteger titleSort(id t1, id t2, void *context)
{
    NSString* title1 = t1;
    NSString* title2 = t2;
    NSString* movieTitle = context;
    
    //NSString* trimmed1 = [title1 stringByTrimmingCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]];
    //NSString* trimmed2 = [title2 stringByTrimmingCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]];

    NSString* trimmed1 = [title1 stringByTrimmingCharactersInSet:[NSCharacterSet alphanumericCharacterSet]];
    NSString* trimmed2 = [title2 stringByTrimmingCharactersInSet:[NSCharacterSet alphanumericCharacterSet]];

    
    NSInteger editDistance1 = [[[[DifferenceEngine alloc] init] autorelease] editDistanceFrom:trimmed1 to:movieTitle];
    NSInteger editDistance2 = [[[[DifferenceEngine alloc] init] autorelease] editDistanceFrom:trimmed2 to:movieTitle];
    
    return editDistance1 - editDistance2;
}

- (NSString*) findBestTitle
{
    NSArray* keys = [self.titleToPosterUrlMap allKeys];
    NSArray* sortedKeys = [keys sortedArrayUsingFunction:titleSort context:self.movie.title];
    
    if ([sortedKeys count] == 0)
    {
        return nil;
    }
    
    return [sortedKeys objectAtIndex:0];
}

- (NSData*) downloadBestPoster:(NSString*) title
{
    if (title == nil)
    {
        return nil;
    }
    
    NSURL* url = [NSURL URLWithString:[self.titleToPosterUrlMap objectForKey:title]];
    return [NSData dataWithContentsOfURL:url];
}


@end
