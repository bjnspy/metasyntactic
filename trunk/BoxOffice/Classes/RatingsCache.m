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
#import "BoxOfficeModel.h"
#import "ExtraMovieInformation.h"
#import "MetacriticDownloader.h"
#import "RottenTomatoesDownloader.h"
#import "Utilities.h"

@implementation RatingsCache

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
        [self onRatingsProviderChanged];
    }

    return self;
}


+ (RatingsCache*) cacheWithModel:(BoxOfficeModel*) model {
    return [[[RatingsCache alloc] initWithModel:model] autorelease];
}


- (void) saveRatingsInBackground:(NSDictionary*) dictionary {
    if (dictionary.count == 0) {
        return;
    }

    [self performSelectorOnMainThread:@selector(saveRatingsInForeground:) withObject:dictionary waitUntilDone:NO];

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
    [Utilities writeObject:result toFile:self.ratingsFile];
}


- (void) saveRatingsInForeground:(NSDictionary*) dictionary {
    self.ratingsAndHash = dictionary;
}


- (NSDictionary*) updateWorker {
    NSString* hash = [self.ratingsAndHash objectForKey:@"Hash"];

    if (self.model.rottenTomatoesRatings) {
        return [[RottenTomatoesDownloader downloaderWithModel:self.model] lookupMovieListings:hash];
    } else if (self.model.metacriticRatings) {
        return [[MetacriticDownloader downloaderWithModel:self.model] lookupMovieListings:hash];
    }

    return nil;
}


- (NSDictionary*) update {
    NSAssert(![NSThread isMainThread], @"");
    NSDictionary* result = [self updateWorker];

    [self saveRatingsInBackground:result];

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