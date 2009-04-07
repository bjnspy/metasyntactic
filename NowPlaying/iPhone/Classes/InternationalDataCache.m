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
@property (retain) NSSet* allowableCountries;
@property (retain) DifferenceEngine* engine;
@property (retain) NSDictionary* indexData;
@property (retain) NSMutableDictionary* movieMap;
@property BOOL updated;
@end


@implementation InternationalDataCache

static NSString* trailers_key = @"trailers";

@synthesize allowableCountries;
@synthesize engine;
@synthesize indexData;
@synthesize movieMap;
@synthesize updated;

- (void) dealloc {
    self.allowableCountries = nil;
    self.engine = nil;
    self.indexData = nil;
    self.movieMap = nil;

    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.engine = [DifferenceEngine engine];
        
        self.allowableCountries =
        [NSSet setWithObjects:@"FR", @"DK", @"NL", @"SE", @"DE", @"IT", @"ES", @"CH", @"FI", nil];
    }
    
    return self;
}


+ (InternationalDataCache*) cache {
    return [[[InternationalDataCache alloc] init] autorelease];
}


- (NSString*) indexFile {
    return [[Application internationalDirectory] stringByAppendingPathComponent:@"Index.plist"];
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

    NSMutableDictionary* additionalFields = [NSMutableDictionary dictionary];
    [additionalFields setObject:trailers forKey:trailers_key];

    return [Movie movieWithIdentifier:[NSString stringWithFormat:@"%d", identifier++]
                                title:title
                               rating:nil
                               length:0
                          releaseDate:nil
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
    
    [AppDelegate majorRefresh];
}


- (void) downloadIndex {
    NSString* address = [NSString stringWithFormat:@"http://%@.iphone.filmtrailer.com/v2.0/cinema/AllCinemaMovies/?channel_user_id=391100099-1&format=mov&size=xlarge", [[LocaleUtilities isoCountry] lowercaseString]];
    NSString* fullAddress = [NSString stringWithFormat:@"http://%@.appspot.com/LookupCachedResource?q=%@",
                             [Application host],
                             [StringUtilities stringByAddingPercentEscapes:address]];
    
    XmlElement* element = [NetworkUtilities xmlWithContentsOfAddress:fullAddress];
    if (element == nil) {
        return;
    }
    
    [self processElement:element];
}


- (void) updateBackgroundEntryPointWorker {
    NSDate* modificationDate = [FileUtilities modificationDate:[self indexFile]];
    if (modificationDate != nil) {
        if (ABS(modificationDate.timeIntervalSinceNow) < 3 * ONE_DAY) {
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


- (void) updateBackgroundEntryPoint {
    if (![allowableCountries containsObject:[LocaleUtilities isoCountry]]) {
        return;
    }
    
    [self updateBackgroundEntryPointWorker];
    //[[CacheUpdater cacheUpdater] addMovies:self.index.allValues];
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
    if (![allowableCountries containsObject:[LocaleUtilities isoCountry]]) {
        return nil;
    }

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

@end