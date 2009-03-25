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

#import "UpcomingCache.h"

#import "Application.h"
#import "DateUtilities.h"
#import "GlobalActivityIndicator.h"
#import "Movie.h"
#import "NetworkUtilities.h"
#import "ThreadingUtilities.h"
#import "Utilities.h"
#import "XmlElement.h"

@implementation UpcomingCache

static NSString* movies_key = @"Movies";
static NSString* hash_key = @"Hash";
static NSString* studios_key = @"Studios";
static NSString* titles_key = @"Titles";

@synthesize gate;
@synthesize index;
@synthesize recentMovies;
@synthesize movieMap;

- (void) dealloc {
    self.gate = nil;
    self.index = nil;
    self.recentMovies = nil;
    self.movieMap = nil;

    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.gate = [[[NSRecursiveLock alloc] init] autorelease];
    }

    return self;
}


+ (UpcomingCache*) cache {
    return [[[UpcomingCache alloc] init] autorelease];
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

    [Utilities writeObject:result toFile:[Application upcomingMoviesIndexFile]];
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
                                       length:@""
                                  releaseDate:releaseDate
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
        Movie* movie = [self processMovieElement:movieElement studioKeys:studioKeys titleKeys:titleKeys];
        if (movie != nil) {
            [result addObject:movie];
        }
    }

    return result;
}


- (NSDictionary*) updateMoviesListWorker {
    NSString* localHash = [index objectForKey:hash_key];

    NSString* serverHash = [NetworkUtilities stringWithContentsOfAddress:[NSString stringWithFormat:@"http://%@.appspot.com/LookupUpcomingListings?q=index&hash=true", [Application host]]
                                                        important:NO];
    if (serverHash == nil) {
        serverHash = @"0";
    }

    if (localHash != nil &&
        [localHash isEqual:serverHash]) {
        return [NSDictionary dictionary];
    }

    XmlElement* resultElement = [NetworkUtilities xmlWithContentsOfAddress:[NSString stringWithFormat:@"http://%@.appspot.com/LookupUpcomingListings?q=index", [Application host]]
                                                          important:NO];

    NSMutableDictionary* studioKeys = [NSMutableDictionary dictionary];
    NSMutableDictionary* titleKeys = [NSMutableDictionary dictionary];
    NSArray* movies = [self processResultElement:resultElement studioKeys:studioKeys titleKeys:titleKeys];
    if (movies.count == 0) {
        return [NSDictionary dictionary];
    }

    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    [result setObject:serverHash forKey:hash_key];
    [result setObject:movies forKey:movies_key];
    [result setObject:studioKeys forKey:studios_key];
    [result setObject:titleKeys forKey:titles_key];

    [self writeData:result];

    return result;
}


- (void) updateMoviesList {
    NSAssert(![NSThread isMainThread], @"");

    NSDictionary* index_ = [self updateMoviesListWorker];

    if (index_.count > 0) {
        [self performSelectorOnMainThread:@selector(saveIndex:) withObject:index_ waitUntilDone:NO];
    }
}


- (void) saveIndex:(NSDictionary*) index_ {
    self.index = index_;
    self.recentMovies = nil;
    self.movieMap = nil;

    [self updateMovieDetails];
}


- (void) deleteObsoleteData {

}


- (void) updateMovieDetails {
    NSAssert([NSThread isMainThread], @"");
    [self deleteObsoleteData];

    [ThreadingUtilities performSelector:@selector(updateMovieDetailsInBackgroundEntryPoint:)
                               onTarget:self
               inBackgroundWithArgument:self.index
                                   gate:gate
                                visible:NO];
}


- (NSString*) imdbFile:(Movie*) movie {
    return [[[Application upcomingIMDbFolder] stringByAppendingPathComponent:[Application sanitizeFileName:movie.canonicalTitle]] stringByAppendingPathExtension:@"plist"];
}


- (NSString*) posterFile:(Movie*) movie {
    NSString* fileName = [Application sanitizeFileName:movie.canonicalTitle];
    fileName = [fileName stringByAppendingPathExtension:@"jpg"];
    return [[Application upcomingPostersFolder] stringByAppendingPathComponent:fileName];
}


- (NSString*) synopsisFile:(Movie*) movie {
    return [[[Application upcomingSynopsesFolder] stringByAppendingPathComponent:[Application sanitizeFileName:movie.canonicalTitle]] stringByAppendingPathExtension:@"plist"];
}


- (NSString*) trailersFile:(Movie*) movie {
    return [[[Application upcomingTrailersFolder] stringByAppendingPathComponent:[Application sanitizeFileName:movie.canonicalTitle]] stringByAppendingPathExtension:@"plist"];
}


- (void) updateIMDb:(Movie*) movie {
    NSString* imdbFile = [self imdbFile:movie];
    if ([[NSFileManager defaultManager] fileExistsAtPath:imdbFile]) {
        return;
    }

    NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupIMDbListings?q=%@", [Application host], [Utilities stringByAddingPercentEscapes:movie.canonicalTitle]];
    NSString* imdbAddress = [NetworkUtilities stringWithContentsOfAddress:url important:NO];

    if (![Utilities isNilOrEmpty:imdbAddress]) {
        [Utilities writeObject:imdbAddress toFile:imdbFile];
    }
}


