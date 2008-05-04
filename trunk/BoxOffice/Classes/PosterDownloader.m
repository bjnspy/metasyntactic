//
//  PosterDownloader.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PosterDownloader.h"
#import "XmlParser.h"
#import "XmlElement.h"
#import "DifferenceEngine.h"
#import "XmlSerializer.h"
#import "ImdbPosterDownloader.h"
#import "AmazonPosterDownloader.h"

@implementation PosterDownloader

@synthesize movie;

- (id) initWithMovie:(Movie*) movie_
{
    if (self = [super init])
    {
        self.movie = movie_;
    }
    
    return self;
}

- (void) dealloc
{
    self.movie = nil;
    [super dealloc];
}

+ (NSData*) download:(Movie*) movie
{
    PosterDownloader* downloader = [[[PosterDownloader alloc] initWithMovie:movie] autorelease];
    return [downloader go];
}

- (NSData*) go
{
    NSData* data = [[[[ImdbPosterDownloader alloc] initWithMovie:self.movie] autorelease] go];
    if (data != nil)
    {
        return data;
    }
    
    data = [[[[AmazonPosterDownloader alloc] initWithMovie:self.movie] autorelease] go];
    if (data != nil)
    {
        return data;
    }
    
    return nil;
}

@end
