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

#import "AbstractDVDBlurayCache.h"

#import "Application.h"
#import "DVD.h"
#import "DateUtilities.h"
#import "FileUtilities.h"
#import "ImageUtilities.h"
#import "LargePosterCache.h"
#import "LinkedSet.h"
#import "Movie.h"
#import "NetworkUtilities.h"
#import "NowPlayingAppDelegate.h"
#import "NowPlayingModel.h"
#import "PointerSet.h"
#import "ThreadingUtilities.h"
#import "Utilities.h"
#import "XmlElement.h"

@interface AbstractDVDBlurayCache()
@property (retain) PointerSet* moviesSetData;
@property (retain) NSArray* moviesData;
@property (retain) LinkedSet* prioritizedMovies;
@property (retain) NSMutableDictionary* bookmarksData;
@end


@implementation AbstractDVDBlurayCache

@synthesize moviesSetData;
@synthesize moviesData;
@synthesize prioritizedMovies;
@synthesize bookmarksData;

- (void) dealloc {
    self.moviesSetData = nil;
    self.moviesData = nil;
    self.prioritizedMovies = nil;
    self.bookmarksData = nil;

    [super dealloc];
}


- (id) initWithModel:(NowPlayingModel*) model_ {
    if (self = [super initWithModel:model_]) {
        self.prioritizedMovies = [LinkedSet set];
    }

    return self;
}


