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

#import "UpcomingCache.h"

#import "Application.h"
#import "DateUtilities.h"
#import "FileUtilities.h"
#import "LargePosterCache.h"
#import "LinkedSet.h"
#import "Movie.h"
#import "NetworkUtilities.h"
#import "NowPlayingAppDelegate.h"
#import "NowPlayingModel.h"
#import "ThreadingUtilities.h"
#import "Utilities.h"
#import "XmlElement.h"

@implementation UpcomingCache

static NSString* movies_key = @"Movies";
static NSString* hash_key = @"Hash";
static NSString* studios_key = @"Studios";
static NSString* titles_key = @"Titles";

@synthesize gate;
@synthesize model;
@synthesize indexData;
@synthesize recentMovies;
@synthesize movieMap;
@synthesize prioritizedMovies;

- (void) dealloc {
    self.gate = nil;
    self.model = nil;
    self.indexData = nil;
    self.recentMovies = nil;
    self.movieMap = nil;
    self.prioritizedMovies = nil;

    [super dealloc];
}


- (id) initWithModel:(NowPlayingModel*) model_ {
    if (self = [super init]) {
        self.gate = [[[NSRecursiveLock alloc] init] autorelease];
        self.prioritizedMovies = [LinkedSet setWithCountLimit:8];
        self.model = model_;
    }

    return self;
}


+ (UpcomingCache*) cacheWithModel:(NowPlayingModel*) model {
    return [[[UpcomingCache alloc] initWithModel:model] autorelease];
}


- (NSString*) indexFile {
    return [[Application upcomingFolder] stringByAppendingPathComponent:@"Index.plist"];
}


- (void) writeData:(NSDictionary*) data {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    [result setObject:[data objectForKey:hash_key]       forKey:hash_key];
    [result setObject:[data objectForKey:studios_key]    forKey:studios_key];
    [result setObject:[data objectForKey:titles_key]     forKey:titles_key];

    NSMutableArray* encodedMovies = [NSMutableArray array];
    for (Movie* movie in [data objectForKey:movies_key]) {
        [encodedMovies addObject:movie.dictionary];
    }

    [result setObject:encodedMovies forKey:movies_key];

    [FileUtilities writeObject:result toFile:self.indexFile];
}


- (NSArray*) processArray:(XmlElement*) element {
    NSMutableArray* array = [NSMutableArray array];

    for (XmlElement* child in element.children) {
        [array addObject:[child attributeValue:@"value"]];
    }

    return array;
}


- (Movie*) processMovieElement:(XmlElement*) movieElement
                    studioKeys:(NSMutableDictionary*) studioKeys
                     titleKeys:(NSMutableDictionary*) titleKeys  {
    NSDate* releaseDate = [DateUtilities dateWithNaturalLanguageString:[movieElement attributeValue:@"date"]];
    NSString* poster = [movieElement attributeValue:@"poster"];
    NSString* rating = [movieElement attributeValue:@"rating"];
    NSString* studio = [movieElement attributeValue:@"studio"];
    NSString* title = [movieElement attributeValue:@"title"];
    NSArray* directors = [self processArray:[movieElement element:@"directors"]];
    NSArray* cast = [self processArray:[movieElement element:@"actors"]];
    NSArray* genres = [self processArray:[movieElement element:@"genres"]];

    NSString* studioKey = [movieElement attributeValue:@"studioKey"];
    NSString* titleKey = [movieElement attributeValue:@"titleKey"];

    Movie* movie = [Movie movieWithIdentifier:[NSString stringWithFormat:@"%d", movieElement]
                                        title:title
                                       rating:rating
                                       length:0
                                  releaseDate:releaseDate
                                  imdbAddress:@""
                                       poster:poster
                                     synopsis:@""
                                       studio:studio
                                    directors:directors
                                         cast:cast
                                       genres:genres];

    [studioKeys setObject:studioKey forKey:movie.canonicalTitle];
    [titleKeys setObject:titleKey forKey:movie.canonicalTitle];

    return movie;
}


- (NSArray*) processResultElement:(XmlElement*) resultElement
                       studioKeys:(NSMutableDictionary*) studioKeys
                        titleKeys:(NSMutableDictionary*) titleKeys {
    NSMutableArray* result = [NSMutableArray array];

    for (XmlElement* movieElement in resultElement.children) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        {
            Movie* movie = [self processMovieElement:movieElement studioKeys:studioKeys titleKeys:titleKeys];
            if (movie != nil) {
                [result addObject:movie];
            }
        }
        [pool release];
    }

    return result;
}


