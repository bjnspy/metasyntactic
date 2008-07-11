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
        
        NSDictionary* dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"movieTrailers"];
        
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

- (void) processResult:(NSArray*) data {
    NSString* text = [data objectAtIndex:0];
    NSArray* urls = [data objectAtIndex:1];
    
    [self.movieToTrailersMap setObject:urls forKey:text];
}

- (void) findTrailers:(NSString*) movieTitle
             indexUrl:(NSString*) indexUrl {
    XmlElement* documentElement = [Utilities downloadXml:indexUrl];
    XmlElement* trackListElement = [documentElement element:@"TrackList"];
    XmlElement* plistElement = [trackListElement element:@"plist"];
    XmlElement* outerDict = [plistElement element:@"dict"];
    XmlElement* arrayElement = [outerDict element:@"array"];
    
    NSMutableArray* urls = [NSMutableArray array];
    
    for (XmlElement* innerDictElement in [arrayElement elements:@"dict"]) {
        for (XmlElement* child in innerDictElement.children) {
            NSString* text = child.text;
            
            if ([text hasSuffix:@".m4v"]) {
                [urls addObject:text];
            }
        }
    }
    
    if (urls.count) {
        NSArray* result = [NSArray arrayWithObjects:movieTitle, urls, nil];
        [self performSelectorOnMainThread:@selector(processResult:) withObject:result waitUntilDone:NO];
    }
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

- (void) backgroundEntryPoint:(NSArray*) movies {
    [gate lock];
    {        
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
        
        [self downloadTrailers:movies];
        [self performSelectorOnMainThread:@selector(onComplete:) withObject:nil waitUntilDone:NO];
        
        [autoreleasePool release];
    }
    [gate unlock];
}

- (void) onComplete:(id) nothing {
    [[NSUserDefaults standardUserDefaults] setObject:self.movieToTrailersMap forKey:@"movieTrailers"];
}

- (NSArray*) trailersForMovie:(Movie*) movie {
    NSArray* result = [movieToTrailersMap objectForKey:movie.title];
    if (result == nil) {
        return [NSArray array];
    }
    
    return result;
}

- (void) applicationWillTerminate {
    [[NSUserDefaults standardUserDefaults] setObject:self.movieToTrailersMap forKey:@"movieTrailers"];
}


@end
