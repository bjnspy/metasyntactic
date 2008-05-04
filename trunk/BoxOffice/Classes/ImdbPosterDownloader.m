//
//  ImdbPosterDownloader.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/4/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ImdbPosterDownloader.h"
#import "XmlParser.h"
#import "XmlSerializer.h"

@implementation ImdbPosterDownloader

- (id) initWithMovie:(Movie*) movie_
{
    if (self = [super initWithMovie:movie_])
    {
    }
    
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (NSData*) go
{
    NSString* imdbId = [self imdbId];
    NSString* imageUrl = [self imageUrl:imdbId];
    return [self downloadImage:imageUrl];
}

- (NSData*) downloadImage:(NSString*) imageUrl
{
    if (imageUrl == nil)
    {
        return nil;
    }
    
    return [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
}

- (NSString*) imdbId
{
    NSString* escapedTitle = [self.movie.title stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString* urlString = [@"http://www.trynt.com/movie-imdb-api/v2/?t=" stringByAppendingString:escapedTitle];
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSData* imdbData = [NSData dataWithContentsOfURL:url];
    if (imdbData == nil)
    {
        NSLog(@"Error occurred retrieving imdb data: %@", self.movie.title);
        return nil;
    }
    
    XmlElement* tryntElement = [XmlParser parse:imdbData];
    XmlElement* movieImdbElement = [tryntElement element:@"movie-imdb"];
    XmlElement* matchedIdElement = [movieImdbElement element:@"matched-id"];
    
    return [matchedIdElement text];
}

- (NSString*) imageUrl:(NSString*) imdbId
{
    if (imdbId == nil)
    {
        return nil;
    }
    
    NSString* urlString = [@"http://www.trynt.com/movie-imdb-api/v2/?i=" stringByAppendingString:imdbId];
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSData* imdbData = [NSData dataWithContentsOfURL:url];
    if (imdbData == nil)
    {
        NSLog(@"Error occurred retrieving imdb image url: %@", self.movie.title);
        return nil;
    }
    
    XmlElement* tryntElement = [XmlParser parse:imdbData];
    XmlElement* movieImdbElement = [tryntElement element:@"movie-imdb"];
    XmlElement* pictureUrlElement = [movieImdbElement element:@"picture-url"];
    
    return [pictureUrlElement text];
}

@end