- (NSDictionary*) loadIndex {
    NSDictionary* dictionary = [FileUtilities readObject:self.indexFile];
    if (dictionary == nil) {
        return [NSDictionary dictionary];
    }
    
    NSMutableArray* decodedMovies = [NSMutableArray array];
    for (NSDictionary* encodedMovie in [dictionary objectForKey:movies_key]) {
        [decodedMovies addObject:[Movie movieWithDictionary:encodedMovie]];
    }
    
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    [result setObject:decodedMovies forKey:movies_key];
    [result setObject:[dictionary objectForKey:hash_key] forKey:hash_key];
    [result setObject:[dictionary objectForKey:studios_key] forKey:studios_key];
    [result setObject:[dictionary objectForKey:titles_key] forKey:titles_key];
    
    return result;
}


- (NSDictionary*) index {
    if (indexData == nil) {
        self.indexData = [self loadIndex];
    }
    
    return indexData;
}


- (void) updateIndex {
    [ThreadingUtilities performSelector:@selector(updateIndexBackgroundEntryPoint:)
                               onTarget:self
               inBackgroundWithArgument:[self.index objectForKey:movies_key]
                                   gate:gate
                                visible:YES];
}


- (void) deleteObsoleteData:(NSArray*) movies {
    if (movies.count == 0) {
        return;
    }

    /*
    [self deleteObsoleteCastData:movies];
    [self deleteObsoleteIMDbData:movies];
    [self deleteObsoletePostersData:movies];
    [self deleteObsoleteSynopsesData:movies];
    [self deleteObsoleteTrailersData:movies];
     */
}


- (void) updateIndexBackgroundEntryPoint:(NSArray*) oldMovies {
    [self deleteObsoleteData:oldMovies];
    
    NSDate* lastLookupDate = [FileUtilities modificationDate:self.indexFile];

    if (lastLookupDate != nil) {
        if (ABS([lastLookupDate timeIntervalSinceNow]) < (3 * ONE_DAY)) {
            return;
        }
    }


    NSString* localHash = [self.index objectForKey:hash_key];
    NSString* serverHash = [NetworkUtilities stringWithContentsOfAddress:[NSString stringWithFormat:@"http://%@.appspot.com/LookupUpcomingListings?q=index&hash=true", [Application host]]
                                                               important:NO];
    if (serverHash == nil) {
        serverHash = @"0";
    }

    if (localHash != nil &&
        [localHash isEqual:serverHash]) {
        return;
    }

    XmlElement* resultElement = [NetworkUtilities xmlWithContentsOfAddress:[NSString stringWithFormat:@"http://%@.appspot.com/LookupUpcomingListings?q=index", [Application host]]
                                                                 important:NO];

    NSMutableDictionary* studioKeys = [NSMutableDictionary dictionary];
    NSMutableDictionary* titleKeys = [NSMutableDictionary dictionary];
    NSArray* movies = [self processResultElement:resultElement studioKeys:studioKeys titleKeys:titleKeys];
    if (movies.count == 0) {
        return;
    }

    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    [result setObject:serverHash forKey:hash_key];
    [result setObject:movies forKey:movies_key];
    [result setObject:studioKeys forKey:studios_key];
    [result setObject:titleKeys forKey:titles_key];

    [self writeData:result];
    [self performSelectorOnMainThread:@selector(reportIndex:) withObject:result waitUntilDone:NO];
}


- (void) updateDetails {
    NSAssert([NSThread isMainThread], @"");
    [ThreadingUtilities performSelector:@selector(updateDetailsInBackgroundEntryPoint:)
                               onTarget:self
               inBackgroundWithArgument:self.index
                                   gate:gate
                                visible:NO];
}


- (void) update {
    [self updateIndex];
    [self updateDetails];
}


- (void) reportIndex:(NSDictionary*) result {
    self.indexData = result;
    self.recentMovies = nil;
    self.movieMap = nil;

    [self updateDetails];
}


- (void) deleteObsoleteData {

}


- (NSString*) castFile:(Movie*) movie {
    return [[[Application upcomingCastFolder] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]] stringByAppendingPathExtension:@"plist"];
}


- (NSString*) imdbFile:(Movie*) movie {
    return [[[Application upcomingIMDbFolder] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]] stringByAppendingPathExtension:@"plist"];
}


