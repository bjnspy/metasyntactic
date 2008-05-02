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

- (id) init
{
    NSLog(@"Initializing BoxOfficeModel");
    if (self = [super init])
    {
    }
    
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (NSString*) zipcode
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"zipCode"];
}

- (void) setZipcode:(NSString*) zipcode
{
    [[NSUserDefaults standardUserDefaults] setObject:zipcode forKey:@"zipCode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (int) searchRadius
{
    return MAX(15, [[NSUserDefaults standardUserDefaults] integerForKey:@"searchRadius"]);
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
        Movie* movie = [[[Movie alloc] initWithDictionary:[array objectAtIndex:i]] autorelease];
        [decodedMovies addObject:movie];
    }
    
    return decodedMovies;
}

- (void) setMovies:(NSArray*) movies
{
    NSLog(@"BoxOfficeModel:setMovies");
    NSMutableArray* array = [NSMutableArray array];
    
    for (int i = 0; i < [movies count]; i++)
    {
        [array addObject:[[movies objectAtIndex:i] dictionary]];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"movies"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray*) theaters
{
    NSArray* array = [[NSUserDefaults standardUserDefaults] arrayForKey:@"theaters"];
    if (array == nil)
    {
        return [NSArray array];
    }
    
    NSMutableArray* decodedTheaters = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array count]; i++)
    {
        [decodedTheaters addObject:[[Theater alloc] initWithDictionary:[array objectAtIndex:i]]];
    }
    
    return decodedTheaters;
}

- (void) setTheaters:(NSArray*) theaters
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [theaters count]; i++)
    {
        [array addObject:[[theaters objectAtIndex:i] dictionary]];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"theaters"];
    [[NSUserDefaults standardUserDefaults] synchronize];    
}

@end
