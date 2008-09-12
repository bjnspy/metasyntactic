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

#import "ReviewCache.h"

#import "Application.h"
#import "ExtraMovieInformation.h"
#import "FileUtilities.h"
#import "GlobalActivityIndicator.h"
#import "NetworkUtilities.h"
#import "NowPlayingModel.h"
#import "Review.h"
#import "ThreadingUtilities.h"
#import "Utilities.h"
#import "XmlElement.h"

@implementation ReviewCache

static NSString* reviews_key = @"Reviews";
static NSString* hash_key = @"Hash";

@synthesize model;
@synthesize gate;

- (void) dealloc {
    self.model = nil;
    self.gate = nil;

    [super dealloc];
}


- (id) initWithModel:(NowPlayingModel*) model_ {
    if (self = [super init]) {
        self.model = model_;
        self.gate = [[[NSLock alloc] init] autorelease];
    }

    return self;
}


+ (ReviewCache*) cacheWithModel:(NowPlayingModel*) model {
    return [[[ReviewCache alloc] initWithModel:model] autorelease];
}


- (NSString*) reviewFilePath:(NSString*) title ratingsProvider:(NSInteger) ratingsProvider {
    NSString* sanitizedTitle = [FileUtilities sanitizeFileName:title];
    NSString* reviewsFolder = [Application providerReviewsFolder:[self.model.ratingsProviders objectAtIndex:ratingsProvider]];
    return [[reviewsFolder stringByAppendingPathComponent:sanitizedTitle] stringByAppendingPathExtension:@"plist"];
}


- (NSDictionary*) loadReviewFile:(NSString*) title ratingsProvider:(NSInteger) ratingsProvider {
    NSDictionary* encodedDictionary = [NSDictionary dictionaryWithContentsOfFile:[self reviewFilePath:title ratingsProvider:ratingsProvider]];
    if (encodedDictionary == nil) {
        return [NSDictionary dictionary];
    }

    NSMutableArray* reviews = [NSMutableArray array];
    for (NSDictionary* dict in [encodedDictionary objectForKey:reviews_key]) {
        [reviews addObject:[Review reviewWithDictionary:dict]];
    }

    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    [result setObject:reviews forKey:reviews_key];
    [result setObject:[encodedDictionary objectForKey:hash_key] forKey:hash_key];

    return result;
}


- (void)       update:(NSDictionary*) supplementaryInformation
      ratingsProvider:(NSInteger) ratingsProvider {
    NSArray* arguments = [NSArray arrayWithObjects:supplementaryInformation, [NSNumber numberWithInt:ratingsProvider], nil];
    [ThreadingUtilities performSelector:@selector(backgroundEntryPoint:)
                               onTarget:self
               inBackgroundWithArgument:arguments
                                   gate:gate
                                visible:NO];
}


- (NSArray*) extractReviews:(XmlElement*) resultElement {
    NSMutableArray* result = [NSMutableArray array];

    for (XmlElement* reviewElement in resultElement.children) {
        NSString* text =   [reviewElement attributeValue:@"text"];
        NSString* score =  [reviewElement attributeValue:@"score"];
        NSString* link =   [reviewElement attributeValue:@"link"];
        NSString* author = [reviewElement attributeValue:@"author"];
        NSString* source = [reviewElement attributeValue:@"source"];

        NSInteger scoreValue = score.intValue;

        [result addObject:[Review reviewWithText:text
                                           score:scoreValue
                                            link:link
                                          author:author
                                          source:source]];
    }

    return result;
}


- (NSArray*) downloadInfoReviews:(ExtraMovieInformation*) info {
    NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupMovieReviews?q=%@&format=xml", [Application host], info.link];
    XmlElement* resultElement = [NetworkUtilities xmlWithContentsOfAddress:url important:NO];

    if (resultElement != nil) {
        return [self extractReviews:resultElement];
    }

    return nil;
}


- (void) saveMovie:(NSString*) title reviews:(NSArray*) reviews hash:(NSString*) hash ratingsProvider:(NSInteger) ratingsProvider {
    NSMutableArray* encodedReviews = [NSMutableArray array];
    for (Review* review in reviews) {
        [encodedReviews addObject:review.dictionary];
    }

    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:encodedReviews forKey:reviews_key];
    [dictionary setObject:hash forKey:hash_key];

    [FileUtilities writeObject:dictionary toFile:[self reviewFilePath:title ratingsProvider:ratingsProvider]];
}


- (NSArray*) reviewsForMovie:(NSString*) movieTitle {
    NSDictionary* dictionary = [self loadReviewFile:movieTitle ratingsProvider:self.model.ratingsProviderIndex];
    if (dictionary == nil) {
        return [NSArray array];
    }

    return [dictionary objectForKey:reviews_key];
}


- (NSString*) reviewsHashForMovie:(NSString*) movieTitle {
    NSDictionary* dictionary = [self loadReviewFile:movieTitle ratingsProvider:self.model.ratingsProviderIndex];
    return [dictionary objectForKey:hash_key];
}


- (void) downloadReviews:(NSDictionary*) supplementaryInformation
         ratingsProvider:(NSInteger) ratingsProvider {
    for (NSString* movieId in supplementaryInformation) {
        if (self.model.ratingsProviderIndex != ratingsProvider) {
            break;
        }

        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];

        ExtraMovieInformation* info = [supplementaryInformation objectForKey:movieId];
        if (info.link.length > 0) {
            NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupMovieReviews?q=%@&format=xml&hash=true", [Application host], info.link];
            NSString* serverHash = [NetworkUtilities stringWithContentsOfAddress:url important:NO];
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


- (void) backgroundEntryPoint:(NSArray*) arguments {
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
            NSTimeInterval span = downloadDate.timeIntervalSinceNow;
            if (ABS(span) > (2 * ONE_DAY)) {
                [infoWithReviews setObject:[supplementaryInformation objectForKey:title] forKey:title];
            }
        }
    }

    [self downloadReviews:infoWithoutReviews ratingsProvider:ratingsProvider];
    [self downloadReviews:infoWithReviews    ratingsProvider:ratingsProvider];
}


@end