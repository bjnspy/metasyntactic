//
//  ImdbPosterDownloader.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/4/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "ImdbPosterDownloader.h"
#import "XmlParser.h"
#import "XmlSerializer.h"

@implementation ImdbPosterDownloader

- (NSString*) imdbId {
    NSString* escapedTitle = [self.movie.title stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString* urlString = [@"http://www.trynt.com/movie-imdb-api/v2/?t=" stringByAppendingString:escapedTitle];
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSData* imdbData = [NSData dataWithContentsOfURL:url];
    if (imdbData != nil) {
        XmlElement* tryntElement = [XmlParser parse:imdbData];
        XmlElement* movieImdbElement = [tryntElement element:@"movie-imdb"];
        XmlElement* matchedIdElement = [movieImdbElement element:@"matched-id"];
        
        return [matchedIdElement text];
    }
    
    return nil;
}

- (NSString*) imageUrl:(NSString*) imdbId {
    if (imdbId == nil) {
        return nil;
    }
    
    NSString* urlString = [@"http://www.trynt.com/movie-imdb-api/v2/?i=" stringByAppendingString:imdbId];
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSData* imdbData = [NSData dataWithContentsOfURL:url];
    if (imdbData != nil) {
        XmlElement* tryntElement = [XmlParser parse:imdbData];
        XmlElement* movieImdbElement = [tryntElement element:@"movie-imdb"];
        XmlElement* pictureUrlElement = [movieImdbElement element:@"picture-url"];
        
        return [pictureUrlElement text];
    }
    
    return nil;
}

- (NSData*) downloadImage:(NSString*) imageUrl {
    if (imageUrl == nil) {
        return nil;
    }
    
    return [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
}

- (NSData*) go {
    NSString* imdbId = [self imdbId];
    NSString* imageUrl = [self imageUrl:imdbId];
    return [self downloadImage:imageUrl];
}

+ (NSData*) download:(Movie*) movie {
    ImdbPosterDownloader* downloader = [[[ImdbPosterDownloader alloc] initWithMovie:movie] autorelease];
    return [downloader go];
}

@end
