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
#import "Utilities.h"

@implementation AddressLocationCache

@synthesize gate;

- (void) dealloc {
    self.gate = nil;
    [super dealloc];
}

+ (AddressLocationCache*) cache {
    return [[[AddressLocationCache alloc] init] autorelease];
}

- (id) init {
    if (self = [super init]) {
        self.gate = [[[NSLock alloc] init] autorelease];
    }
    
    return self;
}
 
- (void) updateAddresses:(NSArray*) addresses {
    [self performSelectorInBackground:@selector(backgroundEntryPoint:)
                           withObject:[NSArray arrayWithArray:addresses]];
}

- (Location*) locationFromLatitudeElement:(XmlElement*) latElement 
                       longitutudeElement:(XmlElement*) lngElement {
    NSString* lat = [latElement text];
    NSString* lng = [lngElement text];
    
    if ([Utilities isNilOrEmpty:lat] ||
        [Utilities isNilOrEmpty:lng]) {
        return nil;
    }
    
    return [Location locationWithLatitude:[lat doubleValue] longitude:[lng doubleValue]];    
}

- (Location*) downloadAddressLocationFromGeocoderWebService:(NSString*) address {
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
                               elementWithName:@"m:geocode"
                               attributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                            @"http://rpc.geocoder.us/Geo/Coder/US/", @"xmlns:m", nil]
                               children: [NSArray arrayWithObjects:
                                          [XmlElement
                                           elementWithName:@"location"
                                           attributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                        @"xsd:string", @"xsi:type", nil]
                                           text:address], nil]]]]]]]];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:@"http://rpc.geocoder.us/service/soap/"]];
    [request setHTTPMethod:@"POST"];
    //[request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    
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
        
        for (XmlElement* child in gensymElement.children) {
            XmlElement* latElement = [child element:@"lat"];
            XmlElement* lngElement = [child element:@"long"];
            
            Location* location = [self locationFromLatitudeElement:latElement longitutudeElement:lngElement];
            if (location != nil) {
                return location;
            }
        }
    }

    return nil;
}

- (Location*) processYahooResult:(NSData*) addressData {
    if (addressData != nil) {
        XmlElement* resultSetElement = [XmlParser parse:addressData];
        
        for (XmlElement* child in resultSetElement.children) {
            XmlElement* latElement = [child element:@"Latitude"];
            XmlElement* lngElement = [child element:@"Longitude"];
            
            Location* location = [self locationFromLatitudeElement:latElement longitutudeElement:lngElement];
            if (location != nil) {
                return location;
            }   
        }
    }
    
    return nil;    
}

- (Location*) downloadAddressLocationFromYahooWebService:(NSString*) address {
    NSString* escapedAddress = [address stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString* yahooId = @"TVq1wv_V34E9W2rK45TyIi1nj1BcnTpf2D00jo6zc4_HyqgVpu8QHRfaGLsbRja4RVO25sb_";
    
    NSString* urlString = [NSString stringWithFormat:@"http://local.yahooapis.com/MapsService/V1/geocode?appid=%@&location=%@", yahooId, escapedAddress];
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSData* addressData = [NSData dataWithContentsOfURL:url];
    return [self processYahooResult:addressData];
}

- (Location*) downloadAddressLocationFromWebService:(NSString*) address {
    if ([Utilities isNilOrEmpty:address]) {
        return nil;
    }
    
    Location* location = [self downloadAddressLocationFromYahooWebService:address];
    if (location != nil) {
        return location;
    }
    
    location = [self downloadAddressLocationFromGeocoderWebService:address];
    if (location != nil) {
        return location;
    }
    
    return nil;
}

- (NSMutableDictionary*) addressLocationMap {
    NSDictionary* dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"addressLocationMap"];
    if (dict == nil) {
        dict = [NSDictionary dictionary];
    }
    
    return [NSMutableDictionary dictionaryWithDictionary:dict];
}

- (Location*) locationForAddress:(NSString*) address {
    NSDictionary* dict = [[self addressLocationMap] valueForKey:address];
    if (dict == nil) {
        return nil;
    }
    
    return [Location locationWithDictionary:dict];
}

