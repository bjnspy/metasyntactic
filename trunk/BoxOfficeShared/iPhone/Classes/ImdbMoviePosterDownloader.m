// Copyright 2010 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "ImdbMoviePosterDownloader.h"

#import "Application.h"

@implementation ImdbMoviePosterDownloader

- (NSString*) imdbId:(Movie*) movie {
  NSString* escapedTitle = [movie.canonicalTitle stringByAddingPercentEscapesUsingEncoding:NSISOLatin1StringEncoding];
  if (escapedTitle != nil) {
    NSString* address = [@"http://www.trynt.com/movie-imdb-api/v2/?t=" stringByAppendingString:escapedTitle];
    NSString* fullAddress = [NSString stringWithFormat:@"http://%@.appspot.com/LookupCachedResource%@?q=%@",
                             [Application apiHost], [Application apiVersion],
                             [StringUtilities stringByAddingPercentEscapes:address]];

    XmlElement* tryntElement = [NetworkUtilities xmlWithContentsOfAddress:fullAddress pause:NO];

    XmlElement* movieImdbElement = [tryntElement element:@"movie-imdb"];
    XmlElement* matchedIdElement = [movieImdbElement element:@"matched-id"];

    return matchedIdElement.text;
  }

  return nil;
}


- (NSString*) imageUrl:(NSString*) imdbId {
  if (imdbId == nil) {
    return nil;
  }

  NSString* address = [@"http://www.trynt.com/movie-imdb-api/v2/?i=" stringByAppendingString:imdbId];
  NSString* fullAddress = [NSString stringWithFormat:@"http://%@.appspot.com/LookupCachedResource%@?q=%@",
                           [Application apiHost], [Application apiVersion],
                           [StringUtilities stringByAddingPercentEscapes:address]];

  XmlElement* tryntElement = [NetworkUtilities xmlWithContentsOfAddress:fullAddress pause:NO];
  XmlElement* movieImdbElement = [tryntElement element:@"movie-imdb"];
  XmlElement* pictureUrlElement = [movieImdbElement element:@"picture-url"];

  return pictureUrlElement.text;
}


- (NSData*) downloadImage:(NSString*) imageUrl {
  if (imageUrl == nil) {
    return nil;
  }

  return [NetworkUtilities dataWithContentsOfAddress:imageUrl];
}


- (NSData*) download:(Movie*) movie {
  NSString* imdbId = [self imdbId:movie];
  NSString* imageUrl = [self imageUrl:imdbId];
  return [self downloadImage:imageUrl];
}

@end
