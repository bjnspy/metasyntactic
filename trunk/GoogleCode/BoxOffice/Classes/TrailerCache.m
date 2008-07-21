//
//  TrailerCache.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/10/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TrailerCache.h"
#import "Utilities.h"
#import "XmlElement.h"
#import "DifferenceEngine.h"

@implementation TrailerCache

static NSString* MOVIE_TRAILERS = @"movieTrailers";

@synthesize gate;
@synthesize movieToTrailersMap;

- (void) dealloc {
    self.gate = nil;
    self.movieToTrailersMap = nil;
    
    [super dealloc];
}

- (id) init {
    if (self = [super init]) {
        self.gate = [[[NSLock alloc] init] autorelease];
        
        NSDictionary* dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:MOVIE_TRAILERS];
        
        if (dict == nil) {
            self.movieToTrailersMap = [NSMutableDictionary dictionary];
        } else {
            self.movieToTrailersMap = [NSMutableDictionary dictionaryWithDictionary:dict];
        }
    }
    
    return self;
}

+ (TrailerCache*) cache {
    return [[[TrailerCache alloc] init] autorelease];
}

- (void) deleteObsoleteTrailers:(NSArray*) movies {
    NSMutableSet* movieTitles = [NSMutableSet set];
    for (Movie* movie in movies) {
        [movieTitles addObject:movie.title];
    }
    
    NSMutableDictionary* trimmedDictionary = [NSMutableDictionary dictionary];
    
    for (NSString* key in self.movieToTrailersMap) {
        if ([movieTitles containsObject:key]) {
            [trimmedDictionary setObject:[self.movieToTrailersMap objectForKey:key] forKey:key];
        }
    }
    
    self.movieToTrailersMap = trimmedDictionary;
}

- (NSArray*) getOrderedMovies:(NSArray*) movies {
    NSMutableArray* moviesWithoutTrailers = [NSMutableArray array];
    NSMutableArray* moviesWithTrailers = [NSMutableArray array];
    for (Movie* movie in movies) {
        NSArray* dateAndTrailers = [self.movieToTrailersMap objectForKey:movie.title];
        if (dateAndTrailers == nil) {
            [moviesWithoutTrailers addObject:movie];
        } else {
            NSDate* downloadDate = [dateAndTrailers objectAtIndex:0];
            NSDate* now = [NSDate date];
            
            NSDateComponents* downloadDateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:downloadDate];
            NSDateComponents* nowDateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:now];
            
            if (downloadDateComponents.day != nowDateComponents.day) {
                [moviesWithTrailers addObject:movie];
            }
        }
    }
    
    return [NSArray arrayWithObjects:moviesWithoutTrailers, moviesWithTrailers, nil];
}

- (void) update:(NSArray*) movies {
    [self deleteObsoleteTrailers:movies];
    
    NSArray* orderedMovies = [self getOrderedMovies:movies];
    
    [self performSelectorInBackground:@selector(backgroundEntryPoint:)
                           withObject:orderedMovies];
}

- (NSString*) getValue:(NSString*) key fromArray:(NSArray*) array {
    for (int i = 0; i < array.count - 2; i++) {
        if ([[array objectAtIndex:i] isEqual:key]) {
            return [array objectAtIndex:(i + 2)];
        }
    }
    
    return nil;
}

- (void) processResult:(NSArray*) data {
    NSString* text = [data objectAtIndex:0];
    NSArray* urls = [data objectAtIndex:1];
    NSArray* dateAndTrailers = [NSArray arrayWithObjects:[NSDate date], urls, nil];
    
    [self.movieToTrailersMap setObject:dateAndTrailers forKey:text];
}