- (NSString*) posterFile:(Movie*) movie {
    NSString* fileName = [FileUtilities sanitizeFileName:movie.canonicalTitle];
    fileName = [fileName stringByAppendingPathExtension:@"jpg"];
    return [[Application upcomingPostersFolder] stringByAppendingPathComponent:fileName];
}


- (NSString*) synopsisFile:(Movie*) movie {
    return [[[Application upcomingSynopsesFolder] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]] stringByAppendingPathExtension:@"plist"];
}


- (NSString*) trailersFile:(Movie*) movie {
    return [[[Application upcomingTrailersFolder] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]] stringByAppendingPathExtension:@"plist"];
}


- (void) updateIMDb:(Movie*) movie {
    NSString* imdbFile = [self imdbFile:movie];

    NSDate* lastLookupDate = [FileUtilities modificationDate:imdbFile];
    if (lastLookupDate != nil) {
        NSString* value = [FileUtilities readObject:imdbFile];
        if (value.length > 0) {
            // we have a real imdb value for this movie
            return;
        }

        // we have a sentinel.  only update if it's been long enough
        if (ABS([lastLookupDate timeIntervalSinceNow]) < (3 * ONE_DAY)) {
            return;
        }
    }

    NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupIMDbListings?q=%@", [Application host], [Utilities stringByAddingPercentEscapes:movie.canonicalTitle]];
    NSString* imdbAddress = [NetworkUtilities stringWithContentsOfAddress:url important:NO];
    if (imdbAddress == nil) {
        return;
    }

    // write down the response (even if it is empty).  An empty value will
    // ensure that we don't update this entry too often.
    [FileUtilities writeObject:imdbAddress toFile:imdbFile];
    [NowPlayingAppDelegate refresh];
}


- (void) updatePoster:(Movie*) movie {
    if (movie.poster.length == 0) {
        [self.model.largePosterCache downloadFirstPosterForMovie:movie];
        return;
    }

    NSString* posterFile = [self posterFile:movie];
    if ([FileUtilities fileExists:posterFile]) {
        return;
    }

    NSData* data = [NetworkUtilities dataWithContentsOfAddress:movie.poster
                                              important:NO];
    if (data != nil) {
        [FileUtilities writeData:data toFile:posterFile];
    }
}


- (void) updateSynopsisAndCast:(Movie*) movie
                 studio:(NSString*) studio
                  title:(NSString*) title {
    NSString* synopsisFile = [self synopsisFile:movie];
    NSDate* lastLookupDate = [FileUtilities modificationDate:synopsisFile];

    if (lastLookupDate != nil) {
        if (ABS(lastLookupDate.timeIntervalSinceNow) < ONE_WEEK) {
            return;
        }
    }

    NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupUpcomingListings?studio=%@&name=%@&format=2", [Application host], studio, title];
    NSString* result = [NetworkUtilities stringWithContentsOfAddress:url important:NO];

    if (result.length == 0) {
        return;
    }

    if ([result rangeOfString:@"403 Over Quota"].length > 0) {
        return;
    }

    NSArray* components = [result componentsSeparatedByString:@"\n"];
    if (components.count == 0) {
        return;
    }

    NSString* synopsis = [components objectAtIndex:0];
    NSMutableArray* cast = [NSMutableArray arrayWithArray:components];
    [cast removeObjectAtIndex:0];

    if (synopsis.length != 0 &&
        ![synopsis hasPrefix:@"No synopsis"]) {
        [FileUtilities writeObject:synopsis toFile:synopsisFile];
    }

    if (cast.count > 0) {
        [FileUtilities writeObject:cast toFile:[self castFile:movie]];
    }

    [NowPlayingAppDelegate refresh];
}


- (void) updateTrailers:(Movie*) movie
                 studio:(NSString*) studio
                  title:(NSString*) title {
    NSString* trailersFile = [self trailersFile:movie];
    NSDate* lastLookupDate = [FileUtilities modificationDate:trailersFile];

    if (lastLookupDate != nil) {
        if (ABS(lastLookupDate.timeIntervalSinceNow) < (3 * ONE_DAY)) {
            return;
        }
    }

    NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupTrailerListings?studio=%@&name=%@", [Application host], studio, title];
    NSString* trailersString = [NetworkUtilities stringWithContentsOfAddress:url important:NO];
    if (trailersString == nil) {
        NSLog(@"", nil);
        return;
    }

    NSArray* trailers = [trailersString componentsSeparatedByString:@"\n"];
    [FileUtilities writeObject:trailers toFile:trailersFile];
    [NowPlayingAppDelegate refresh];
}


