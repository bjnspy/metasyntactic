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

#import "ReviewCache.h"

#import "Application.h"
#import "BoxOfficeModel.h"
#import "ExtraMovieInformation.h"
#import "Review.h"
#import "Utilities.h"

@implementation ReviewCache

@synthesize model;
@synthesize gate;

- (void) dealloc {
    self.model = nil;
    self.gate = nil;

    [super dealloc];
}


- (id) initWithModel:(BoxOfficeModel*) model_ {
    if (self = [super init]) {
        self.model = model_;
        self.gate = [[[NSLock alloc] init] autorelease];
    }

    return self;
}


+ (ReviewCache*) cacheWithModel:(BoxOfficeModel*) model {
    return [[[ReviewCache alloc] initWithModel:model] autorelease];
}


- (NSString*) reviewFilePath:(NSString*) title ratingsProvider:(NSInteger) ratingsProvider {
    NSString* sanitizedTitle = [Application sanitizeFileName:title];
    NSString* reviewsFolder = [Application providerReviewsFolder:[[self.model ratingsProviders] objectAtIndex:ratingsProvider]];
    return [[reviewsFolder stringByAppendingPathComponent:sanitizedTitle] stringByAppendingPathExtension:@"plist"];
}


- (NSDictionary*) loadReviewFile:(NSString*) title ratingsProvider:(NSInteger) ratingsProvider {
    NSDictionary* encodedDictionary = [NSDictionary dictionaryWithContentsOfFile:[self reviewFilePath:title ratingsProvider:ratingsProvider]];
    if (encodedDictionary == nil) {
        return [NSDictionary dictionary];
    }

    NSMutableArray* reviews = [NSMutableArray array];
    for (NSDictionary* dict in [encodedDictionary objectForKey:@"Reviews"]) {
        [reviews addObject:[Review reviewWithDictionary:dict]];
    }

    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    [result setObject:reviews forKey:@"Reviews"];
    [result setObject:[encodedDictionary objectForKey:@"Hash"] forKey:@"Hash"];

    return result;
}


- (void) update:(NSDictionary*) supplementaryInformation ratingsProvider:(NSInteger) ratingsProvider {
    [self performSelectorInBackground:@selector(updateInBackground:)
                           withObject:[NSArray arrayWithObjects:supplementaryInformation, [NSNumber numberWithInt:ratingsProvider], nil]];
}


- (NSArray*) extractReviews:(NSString*) reviewPage {
    NSMutableArray* result = [NSMutableArray array];

    NSArray* rows = [reviewPage componentsSeparatedByString:@"\n"];
    for (NSString* row in rows) {
        NSArray* columns = [row componentsSeparatedByString:@"\t"];

        if (columns.count < 5) {
            continue;
        }

        NSString* score = [columns objectAtIndex:1];
        NSInteger scoreValue = [score intValue];

        [result addObject:[Review reviewWithText:[columns objectAtIndex:0]
                                           score:scoreValue
                                            link:[columns objectAtIndex:2]
                                          author:[columns objectAtIndex:3]
                                          source:[columns objectAtIndex:4]]];
    }

    return result;
}


- (NSArray*) downloadInfoReviews:(ExtraMovieInformation*) info {
    NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupMovieReviews?q=%@", [Application host], info.link];
    NSString* reviewPage = [Utilities stringWithContentsOfAddress:url];

    if (reviewPage != nil) {
        return [self extractReviews:reviewPage];
    }

    return nil;
}


- (void) saveMovie:(NSString*) title reviews:(NSArray*) reviews hash:(NSString*) hash ratingsProvider:(NSInteger) ratingsProvider {
    NSMutableArray* encodedReviews = [NSMutableArray array];
    for (Review* review in reviews) {
        [encodedReviews addObject:[review dictionary]];
    }

    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:encodedReviews forKey:@"Reviews"];
    [dictionary setObject:hash forKey:@"Hash"];

    [Utilities writeObject:dictionary toFile:[self reviewFilePath:title ratingsProvider:ratingsProvider]];
}


- (NSArray*) reviewsForMovie:(NSString*) movieTitle {
    NSDictionary* dictionary = [self loadReviewFile:movieTitle ratingsProvider:[self.model ratingsProviderIndex]];
    if (dictionary == nil) {
        return [NSArray array];
    }

    return [dictionary objectForKey:@"Reviews"];
}


- (NSString*) reviewsHashForMovie:(NSString*) movieTitle {
    NSDictionary* dictionary = [self loadReviewFile:movieTitle ratingsProvider:[self.model ratingsProviderIndex]];
    return [dictionary objectForKey:@"Hash"];
}


- (void) downloadReviews:(NSDictionary*) supplementaryInformation
         ratingsProvider:(NSInteger) ratingsProvider {
    for (NSString* movieId in supplementaryInformation) {
        if ([self.model ratingsProviderIndex] != ratingsProvider) {
            break;
        }

        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];

        ExtraMovieInformation* info = [supplementaryInformation objectForKey:movieId];
        if (info.link.length > 0) {
            NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupMovieReviews?q=%@&hash=true", [Application host], info.link];
            NSString* serverHash = [Utilities stringWithContentsOfAddress:url];
            if (serverHash == nil) {
                serverHash = @"0";
            }

            NSString* localHash = [self reviewsHashForMovie:movieId];

            if (localHash != nil &&
                [localHash isEqual:serverHash]) {
                continue;
            }

            NSArray* reviews = [self downloadInfoReviews:info];
            if (reviews.count > 0) {
                [self saveMovie:movieId reviews:reviews hash:serverHash ratingsProvider:ratingsProvider];
            }
        }

        [autoreleasePool release];
    }
}


- (void) updateInBackground:(NSArray*) arguments {
    NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
    [gate lock];
    {
        [NSThread setThreadPriority:0.0];

        NSDictionary* supplementaryInformation = [arguments objectAtIndex:0];
        NSInteger ratingsProvider = [[arguments objectAtIndex:1] intValue];

        NSMutableDictionary* infoWithReviews = [NSMutableDictionary dictionary];
        NSMutableDictionary* infoWithoutReviews = [NSMutableDictionary dictionary];

        for (NSString* title in supplementaryInformation) {
            NSDate* downloadDate = [[[NSFileManager defaultManager] attributesOfItemAtPath:[self reviewFilePath:title ratingsProvider:ratingsProvider]
                                                                                     error:NULL] objectForKey:NSFileModificationDate];

            if (downloadDate == nil) {
                [infoWithoutReviews setObject:[supplementaryInformation objectForKey:title] forKey:title];
            } else {
                NSTimeInterval span = [downloadDate timeIntervalSinceNow];
                if (ABS(span) > (24 * 60 * 60)) {
                    [infoWithReviews setObject:[supplementaryInformation objectForKey:title] forKey:title];
                }
            }
        }

        [self downloadReviews:infoWithoutReviews ratingsProvider:ratingsProvider];
        [self downloadReviews:infoWithReviews    ratingsProvider:ratingsProvider];
    }
    [gate unlock];
    [autoreleasePool release];
}


@end