- (NSString*) serverAddress {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (NSString*) directory {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (NSString*) detailsDirectory {
    return [self.directory stringByAppendingPathComponent:@"Details"];
}


- (NSString*) postersDirectory {
    return [self.directory stringByAppendingPathComponent:@"Posters"];
}


- (NSString*) imdbDirectory {
    return [self.directory stringByAppendingPathComponent:@"IMDb"];
}


- (NSString*) moviesFile {
    return [[self directory] stringByAppendingPathComponent:@"Movies.plist"];
}


- (NSString*) bookmarksFile {
    return [[self directory] stringByAppendingPathComponent:@"Bookmarks.plist"];
}


- (NSArray*) decodeMovieArray:(NSArray*) array {
    if (array == nil) {
        return [NSArray array];
    }

    NSMutableArray* result = [NSMutableArray array];
    for (NSDictionary* dictionary in array) {
        [result addObject:[Movie movieWithDictionary:dictionary]];
    }

    return result;
}


- (NSArray*) loadMovies:(NSString*) file {
    NSArray* encodedMovies = [FileUtilities readObject:file];
    return [self decodeMovieArray:encodedMovies];
}


- (NSArray*) loadMovies {
    return [self loadMovies:self.moviesFile];
}


- (void) setMovies:(NSArray*) array {
    self.moviesData = array;
    self.moviesSetData = [PointerSet setWithArray:array];
}


- (NSArray*) movies {
    if (moviesData == nil) {
        [self setMovies:[self loadMovies]];
    }

    return moviesData;
}


- (PointerSet*) moviesSet {
    [self movies];
    return moviesSetData;
}


- (NSMutableDictionary*) loadBookmarks {
    NSArray* movies = [self loadMovies:self.bookmarksFile];
    if (movies.count == 0) {
        return [NSMutableDictionary dictionary];
    }

    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    for (Movie* movie in movies) {
        [result setObject:movie forKey:movie.canonicalTitle];
    }

    return result;
}


- (NSMutableDictionary*) bookmarks {
    if (bookmarksData == nil) {
        self.bookmarksData = [self loadBookmarks];
    }

    return bookmarksData;
}


- (void) updateMovies {
    [ThreadingUtilities performSelector:@selector(updateMoviesBackgroundEntryPoint)
                               onTarget:self
               inBackgroundWithGate:gate
                                visible:YES];
}


- (void) updateDetails {
    [ThreadingUtilities performSelector:@selector(updateDetailsBackgroundEntryPoint:)
                               onTarget:self
               inBackgroundWithArgument:self.movies
                                   gate:gate
                                visible:NO];
}


- (void) update {
    if (model.userAddress.length == 0) {
        return;
    }

    [self updateMovies];
    [self updateDetails];
}


- (NSArray*) split:(NSString*) value {
    if (value.length == 0) {
        return [NSArray array];
    }

    return [value componentsSeparatedByString:@"/"];
}


- (NSString*) massage:(NSString*) text {
    unichar a1[] = { 0xE2, 0x20AC, 0x201C };
    text = [text stringByReplacingOccurrencesOfString:[NSString stringWithCharacters:a1 length:ArrayLength(a1)]
                                           withString:@"-"];

    unichar a2[] = { 0xEF, 0xBF, 0xBD };
    text = [text stringByReplacingOccurrencesOfString:[NSString stringWithCharacters:a2 length:ArrayLength(a2)]
                                           withString:@"'"];

    unichar a3[] = { 0xE2, 0x20AC, 0x153 };
    text = [text stringByReplacingOccurrencesOfString:[NSString stringWithCharacters:a3 length:ArrayLength(a3)]
                                           withString:@"\""];

    unichar a4[] = { 0xE2, 0x20AC, 0x9D };
    text = [text stringByReplacingOccurrencesOfString:[NSString stringWithCharacters:a4 length:ArrayLength(a4)]
                                           withString:@"\""];

    unichar a5[] = { 0xE2, 0x20AC, 0x2122 };
    text = [text stringByReplacingOccurrencesOfString:[NSString stringWithCharacters:a5 length:ArrayLength(a5)]
                                           withString:@"'"];

    unichar a6[] = { 0xC2, 0xA0 };
    text = [text stringByReplacingOccurrencesOfString:[NSString stringWithCharacters:a6 length:ArrayLength(a6)]
                                           withString:@" "];

    unichar a7[] = { 0xE2, 0x20AC, 0x201D };
    text = [text stringByReplacingOccurrencesOfString:[NSString stringWithCharacters:a7 length:ArrayLength(a7)]
                                           withString:@"-"];

    unichar a8[] = { 0xC2, 0xAE };
    text = [text stringByReplacingOccurrencesOfString:[NSString stringWithCharacters:a8 length:ArrayLength(a8)]
                                           withString:@"®"];

    unichar a9[] = { 0xE2, 0x20AC, 0xA2 };
    text = [text stringByReplacingOccurrencesOfString:[NSString stringWithCharacters:a9 length:ArrayLength(a9)]
                                           withString:@"•"];

    return text;
}


- (void) processVideoElement:(XmlElement*) videoElement
                      result:(NSMutableDictionary*) result {
    NSString* title = [videoElement attributeValue:@"title"];
    NSString* releaseDateString = [videoElement attributeValue:@"release_date"];
    NSString* price = [videoElement attributeValue:@"retail_price"];
    NSString* rating = [videoElement attributeValue:@"mpaa_rating"];
    NSString* format = [videoElement attributeValue:@"format"];
    NSArray* genres = [self split:[videoElement attributeValue:@"genre"]];
    NSArray* cast = [self split:[videoElement attributeValue:@"cast"]];
    NSArray* directors = [self split:[videoElement attributeValue:@"director"]];
    NSString* discs = [videoElement attributeValue:@"discs"];
    NSString* poster = [videoElement attributeValue:@"image"];
    NSString* synopsis = [videoElement attributeValue:@"synopsis"];
    NSDate* releaseDate = [DateUtilities parseIS08601Date:releaseDateString];
    NSString* url = [videoElement attributeValue:@"url"];
    NSString* length = [videoElement attributeValue:@"length"];
    NSString* studio = [videoElement attributeValue:@"studio"];

    synopsis = [self massage:synopsis];

    DVD* dvd = [DVD dvdWithTitle:title
                           price:price
                          format:format
                           discs:discs
                             url:url];

    Movie* movie = [Movie movieWithIdentifier:[NSString stringWithFormat:@"%d", dvd]
                                        title:title
                                       rating:rating
                                       length:[length intValue]
                                  releaseDate:releaseDate
                                  imdbAddress:@""
                                       poster:poster
                                     synopsis:synopsis
                                       studio:studio
                                    directors:directors
                                         cast:cast
                                       genres:genres];

    [result setObject:dvd forKey:movie];
}


- (NSDictionary*) processElement:(XmlElement*) element {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];

    for (XmlElement* child in element.children) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        {
            [self processVideoElement:child result:result];
        }
        [pool release];
    }

    return result;
}


