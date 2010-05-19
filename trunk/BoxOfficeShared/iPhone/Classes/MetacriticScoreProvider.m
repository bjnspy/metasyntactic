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

#import "MetacriticScoreProvider.h"

#import "Application.h"
#import "Score.h"

@implementation MetacriticScoreProvider

+ (MetacriticScoreProvider*) provider {
  return [[[MetacriticScoreProvider alloc] init] autorelease];
}


- (NSString*) providerName {
  return @"Metacritic";
}


- (NSString*) lookupServerHash {
  NSString* address = [NSString stringWithFormat:@"http://%@.appspot.com/LookupMovieScores%@?q=metacritic&hash=true",
                       [Application apiHost], [Application apiVersion]];
  NSString* value = [NetworkUtilities stringWithContentsOfAddress:address pause:NO];
  return value;
}


- (NSMutableDictionary*) lookupServerScores {
  NSString* address = [NSString stringWithFormat:@"http://%@.appspot.com/LookupMovieScores%@?q=metacritic",
                       [Application apiHost], [Application apiVersion]];
  XmlElement* resultElement = [NetworkUtilities xmlWithContentsOfAddress:address pause:NO];

  if (resultElement != nil) {
    NSMutableDictionary* ratings = [NSMutableDictionary dictionary];

    for (XmlElement* movieElement in resultElement.children) {
      NSString* title =    [movieElement attributeValue:@"title"];
      NSString* link =     [movieElement attributeValue:@"link"];
      NSString* synopsis = [movieElement attributeValue:@"synopsis"];
      NSString* score =    [movieElement attributeValue:@"score"];

      if ([score isEqual:@"xx"]) {
        score = @"-1";
      }

      Score* extraInfo = [Score scoreWithTitle:title
                                      synopsis:synopsis
                                         score:score
                                      provider:@"metacritic"
                                    identifier:link];

      [ratings setObject:extraInfo forKey:extraInfo.canonicalTitle];
    }

    return ratings;
  }

  return nil;
}

@end