- (void) updateDetails:(Movie*) movie studio:(NSString*) studio title:(NSString*) title {
    [self updateIMDb:movie];
    [self updatePoster:movie];
    [self updateSynopsisAndCast:movie studio:studio title:title];
    [self updateTrailers:movie studio:studio title:title];
}


- (Movie*) getNextMovie:(NSMutableArray*) movies {
    Movie* movie = [prioritizedMovies removeLastObjectAdded];

    if (movie != nil) {
        return movie;
    }

    if (movies.count > 0) {
        movie = [[[movies lastObject] retain] autorelease];
        [movies removeLastObject];
        return movie;
    }

    return nil;
}


- (void) updateDetailsInBackgroundEntryPoint:(NSDictionary*) index_ {
    [self deleteObsoleteData];

    NSArray* movies = [index_ objectForKey:movies_key];
    if (movies == nil) {
        return;
    }

    NSMutableArray* mutableMovies = [NSMutableArray arrayWithArray:movies];
    NSDictionary* studios = [index_ objectForKey:studios_key];
    NSDictionary* titles = [index_ objectForKey:titles_key];

    Movie* movie;
    do {
        NSAutoreleasePool* autoreleasePool = [[NSAutoreleasePool alloc] init];
        {
            movie = [self getNextMovie:mutableMovies];
            if (movie != nil) {
                [self updateDetails:movie
                             studio:[studios objectForKey:movie.canonicalTitle]
                              title:[titles objectForKey:movie.canonicalTitle]];
            }
        }
        [autoreleasePool release];
    } while (movie != nil);
}


- (void) prioritizeMovie:(Movie*) movie {
    [prioritizedMovies addObject:movie];
}


- (NSArray*) upcomingMovies {
    if (recentMovies == nil) {
        NSMutableArray* result = [NSMutableArray array];
        NSDate* now = [NSDate date];

        for (Movie* movie in [self.index objectForKey:movies_key]) {
            if ([now compare:movie.releaseDate] == NSOrderedDescending) {
                continue;
            }

            [result addObject:movie];
        }

        self.recentMovies = result;
    }

    if (recentMovies == nil) {
        return [NSArray array];
    }

    return recentMovies;
}


- (void) createMovieMap {
    if (movieMap != nil) {
        return;
    }

    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    for (Movie* movie in [self.index objectForKey:movies_key]) {
        [dictionary setObject:movie forKey:movie.canonicalTitle];
    }
    self.movieMap = dictionary;
}


- (NSDate*) releaseDateForMovie:(Movie*) movie {
    [self createMovieMap];
    return [[movieMap objectForKey:movie.canonicalTitle] releaseDate];
}


- (NSArray*) directorsForMovie:(Movie*) movie {
    [self createMovieMap];
    return [[movieMap objectForKey:movie.canonicalTitle] directors];
}


- (NSArray*) castForMovie:(Movie*) movie {
    [self createMovieMap];
    NSArray* result = [[movieMap objectForKey:movie.canonicalTitle] cast];
    if (result.count > 0) {
        return result;
    }

    result = [FileUtilities readObject:[self castFile:movie]];
    if (result.count > 0) {
        return result;
    }

    return [NSArray array];
}


- (NSArray*) genresForMovie:(Movie*) movie {
    [self createMovieMap];
    return [[movieMap objectForKey:movie.canonicalTitle] genres];
}


- (NSString*) imdbAddressForMovie:(Movie*) movie {
    return [FileUtilities readObject:[self imdbFile:movie]];
}


- (UIImage*) posterForMovie:(Movie*) movie {
    NSData* data = [FileUtilities readData:[self posterFile:movie]];
    if (data == nil) {
        return nil;
    }

    return [UIImage imageWithData:data];
}


- (NSString*) synopsisForMovie:(Movie*) movie {
    return [FileUtilities readObject:[self synopsisFile:movie]];
}


- (NSArray*) trailersForMovie:(Movie*) movie {
    NSArray* array = [FileUtilities readObject:[self trailersFile:movie]];
    if (array == nil) {
        return [NSArray array];
    }

    return array;
}

@end