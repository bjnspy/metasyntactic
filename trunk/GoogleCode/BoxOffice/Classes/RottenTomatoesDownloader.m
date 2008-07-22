//
//  RottenTomatoesDownloader.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "RottenTomatoesDownloader.h"
#import "Application.h"
#import "ExtraMovieInformation.h"
#import "Utilities.h"

@implementation RottenTomatoesDownloader

@synthesize model;

- (void) dealloc {
    self.model = nil;
    
    [super dealloc];
}

- (id) initWithModel:(BoxOfficeModel*) model_ {
    if (self = [super init]) {
        self.model = model_;
    }
    
    return self;
}

+ (RottenTomatoesDownloader*) downloaderWithModel:(BoxOfficeModel*) model {
    return [[[RottenTomatoesDownloader alloc] initWithModel:model] autorelease];
}

- (NSDictionary*) lookupMovieListings {
    NSMutableArray* hosts = [Application hosts];
    NSString* host = [Utilities removeRandomElement:hosts];
    host = @"metaboxoffice6";
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@.appspot.com/LookupMovieListings?q=RottenTomatoes", host]];
    NSError* httpError = nil;
    NSString* movieListings = [NSString stringWithContentsOfURL:url encoding:NSISOLatin1StringEncoding error:&httpError];
    
    if (httpError == nil && movieListings != nil) {    
        NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
        
        NSArray* rows = [movieListings componentsSeparatedByString:@"\n"];
        
        // first row are the column headers.  last row is empty.  skip both.
        for (NSInteger i = 1; i < rows.count - 1; i++) {   
            NSArray* columns = [[rows objectAtIndex:i] componentsSeparatedByString:@"\t"];
            
            if (columns.count >= 9) {
                NSString* title = [columns objectAtIndex:1];
                NSString* synopsis = [columns objectAtIndex:8];
                synopsis = [synopsis stringByReplacingOccurrencesOfString:@"<i>" withString:@""];
                synopsis = [synopsis stringByReplacingOccurrencesOfString:@"</i>" withString:@""];
                ExtraMovieInformation* extraInfo = [ExtraMovieInformation infoWithTitle:title
                                                                                   link:[columns objectAtIndex:2]
                                                                               synopsis:synopsis
                                                                                  score:[columns objectAtIndex:3]];
                
                
                [dictionary setObject:extraInfo forKey:[extraInfo title]];
            }
        }
        
        return dictionary;
    }
    
    return nil;
}

@end
