// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "ImdbPosterDownloader.h"

#import "Movie.h"
#import "NetworkUtilities.h"
#import "XmlElement.h"

@implementation ImdbPosterDownloader

+ (NSString*) imdbId:(Movie*) movie {
    NSString* escapedTitle = [movie.canonicalTitle stringByAddingPercentEscapesUsingEncoding:NSISOLatin1StringEncoding];
    if (escapedTitle != nil) {
        NSString* urlString = [@"http://www.trynt.com/movie-imdb-api/v2/?t=" stringByAppendingString:escapedTitle];
        XmlElement* tryntElement = [NetworkUtilities xmlWithContentsOfAddress:urlString important:NO];

        XmlElement* movieImdbElement = [tryntElement element:@"movie-imdb"];
        XmlElement* matchedIdElement = [movieImdbElement element:@"matched-id"];

        return matchedIdElement.text;
    }

    return nil;
}


+ (NSString*) imageUrl:(NSString*) imdbId {
    if (imdbId == nil) {
        return nil;
    }

    NSString* address = [@"http://www.trynt.com/movie-imdb-api/v2/?i=" stringByAppendingString:imdbId];

    XmlElement* tryntElement = [NetworkUtilities xmlWithContentsOfAddress:address important:NO];
    XmlElement* movieImdbElement = [tryntElement element:@"movie-imdb"];
    XmlElement* pictureUrlElement = [movieImdbElement element:@"picture-url"];

    return pictureUrlElement.text;
}


+ (NSData*) downloadImage:(NSString*) imageUrl {
    if (imageUrl == nil) {
        return nil;
    }

    return [NetworkUtilities dataWithContentsOfAddress:imageUrl important:NO];
}


+ (NSData*) download:(Movie*) movie {
    NSString* imdbId = [self imdbId:movie];
    NSString* imageUrl = [self imageUrl:imdbId];
    return [self downloadImage:imageUrl];
}

@end