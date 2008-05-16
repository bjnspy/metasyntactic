//
//  TheaterLocationCache.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/8/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "AddressLocationCache.h"
#import "XmlSerializer.h"
#import "XmlDocument.h"
#import "XmlElement.h"
#import "XmlParser.h"
#import "Utilities.h"
#import "BoxOfficeModel.h"

@implementation AddressLocationCache

@synthesize gate;
@synthesize cachedTheaterDistanceMap;

- (void) dealloc {
    self.gate = nil;
    self.cachedTheaterDistanceMap = nil;
    [super dealloc];
}

- (id) init {
    if (self = [super init]) {
        self.gate = [[[NSLock alloc] init] autorelease];
        self.cachedTheaterDistanceMap = [NSMutableDictionary dictionary];
    }
    
    return self;
}

+ (AddressLocationCache*) cache {
    return [[[AddressLocationCache alloc] init] autorelease];
}

- (void) updateAddresses:(NSArray*) addresses {
    self.cachedTheaterDistanceMap = [NSMutableDictionary dictionary];
    
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
    if (error == nil && result != nil) {
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
    
    [self performSelectorOnMainThread:@selector(invalidateCachedData:) withObject:nil waitUntilDone:NO];
}

- (void) downloadAddressLocation:(NSString*) address {
    if ([self locationForAddress:address] != nil) {
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
    self.cachedTheaterDistanceMap = [NSMutableDictionary dictionary];
    
    if ([Utilities isNilOrEmpty:zipcode]) {
        return;
    }
    
    if ([self locationForZipcode:zipcode] != nil) {
        return;
    }
    
    [self performSelectorInBackground:@selector(updateZipcodeBackgroundEntryPoint:)
                           withObject:zipcode];    
}

- (void) invalidateCachedData:(id) object {
    self.cachedTheaterDistanceMap = [NSMutableDictionary dictionary];
}

- (NSDictionary*) theaterDistanceMap:(Location*) userLocation
                            theaters:(NSArray*) theaters {
    NSString* locationDescription = [userLocation description];
    if (locationDescription == nil) {
        locationDescription = @"";
    }
    
    NSMutableDictionary* theaterDistanceMap = [self.cachedTheaterDistanceMap objectForKey:locationDescription];
    if (theaterDistanceMap == nil) {
        theaterDistanceMap = [NSMutableDictionary dictionary];
        
        for (Theater* theater in theaters) {
            double d;
            if (userLocation != nil) {
                d = [userLocation distanceTo:[self locationForAddress:theater.address]];
            } else {
                d = UNKNOWN_DISTANCE;
            }
            
            NSNumber* value = [NSNumber numberWithDouble:d];
            NSString* key = theater.address;
            [theaterDistanceMap setObject:value forKey:key];
        }
        
        [self.cachedTheaterDistanceMap setObject:theaterDistanceMap
         forKey:locationDescription];
    }
    
    return theaterDistanceMap;    
}

@end