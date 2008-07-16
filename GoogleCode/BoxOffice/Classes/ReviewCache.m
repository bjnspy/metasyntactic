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

@implementation ReviewCache

static NSString* MOVIE_REVIEWS = @"movieReviews";

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
        
        NSDictionary* dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:MOVIE_REVIEWS];
        if (dict == nil) {
            for (NSString* movieId in dict) {
                [self.movieToReviewMap setObject:[Review reviewWithDictionary:[dict objectForKey:movieId]]
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
    [self performSelectorInBackground:@selector(updateInBackground:) withObject:supplementaryInformation];
}

- (NSArray*) extractReviewSections:(NSString*) reviewPage {
    NSArray* rows = [reviewPage componentsSeparatedByString:@"\n"];
    
    int lineNumber;
    for (lineNumber = 0; lineNumber < rows.count; lineNumber++) {
        NSString* line = [rows objectAtIndex:lineNumber];
        
        if ([line rangeOfString:@"<div id=\"Content_Reviews\""].length > 0) {
            break;
        }
    }
    
    NSMutableString* buffer = [NSMutableString string];
    for (;lineNumber < rows.count; lineNumber++) {
        NSString* line = [rows objectAtIndex:lineNumber];
        if ([line rangeOfString:@"<div class=\"main_reviews_column_nav\""].length > 0) {
            break;
        }
        
        [buffer appendString:line];
        [buffer appendString:@"\n"];
    }

    NSString* trimmedString = [buffer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray* sections = [trimmedString componentsSeparatedByString:@"quoteBubble"];
    
    NSMutableArray* result = [NSMutableArray arrayWithArray:sections];
    [result removeObjectAtIndex:0];
    
    return result;
}

- (NSString*) extractText:(NSString*) section {
    NSRange startRange = [section rangeOfString:@"<p>"];
    if (startRange.length <= 0) {
        return nil;
    }
    
    NSRange endRange = [section rangeOfString:@"</p>"];
    if (startRange.length <= 0) {
        return nil;
    }
    
    NSRange extractRange;
    extractRange.location = startRange.location + startRange.length;
    extractRange.length = endRange.location - extractRange.location;
    return [[section substringWithRange:extractRange] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (Review*) extractReview:(NSString*) section {
    BOOL positive = [section rangeOfString:@"fresh.gif"].length > 0;
    NSString* text = [self extractText:section];
    
    return [Review reviewWithText:text
                         positive:positive
                             link:@""
                           author:@""
                           source:@""];
}

- (NSArray*) downloadInfoReviews:(ExtraMovieInformation*) info {
    if (info.link.length == 0) {
        return nil;
    }
    
    NSMutableString* link = [NSMutableString stringWithString:info.link];
    if ([link characterAtIndex:(link.length - 1)] != '/') {
        [link appendString:@"/"];
    }
    [link appendString:@"?critic=creamcrop"];
    
    NSURL* url = [NSURL URLWithString:link];
    NSError* httpError = nil;
    NSString* reviewPage = [NSString stringWithContentsOfURL:url encoding:NSISOLatin1StringEncoding error:&httpError];
    
    if (httpError == nil && reviewPage != nil) {
        NSArray* reviewSections = [self extractReviewSections:reviewPage];
        NSMutableArray* reviews = [NSMutableArray array];
        
        for (NSString* section in reviewSections) {
            Review* review = [self extractReview:section];
            if (review != nil) {
                [reviews addObject:review];
            }
        }
        
        return reviews;
    }
    
    return nil;
}

- (void) reportReviews:(NSArray*) movieIdAndReviews {
    NSString* movieId = [movieIdAndReviews objectAtIndex:0];
    NSArray* reviews = [movieIdAndReviews objectAtIndex:1];
    
    [self.movieToReviewMap setObject:reviews forKey:movieId];
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

- (void) updateInBackground:(NSDictionary*) supplementaryInformation {
    [gate lock];
    {
        [NSThread setThreadPriority:0.0];
        
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
        
        [self downloadReviews:supplementaryInformation];
        [self performSelectorOnMainThread:@selector(onComplete:) withObject:nil waitUntilDone:NO];
        
        [autoreleasePool release];
    }
    [gate unlock];
}

- (NSArray*) reviewsForMovie:(NSString*) movieTitle {
    NSArray* array = [self.movieToReviewMap objectForKey:movieTitle];
    if (array == nil) {
        return [NSArray array];
    }
    return array;
}

- (void) onComplete:(id) nothing {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    for (NSString* movieId in self.movieToReviewMap) {
        NSMutableArray* encodedReviews = [NSMutableArray array];
        
        for (Review* review in [self.movieToReviewMap objectForKey:movieId]) {
            [encodedReviews addObject:[review dictionary]];
        }
        
        [dict setObject:encodedReviews forKey:movieId];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:MOVIE_REVIEWS];
}

- (void) applicationWillTerminate {
    [self onComplete:nil];
}

@end
