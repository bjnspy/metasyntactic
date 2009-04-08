// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "InternationalDataCache.h"

#import "AppDelegate.h"
#import "Application.h"
#import "CacheUpdater.h"
#import "DateUtilities.h"
#import "DifferenceEngine.h"
#import "FileUtilities.h"
#import "LocaleUtilities.h"
#import "Model.h"
#import "Movie.h"
#import "NetworkUtilities.h"
#import "NotificationCenter.h"
#import "OperationQueue.h"
#import "StringUtilities.h"
#import "XmlElement.h"

@interface InternationalDataCache()
@property (retain) DifferenceEngine* engine;
@property (retain) NSDictionary* indexData;
@property (retain) NSMutableDictionary* movieMap;
@property (retain) NSMutableDictionary* ratingCache;
@property BOOL updated;
@end


@implementation InternationalDataCache

static NSString* trailers_key = @"trailers";

@synthesize engine;
@synthesize indexData;
@synthesize movieMap;
@synthesize ratingCache;
@synthesize updated;

- (void) dealloc {
    self.engine = nil;
    self.indexData = nil;
    self.movieMap = nil;
    self.ratingCache = nil;

    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.engine = [DifferenceEngine engine];
        self.ratingCache = [NSMutableDictionary dictionary];

        mapRatingWorker = NSSelectorFromString([NSString stringWithFormat:@"mapRating_%@:", [LocaleUtilities isoCountry]]);
        if (![self respondsToSelector:mapRatingWorker]) {
            mapRatingWorker = nil;
        }
    }

    return self;
}


+ (InternationalDataCache*) cache {
    NSSet* allowableCountries =
    [NSSet setWithObjects:@"FR", @"DK", @"NL", @"SE", @"DE", @"IT", @"ES", @"CH", @"FI", nil];

    if (![allowableCountries containsObject:[LocaleUtilities isoCountry]]) {
        return nil;
    }

    return [[[InternationalDataCache alloc] init] autorelease];
}


- (NSString*) indexFile {
    NSString* name = [NSString stringWithFormat:@"%@.plist", [LocaleUtilities isoCountry]];
    return [[Application internationalDirectory] stringByAppendingPathComponent:name];
}


- (NSDictionary*) loadIndex {
    NSDictionary* dictionary = [FileUtilities readObject:[self indexFile]];
    if (dictionary == nil) {
        return [NSDictionary dictionary];
    }

    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    for (NSString* title in dictionary) {
        [result setObject:[Movie movieWithDictionary:[dictionary objectForKey:title]] forKey:title];
    }
    return result;
}


- (void) saveIndex:(NSDictionary*) value {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    for (NSString* title in value) {
        [dictionary setObject:[[value objectForKey:title] dictionary] forKey:title];
    }

    [FileUtilities writeObject:dictionary toFile:self.indexFile];
}


- (NSDictionary*) indexWorker {
    if (indexData == nil) {
        self.indexData = [self loadIndex];
    }

    // call through the property to ensure a good pointer
    return self.indexData;
}


- (NSDictionary*) index {
    NSDictionary* result;
    [dataGate lock];
    {
        result = [self indexWorker];
    }
    [dataGate unlock];
    return result;
}


- (Model*) model {
    return [Model model];
}


- (void) update {
    if (self.model.userAddress.length == 0) {
        return;
    }

    if (updated) {
        return;
    }
    self.updated = YES;

    [[OperationQueue operationQueue] performSelector:@selector(updateBackgroundEntryPoint)
                                            onTarget:self
                                                gate:nil
                                            priority:Priority];
}


- (NSArray*) extractArray:(XmlElement*) element {
    NSMutableArray* array = [NSMutableArray array];
    for (XmlElement* child in element.children) {
        [array addObject:child.text];
    }
    return array;
}


- (NSString*) mapRating_FR:(NSString*) value {
    NSInteger i = value.intValue;
    if (i == 99) {
        return @"U";
    }

    if (i == 0) {
        return @"";
    }

    return value;
}


