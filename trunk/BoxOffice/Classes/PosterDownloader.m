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

@implementation PosterDownloader

@synthesize movie;
@synthesize identifiers;

- (id) initWithMovie:(Movie*) movie_
{
    if (self = [super init])
    {
        self.movie = movie_;
        self.identifiers = [NSMutableArray array];
    }
    
    return self;
}

- (void) dealloc
{
    self.movie = nil;
    self.identifiers = nil;
    [super dealloc];
}

+ (NSData*) download:(Movie*) movie
{
    PosterDownloader* downloader = [[[PosterDownloader alloc] initWithMovie:movie] autorelease];
    return [downloader go];
}

- (NSData*) go
{
    [self searchForItems];
    [self lookupItems];
    return nil;
}

- (void) searchForItems
{
    NSString* post =
    @"<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\">"
        "<s:Body xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
                "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">"
            "<ItemSearch xmlns=\"http://webservices.amazon.com/AWSECommerceService/2008-04-07\">"
                "<AWSAccessKeyId>1RRVC0BHDPKTXB98FCR2</AWSAccessKeyId>"
                "<AssociateTag>cyrusnajma-20</AssociateTag>"
                "<Request>"
                    "<SearchIndex>DVD</SearchIndex>"
                    "<Title>Juno</Title>"
                "</Request>"
                "<Request>"
                    "<Keywords>Juno</Keywords>"
                    "<SearchIndex>All</SearchIndex>"
                "</Request>"
            "</ItemSearch>"
        "</s:Body>"
    "</s:Envelope>";
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
    
    [NSThread sleepForTimeInterval:0.25];
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
    }
}

- (void) lookupItem1:(NSString*) item1
               item2:(NSString*) item2
{
    /*
     POST /onca/soap?Service=AWSECommerceService HTTP/1.1
     Content-Type: text/xml; charset=utf-8
     SOAPAction: "http://soap.amazon.com"
     Host: soap.amazon.com
     Content-Length: 638
     Expect: 100-continue
     */
    NSMutableString* post = 
    @"<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\">"
        "<s:Body xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\""
                "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">"
            "<ItemLookup xmlns=\"http://webservices.amazon.com/AWSECommerceService/2008-04-07\">"
                "<AWSAccessKeyId>1RRVC0BHDPKTXB98FCR2</AWSAccessKeyId>"
                "<AssociateTag>cyrusnajma-20</AssociateTag>"
                "<Request>"
                    "<ItemId>B000YABYLA</ItemId>"
                    "<ResponseGroup>Images</ResponseGroup>"
                    "<ResponseGroup>ItemAttributes</ResponseGroup>"
                "</Request>"
                "<Request>"
                    "<ItemId>B0014CQNTK</ItemId>"
                    "<ResponseGroup>Images</ResponseGroup>"
                    "<ResponseGroup>ItemAttributes</ResponseGroup>"
                "</Request>"
            "</ItemLookup>"
        "</s:Body>"
    "</s:Envelope>";

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
    NSString* desc = [envelopeElement description];
    
    NSLog(@"%@", desc);
}


@end
