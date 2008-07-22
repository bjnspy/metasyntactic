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

- (void) dealloc {
    self.model = nil;
    self.gate = nil;
    
    [super dealloc];
}

- (id) initWithModel:(BoxOfficeModel*) model_ {
    if (self = [super init]) {
        self.model = model_;
        self.gate = [[[NSLock alloc] init] autorelease];
    }
    
    return self;
}

+ (ReviewCache*) cacheWithModel:(BoxOfficeModel*) model {
    return [[[ReviewCache alloc] initWithModel:model] autorelease];
}

- (NSString*) reviewFilePath:(NSString*) title {
    NSString* sanitizedTitle = [title stringByReplacingOccurrencesOfString:@"/" withString:@"-slash-"];
    return [[[Application reviewsFolder] stringByAppendingPathComponent:sanitizedTitle] stringByAppendingPathExtension:@"plist"];
}

- (NSArray*) loadReviewFile:(NSString*) title {
    NSArray* encodedReviews = [NSArray arrayWithContentsOfFile:[self reviewFilePath:title]];
    
    NSMutableArray* reviews = [NSMutableArray array];
    for (NSDictionary* dict in encodedReviews) {
        [reviews addObject:[Review reviewWithDictionary:dict]];
    }
    return reviews;
}


- (void) saveMovie:(NSString*) title reviews:(NSArray*) reviews {
    NSMutableArray* encodedReviews = [NSMutableArray array];
    for (Review* review in reviews) {
        [encodedReviews addObject:[review dictionary]];
    }
    
    [encodedReviews writeToFile:[self reviewFilePath:title] atomically:YES];
}

- (void) update:(NSDictionary*) supplementaryInformation ratingsProvider:(NSInteger) ratingsProvider {
    NSMutableDictionary* infoWithReviews = [NSMutableDictionary dictionary];
    NSMutableDictionary* infoWithoutReviews = [NSMutableDictionary dictionary];
    
    for (NSString* title in supplementaryInformation) {
        NSError* error = nil;
        NSDate* downloadDate = [[[NSFileManager defaultManager] attributesOfItemAtPath:[self reviewFilePath:title]
                                                                                 error:&error] objectForKey:NSFileModificationDate];
        
        if (downloadDate == nil) {
            [infoWithoutReviews setObject:[supplementaryInformation objectForKey:title] forKey:title];
        } else {
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
    
    [self saveMovie:movieId reviews:reviews];
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
        }
        
        [autoreleasePool release];
    }
    [gate unlock];
}

- (NSArray*) reviewsForMovie:(NSString*) movieTitle {
    NSArray* array = [self loadReviewFile:movieTitle];
    if (array == nil) {
        return [NSArray array];
    }
    return array;
}

- (void) clear {
    NSArray* contents = [[NSFileManager defaultManager] directoryContentsAtPath:[Application reviewsFolder]];
    for (NSString* filePath in contents) {
        NSError* error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    }
}

@end
