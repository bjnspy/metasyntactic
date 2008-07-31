//
//  RatingsDownloader.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/31/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "RatingsCache.h"
#import "BoxOfficeModel.h"
#import "Utilities.h"
#import "Application.h"
#import "ExtraMovieInformation.h"
#import "RottenTomatoesDownloader.h"
#import "MetacriticDownloader.h"

@implementation RatingsCache

@synthesize model;
@synthesize ratingsAndHash;

- (void) dealloc {
    self.model = nil;
    self.ratingsAndHash = nil;
    
    [super dealloc];
}

- (NSString*) ratingsFile {
    return [Application ratingsFile:[self.model currentRatingsProvider]];
}

- (NSDictionary*) loadRatingsProvider {
    NSDictionary* dictionary = [NSDictionary dictionaryWithContentsOfFile:[self ratingsFile]];
    if (dictionary == nil) {
        return [NSDictionary dictionary];
    }
    
    NSDictionary* encodedRatings = [dictionary objectForKey:@"Ratings"];
    NSString* hash = [dictionary objectForKey:@"Hash"];
    
    NSMutableDictionary* decodedRatings = [NSMutableDictionary dictionary];
    for (NSString* key in encodedRatings) {
        [decodedRatings setObject:[ExtraMovieInformation infoWithDictionary:[encodedRatings objectForKey:key]] forKey:key];
    }
    
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    [result setObject:decodedRatings forKey:@"Ratings"];
    [result setObject:hash forKey:@"Hash"];
    
    return result;
}

- (void) onRatingsProviderChanged {
    self.ratingsAndHash = [self loadRatingsProvider];
}

- (id) initWithModel:(BoxOfficeModel*) model_ {
    if (self = [super init]) {
        self.model = model_;
    }
    
    return self;
}

+ (RatingsCache*) cacheWithModel:(BoxOfficeModel*) model {
    return [[[RatingsCache alloc] initWithModel:model] autorelease];
}

- (void) saveRatings:(NSDictionary*) dictionary {
    if (dictionary.count == 0) {
        return;
    }
    
    self.ratingsAndHash = dictionary;
    
    NSMutableDictionary* encodedRatings = [NSMutableDictionary dictionary];
    NSDictionary* ratings = [dictionary objectForKey:@"Ratings"];
    NSString* hash = [dictionary objectForKey:@"Hash"];
    
    for (NSString* key in ratings) {
        [encodedRatings setObject:[[ratings objectForKey:key] dictionary] forKey:key];
    }
    
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    [result setObject:encodedRatings forKey:@"Ratings"];
    [result setObject:hash forKey:@"Hash"];
    
        //[Application ratingsFile:[self currentRatingsProvider]]
    [Utilities writeObject:result toFile:[self ratingsFile]];
}

- (NSDictionary*) updateWorker {
    NSString* hash = [self.ratingsAndHash objectForKey:@"Hash"];
    
    if ([self.model rottenTomatoesRatings]) {
        return [[RottenTomatoesDownloader downloaderWithModel:self.model] lookupMovieListings:hash];
    } else if ([self.model metacriticRatings]) {
        return [[MetacriticDownloader downloaderWithModel:self.model] lookupMovieListings:hash];
    }
    
    return nil;    
}

- (NSDictionary*) update {
    NSDictionary* result = [self updateWorker];
    
    [self saveRatings:result];
    
    return [result objectForKey:@"Ratings"];
}

- (NSDictionary*) ratings {
    NSDictionary* result = [self.ratingsAndHash objectForKey:@"Ratings"];
    if (result == nil) {
        return [NSDictionary dictionary];
    }
    
    return result;
}

@end
