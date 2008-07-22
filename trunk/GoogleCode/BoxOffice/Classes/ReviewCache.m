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
#import "BoxOfficeModel.h"

@implementation ReviewCache

@synthesize model;
@synthesize gate;
@synthesize movieToReviewMap;

- (void) dealloc {
    self.model = nil;
    self.gate = nil;
    self.movieToReviewMap = nil;
    
    [super dealloc];
}

- (id) initWithModel:(BoxOfficeModel*) model_ {
    if (self = [super init]) {
        self.model = model_;
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

+ (ReviewCache*) cacheWithModel:(BoxOfficeModel*) model {
    return [[[ReviewCache alloc] initWithModel:model] autorelease];
}

- (void) update:(NSDictionary*) supplementaryInformation ratingsProvider:(NSInteger) ratingsProvider {
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
                           withObject:[NSArray arrayWithObjects:infoWithoutReviews, infoWithReviews, [NSNumber numberWithInt:ratingsProvider], nil]];
}

- (NSArray*) extractReviews:(NSString*) reviewPage {
    NSMutableArray* result = [NSMutableArray array];
    
    NSArray* rows = [reviewPage componentsSeparatedByString:@"\n"];
    for (NSString* row in rows) {
        NSArray* columns = [row componentsSeparatedByString:@"\t"];
        
        if (columns.count < 5) {
            continue;
        }
        
        NSString* score = [columns objectAtIndex:1];
        NSInteger scoreValue = [score intValue];
        
        [result addObject:[Review reviewWithText:[columns objectAtIndex:0]
                                           score:scoreValue
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
    
    NSMutableArray* hosts = [Application hosts];
    NSInteger index = abs([Utilities hashString:info.link]) % hosts.count;
    NSString* host = [hosts objectAtIndex:index];
    
    NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupMovieReviews?q=%@", host, info.link];
    
    NSError* httpError = nil;
    NSString* reviewPage = [NSString stringWithContentsOfURL:[NSURL URLWithString:url]
                                                    encoding:NSISOLatin1StringEncoding
                                                       error:&httpError];
    
    if (httpError == nil && reviewPage != nil) {
        return [self extractReviews:reviewPage];
    }
    
    return nil;
}

- (void) reportReviews:(NSArray*) arguments {
    NSString* movieId = [arguments objectAtIndex:0];
    NSArray* reviews = [arguments objectAtIndex:1];
    NSInteger ratingsProvider = [[arguments objectAtIndex:2] intValue];
    
    if (ratingsProvider != [self.model ratingsProviderIndex]) {
        return;
    }
    
    NSArray* dateAndReviews = [NSArray arrayWithObjects:[NSDate date], reviews, nil];
    
    [self.movieToReviewMap setObject:dateAndReviews forKey:movieId];
}

- (void) downloadReviews:(NSDictionary*) supplementaryInformation
         ratingsProvider:(NSInteger) ratingsProvider {
    for (NSString* movieId in supplementaryInformation) {
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
        
        ExtraMovieInformation* info = [supplementaryInformation objectForKey:movieId];
        NSArray* reviews = [self downloadInfoReviews:info];
        if (reviews.count > 0) {
            NSArray* arguments = [NSArray arrayWithObjects:movieId, reviews, [NSNumber numberWithInt:ratingsProvider], nil];
            [self performSelectorOnMainThread:@selector(reportReviews:) withObject:arguments waitUntilDone:NO];
        }
        
        [autoreleasePool release];
    }
}

- (void) updateInBackground:(NSArray*) arguments {
    [gate lock];
    {
        [NSThread setThreadPriority:0.0];
        
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
        
        NSInteger ratingsProvider = [[arguments lastObject] intValue];
        for (int i = 0; i < [arguments count] - 1; i++) {
            [self downloadReviews:[arguments objectAtIndex:i] ratingsProvider:ratingsProvider];
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

- (void) clear {
    self.movieToReviewMap = [NSMutableDictionary dictionary];
    [self onComplete:nil];
}

- (void) applicationWillTerminate {
    [self onComplete:nil];
}

@end
