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
#import "Application.h"

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

- (Location*) processResult:(XmlElement*) resultElement {
    if (resultElement != nil) {
        NSString* latitude = [resultElement attributeValue:@"latitude"];
        NSString* longitude = [resultElement attributeValue:@"longitude"];
        
        if (![Utilities isNilOrEmpty:latitude] && ![Utilities isNilOrEmpty:longitude]) {
            return [Location locationWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
        }
    }
    
    return nil;    
}

- (Location*) downloadAddressLocationFromWebService:(NSString*) address {
    if ([Utilities isNilOrEmpty:address]) {
        return nil;
    } 
    
    NSString* escapedAddress = [address stringByAddingPercentEscapesUsingEncoding:NSISOLatin1StringEncoding];
    if (escapedAddress != nil) {    
        NSMutableArray* hosts = [Application hosts];
        NSInteger index = abs([escapedAddress hash]) % [hosts count];
        NSString* host = [hosts objectAtIndex:index];
        
        NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupLocation?q=%@", host, escapedAddress];
        
        XmlElement* element = [Utilities downloadXml:url];
        return [self processResult:element];
    }
    
    return nil;
}

- (NSDictionary*) addressLocationMap {
    NSDictionary* dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"addressLocationMap"];
    if (dict == nil) {
        return [NSDictionary dictionary];
    }
    
    return dict;
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
    
    NSMutableDictionary* map = [NSMutableDictionary dictionaryWithDictionary:[self addressLocationMap]];
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

- (void) updateZipcodeBackgroundEntryPoint:(NSString*) zipcode
{
    NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
    
    [self downloadAddressLocation:zipcode];
    
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