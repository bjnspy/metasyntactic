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

- (id) init
{
    if (self = [super init])
    {
        self.posterCache = [[PosterCache alloc] initWithModel:self];
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

- (BOOL) areEqual:(NSArray*) movies1
         movies:(NSArray*) movies2
{
    NSSet* set1 = [NSSet setWithArray:movies1];
    NSSet* set2 = [NSSet setWithArray:movies2];
    
    return [set1 isEqualToSet:set2];
}

- (void) setMovies:(NSArray*) movies
{
    NSLog(@"BoxOfficeModel:setMovies");
    
    if ([self areEqual:movies movies:self.movies])
    {
        return;
    }
    
    NSMutableArray* array = [NSMutableArray array];
    
    for (int i = 0; i < [movies count]; i++)
    {
        [array addObject:[[movies objectAtIndex:i] dictionary]];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"movies"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [posterCache update];
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
        [decodedTheaters addObject:[[[Theater alloc] initWithDictionary:[array objectAtIndex:i]] autorelease]];
    }
    
    return decodedTheaters;
}

- (BOOL) areEqual:(NSArray*) theaters1
         theaters:(NSArray*) theaters2
{
    NSSet* set1 = [NSSet setWithArray:theaters1];
    NSSet* set2 = [NSSet setWithArray:theaters2];
    
    return [set1 isEqualToSet:set2];
}

- (void) setTheaters:(NSArray*) theaters
{
    if ([self areEqual:theaters theaters:[self theaters]])
    {
        return;
    }
    
    NSMutableArray* array = [NSMutableArray array];
    
    for (int i = 0; i < [theaters count]; i++)
    {
        [array addObject:[[theaters objectAtIndex:i] dictionary]];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"theaters"];
    [[NSUserDefaults standardUserDefaults] synchronize];    
}

- (UIImage*) posterForMovie:(Movie*) movie
{
    return [self.posterCache posterForMovie:movie];
}

@end
