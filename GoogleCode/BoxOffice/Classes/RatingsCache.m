// Copyright (c) 2008, Cyrus Najmabadi
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
//   Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
//
//   Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
//   Neither the name 'Cyrus Najmabadi' nor the names of its contributors may be
//   used to endorse or promote products derived from this software without
//   specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

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
        [self onRatingsProviderChanged];
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
