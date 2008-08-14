// Copyright (c) 2008, Cyrus Najmabadi
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
//   Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
//
//   Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
//   Neither the name 'Cyrus Najmabadi' nor the names of its contributors may be
//   used to endorse or promote products derived from this software without
//   specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#import "ImdbPosterDownloader.h"

#import "Movie.h"
#import "XmlElement.h"
#import "XmlParser.h"

@implementation ImdbPosterDownloader

- (NSString*) imdbId {
    NSString* escapedTitle = [self.movie.canonicalTitle stringByAddingPercentEscapesUsingEncoding:NSISOLatin1StringEncoding];
    if (escapedTitle != nil) {
        NSString* urlString = [@"http://www.trynt.com/movie-imdb-api/v2/?t=" stringByAppendingString:escapedTitle];
        NSURL* url = [NSURL URLWithString:urlString];

        NSData* imdbData = [NSData dataWithContentsOfURL:url];
        if (imdbData != nil) {
            XmlElement* tryntElement = [XmlParser parse:imdbData];
            XmlElement* movieImdbElement = [tryntElement element:@"movie-imdb"];
            XmlElement* matchedIdElement = [movieImdbElement element:@"matched-id"];

            return [matchedIdElement text];
        }
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