- (void) setLocation:(Location*) location
          forAddress:(NSString*) address {
    if (location == nil || [Utilities isNilOrEmpty:address]) {
        return;
    }
    
    NSMutableDictionary* map = [self addressLocationMap];
    [map setValue:[location dictionary] forKey:address];
    
    [[NSUserDefaults standardUserDefaults] setValue:map forKey:@"addressLocationMap"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) downloadAddressLocation:(NSString*) address {
    if ([self locationForAddress:address] != nil) {
        // already have the address, don't need to do anything.
        return;
    }
    
    Location* location = [self downloadAddressLocationFromWebService:address];
    [self setLocation:location forAddress:address];
}

- (void) downloadAddressLocations:(NSArray*) addresses {
    for (NSString* address in addresses) {
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
        
        [self downloadAddressLocation:address];
        
        [autoreleasePool release];
    }
}

- (void) backgroundEntryPoint:(NSArray*) addresses {
    [gate lock];
    {
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
    
        [self downloadAddressLocations:addresses];
    
        [autoreleasePool release];
    }
    [gate unlock];
}

- (Location*) locationForZipcode:(NSString*) zipcode {
    return [self locationForAddress:zipcode];
}

- (Location*) downloadZipcodeLocationFromYahooWebService:(NSString*) zipcode {
    NSString* yahooId = @"TVq1wv_V34E9W2rK45TyIi1nj1BcnTpf2D00jo6zc4_HyqgVpu8QHRfaGLsbRja4RVO25sb_";
    
    NSString* urlString = [NSString stringWithFormat:@"http://local.yahooapis.com/MapsService/V1/geocode?appid=%@&zip=%@", yahooId, zipcode];
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSData* addressData = [NSData dataWithContentsOfURL:url];
    return [self processYahooResult:addressData];
}

- (Location*) downloadZipcodeLocationFromGeonamesWebService:(NSString*) zipcode {
    NSString* escapedZipcode = [zipcode stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString* urlString = [NSString stringWithFormat:@"http://ws.geonames.org/postalCodeSearch?postalcode=%@&maxRows=1", escapedZipcode];
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSData* zipcodeData = [NSData dataWithContentsOfURL:url];
    if (zipcodeData != nil) {
        /*
         <?xml version="1.0" encoding="UTF-8" standalone="no"?>
         <geonames>
            <totalResultsCount>9</totalResultsCount>
            <code>
                <postalcode>20816</postalcode>
                <name>Bethesda</name>
                <countryCode>US</countryCode>
                <lat>38.955907</lat>
                <lng>-77.1165</lng>
                <adminCode1>MD</adminCode1>
                <adminName1>Maryland</adminName1>
                <adminCode2>031</adminCode2>
                <adminName2>Montgomery</adminName2>
                <adminCode3/>
                <adminName3/>
            </code>
         </geonames>
         */
        
        XmlElement* geonamesElement = [XmlParser parse:zipcodeData];
        XmlElement* codeElement = [geonamesElement element:@"code"];
        
        XmlElement* latElement = [codeElement element:@"lat"];
        XmlElement* lngElement = [codeElement element:@"lng"];
        
        return [self locationFromLatitudeElement:latElement longitutudeElement:lngElement];
    }
    
    return nil;
}

- (void) downloadZipcodeLocationFromWebService:(NSString*) zipcode {
    if ([Utilities isNilOrEmpty:zipcode]) {
        return;
    }
    
    Location* location = [self downloadZipcodeLocationFromYahooWebService:zipcode];
    if (location == nil) {
        location = [self downloadZipcodeLocationFromGeonamesWebService:zipcode];
    }
    
    [self setLocation:location forAddress:zipcode];
}

- (void) updateZipcodeBackgroundEntryPoint:(NSString*) zipcode
{
    NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
    
    [self downloadZipcodeLocationFromWebService:zipcode];
    
    [autoreleasePool release];    
}

- (void) updateZipcode:(NSString*) zipcode
{
    if ([self locationForZipcode:zipcode] != nil) {
        // already have the address, don't need to do anything.
        return;
    }    
    
    [self performSelectorInBackground:@selector(updateZipcodeBackgroundEntryPoint:)
                           withObject:zipcode];    
}

@end