- (NSString*) mapRating_DK:(NSString*) value {
    NSInteger i = value.intValue;
    if (i == 99) {
        return @"A";
    }

    if (i == 0) {
        return @"";
    }

    return value;
}


- (NSString*) mapRating_NL:(NSString*) value {
    NSInteger i = value.intValue;
    if (i == 99) {
        return @"AL";
    }

    if (i == 0) {
        return @"";
    }

    return value;
}


- (NSString*) mapRating_SE:(NSString*) value {
    NSInteger i = value.intValue;
    if (i == 99) {
        return @"Btl";
    }

    if (i == 0) {
        return @"";
    }

    return value;
}


- (NSString*) mapRating_DE:(NSString*) value {
    NSInteger i = value.intValue;
    if (i == 99) {
        return @"FSK 0";
    }

    if (i == 0) {
        return @"";
    }

    return [NSString stringWithFormat:@"FSK %@", value];
}


- (NSString*) mapRating_IT:(NSString*) value {
    NSInteger i = value.intValue;
    if (i == 99) {
        return @"T";
    }

    if (i == 0) {
        return @"";
    }

    return [NSString stringWithFormat:@"VM %@", value];
}


- (NSString*) mapRating_ES:(NSString*) value {
    NSInteger i = value.intValue;
    if (i == 99) {
        return @"Todos los publicos";
    }

    if (i == 0) {
        return @"";
    }

    return value;
}


- (NSString*) mapRating_CH:(NSString*) value {
    NSInteger i = value.intValue;
    if (i == 99) {
        return @"0";
    }

    if (i == 0) {
        return @"";
    }

    return value;
}


- (NSString*) mapRating_FI:(NSString*) value {
    NSInteger i = value.intValue;
    if (i == 99) {
        return @"K-3";
    }

    return [NSString stringWithFormat:@"K-%@", value];
}


- (NSString*) mapRating:(NSString*) value {
    if (value.length == 0) {
        return nil;
    }

    NSString* result = [ratingCache objectForKey:value];
    if (result == nil) {
        if (mapRatingWorker != nil) {
            result = [self performSelector:mapRatingWorker withObject:value];
        } else {
            result = @"";
        }

        [ratingCache setObject:result forKey:value];
    }
    return result;
}


- (Movie*) processMovieElement:(XmlElement*) element {
    static NSInteger identifier = 1;

    NSString* imdbId = [element attributeValue:@"imdb"];
    NSString* imdbAddress = imdbId.length == 0 ? @"" : [NSString stringWithFormat:@"http://www.imdb.com/title/%@", imdbId];

    NSString* title = [[element element:@"title"] text];
    if (title.length == 0) {
        return nil;
    }

    NSString* synopsis = [[element element:@"description"] text];
    NSString* poster = [[element element:@"poster"] text];

    NSMutableArray* trailers = [NSMutableArray array];
    for (XmlElement* trailerElement in [element elements:@"trailer"]) {
        [trailers addObject:[trailerElement.text stringByReplacingOccurrencesOfString:@"|" withString:@"%7C"]];
    }

    NSArray* directors = [self extractArray:[element element:@"directors"]];
    NSArray* cast = [self extractArray:[element element:@"actors"]];
    NSArray* genres = [self extractArray:[element element:@"categories"]];

    NSInteger length = [[[element element:@"duration"] text] intValue];
    NSDate* releaseDate = [DateUtilities parseIS08601Date:[[element element:@"release"] text]];
    NSString* rating = [self mapRating:[[element element:@"rating"] text]];

    NSMutableDictionary* additionalFields = [NSMutableDictionary dictionary];
    [additionalFields setObject:trailers forKey:trailers_key];

    return [Movie movieWithIdentifier:[NSString stringWithFormat:@"%d", identifier++]
                                title:title
                               rating:rating
                               length:length
                          releaseDate:releaseDate
                          imdbAddress:imdbAddress
                               poster:poster
                             synopsis:synopsis
                               studio:nil
                            directors:directors
                                 cast:cast
                               genres:genres
                     additionalFields:additionalFields];
}


