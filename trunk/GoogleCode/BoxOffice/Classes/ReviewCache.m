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
                NSMutableArray* reviews = [NSMutableArray array];
                
                for (NSDictionary* child in [dict objectForKey:movieId]) {
                    [reviews addObject:[Review reviewWithDictionary:child]];
                }
                
                [self.movieToReviewMap setObject:reviews
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
        if ([self.movieToReviewMap objectForKey:title] == nil) {
            [infoWithoutReviews setObject:[supplementaryInformation objectForKey:title] forKey:title];
        } else {
            [infoWithReviews setObject:[supplementaryInformation objectForKey:title] forKey:title];
        }
    }
    
    [self performSelectorInBackground:@selector(updateInBackground:)
                           withObject:[NSArray arrayWithObjects:infoWithoutReviews, infoWithReviews, nil]];
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
    NSString* result = [[section substringWithRange:extractRange] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    result = [result stringByReplacingOccurrencesOfString:@"<i>" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"</i>" withString:@""];
    
    return result;
}

- (NSString*) extractLink:section {
    NSRange fullReviewRange = [section rangeOfString:@"Full Review"];
    if (fullReviewRange.length == 0) {
        return nil;
    }
    
    NSRange searchRange;
    searchRange.location = 0;
    searchRange.length = fullReviewRange.location;
    
    NSRange hrefRange = [section rangeOfString:@"href=\"" options:NSBackwardsSearch range:searchRange];
    if (hrefRange.length == 0) {
        return nil;
    }
    
    NSRange startRange;
    startRange.location = hrefRange.location + hrefRange.length;
    startRange.length = fullReviewRange.location - startRange.location;
    
    NSRange quoteRange = [section rangeOfString:@"\"" options:0 range:startRange];
    if (quoteRange.length == 0) {
        return nil;
    }
    
    NSRange extractRange;
    extractRange.location = startRange.location;
    extractRange.length = quoteRange.location - extractRange.location;
    NSString* address = [section substringWithRange:extractRange];
    
    return [NSString stringWithFormat:@"http://www.rottentomatoes.com%@", address];
}

- (NSString*) extractCriticInformation:(NSString*) section
                                anchor:(NSString*) anchor {
    NSRange authorRange = [section rangeOfString:anchor];
    if (authorRange.length == 0) {
        return nil;
    }
    
    NSRange searchRange;
    searchRange.location = authorRange.location + authorRange.length;
    searchRange.length = [section length] - searchRange.location;
    NSRange startRange = [section rangeOfString:@"\">" options:0 range:searchRange];
    if (startRange.length == 0) {
        return nil;
    }
    
    searchRange.location = startRange.location;
    searchRange.length = [section length] - searchRange.location;
    NSRange endRange = [section rangeOfString:@"</a>" options:0 range:searchRange];
    if (endRange.length == 0) {
        return nil;
    }
    
    NSRange extractRange;
    extractRange.location = startRange.location + startRange.length;
    extractRange.length = endRange.location - extractRange.location;
    return [section substringWithRange:extractRange];
}

- (NSString*) extractAuthor:(NSString*) section {
    return [self extractCriticInformation:section anchor:@"<div class=\"author\">"];
}

- (NSString*) extractSource:(NSString*) section {
    return [self extractCriticInformation:section anchor:@"<div class=\"source\">"];
}

- (Review*) extractReview:(NSString*) section {
    NSString* text = [self extractText:section];
    if (text == nil) {
        return nil;
    }
    
    BOOL positive = [section rangeOfString:@"fresh.gif"].length > 0;
    NSString* link = [self extractLink:section];
    NSString* author = [self extractAuthor:section];
    NSString* source = [self extractSource:section];
    
    return [Review reviewWithText:text
                         positive:positive
                             link:link
                           author:author
                           source:source];
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
    
    [dict writeToFile:[Application reviewsFile] atomically:YES];
}

- (void) applicationWillTerminate {
    [self onComplete:nil];
}

@end