- (void) findTrailers:(NSString*) movieTitle
             indexUrl:(NSString*) indexUrl {
    NSString* contents = [NSString stringWithContentsOfURL:[NSURL URLWithString:indexUrl]];
    
    NSMutableArray* urls = [NSMutableArray array];
    while (contents != nil) {
        NSRange endRange = [contents rangeOfString:@".m4v</string>"];
        if (endRange.length == 0) {
            break;
        }
        
        NSRange startRange = [contents rangeOfString:@"<string>" options:NSBackwardsSearch range:NSMakeRange(0, endRange.location)];
        if (startRange.length == 0) {
            break;
        }
        
        NSRange extractRange;
        extractRange.location = NSMaxRange(startRange);
        extractRange.length = endRange.location - extractRange.location;
        extractRange.length += 4;  // ".m4v"
        
        [urls addObject:[contents substringWithRange:extractRange]];
        contents = [contents substringFromIndex:NSMaxRange(endRange)]; 
    }
    
    if (urls.count) {
        NSArray* result = [NSArray arrayWithObjects:movieTitle, urls, nil];
        [self performSelectorOnMainThread:@selector(processResult:) withObject:result waitUntilDone:NO];
    }
}

- (NSString*) massage:(NSString*) value {
    while (true) {
        NSRange range = [value rangeOfString:@"\\u"];
        if (range.length <= 0) {
            break;
        }
        
        range.length += 4;
        value = [value stringByReplacingCharactersInRange:range withString:@""];
    }
    
    return value;
}

- (void) processJsonRow:(NSString*) row
           moviesTitles:(NSArray*) movieTitles
                 engine:(DifferenceEngine*) engine {
    
    NSArray* values = [row componentsSeparatedByString:@"\""];
    NSString* titleValue = [self getValue:@"title" fromArray:values];
    NSString* locationValue = [self getValue:@"location" fromArray:values];
    
    if (titleValue == nil || locationValue == nil) {
        return;
    }
    
    titleValue = [self massage:titleValue];
    locationValue = [self massage:locationValue];
    
    NSString* movieTitle = [engine findClosestMatch:titleValue inArray:movieTitles];
    if (movieTitle == nil) {
        return;
    }
    
    NSArray* locations = [locationValue componentsSeparatedByString:@"/"];
    NSString* indexUrl = [NSString stringWithFormat:@"http://www.apple.com/moviesxml/s/%@/%@/index.xml",
                          [locations objectAtIndex:2],
                          [locations objectAtIndex:3]]; 
    
    [self findTrailers:movieTitle indexUrl:indexUrl];
}

- (void) downloadTrailers:(NSArray*) movies {
    NSURL* url = [NSURL URLWithString:@"http://www.apple.com/trailers/home/feeds/studios.json"];
    NSError* httpError = nil;
    NSString* jsonFeed = [NSString stringWithContentsOfURL:url encoding:NSISOLatin1StringEncoding error:&httpError];
    
    NSMutableArray* movieTitles = [NSMutableArray array];
    
    for (Movie* movie in movies) {
        [movieTitles addObject:movie.title];
    }
    
    DifferenceEngine* engine = [DifferenceEngine engine];
    
    NSArray* rows = [jsonFeed componentsSeparatedByString:@"\n"];
    for (NSString* row in rows) {
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
        
        [self processJsonRow:row moviesTitles:movieTitles engine:engine];
        
        [autoreleasePool release];
    }
}

- (void) backgroundEntryPoint:(NSArray*) array {
    [gate lock];
    {
        [NSThread setThreadPriority:0.0];
        
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
        
        for (NSArray* movies in array) {
            [self downloadTrailers:movies];
        }
        
        [self performSelectorOnMainThread:@selector(onComplete:) withObject:nil waitUntilDone:NO];
        
        [autoreleasePool release];
    }
    [gate unlock];
}

- (void) onComplete:(id) nothing {
    [[NSUserDefaults standardUserDefaults] setObject:self.movieToTrailersMap forKey:MOVIE_TRAILERS];
}

- (NSArray*) trailersForMovie:(Movie*) movie {
    NSArray* dateAndTrailers = [movieToTrailersMap objectForKey:movie.title];
    NSArray* result = [dateAndTrailers objectAtIndex:1];
    if (result == nil) {
        return [NSArray array];
    }
    
    return result;
}

- (void) applicationWillTerminate {
    [self onComplete:nil];
}


@end
