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

- (id) initWithMovie:(Movie*) movie_
{
    if (self = [super init])
    {
        self.movie = movie_;
    }
    
    return self;
}

- (void) dealloc
{
    self.movie = nil;
    [super dealloc];
}

+ (NSData*) download:(Movie*) movie
{
    PosterDownloader* downloader = [[[PosterDownloader alloc] initWithMovie:movie] autorelease];
    return [downloader go];
}

- (NSData*) go
{
    [self searchForItem];
    return nil;
}

- (void) searchForItem
{
    /*
     POST /onca/soap?Service=AWSECommerceService HTTP/1.1
     Content-Type: text/xml; charset=utf-8
     SOAPAction: "http://soap.amazon.com"
     Host: soap.amazon.com
     Content-Length: 604
     Expect: 100-continue
     
     <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><ItemSearch xmlns="http://webservices.amazon.com/AWSECommerceService/2008-04-07"><AWSAccessKeyId>1RRVC0BHDPKTXB98FCR2</AWSAccessKeyId><AssociateTag>cyrusnajma-20</AssociateTag><Request><SearchIndex>DVD</SearchIndex><Title>Dare Not Walk Alone: A War of Responsibility</Title></Request><Request><Keywords>Dare Not Walk Alone: A War of Responsibility</Keywords><SearchIndex>All</SearchIndex></Request></ItemSearch></s:Body></s:Envelope>
     */
    
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
    XmlElement* bodyElement = [envelopeElement element:@"SOAP-ENV:body"];
    XmlElement* responseElement = [bodyElement element:@"ItemSearchResponse"];
    XmlElement* itemsElement = [responseElement element:@"Items"];
    
    NSMutableArray* identifiers = [NSMutableArray array];
    
    
    NSString* desc = [envelopeElement description];
    NSLog(@"%@", desc);
    
    [NSThread sleepForTimeInterval:0.25];
}

@end
