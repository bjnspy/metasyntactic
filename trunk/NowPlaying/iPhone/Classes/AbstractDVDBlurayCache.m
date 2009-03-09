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

#import "AmazonCache.h"
#import "Application.h"
#import "DVD.h"
#import "DateUtilities.h"
#import "FileUtilities.h"
#import "ImageUtilities.h"
#import "IMDbCache.h"
#import "LargePosterCache.h"
#import "LinkedSet.h"
#import "Movie.h"
#import "NetflixCache.h"
#import "NetworkUtilities.h"
#import "AppDelegate.h"
#import "Model.h"
#import "PointerSet.h"
#import "StringUtilities.h"
#import "ThreadingUtilities.h"
#import "Utilities.h"
#import "XmlElement.h"

@interface AbstractDVDBlurayCache()
@property (retain) PointerSet* moviesSetData;
@property (retain) NSArray* moviesData;
@property (retain) NSMutableDictionary* bookmarksData;
@end


@implementation AbstractDVDBlurayCache

@synthesize moviesSetData;
@synthesize moviesData;
@synthesize bookmarksData;

- (void) dealloc {
    self.moviesSetData = nil;
    self.moviesData = nil;
    self.bookmarksData = nil;
    
    [super dealloc];
}


- (id) initWithModel:(Model*) model_ {
    if (self = [super initWithModel:model_]) {
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


- (NSString*) netflixDirectory {
    return [self.directory stringByAppendingPathComponent:@"Netflix"];
}


- (NSString*) moviesFile {
    return [[self directory] stringByAppendingPathComponent:@"Movies.plist"];
}


- (NSArray*) loadMovies:(NSString*) file {
    NSArray* encodedMovies = [FileUtilities readObject:file];
    return [Movie decodeArray:encodedMovies];
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


- (NSArray*) loadBookmarksArray {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (NSMutableDictionary*) loadBookmarks {
    NSArray* movies = [self loadBookmarksArray];
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


- (void) update {
    if (model.userAddress.length == 0) {
        return;
    }
    
    if (!model.dvdBlurayEnabled) {
        return;
    }
    
    if (updated) {
        return;
    }
    updated = YES;
    
    [ThreadingUtilities backgroundSelector:@selector(updateMoviesBackgroundEntryPoint)
                                  onTarget:self
                                      gate:nil
                                   visible:YES];
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
                                           withString:@"Â®"];
    
    unichar a9[] = { 0xE2, 0x20AC, 0xA2 };
    text = [text stringByReplacingOccurrencesOfString:[NSString stringWithCharacters:a9 length:ArrayLength(a9)]
                                           withString:@"â€¢"];
    
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


- (void) saveData:(NSDictionary*) dictionary {
    NSArray* videos = dictionary.allKeys;
    
    for (Movie* movie in dictionary) {
        DVD* dvd = [dictionary objectForKey:movie];
        [FileUtilities writeObject:dvd.dictionary toFile:[self detailsFile:movie set:nil]];
    }
    
    // do this last.  it signifies that we're done
    [FileUtilities writeObject:[Movie encodeArray:videos] toFile:self.moviesFile];
}


- (NSArray*) updateMoviesBackgroundEntryPointWorker {
    NSDate* lastUpdateDate = [FileUtilities modificationDate:self.moviesFile];
    if (lastUpdateDate != nil) {
        if (ABS(lastUpdateDate.timeIntervalSinceNow) < (3 * ONE_DAY)) {
            return nil;
        }
    }
    
    XmlElement* element = [NetworkUtilities xmlWithContentsOfAddress:self.serverAddress
                                                           important:YES];
    
    if (element == nil) {
        return nil;
    }
    
    NSDictionary* map = [self processElement:element];
    
    if (map.count == 0) {
        return nil;
    }
    
    [self saveData:map];
    [self clearUpdatedMovies];
    
    [self performSelectorOnMainThread:@selector(reportResults:)
                           withObject:map
                        waitUntilDone:NO];
    
    return map.allKeys;
}


- (void) updateMoviesBackgroundEntryPoint {
    NSArray* movies = [self updateMoviesBackgroundEntryPointWorker];
    if (movies.count == 0) {
        movies = [self loadMovies];
    }
    
    [self addPrimaryMovies:movies];
}


- (void) saveBookmarks {
    [model setBookmarkedDVD:self.bookmarks.allValues];
}


- (void) reportResults:(NSDictionary*) map {
    NSAssert([NSThread isMainThread], nil);
    
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
    
    [AppDelegate majorRefresh];
}


- (void) updateNetflix:(Movie*) movie {
    [model.netflixCache lookupNetflixMovieForLocalMovieBackgroundEntryPoint:movie];
}


- (void) updatePoster:(Movie*) movie {
    [model.posterCache updateMovie:movie];
}


- (void) updateIMDb:(Movie*) movie {
    [model.imdbCache updateMovie:movie];
}


- (void) updateAmazon:(Movie*) movie {
    [model.amazonCache updateMovie:movie];
}


- (void) updateWikipedia:(Movie*) movie {
    [model.wikipediaCache updateMovie:movie];
}


- (void) prioritizeMovie:(Movie*) movie {
    if (![self.moviesSet containsObject:movie]) {
        return;
    }
    
    [super prioritizeMovie:movie];
}


- (void) updateMovieDetails:(Movie*) movie {
    [self updatePoster:movie];
    [self updateNetflix:movie];
    [self updateIMDb:movie];
    [self updateWikipedia:movie];
    [self updateAmazon:movie];
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