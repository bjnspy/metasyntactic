//
//  ReviewCache.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/15/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ReviewCache.h"
#import "Review.h"
#import "ExtraMovieInformation.h"
#import "XmlElement.h"
#import "XmlParser.h"
#import "Application.h"
#import "Utilities.h"

@implementation ReviewCache

@synthesize gate;
@synthesize movieToReviewMap;

- (void) dealloc {
    self.gate = nil;
    self.movieToReviewMap = nil;
    
    [super dealloc];
}

- (id) init {
    if (self = [super init]) {
        self.gate = [[[NSLock alloc] init] autorelease];
        self.movieToReviewMap = [NSMutableDictionary dictionary];
        
        NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:[Application reviewsFile]];
        if (dict != nil) {
            for (NSString* movieId in dict) {
                NSArray* dateAndEncodedReviews = [dict objectForKey:movieId];
                
                NSDate* date = [dateAndEncodedReviews objectAtIndex:0];
                NSArray* encodedReviews = [dateAndEncodedReviews objectAtIndex:1];
                
                NSMutableArray* reviews = [NSMutableArray array];
                for (NSDictionary* child in encodedReviews) {
                    [reviews addObject:[Review reviewWithDictionary:child]];
                }
                
                NSArray* dateAndReviews = [NSArray arrayWithObjects:date, reviews, nil];
                [self.movieToReviewMap setObject:dateAndReviews
                                          forKey:movieId];
            }
        }
    }
    
    return self;
}

+ (ReviewCache*) cache {
    return [[[ReviewCache alloc] init] autorelease];
}

- (void) update:(NSDictionary*) supplementaryInformation {
    NSMutableDictionary* infoWithReviews = [NSMutableDictionary dictionary];
    NSMutableDictionary* infoWithoutReviews = [NSMutableDictionary dictionary];
    
    for (NSString* title in supplementaryInformation) {
        NSArray* dateAndReviews = [self.movieToReviewMap objectForKey:title];
        if (dateAndReviews == nil) {
            [infoWithoutReviews setObject:[supplementaryInformation objectForKey:title] forKey:title];
        } else {
            NSDate* downloadDate = [dateAndReviews objectAtIndex:0];
            NSDate* now = [NSDate date];
            
            NSDateComponents* downloadDateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:downloadDate];
            NSDateComponents* nowDateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:now];
            
            if (downloadDateComponents.day != nowDateComponents.day) {
                [infoWithReviews setObject:[supplementaryInformation objectForKey:title] forKey:title];
            }
        }
    }
    
    [self performSelectorInBackground:@selector(updateInBackground:)
                           withObject:[NSArray arrayWithObjects:infoWithoutReviews, infoWithReviews, nil]];
}

- (NSArray*) extractReviews:(NSString*) reviewPage {
    NSMutableArray* result = [NSMutableArray array];
    
    NSArray* rows = [reviewPage componentsSeparatedByString:@"\n"];
    for (NSString* row in rows) {
        NSArray* columns = [row componentsSeparatedByString:@"\t"];
        
        if (columns.count < 5) {
            continue;
        }
        
        [result addObject:[Review reviewWithText:[columns objectAtIndex:0]
                                        positive:[[columns objectAtIndex:1] isEqual:@"True"]
                                            link:[columns objectAtIndex:2]
                                          author:[columns objectAtIndex:3]
                                          source:[columns objectAtIndex:4]]];
    }
    
    return result;
}


- (NSArray*) downloadInfoReviews:(ExtraMovieInformation*) info {
    if (info.link.length == 0) {
        return nil;
    }
    
    NSMutableString* link = [NSMutableString stringWithString:info.link];
    [NSMutableString stringWithString:info.link];
    if ([link characterAtIndex:(link.length - 1)] != '/') {
        [link appendString:@"/"];
    }
    [link appendString:@"?critic=creamcrop"];
    
    NSMutableArray* hosts = [Application hosts];
    NSInteger index = abs([Utilities hashString:info.link]) % hosts.count;
    NSString* host = [hosts objectAtIndex:index];
    
    NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupMovieReviews?q=%@", host, link];
    
    NSError* httpError = nil;
    NSString* reviewPage = [NSString stringWithContentsOfURL:[NSURL URLWithString:url]
                                                    encoding:NSISOLatin1StringEncoding
                                                       error:&httpError];
    
    if (httpError == nil && reviewPage != nil) {
        return [self extractReviews:reviewPage];
    }
    
    return nil;
}

- (void) reportReviews:(NSArray*) movieIdAndReviews {
    NSString* movieId = [movieIdAndReviews objectAtIndex:0];
    NSArray* reviews = [movieIdAndReviews objectAtIndex:1];
    
    NSArray* dateAndReviews = [NSArray arrayWithObjects:[NSDate date], reviews, nil];
    
    [self.movieToReviewMap setObject:dateAndReviews forKey:movieId];
}

- (void) downloadReviews:(NSDictionary*) supplementaryInformation {
    for (NSString* movieId in supplementaryInformation) {
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
        
        ExtraMovieInformation* info = [supplementaryInformation objectForKey:movieId];
        NSArray* reviews = [self downloadInfoReviews:info];
        if (reviews.count > 0) {
            NSArray* array = [NSArray arrayWithObjects:movieId, reviews, nil];
            [self performSelectorOnMainThread:@selector(reportReviews:) withObject:array waitUntilDone:NO];
        }
        
        [autoreleasePool release];
    }
}

- (void) updateInBackground:(NSArray*) array {
    [gate lock];
    {
        [NSThread setThreadPriority:0.0];
        
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
        
        for (NSDictionary* dictionary in array) {
            [self downloadReviews:dictionary];
            [self performSelectorOnMainThread:@selector(onComplete:) withObject:nil waitUntilDone:NO];
        }
        
        [autoreleasePool release];
    }
    [gate unlock];
}

- (NSArray*) reviewsForMovie:(NSString*) movieTitle {
    NSArray* dateAndReviews = [self.movieToReviewMap objectForKey:movieTitle];
    
    NSArray* array = [dateAndReviews objectAtIndex:1];
    if (array == nil) {
        return [NSArray array];
    }
    return array;
}

- (void) onComplete:(id) nothing {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    for (NSString* movieId in self.movieToReviewMap) {
        NSArray* dateAndReviews = [self.movieToReviewMap objectForKey:movieId];
        
        NSMutableArray* encodedReviews = [NSMutableArray array];
        for (Review* review in [dateAndReviews objectAtIndex:1]) {
            [encodedReviews addObject:[review dictionary]];
        }
        
        NSArray* dateAndEncodedReviews = [NSArray arrayWithObjects:[dateAndReviews objectAtIndex:0], encodedReviews, nil];
        [dict setObject:dateAndEncodedReviews forKey:movieId];
    }
    
    [dict writeToFile:[Application reviewsFile] atomically:YES];
}

- (void) applicationWillTerminate {
    [self onComplete:nil];
}

@end
