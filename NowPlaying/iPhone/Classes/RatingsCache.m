// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "RatingsCache.h"

#import "Application.h"
#import "ExtraMovieInformation.h"
#import "FileUtilities.h"
#import "GoogleRatingsDownloader.h"
#import "MetacriticRatingsDownloader.h"
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
        [decodedRatings setObject:[ExtraMovieInformation infoWithDictionary:[encodedRatings objectForKey:key]] forKey:key];
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