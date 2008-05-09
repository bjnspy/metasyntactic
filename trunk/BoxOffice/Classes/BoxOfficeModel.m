//
//  BoxOfficeModel.m
//  BoxOfficeApplication
//
//  Created by Cyrus Najmabadi on 4/26/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BoxOfficeModel.h"
#import "Movie.h"
#import "Theater.h"

@implementation BoxOfficeModel

@synthesize posterCache;
@synthesize addressLocationCache;

- (void) updatePosterCache
{
    [self.posterCache update:self.movies];
}

- (void) updateAddressLocationCache
{
    NSMutableArray* addresses = [NSMutableArray array];
    for (Theater* theater in self.theaters)
    {
        [addresses addObject:theater.address];
    }
    
    [self.addressLocationCache updateAddresses:addresses];
}

- (void) updateZipcodeAddressLocation
{
    [self.addressLocationCache updateZipcode:self.zipcode];
}

- (id) init
{
    if (self = [super init])
    {
        self.posterCache = [PosterCache cache];
        self.addressLocationCache = [AddressLocationCache cache];
        
        [self updatePosterCache];
        [self updateAddressLocationCache];
        [self updateZipcodeAddressLocation];
    }
    
    return self;
}

- (void) dealloc
{
    self.posterCache = nil;
    [super dealloc];
}

- (NSString*) zipcode
{
    NSString* result = [[NSUserDefaults standardUserDefaults] stringForKey:@"zipCode"];
    if (result == nil)
    {
        return @"";
    }
    
    return result;
}

- (void) setZipcode:(NSString*) zipcode
{
    if ([zipcode isEqual:[self zipcode]])
    {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:zipcode forKey:@"zipCode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self updateZipcodeAddressLocation];
}

- (int) searchRadius
{
    return MAX(5, [[NSUserDefaults standardUserDefaults] integerForKey:@"searchRadius"]);
}

- (void) setSearchRadius:(NSInteger) searchRadius
{
    [[NSUserDefaults standardUserDefaults] setInteger:searchRadius forKey:@"searchRadius"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray*) movies
{
    NSLog(@"BoxOfficeModel:movies");
    NSArray* array = [[NSUserDefaults standardUserDefaults] arrayForKey:@"movies"];
    if (array == nil)
    {
        return [NSArray array];
    }
    
    NSMutableArray* decodedMovies = [NSMutableArray array];
    
    for (int i = 0; i < [array count]; i++)
    {
        Movie* movie = [Movie movieWithDictionary:[array objectAtIndex:i]];
        [decodedMovies addObject:movie];
    }
    
    return decodedMovies;
}

- (void) setMovies:(NSArray*) movies
{    
    NSMutableArray* array = [NSMutableArray array];
    
    for (int i = 0; i < [movies count]; i++)
    {
        [array addObject:[[movies objectAtIndex:i] dictionary]];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"movies"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self updatePosterCache];
}

- (NSArray*) theaters
{
    NSArray* array = [[NSUserDefaults standardUserDefaults] arrayForKey:@"theaters"];
    if (array == nil)
    {
        return [NSArray array];
    }
    
    NSMutableArray* decodedTheaters = [NSMutableArray array];
    
    for (int i = 0; i < [array count]; i++)
    {
        [decodedTheaters addObject:[Theater theaterWithDictionary:[array objectAtIndex:i]]];
    }
    
    return decodedTheaters;
}

- (void) setTheaters:(NSArray*) theaters
{
    NSMutableArray* array = [NSMutableArray array];
    
    for (int i = 0; i < [theaters count]; i++)
    {
        [array addObject:[[theaters objectAtIndex:i] dictionary]];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"theaters"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self updateAddressLocationCache];
}

- (UIImage*) posterForMovie:(Movie*) movie
{
    return [self.posterCache posterForMovie:movie];
}

- (Location*) locationForAddress:(NSString*) address
{
    return [self.addressLocationCache locationForAddress:address];
}

- (Location*) locationForZipcode:(NSString*) zipcode
{
    return [self.addressLocationCache locationForZipcode:zipcode];
}

@end
