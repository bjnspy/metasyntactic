//
//  TheaterLocationCache.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AddressLocationCache.h"
#import "XmlSerializer.h"
#import "XmlDocument.h"
#import "XmlElement.h"
#import "XmlParser.h"

@implementation AddressLocationCache

@synthesize gate;

+ (AddressLocationCache*) cache
{
    return [[[AddressLocationCache alloc] init] autorelease];
}

- (id) init
{
    if (self = [super init])
    {
        self.gate = [[[NSLock alloc] init] autorelease];
    }
    
    return self;
}

- (void) dealloc
{
    self.gate = nil;
    [super dealloc];
}

- (NSMutableDictionary*) addressLocationMap
{
    NSDictionary* dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"addressLocationMap"];
    if (dict == nil)
    {
        dict = [NSDictionary dictionary];
    }
    
    return [NSMutableDictionary dictionaryWithDictionary:dict];
}

- (void) setAddressLocationMap:(NSDictionary*) dictionary
{
    [[NSUserDefaults standardUserDefaults] setObject:dictionary forKey:@"addressLocationMap"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) update:(NSArray*) addresses
{
    [self performSelectorInBackground:@selector(backgroundEntryPoint:)
                           withObject:[NSArray arrayWithArray:addresses]];
}

- (Location*) downloadAddressLocationFromWebService:(NSString*) address
{
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
                                                                  [XmlElement elementWithName:@"m:geocode"
                                                                                   attributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                @"http://rpc.geocoder.us/Geo/Coder/US/", @"xmlns:m", nil]
                                                                                     children: [NSArray arrayWithObjects:
                                                                                                [XmlElement elementWithName:@"location"
                                                                                                                 attributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                                              @"xsd:string", @"xsi:type", nil]
                                                                                                                       text:address], nil]]]]]]]];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:@"http://rpc.geocoder.us/service/soap/"]];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"http://rpc.geocoder.us/Geo/Coder/US#geocode" forHTTPHeaderField:@"Soapaction"];
    [request setValue:@"rpc.geocoder.us" forHTTPHeaderField:@"Host"];
    
    [request setHTTPBody:postData];    
    
    NSURLResponse* response = nil;
    NSError* error = nil;
    NSData* result =
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&response
                                      error:&error];
    if (error == nil && result != nil)
    {
        
        /*
            <?xml version="1.0" encoding="UTF-8"?>
            <SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
                               xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" 
                               xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" 
                               xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                               SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
                <SOAP-ENV:Body>
                    <namesp24:geocodeResponse xmlns:namesp24="http://rpc.geocoder.us/Geo/Coder/US/">
                        <geo:s-gensym118 xsi:type="SOAP-ENC:Array" xmlns:geo="http://rpc.geocoder.us/Geo/Coder/US/" SOAP-ENC:arrayType="geo:GeocoderAddressResult[2]">
                            <item xsi:type="geo:GeocoderAddressResult">
                                <number xsi:type="xsd:int">240</number>
                                <lat xsi:type="xsd:float">40.656591</lat>
                                <street xsi:type="xsd:string">1st</street>
                                <state xsi:type="xsd:string">NY</state>
                                <city xsi:type="xsd:string">New York</city>
                                <zip xsi:type="xsd:int">11232</zip>
                                <suffix xsi:type="xsd:string"/>
                                <long xsi:type="xsd:float">-74.012768</long>
                                <type xsi:type="xsd:string">Ave</type>
                                <prefix xsi:type="xsd:string"/>
                            </item>
                            <item xsi:type="geo:GeocoderAddressResult">
                                <number xsi:type="xsd:int">240</number>
                                <lat xsi:type="xsd:float">40.731885</lat>
                                <street xsi:type="xsd:string">1st</street>
                                <state xsi:type="xsd:string">NY</state>
                                <city xsi:type="xsd:string">New York</city>
                                <zip xsi:type="xsd:int">10009</zip>
                                <suffix xsi:type="xsd:string"/>
                                <long xsi:type="xsd:float">-73.982589</long>
                                <type xsi:type="xsd:string">Ave</type>
                                <prefix xsi:type="xsd:string"/>
                            </item>
                        </geo:s-gensym118>
                    </namesp24:geocodeResponse>
                </SOAP-ENV:Body>
            </SOAP-ENV:Envelope>
         */
        
        XmlElement* envelopeElement = [XmlParser parse:result];
        XmlElement* bodyElement = [envelopeElement elementAtIndex:0];
        XmlElement* responseElement = [bodyElement elementAtIndex:0];
        XmlElement* gensymElement = [responseElement elementAtIndex:0];
        
        for (XmlElement* child in gensymElement.children)
        {
            XmlElement* latElement = [child element:@"lat"];
            XmlElement* lngElement = [child element:@"long"];
            
            NSString* lat = [latElement text];
            NSString* lng = [lngElement text];
            
            if (lat != nil && lng != nil && ![lat isEqual:@""] && ![lng isEqual:@""])
            {
                return [Location locationWithLatitude:[lat doubleValue] longitude:[lng doubleValue]];
            }
        }
    }

    return nil;
}

- (void) downloadAddressLocation:(NSString*) address
{
    NSMutableDictionary* map = [self addressLocationMap];
    if ([map objectForKey:address] != nil)
    {
        // already have the poster.  Don't need to do anything.
        return;
    }
    
    Location* location = [self downloadAddressLocationFromWebService:address];
    if (location != nil)
    {    
        [map setValue:[location dictionary] forKey:address];
        [self setAddressLocationMap:map];
    }
}

- (void) downloadAddressLocations:(NSArray*) addresses
{
    for (NSString* address in addresses)
    {
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
        
        [self downloadAddressLocation:address];
        
        [autoreleasePool release];
    }
}

- (void) updateInBackground:(NSArray*) addresses
{
    [gate lock];
    {
        [self downloadAddressLocations:addresses];
    }
    [gate unlock];
}

- (void) backgroundEntryPoint:(NSArray*) addresses
{
    NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
    
    [self updateInBackground:addresses];
    
    [autoreleasePool release];
}

- (Location*) locationForAddress:(NSString*) address
{
    NSDictionary* dict = [[self addressLocationMap] valueForKey:address];
    if (dict == nil)
    {
        return nil;
    }
    
    return [Location locationWithDictionary:dict];
}

@end
