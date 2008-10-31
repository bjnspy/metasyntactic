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

#import "DVDCache.h"

#import "Application.h"
#import "DateUtilities.h"
#import "DVD.h"
#import "FileUtilities.h"
#import "LinkedSet.h"
#import "Movie.h"
#import "NetworkUtilities.h"
#import "NowPlayingAppDelegate.h"
#import "PointerSet.h"
#import "ThreadingUtilities.h"
#import "Utilities.h"
#import "XmlElement.h"

@implementation DVDCache

@synthesize gate;
@synthesize dvdSetData;
@synthesize bluraySetData;
@synthesize dvdData;
@synthesize blurayData;
@synthesize prioritizedMovies;

- (void) dealloc {
    self.gate = nil;
    self.dvdSetData = nil;
    self.bluraySetData = nil;
    self.dvdData = nil;
    self.blurayData = nil;
    self.prioritizedMovies = nil;

    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.prioritizedMovies = [LinkedSet set];
    }

    return self;
}


+ (DVDCache*) cache {
    return [[[DVDCache alloc] init] autorelease];
}


- (NSString*) dvdFile {
    return [[Application dvdFolder] stringByAppendingPathComponent:@"DVD.plist"];
}


- (NSString*) blurayFile {
    return [[Application dvdFolder] stringByAppendingPathComponent:@"Blu-ray.plist"];
}


- (NSArray*) decodeArray:(NSArray*) array {
    if (array == nil) {
        return [NSArray array];
    }

    NSMutableArray* result = [NSMutableArray array];
    for (NSDictionary* dictionary in array) {
        [result addObject:[Movie movieWithDictionary:dictionary]];
    }

    return result;
}


- (NSArray*) loadDvd {
    NSArray* encodedMovies = [FileUtilities readObject:[self dvdFile]];
    return [self decodeArray:encodedMovies];
}


- (NSArray*) loadBluray {
    NSArray* encodedMovies = [FileUtilities readObject:[self blurayFile]];
    return [self decodeArray:encodedMovies];
}


- (void) setDvd:(NSArray*) array {
    self.dvdData = array;
    self.dvdSetData = [PointerSet setWithArray:array];
}


- (void) setBluray:(NSArray*) array {
    self.blurayData = array;
    self.bluraySetData = [PointerSet setWithArray:array];
}


- (NSArray*) dvdMovies {
    if (dvdData == nil) {
        [self setDvd:[self loadDvd]];
    }

    return dvdData;
}


- (NSArray*) blurayMovies {
    if (blurayData == nil) {
        [self setBluray:[self loadBluray]];
    }

    return blurayData;
}


- (PointerSet*) dvdSet {
    [self dvdMovies];
    return dvdSetData;
}


- (PointerSet*) bluraySet {
    [self blurayMovies];
    return bluraySetData;
}


- (NSArray*) allMovies {
    return [self.dvdMovies arrayByAddingObjectsFromArray:self.blurayMovies];
}


- (void) updateMovies {
    [ThreadingUtilities performSelector:@selector(updateMoviesBackgroundEntryPoint)
                               onTarget:self
               inBackgroundWithArgument:nil
                                   gate:gate
                                visible:YES];
}


- (void) updateDetails {
    NSArray* arguments = [NSArray arrayWithObjects:self.dvdMovies, self.blurayMovies, nil];
    [ThreadingUtilities performSelector:@selector(updateDetailsBackgroundEntryPoint:)
                               onTarget:self
               inBackgroundWithArgument:arguments
                                   gate:gate
                                visible:NO];
}


- (void) update {
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

    NSRange range = [synopsis rangeOfString:@"€"];
    if (range.length > 0) {
        NSLog(@"%c%c%c %d %d %d",
              [synopsis characterAtIndex:range.location - 1],
              [synopsis characterAtIndex:range.location],
              [synopsis characterAtIndex:range.location + 1],
              [synopsis characterAtIndex:range.location - 1],
              [synopsis characterAtIndex:range.location],
              [synopsis characterAtIndex:range.location + 1]);
    }

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
    // <video url="http://videoeta.com/movie/54201"
    // title="Antwone Fisher"
    // year="2002"
    // release_date="2009-01-20"
    // retail_price="34.99"
    // mpaa_rating="PG-13"
    // format="Blu-ray"
    // genre="Drama"
    // discs="1"
    // image="http://videoeta.com/images/eta/np/movies/medium/FOX_BR2256500.jpg"
    // cast="Denzel Washington/Derek Luke/Joy Bryant/Salli Richardson"
    // director="Denzel Washington"
    // synopsis="Story of a young sailor who's past is full of tragedy and child abuse.  Fisher turns to his girlfriend and a Navy psychiatrist to help come to terms with his demons and confront his past."/>

    NSMutableDictionary* result = [NSMutableDictionary dictionary];

    for (XmlElement* child in element.children) {
        [self processVideoElement:child result:result];
    }

    return result;
}


- (NSString*) detailsFile:(Movie*) movie isBluray:(BOOL) isBluray {
    if (!isBluray) {
        return [[[Application dvdDetailsFolder] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]]
                stringByAppendingString:@"-DVD.plist"];
    } else {
        return [[[Application dvdDetailsFolder] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]]
                stringByAppendingString:@"-Bluray.plist"];
    }
}


- (NSString*) detailsFile:(Movie*) movie {
    if ([self.dvdSet containsObject:movie]) {
        return [self detailsFile:movie isBluray:NO];
    } else if ([self.bluraySet containsObject:movie]) {
        return [self detailsFile:movie isBluray:YES];
    } else {
        return nil;
    }
}


