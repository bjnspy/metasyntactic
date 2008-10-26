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

#import "ReviewCache.h"

#import "Application.h"
#import "FileUtilities.h"
#import "Location.h"
#import "MovieRating.h"
#import "NetworkUtilities.h"
#import "NowPlayingAppDelegate.h"
#import "NowPlayingModel.h"
#import "Review.h"
#import "ThreadingUtilities.h"
#import "UserLocationCache.h"
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
    NSString* reviewsFolder = [Application providerReviewsFolder:[self.model.scoreProvider objectAtIndex:ratingsProvider]];
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

        if ([author rangeOfString:@"HREF"].length > 0) {
            continue;
        }

        NSInteger scoreValue = score.intValue;

        [result addObject:[Review reviewWithText:text
                                           score:scoreValue
                                            link:link
                                          author:author
                                          source:source]];
    }

    return result;
}


- (NSString*) serverAddress:(MovieRating*) info {
    Location* location = [model.userLocationCache locationForUserAddress:model.userAddress];

    NSString* country = location.country.length == 0 ? [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]
    : location.country;

    NSString* url =
    [NSString stringWithFormat:@"http://%@.appspot.com/LookupMovieReviews2?country=%@&language=%@&id=%@&provider=%@&latitude=%d&longitude=%d",
     [Application host],
     country,
     [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode],
     info.identifier,
     info.provider,
     (int)(location.latitude * 1000000),
     (int)(location.longitude * 1000000)];

    return url;
}


- (NSArray*) downloadInfoReviews:(MovieRating*) info {
    NSString* url = [self serverAddress:info];

    XmlElement* resultElement = [NetworkUtilities xmlWithContentsOfAddress:url important:NO];

    if (resultElement == nil) {
        return nil;
    }

    return [self extractReviews:resultElement];
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
    NSDictionary* dictionary = [self loadReviewFile:movieTitle ratingsProvider:self.model.scoreProviderIndex];
    if (dictionary == nil) {
        return [NSArray array];
    }

    return [dictionary objectForKey:reviews_key];
}


- (NSString*) reviewsHashForMovie:(NSString*) movieTitle {
    NSDictionary* dictionary = [self loadReviewFile:movieTitle ratingsProvider:self.model.scoreProviderIndex];
    return [dictionary objectForKey:hash_key];
}


- (void) downloadReviews:(NSDictionary*) supplementaryInformation
              ratingsProvider:(NSInteger) ratingsProvider
                forMovie:(NSString*) movieTitle {
    MovieRating* info = [supplementaryInformation objectForKey:movieTitle];
    NSString* url = [[self serverAddress:info] stringByAppendingString:@"&hash=true"];

    NSString* serverHash = [NetworkUtilities stringWithContentsOfAddress:url important:NO];
    if (serverHash == nil) {
        serverHash = @"0";
    }

    NSString* localHash = [self reviewsHashForMovie:movieTitle];

    if ([serverHash isEqual:localHash]) {
        return;
    }

    NSArray* reviews = [self downloadInfoReviews:info];
    if (reviews == nil) {
        // didn't download.  just ignore it.
        return;
    }

    if (reviews.count == 0) {
        // we got no reviews.  only save that fact if we don't currently have
        // any reviews.  This way we don't end up checking every single time
        // for movies that don't have reviews yet
        NSArray* existingReviews = [self reviewsForMovie:movieTitle];
        if (existingReviews.count > 0) {
            // we have reviews already.  don't wipe it out.
            return;
        }
    }

    [self saveMovie:movieTitle reviews:reviews hash:serverHash ratingsProvider:ratingsProvider];
    [NowPlayingAppDelegate refresh];
}


- (void) downloadReviews:(NSDictionary*) supplementaryInformation
         ratingsProvider:(NSInteger) ratingsProvider {
    for (NSString* movieTitle in supplementaryInformation) {
        if (self.model.scoreProviderIndex != ratingsProvider) {
            break;
        }

        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
        {
            [self downloadReviews:supplementaryInformation
                  ratingsProvider:ratingsProvider
                         forMovie:movieTitle];
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
        NSString* path = [self reviewFilePath:title ratingsProvider:ratingsProvider];
        NSDate* downloadDate = [[[NSFileManager defaultManager] attributesOfItemAtPath:path
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