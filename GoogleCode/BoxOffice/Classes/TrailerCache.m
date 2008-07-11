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
        
        self.movieToTrailersMap = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"movieTrailers"];
        if (self.movieToTrailersMap == nil) {
            self.movieToTrailersMap = [NSDictionary dictionary];
        }
    }
    
    return self;
}

+ (TrailerCache*) cache {
    return [[[TrailerCache alloc] init] autorelease];
}

- (void) update:(NSArray*) movies {
    [self performSelectorInBackground:@selector(backgroundEntryPoint:)
                           withObject:[NSArray arrayWithArray:movies]];
}

- (NSString*) getValue:(NSString*) key fromArray:(NSArray*) array {
    for (int i = 0; i < [array count] - 2; i++) {
        if ([[array objectAtIndex:i] isEqual:key]) {
            return [array objectAtIndex:(i + 2)];
        }
    }
    
    return nil;
}

- (void) addKey:(NSString*) key
          value:(NSString*) value
     dictionary:(NSMutableDictionary*) dictionary {
    NSMutableArray* array = [dictionary objectForKey:key];
    
    if (array == nil) {
        array = [NSMutableArray array];
        [dictionary setObject:array forKey:key];
    }
    
    [array addObject:value];
}

- (void) findTrailers:(NSString*) movieTitle
             indexUrl:(NSString*) indexUrl
               result:(NSMutableDictionary*) result {
    XmlElement* documentElement = [Utilities downloadXml:indexUrl];
    XmlElement* trackListElement = [documentElement element:@"TrackList"];
    XmlElement* plistElement = [trackListElement element:@"plist"];
    XmlElement* outerDict = [plistElement element:@"dict"];
    XmlElement* arrayElement = [outerDict element:@"array"];
    
    for (XmlElement* innerDictElement in [arrayElement elements:@"dict"]) {
        for (XmlElement* child in innerDictElement.children) {
            NSString* text = child.text;
            
            if ([text hasSuffix:@".m4v"]) {
                [self addKey:movieTitle value:text dictionary:result]; 
            }
        }
    }
}

- (void) processJsonRow:(NSString*) row
           moviesTitles:(NSArray*) movieTitles
                 result:(NSMutableDictionary*) result
                 engine:(DifferenceEngine*) engine {
    
    NSArray* values = [row componentsSeparatedByString:@"\""];
    NSString* titleValue = [self getValue:@"title" fromArray:values];
    NSString* locationValue = [self getValue:@"location" fromArray:values];
    
    if (titleValue == nil || locationValue == nil) {
        return;
    }
    
    NSString* movieTitle = [engine findClosestMatch:titleValue inArray:movieTitles];
    if (movieTitle == nil) {
        return;
    }
    
    NSArray* locations = [locationValue componentsSeparatedByString:@"/"];
    NSString* indexUrl = [NSString stringWithFormat:@"http://www.apple.com/moviesxml/s/%@/%@/index.xml",
                          [locations objectAtIndex:2],
                          [locations objectAtIndex:3]]; 
    
    [self findTrailers:movieTitle indexUrl:indexUrl result:result];
}

- (NSDictionary*) downloadTrailers:(NSArray*) movies {
    NSURL* url = [NSURL URLWithString:@"http://www.apple.com/trailers/home/feeds/studios.json"];
    NSError* httpError = nil;
    NSString* jsonFeed = [NSString stringWithContentsOfURL:url encoding:NSISOLatin1StringEncoding error:&httpError];
    
    NSMutableArray* movieTitles = [NSMutableArray array];
    
    for (Movie* movie in movies) {
        [movieTitles addObject:movie.title];
    }
    
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    DifferenceEngine* engine = [DifferenceEngine engine];
    
    NSArray* rows = [jsonFeed componentsSeparatedByString:@"\n"];
    for (NSString* row in rows) {
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
        
        [self processJsonRow:row moviesTitles:movieTitles result:result engine:engine];
        
        [autoreleasePool release];
    }
    
    return result;
}

- (void) backgroundEntryPoint:(NSArray*) movies {
    [gate lock];
    {        
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
        
        NSDictionary* result = [self downloadTrailers:movies];
        [self performSelectorOnMainThread:@selector(processResult:) withObject:result waitUntilDone:NO];
        
        [autoreleasePool release];
    }
    [gate unlock];
}

- (void) processResult:(NSDictionary*) result {
    self.movieToTrailersMap = result;
    
    [[NSUserDefaults standardUserDefaults] setObject:self.movieToTrailersMap forKey:@"movieTrailers"];
}

- (NSArray*) trailersForMovie:(Movie*) movie {
    NSArray* result = [movieToTrailersMap objectForKey:movie.title];
    if (result == nil) {
        return [NSArray array];
    }
    
    return result;
}


@end