- (NSString*) detailsFile:(Movie*) movie set:(PointerSet*) movies {
    if (movies == nil || [movies containsObject:movie]) {
        return [[[self detailsDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]]
                stringByAppendingString:@".plist"];
    }

    return nil;
}


- (NSString*) detailsFile:(Movie*) movie {
    NSAssert([NSThread isMainThread], @"");

    return [self detailsFile:movie set:self.moviesSet];
}


- (NSString*) imdbFile:(Movie*) movie set:(PointerSet*) movies {
    if (movies == nil || [movies containsObject:movie]) {
        return [[[self imdbDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]]
                stringByAppendingString:@".plist"];
    }

    return nil;
}


- (NSString*) imdbFile:(Movie*) movie {
    NSAssert([NSThread isMainThread], @"");

    return [self imdbFile:movie set:self.moviesSet];
}


- (NSString*) posterFile:(Movie*) movie set:(PointerSet*) movies {
    if (movies == nil || [movies containsObject:movie]) {
        return [[[self postersDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]]
                stringByAppendingString:@".jpg"];
    }

    return nil;
}


- (NSString*) smallPosterFile:(Movie*) movie set:(PointerSet*) movies {
    if (movies == nil || [movies containsObject:movie]) {
        return [[[self postersDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]]
                stringByAppendingString:@"-small.png"];
    }

    return nil;
}


- (NSString*) posterFile:(Movie*) movie {
    NSAssert([NSThread isMainThread], @"");

    return [self posterFile:movie set:self.moviesSet];
}


- (NSString*) smallPosterFile:(Movie*) movie {
    NSAssert([NSThread isMainThread], @"");

    return [self smallPosterFile:movie set:self.moviesSet];
}


- (void) saveVideosArray:(NSArray*) videos toFile:(NSString*) file {
    NSMutableArray* encoded = [NSMutableArray array];
    for (Movie* video in videos) {
        [encoded addObject:video.dictionary];
    }
    [FileUtilities writeObject:encoded toFile:file];
}


- (void) saveData:(NSDictionary*) dictionary {
    NSArray* videos = dictionary.allKeys;

    for (Movie* movie in dictionary) {
        DVD* dvd = [dictionary objectForKey:movie];
        [FileUtilities writeObject:dvd.dictionary toFile:[self detailsFile:movie set:nil]];
    }

    // do this last.  it signifies that we're done
    [self saveVideosArray:videos toFile:self.moviesFile];
}


- (NSSet*) cachedDirectoriesToClear {
    return [NSSet setWithObjects:
            [self detailsDirectory],
            [self imdbDirectory],
            [self postersDirectory], nil];
}


- (void) updateMoviesBackgroundEntryPoint {
    NSDate* lastUpdateDate = [FileUtilities modificationDate:self.moviesFile];
    if (lastUpdateDate != nil) {
        if (ABS(lastUpdateDate.timeIntervalSinceNow) < (3 * ONE_DAY)) {
            return;
        }
    }

    XmlElement* element = [NetworkUtilities xmlWithContentsOfAddress:self.serverAddress
                                                           important:YES];

    if (element == nil) {
        return;
    }

    NSDictionary* map = [self processElement:element];

    if (map.count == 0) {
        return;
    }

    [self saveData:map];

    [self performSelectorOnMainThread:@selector(reportResults:)
                           withObject:map
                        waitUntilDone:NO];
}


- (void) saveBookmarks {
    [self saveVideosArray:self.bookmarks.allValues toFile:self.bookmarksFile];
}


- (void) reportResults:(NSDictionary*) map {
    NSMutableArray* movies = [NSMutableArray arrayWithArray:map.allKeys];
    // add in any previously bookmarked movies that we now no longer know about.
    for (Movie* movie in self.bookmarks.allValues) {
        if (![movies containsObject:movie]) {
            [movies addObject:movie];
        }
    }

    // also determine if any of the data we found match items the user bookmarked
    for (Movie* movie in movies) {
        if ([model isBookmarked:movie]) {
            [self.bookmarks setObject:movie forKey:movie.canonicalTitle];
        }
    }
    [self saveBookmarks];

    [self setMovies:movies];
    [self updateDetails];
    [NowPlayingAppDelegate majorRefresh];
}


