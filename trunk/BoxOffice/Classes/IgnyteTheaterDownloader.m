//
//  IgnyteTheaterDownloader.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/14/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "IgnyteTheaterDownloader.h"

#import "XmlElement.h"
#import "XmlParser.h"
#import "Theater.h"
#import "XmlDocument.h"
#import "XmlSerializer.h"

@implementation IgnyteTheaterDownloader

+ (NSDictionary*) processMoviesElement:(XmlElement*) moviesElement {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    
    for (XmlElement* movieElement in moviesElement.children) {
        XmlElement* nameElement = [movieElement element:@"Name"];
        XmlElement* showtimesElement = [movieElement element:@"ShowTimes"];
        
        
        [dictionary setValue:[showtimesElement.text componentsSeparatedByString:@" | "]
                      forKey:nameElement.text];
    }
    
    return dictionary;
}

+ (Theater*) processTheaterElement:(XmlElement*) theaterElement {
    XmlElement* nameElement = [theaterElement element:@"Name"];
    XmlElement* addressElement = [theaterElement element:@"Address"];
    XmlElement* moviesElement = [theaterElement element:@"Movies"];
    NSDictionary* moviesToShowtimeMap = [self processMoviesElement:moviesElement];
    
    NSDictionary* preparedShowtimes = [Theater prepareShowtimesMap:moviesToShowtimeMap];
    Theater* theater = [Theater theaterWithName:nameElement.text
                                        address:addressElement.text
                                    phoneNumber:nil
                            movieToShowtimesMap:preparedShowtimes];
    
    return theater;
}

+ (NSArray*) download:(NSString*) zipcode {
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
                                           text:zipcode],
                                          [XmlElement
                                           elementWithName:@"radius"
                                           attributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                        @"xsd:int", @"xsi:type", nil]
                                           text:@"50"], nil]]]]]]]];
    
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
        NSString* value = [[[NSString alloc] initWithData:result encoding:NSASCIIStringEncoding] autorelease];
        NSLog(@"", value);
        
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

@end
