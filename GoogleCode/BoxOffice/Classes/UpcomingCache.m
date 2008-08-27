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
#import "Movie.h"
#import "Utilities.h"
#import "XmlElement.h"

@implementation UpcomingCache

@synthesize gate;
@synthesize index;

- (void) dealloc {
    self.gate = nil;
    self.index = nil;

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


- (void) writeMovies:(NSArray*) movies 
          studioKeys:(NSMutableDictionary*) studioKeys 
           titleKeys:(NSMutableDictionary*) titleKeys
                hash:(NSString*) hash {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    [result setObject:hash forKey:@"Hash"];
    [result setObject:studioKeys forKey:@"Studios"];
    [result setObject:titleKeys forKey:@"Titles"];
    
    NSMutableArray* encodedMovies = [NSMutableArray array];
    for (Movie* movie in movies) {
        [encodedMovies addObject:movie.dictionary];
    }
    
    [result setObject:encodedMovies forKey:@"Movies"];
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
    NSDate* now = [NSDate date];
    NSDate* releaseDate = [DateUtilities dateWithNaturalLanguageString:[movieElement attributeValue:@"date"]];
        
    if ([now compare:releaseDate] == NSOrderedDescending) {
        return nil;
    }

    NSString* director = [movieElement attributeValue:@"director"];
    NSString* poster = [movieElement attributeValue:@"poster"];
    NSString* rating = [movieElement attributeValue:@"rating"];
    NSString* studio = [movieElement attributeValue:@"studio"];
    NSString* title = [movieElement attributeValue:@"title"];
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
                                     director:director
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
    NSString* localHash = [index objectForKey:@"Hash"];
    
    NSString* serverHash = [Utilities stringWithContentsOfAddress:[NSString stringWithFormat:@"http://%@.appspot.com/LookupUpcomingListings?q=index&hash=true", [Application host]]];
    if (serverHash == nil) {
        serverHash = @"0";
    }
    
    if (localHash != nil &&
        [localHash isEqual:serverHash]) {
        return [NSDictionary dictionary];
    }

    XmlElement* resultElement = [Utilities downloadXml:[NSString stringWithFormat:@"http://%@.appspot.com/LookupUpcomingListings?q=index", [Application host]]];
    
    NSMutableDictionary* studioKeys = [NSMutableDictionary dictionary];
    NSMutableDictionary* titleKeys = [NSMutableDictionary dictionary];
    NSArray* movies = [self processResultElement:resultElement studioKeys:studioKeys titleKeys:titleKeys];
    
    
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    [result setObject:serverHash forKey:@"Hash"];
    [result setObject:movies forKey:@"Movies"];
    [result setObject:studioKeys forKey:@"Studios"];
    [result setObject:titleKeys forKey:@"Titles"];
    
    [self writeMovies:movies studioKeys:studioKeys titleKeys:titleKeys hash:serverHash];
    
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
    [self updateMovieDetails];
}


- (void) deleteObsoleteData {
    
}


- (void) updateMovieDetails {
    NSAssert([NSThread isMainThread], @"");
    [self deleteObsoleteData];
    
    [self performSelectorInBackground:@selector(updateMovieDetailsInBackground:) withObject:self.index];
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


- (void) updatePoster:(Movie*) movie {
    if ([Utilities isNilOrEmpty:movie.poster]) {
        return;
    }
    
    NSString* posterFile = [self posterFile:movie];
    if ([[NSFileManager defaultManager] fileExistsAtPath:posterFile]) {
        return;
    }

    NSData* data = [Utilities dataWithContentsOfAddress:movie.poster];
    if (data != nil) {
        [data writeToFile:posterFile atomically:YES];
    }
}


- (void) updateSynopsis:(Movie*) movie
                 studio:(NSString*) studio
                  title:(NSString*) title {
    NSString* synopsisFile = [self synopsisFile:movie];
    if ([[NSFileManager defaultManager] fileExistsAtPath:synopsisFile]) {
        return;
    }

    NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupUpcomingListings?studio=%@&name=%@", [Application host], studio, title];
    NSString* synopsis = [Utilities stringWithContentsOfAddress:url];

    if (![Utilities isNilOrEmpty:synopsis]) {
        [Utilities writeObject:[NSArray arrayWithObject:synopsis] toFile:synopsisFile];
    }
}


- (void) updateTrailers:(Movie*) movie 
                 studio:(NSString*) studio
                  title:(NSString*) title {
    NSString* trailersFile = [self trailersFile:movie];
    if ([[NSFileManager defaultManager] fileExistsAtPath:trailersFile]) {
        return;
    }

    NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupTrailerListings?studio=%@&name=%@", [Application host], studio, title];
    NSString* trailersString = [Utilities stringWithContentsOfAddress:url];
    NSArray* trailers = [trailersString componentsSeparatedByString:@"\n"];
    
    if (trailers.count) {
        [Utilities writeObject:trailers toFile:trailersFile];
    }
}


- (void) updateDetails:(Movie*) movie studio:(NSString*) studio title:(NSString*) title {
    [self updatePoster:movie];
    [self updateSynopsis:movie studio:studio title:title];
    [self updateTrailers:movie studio:studio title:title];
}


- (void) updateMovieDetailsInBackground:(NSDictionary*) index_ {
    NSAutoreleasePool* autoreleasePool = [[NSAutoreleasePool alloc] init];
    [self.gate lock];
    {
        [NSThread setThreadPriority:0.0];
        NSArray* movies = [index_ objectForKey:@"Movies"];
        NSDictionary* studios = [index_ objectForKey:@"Studios"];
        NSDictionary* titles = [index_ objectForKey:@"Titles"];
        
        for (Movie* movie in movies) {
            NSAutoreleasePool* autoreleasePool = [[NSAutoreleasePool alloc] init];
            
            [self updateDetails:movie
                         studio:[studios objectForKey:movie.canonicalTitle]
                          title:[titles objectForKey:movie.canonicalTitle]];
            
            [autoreleasePool release];
        }
    }
    [self.gate unlock];
    [autoreleasePool release];
}


- (NSDictionary*) loadIndex {
    NSDictionary* dictionary = [NSDictionary dictionaryWithContentsOfFile:[Application upcomingMoviesIndexFile]];
    if (dictionary == nil) {
        return [NSDictionary dictionary];
    }

    NSArray* encodedMovies = [dictionary objectForKey:@"Movies"];    
    NSMutableArray* decodedMovies = [NSMutableArray array];

    for (NSDictionary* dictionary in encodedMovies) {
        [decodedMovies addObject:[Movie movieWithDictionary:dictionary]];
    }
    
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    [result setObject:decodedMovies forKey:@"Movies"];
    [result setObject:[dictionary objectForKey:@"Hash"] forKey:@"Hash"];
    [result setObject:[dictionary objectForKey:@"Studios"] forKey:@"Studios"];
    [result setObject:[dictionary objectForKey:@"Titles"] forKey:@"Titles"];
    
    return result;
}


- (NSArray*) upcomingMovies {
    if (index == nil) {
        self.index = [self loadIndex];
    }
    
    NSArray* result = [index objectForKey:@"Movies"];

    if (result == nil) {
        return [NSArray array];
    }
    
    return result;
}


- (UIImage*) posterForMovie:(Movie*) movie {
    NSData* data = [NSData dataWithContentsOfFile:[self posterFile:movie]];
    if (data == nil) {
        return nil;
    }
    
    return [UIImage imageWithData:data];
}


- (NSString*) synopsisForMovie:(Movie*) movie {
    NSArray* array = [NSArray arrayWithContentsOfFile:[self synopsisFile:movie]];
    if (array == nil) {
        return nil;
    }
    
    return [array objectAtIndex:0];
}


- (NSArray*) trailersForMovie:(Movie*) movie {
    NSArray* array = [NSArray arrayWithContentsOfFile:[self trailersFile:movie]];
    if (array == nil) {
        return [NSArray array];
    }
    
    return array;
}


@end
