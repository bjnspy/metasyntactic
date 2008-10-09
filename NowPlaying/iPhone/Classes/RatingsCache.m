//Copyright 2008 Cyrus Najmabadi
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

#import "RatingsCache.h"

#import "Application.h"
#import "FileUtilities.h"
#import "GoogleRatingsDownloader.h"
#import "MetacriticRatingsDownloader.h"
#import "MovieRating.h"
#import "NowPlayingModel.h"
#import "RottenTomatoesRatingsDownloader.h"

@implementation RatingsCache

static NSString* ratings_key = @"Ratings";
static NSString* hash_key = @"Hash";

@synthesize model;
@synthesize ratingsAndHash;

- (void) dealloc {
    self.model = nil;
    self.ratingsAndHash = nil;

    [super dealloc];
}


- (NSString*) ratingsFile {
    return [Application ratingsFile:self.model.currentRatingsProvider];
}


- (NSDictionary*) loadRatingsProvider {
    NSDictionary* dictionary = [NSDictionary dictionaryWithContentsOfFile:[self ratingsFile]];
    if (dictionary == nil) {
        return [NSDictionary dictionary];
    }

    NSDictionary* encodedRatings = [dictionary objectForKey:ratings_key];
    NSString* hash = [dictionary objectForKey:hash_key];

    NSMutableDictionary* decodedRatings = [NSMutableDictionary dictionary];
    for (NSString* key in encodedRatings) {
        [decodedRatings setObject:[MovieRating ratingWithDictionary:[encodedRatings objectForKey:key]] forKey:key];
    }

    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    [result setObject:decodedRatings forKey:ratings_key];
    [result setObject:hash forKey:hash_key];

    return result;
}


- (void) onRatingsProviderChanged {
    self.ratingsAndHash = [self loadRatingsProvider];
}


- (id) initWithModel:(NowPlayingModel*) model_ {
    if (self = [super init]) {
        self.model = model_;
        [self onRatingsProviderChanged];
    }

    return self;
}


+ (RatingsCache*) cacheWithModel:(NowPlayingModel*) model {
    return [[[RatingsCache alloc] initWithModel:model] autorelease];
}


- (void) saveRatingsInBackground:(NSDictionary*) dictionary {
    if (dictionary.count == 0) {
        return;
    }

    [self performSelectorOnMainThread:@selector(saveRatingsInForeground:) withObject:dictionary waitUntilDone:NO];

    NSMutableDictionary* encodedRatings = [NSMutableDictionary dictionary];
    NSDictionary* ratings = [dictionary objectForKey:ratings_key];
    NSString* hash = [dictionary objectForKey:hash_key];

    for (NSString* key in ratings) {
        [encodedRatings setObject:[[ratings objectForKey:key] dictionary] forKey:key];
    }

    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    [result setObject:encodedRatings forKey:ratings_key];
    [result setObject:hash forKey:hash_key];

    //[Application ratingsFile:[self currentRatingsProvider]]
    [FileUtilities writeObject:result toFile:self.ratingsFile];
}


- (void) saveRatingsInForeground:(NSDictionary*) dictionary {
    self.ratingsAndHash = dictionary;
}


- (NSString*) lookupServerHash {
    if (self.model.rottenTomatoesRatings) {
        return [RottenTomatoesRatingsDownloader lookupServerHash];
    } else if (self.model.metacriticRatings) {
        return [MetacriticRatingsDownloader lookupServerHash];
    } else if (self.model.googleRatings) {
        return [GoogleRatingsDownloader lookupServerHash:model];
    }

    return nil;
}


- (NSDictionary*) updateWorker {
    NSString* localHash = [ratingsAndHash objectForKey:hash_key];
    NSString* serverHash = [self lookupServerHash];

    if (serverHash.length == 0) {
        serverHash = @"0";
    }

    if ([@"0" isEqual:serverHash]) {
        return nil;
    }

    if (localHash != nil &&
        [localHash isEqual:serverHash]) {
        return nil;
    }

    NSDictionary* ratings = nil;
    if (self.model.rottenTomatoesRatings) {
        ratings = [[RottenTomatoesRatingsDownloader downloaderWithModel:self.model] lookupMovieListings];
    } else if (self.model.metacriticRatings) {
        ratings = [[MetacriticRatingsDownloader downloaderWithModel:self.model] lookupMovieListings];
    } else if (self.model.googleRatings) {
        ratings = [[GoogleRatingsDownloader downloaderWithModel:self.model] lookupMovieListings];
    }

    if (ratings.count > 0) {
        NSMutableDictionary* result = [NSMutableDictionary dictionary];
        [result setObject:ratings forKey:ratings_key];
        [result setObject:serverHash forKey:hash_key];

        return result;
    }

    return nil;
}


- (NSDictionary*) update {
    NSAssert(![NSThread isMainThread], @"");
    NSDictionary* result = [self updateWorker];

    [self saveRatingsInBackground:result];

    return [result objectForKey:ratings_key];
}


- (NSDictionary*) ratings {
    NSDictionary* result = [ratingsAndHash objectForKey:ratings_key];
    if (result == nil) {
        return [NSDictionary dictionary];
    }

    return result;
}


@end