- (void) updateVideoPoster:(Movie*) movie {
    if (movie == nil) {
        return;
    }

    NSString* file = [self posterFile:movie set:nil];
    if ([FileUtilities fileExists:file]) {
        return;
    }

    if (movie.poster.length == 0) {
        [model.largePosterCache downloadFirstPosterForMovie:movie];
        return;
    }

    NSString* address = [NSString stringWithFormat:@"http://%@.appspot.com/LookupCachedResource?q=%@",
                         [Application host], [Utilities stringByAddingPercentEscapes:movie.poster]];

    NSData* data = [NetworkUtilities dataWithContentsOfAddress:address important:NO];
    if (data != nil) {
        [FileUtilities writeData:data toFile:file];
        [NowPlayingAppDelegate minorRefresh];
    }
}


- (void) updateVideoImdbAddress:(Movie*) movie {
    if (movie == nil) {
        return;
    }

    NSString* imdbFile = [self imdbFile:movie set:nil];

    NSDate* lastLookupDate = [FileUtilities modificationDate:imdbFile];
    if (lastLookupDate != nil) {
        NSString* value = [FileUtilities readObject:imdbFile];
        if (value.length > 0) {
            // we have a real imdb value for this movie
            return;
        }

        // we have a sentinel.  only update if it's been long enough
        if (ABS(lastLookupDate.timeIntervalSinceNow) < (3 * ONE_DAY)) {
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
    if (imdbAddress.length > 0) {
        [NowPlayingAppDelegate minorRefresh];
    }
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


- (void) prioritizeMovie:(Movie*) movie {
    if (![self.moviesSet containsObject:movie]) {
        return;
    }

    [prioritizedMovies addObject:movie];
}


- (void) updateDetailsBackgroundEntryPoint:(NSArray*) movies {
    NSMutableArray* videos = [NSMutableArray arrayWithArray:movies];

    Movie* movie;
    do {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        {
            movie = [self getNextMovie:videos];
            [self updateVideoPoster:movie];
            [self updateVideoImdbAddress:movie];
        }
        [pool release];
    } while (movie != nil);
}


- (NSString*) imdbAddressForMovie:(Movie*) movie {
    return [FileUtilities readObject:[self imdbFile:movie]];
}


- (UIImage*) posterForMovie:(Movie*) movie {
    return [UIImage imageWithData:[FileUtilities readData:[self posterFile:movie]]];
}


- (UIImage*) smallPosterForMovie:(Movie*) movie {
    NSString* smallPosterPath = [self smallPosterFile:movie];
    NSData* smallPosterData;

    if ([FileUtilities size:smallPosterPath] == 0) {
        NSData* normalPosterData = [FileUtilities readData:[self posterFile:movie]];
        smallPosterData = [ImageUtilities scaleImageData:normalPosterData
                                                toHeight:SMALL_POSTER_HEIGHT];

        [FileUtilities writeData:smallPosterData
                          toFile:smallPosterPath];
    } else {
        smallPosterData = [FileUtilities readData:smallPosterPath];
    }

    return [UIImage imageWithData:smallPosterData];
}


- (DVD*) detailsForMovie:(Movie*) movie {
    NSDictionary* dictionary = [FileUtilities readObject:[self detailsFile:movie]];
    if (dictionary == nil) {
        return nil;
    }

    return [DVD dvdWithDictionary:dictionary];
}


- (void) addBookmark:(NSString*) canonicalTitle {
    for (Movie* movie in self.movies) {
        if ([movie.canonicalTitle isEqual:canonicalTitle]) {
            [self.bookmarks setObject:movie forKey:canonicalTitle];
            [self saveBookmarks];
            return;
        }
    }
}


- (void) removeBookmark:(NSString*) canonicalTitle {
    [self.bookmarks removeObjectForKey:canonicalTitle];
    [self saveBookmarks];
}

@end