- (void) updatePoster:(Movie*) movie {
    if ([Utilities isNilOrEmpty:movie.poster]) {
        return;
    }

    NSString* posterFile = [self posterFile:movie];
    if ([[NSFileManager defaultManager] fileExistsAtPath:posterFile]) {
        return;
    }

    NSData* data = [NetworkUtilities dataWithContentsOfAddress:movie.poster
                                              important:NO];
    if (data != nil) {
        [data writeToFile:posterFile atomically:YES];
    }
}


- (void) updateSynopsis:(Movie*) movie
                 studio:(NSString*) studio
                  title:(NSString*) title {
    NSString* synopsisFile = [self synopsisFile:movie];
    NSDate* lastLookupDate = [[[NSFileManager defaultManager] attributesOfItemAtPath:synopsisFile
                                                                               error:NULL] objectForKey:NSFileModificationDate];

    if (lastLookupDate != nil) {
        if (ABS(lastLookupDate.timeIntervalSinceNow) < ONE_WEEK) {
            return;
        }
    }

    NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupUpcomingListings?studio=%@&name=%@", [Application host], studio, title];
    NSString* synopsis = [NetworkUtilities stringWithContentsOfAddress:url important:NO];

    if (![Utilities isNilOrEmpty:synopsis]) {
        [Utilities writeObject:synopsis toFile:synopsisFile];
    }
}


- (void) updateTrailers:(Movie*) movie
                 studio:(NSString*) studio
                  title:(NSString*) title {
    NSString* trailersFile = [self trailersFile:movie];

    NSDate* lastLookupDate = [[[NSFileManager defaultManager] attributesOfItemAtPath:trailersFile
                                                                               error:NULL] objectForKey:NSFileModificationDate];

    if (lastLookupDate != nil) {
        if (ABS(lastLookupDate.timeIntervalSinceNow) < (3 * ONE_DAY)) {
            return;
        }
    }

    NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupTrailerListings?studio=%@&name=%@", [Application host], studio, title];
    NSString* trailersString = [NetworkUtilities stringWithContentsOfAddress:url important:NO];
    NSArray* trailers = [trailersString componentsSeparatedByString:@"\n"];

    if (trailers.count) {
        [Utilities writeObject:trailers toFile:trailersFile];
    }
}


- (void) updateDetails:(Movie*) movie studio:(NSString*) studio title:(NSString*) title {
    [self updateIMDb:movie];
    [self updatePoster:movie];
    [self updateSynopsis:movie studio:studio title:title];
    [self updateTrailers:movie studio:studio title:title];
}


- (void) updateMovieDetailsInBackgroundEntryPoint:(NSDictionary*) index_ {
    NSArray* movies = [index_ objectForKey:movies_key];
    NSDictionary* studios = [index_ objectForKey:studios_key];
    NSDictionary* titles = [index_ objectForKey:titles_key];

    for (Movie* movie in movies) {
        NSAutoreleasePool* autoreleasePool = [[NSAutoreleasePool alloc] init];

        [self updateDetails:movie
                     studio:[studios objectForKey:movie.canonicalTitle]
                      title:[titles objectForKey:movie.canonicalTitle]];

        [autoreleasePool release];
    }
}


- (NSDictionary*) loadIndex {
    NSDictionary* dictionary = [NSDictionary dictionaryWithContentsOfFile:[Application upcomingMoviesIndexFile]];
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


- (NSArray*) upcomingMovies {
    if (index == nil) {
        self.index = [self loadIndex];
    }

    if (recentMovies == nil) {
        NSMutableArray* result = [NSMutableArray array];
        NSDate* now = [NSDate date];

        for (Movie* movie in [index objectForKey:movies_key]) {
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
    for (Movie* movie in [index objectForKey:movies_key]) {
        [dictionary setObject:movie forKey:movie.canonicalTitle];
    }
    self.movieMap = dictionary;
}


- (NSArray*) directorsForMovie:(Movie*) movie {
    [self createMovieMap];
    return [[movieMap objectForKey:movie.canonicalTitle] directors];
}


- (NSArray*) castForMovie:(Movie*) movie {
    [self createMovieMap];
    return [[movieMap objectForKey:movie.canonicalTitle] cast];
}


- (NSArray*) genresForMovie:(Movie*) movie {
    [self createMovieMap];
    return [[movieMap objectForKey:movie.canonicalTitle] genres];
}


- (NSString*) imdbAddressForMovie:(Movie*) movie {
    return [Utilities readObject:[self imdbFile:movie]];
}


- (UIImage*) posterForMovie:(Movie*) movie {
    NSData* data = [NSData dataWithContentsOfFile:[self posterFile:movie]];
    if (data == nil) {
        return nil;
    }

    return [UIImage imageWithData:data];
}


- (NSString*) synopsisForMovie:(Movie*) movie {
    return [Utilities readObject:[self synopsisFile:movie]];
}


- (NSArray*) trailersForMovie:(Movie*) movie {
    NSArray* array = [NSArray arrayWithContentsOfFile:[self trailersFile:movie]];
    if (array == nil) {
        return [NSArray array];
    }

    return array;
}


@end