- (NSString*) imdbFile:(Movie*) movie {
    if ([self.dvdSet containsObject:movie]) {
        return [[[Application dvdIMDbFolder] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]]
                stringByAppendingString:@"-DVD.plist"];
    } else if ([self.bluraySet containsObject:movie]) {
        return [[[Application dvdIMDbFolder] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]]
                stringByAppendingString:@"-Bluray.plist"];
    }

    return nil;
}


- (NSString*) posterFile:(Movie*) movie {
    if ([self.dvdSet containsObject:movie]) {
        return [[[Application dvdPostersFolder] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]]
                stringByAppendingString:@"-DVD.jpg"];
    } else if ([self.bluraySet containsObject:movie]) {
        return [[[Application dvdPostersFolder] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]]
                stringByAppendingString:@"-Bluray.jpg"];
    } else {
        return nil;
    }
}


- (void) saveData:(NSDictionary*) dictionary file:(NSString*) file isBluray:(BOOL) isBluray {
    NSArray* videos = dictionary.allKeys;
    NSMutableArray* encodedVideos = [NSMutableArray array];

    for (Movie* movie in videos) {
        [encodedVideos addObject:movie.dictionary];
    }

    [FileUtilities writeObject:encodedVideos toFile:file];

    for (Movie* movie in dictionary) {
        DVD* dvd = [dictionary objectForKey:movie];
        [FileUtilities writeObject:dvd.dictionary toFile:[self detailsFile:movie isBluray:isBluray]];
    }
}


- (void) updateMoviesBackgroundEntryPoint {
    NSDate* lastUpdateDate = [FileUtilities modificationDate:[self dvdFile]];
    if (lastUpdateDate != nil) {
        if (ABS([lastUpdateDate timeIntervalSinceNow]) < (3 * ONE_DAY)) {
            return;
        }
    }

    XmlElement* dvdElement = [NetworkUtilities xmlWithContentsOfAddress:[NSString stringWithFormat:@"http://%@.appspot.com/LookupDVDListings?q=dvd", [Application host]]
                                                              important:YES];
    XmlElement* blurayElement = [NetworkUtilities xmlWithContentsOfAddress:[NSString stringWithFormat:@"http://%@.appspot.com/LookupDVDListings?q=bluray", [Application host]]
                                                                 important:YES];

    if (dvdElement == nil && blurayElement == nil) {
        return;
    }

    NSDictionary* dvdMap = [self processElement:dvdElement];
    //NSDictionary* blurayMap = [self processElement:blurayElement];
    NSDictionary* blurayMap = [NSDictionary dictionary];


    if (dvdMap.count == 0 && blurayMap.count == 0) {
        return;
    }

    [self saveData:dvdMap file:[self dvdFile] isBluray:NO];
    [self saveData:blurayMap file:[self blurayFile] isBluray:YES];

    NSArray* results = [NSArray arrayWithObjects:dvdMap.allKeys, blurayMap.allKeys, nil];
    [self performSelectorOnMainThread:@selector(reportResults:) withObject:results waitUntilDone:NO];
}


- (void) reportResults:(NSArray*) arguments {
    NSArray* dvds = [arguments objectAtIndex:0];
    NSArray* blurays = [arguments objectAtIndex:1];

    if (dvds.count > 0 || blurays.count > 0) {
        [self setDvd:dvds];
        [self setBluray:blurays];

        [self updateDetails];
        [NowPlayingAppDelegate refresh];
    }
}


- (void) updateVideoPoster:(Movie*) movie {
    if (movie == nil) {
        return;
    }

    NSString* file = [self posterFile:movie];
    if ([FileUtilities fileExists:file]) {
        return;
    }

    if (movie.poster.length == 0) {
        return;
    }

    NSString* address = [NSString stringWithFormat:@"http://%@.appspot.com/LookupCachedResource?q=%@",
                         [Application host], [Utilities stringByAddingPercentEscapes:movie.poster]];

    NSData* data = [NetworkUtilities dataWithContentsOfAddress:address important:NO];
    if (data != nil) {
        [FileUtilities writeData:data toFile:file];
    }
    [NowPlayingAppDelegate refresh];
}


- (void) updateVideoImdbAddress:(Movie*) movie {
    if (movie == nil) {
        return;
    }

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


- (void) updateVideoDetails:(NSMutableArray*) videos {
    Movie* movie;
    do {
        movie = [self getNextMovie:videos];
        [self updateVideoPoster:movie];
        [self updateVideoImdbAddress:movie];
    } while (movie != nil);
}


- (void) prioritizeMovie:(Movie*) movie {
    [prioritizedMovies addObject:movie];
}


- (void) updateDetailsBackgroundEntryPoint:(NSArray*) arguments {
    NSMutableArray* dvds = [NSMutableArray arrayWithArray:[arguments objectAtIndex:0]];
    NSMutableArray* blurays = [NSMutableArray arrayWithArray:[arguments objectAtIndex:1]];

    [self updateVideoDetails:dvds];
    [self updateVideoDetails:blurays];
}


- (NSString*) imdbAddressForMovie:(Movie*) movie {
    return [FileUtilities readObject:[self imdbFile:movie]];
}


- (UIImage*) posterForMovie:(Movie*) movie {
    return [UIImage imageWithData:[FileUtilities readData:[self posterFile:movie]]];
}


- (DVD*) dvdDetailsForMovie:(Movie*) movie {
    NSDictionary* dictionary = [FileUtilities readObject:[self detailsFile:movie]];
    if (dictionary == nil) {
        return nil;
    }

    return [DVD dvdWithDictionary:dictionary];
}

@end