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
@synthesize moviesAndHash;

- (void) dealloc {
    self.gate = nil;
    self.moviesAndHash = nil;

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


- (void) writeMovies:(NSArray*) movies hash:(NSString*) hash {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    [result setObject:hash forKey:@"Hash"];
    
    NSMutableArray* encodedMovies = [NSMutableArray array];
    for (Movie* movie in movies) {
        [encodedMovies addObject:movie.dictionary];
    }
    
    [result setObject:encodedMovies forKey:@"Movies"];
    [Utilities writeObject:result toFile:[Application upcomingMoviesFile]];
}


- (NSArray*) processArray:(XmlElement*) element {
    NSMutableArray* array = [NSMutableArray array];
    
    for (XmlElement* child in element.children) {
        [array addObject:[child attributeValue:@"value"]];
    }
    
    return array;
}


- (Movie*) processMovieElement:(XmlElement*) movieElement {
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
    
    return [Movie movieWithIdentifier:[NSString stringWithFormat:@"%d", movieElement]
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
}


- (NSArray*) processResultElement:(XmlElement*) resultElement {
    NSMutableArray* result = [NSMutableArray array];
    
    for (XmlElement* movieElement in resultElement.children) {
        Movie* movie = [self processMovieElement:movieElement];
        if (movie != nil) {
            [result addObject:movie];
        }
    }
    
    return result;
}


- (NSDictionary*) updateMoviesListWorker {
    NSString* localHash = [moviesAndHash objectForKey:@"Hash"];
    
    NSString* serverHash = [Utilities stringWithContentsOfAddress:[NSString stringWithFormat:@"http://%@.appspot.com/LookupUpcomingListings?q=index&hash=true", [Application host]]];
    if (serverHash == nil) {
        serverHash = @"0";
    }
    
    if (localHash != nil &&
        [localHash isEqual:serverHash]) {
        return [NSDictionary dictionary];
    }

    XmlElement* resultElement = [Utilities downloadXml:[NSString stringWithFormat:@"http://%@.appspot.com/LookupUpcomingListings?q=index", [Application host]]];
    NSArray* movies = [self processResultElement:resultElement];
    
    
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    [result setObject:serverHash forKey:@"Hash"];
    [result setObject:movies forKey:@"Movies"];
    
    [self writeMovies:movies hash:serverHash];
    
    return result;
}


- (void) updateMoviesList {
    NSAssert(![NSThread isMainThread], @"");
    
    NSDictionary* dictionary = [self updateMoviesListWorker];
    
    if (dictionary.count > 0) {
        [self performSelectorOnMainThread:@selector(saveMovies:) withObject:dictionary waitUntilDone:NO];
    }
}


- (void) saveMovies:(NSDictionary*) dictionary {
    self.moviesAndHash = dictionary;
    [self updateMovieDetails];
}


- (void) deleteObsoleteData {
    
}


- (void) updateMovieDetails {
    NSAssert([NSThread isMainThread], @"");
    [self deleteObsoleteData];
    
    [self performSelectorInBackground:@selector(updateMovieDetailsInBackground:) withObject:self.upcomingMovies];
}


- (NSString*) posterFile:(Movie*) movie {
    NSString* fileName = [Application sanitizeFileName:movie.canonicalTitle];
    fileName = [fileName stringByAppendingPathExtension:@"jpg"];
    return [[Application upcomingPostersFolder] stringByAppendingPathComponent:fileName];
}


- (NSString*) synopsisFile:(Movie*) movie {
    return [[Application upcomingSynopsesFolder] stringByAppendingPathComponent:[Application sanitizeFileName:movie.canonicalTitle]];
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


- (void) updateSynopsis:(Movie*) movie {
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self synopsisFile:movie]]) {
        return;
    }
}


- (void) updateDetails:(Movie*) movie {
    [self updatePoster:movie];
    [self updateSynopsis:movie];
}


- (void) updateMovieDetailsInBackground:(NSArray*) movies {
    NSAutoreleasePool* autoreleasePool = [[NSAutoreleasePool alloc] init];
    [self.gate lock];
    {
        [NSThread setThreadPriority:0.0];
        
        for (Movie* movie in movies) {
            NSAutoreleasePool* autoreleasePool = [[NSAutoreleasePool alloc] init];
            
            [self updateDetails:movie];
            
            [autoreleasePool release];
        }
    }
    [self.gate unlock];
    [autoreleasePool release];
    
}


- (NSDictionary*) loadUpcomingMovies {
    NSDictionary* dictionary = [NSDictionary dictionaryWithContentsOfFile:[Application upcomingMoviesFile]];
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
    
    return result;
}


- (NSArray*) upcomingMovies {
    if (moviesAndHash == nil) {
        self.moviesAndHash = [self loadUpcomingMovies];
    }
    
    NSArray* result = [moviesAndHash objectForKey:@"Movies"];

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
    return [NSString stringWithContentsOfFile:[self synopsisFile:movie]];
}


@end