- (void) processElement:(XmlElement*) element {
    NSMutableArray* movies = [NSMutableArray array];
    for (XmlElement* child in element.children) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        {
            Movie* movie = [self processMovieElement:child];
            if (movie != nil) {
                [movies addObject:movie];
            }
        }
        [pool release];
    }

    if (movies.count == 0) {
        return;
    }

    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    for (Movie* movie in movies) {
        [dictionary setObject:movie forKey:movie.canonicalTitle.lowercaseString];
    }

    [self saveIndex:dictionary];
    [dataGate lock];
    {
        self.indexData = dictionary;
        self.movieMap = [NSMutableDictionary dictionary];
    }
    [dataGate unlock];
}


- (void) downloadIndex {
    NSString* address = [NSString stringWithFormat:@"http://%@.iphone.filmtrailer.com/v2.0/cinema/AllCinemaMovies/?channel_user_id=391100099-1&format=mov&size=xlarge", [[LocaleUtilities isoCountry] lowercaseString]];
    NSString* fullAddress = [NSString stringWithFormat:@"http://%@.appspot.com/LookupCachedResource?q=%@",
                             [Application host],
                             [StringUtilities stringByAddingPercentEscapes:address]];

    XmlElement* element;
    if ((element = [NetworkUtilities xmlWithContentsOfAddress:fullAddress]) == nil &&
        (element = [NetworkUtilities xmlWithContentsOfAddress:address]) == nil) {
        return;
    }

    [self processElement:element];
}


- (void) updateBackgroundEntryPoint {
    NSDate* modificationDate = [FileUtilities modificationDate:[self indexFile]];
    if (modificationDate != nil) {
        if (ABS(modificationDate.timeIntervalSinceNow) < THREE_DAYS) {
            return;
        }
    }

    NSString* notification = NSLocalizedString(@"international data", nil);
    [NotificationCenter addNotification:notification];
    {
        [self downloadIndex];
    }
    [NotificationCenter removeNotification:notification];
}


- (Movie*) findMovieWorker:(NSString*) title {
    NSDictionary* index = self.index;

    Movie* result;
    if ((result = [index objectForKey:title]) != nil) {
        return result;
    }

    NSString* closestTitle = [engine findClosestMatch:title inArray:index.allKeys];
    if (closestTitle.length == 0) {
        return nil;
    }

    return [index objectForKey:closestTitle];
}


- (Movie*) findInternationalMovie:(Movie*) movie {
    id result;
    [dataGate lock];
    {
        NSString* title = movie.canonicalTitle.lowercaseString;
        result = [movieMap objectForKey:title];
        if (result == nil) {
            result = [self findMovieWorker:title];
            if (result == nil) {
                [movieMap setObject:[NSNull null] forKey:title];
            }
        }
    }
    [dataGate unlock];
    if ([result isKindOfClass:[Movie class]]) {
        return result;
    }

    return nil;
}


- (NSString*) synopsisForMovie:(Movie*) movie {
    return [[self findInternationalMovie:movie] synopsis];
}


- (NSArray*) trailersForMovie:(Movie*) movie {
    return [[[self findInternationalMovie:movie] additionalFields] objectForKey:trailers_key];
}


- (NSArray*) directorsForMovie:(Movie*) movie {
    return [[self findInternationalMovie:movie] directors];
}


- (NSArray*) castForMovie:(Movie*) movie {
    return [[self findInternationalMovie:movie] cast];
}


- (NSString*) imdbAddressForMovie:(Movie*) movie {
    return [[self findInternationalMovie:movie] imdbAddress];
}


- (NSDate*) releaseDateForMovie:(Movie*) movie {
    return [[self findInternationalMovie:movie] releaseDate];
}


- (NSString*) ratingForMovie:(Movie*) movie {
    return [[self findInternationalMovie:movie] rating];
}


- (NSInteger) lengthForMovie:(Movie*) movie {
    return [[self findInternationalMovie:movie] length];
}

@end