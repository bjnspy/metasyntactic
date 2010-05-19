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

#import "GoogleScoreProvider.h"

#import "Application.h"
#import "Model.h"
#import "NowPlaying.pb.h"
#import "Score.h"
#import "UserLocationCache.h"

@implementation GoogleScoreProvider

+ (GoogleScoreProvider*) provider {
  return [[[GoogleScoreProvider alloc] init] autorelease];
}


- (NSString*) providerName {
  return @"Google";
}


- (NSString*) serverUrl {
  Location* location = [[UserLocationCache cache] locationForUserAddress:[Model model].userAddress];

  if (location.postalCode == nil) {
    return nil;
  }

  NSString* country = location.country.length == 0 ? [LocaleUtilities isoCountry]
  : location.country;


  NSDateComponents* components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit
                                                                 fromDate:[DateUtilities today]
                                                                   toDate:[Model model].searchDate
                                                                  options:0];
  NSInteger day = components.day;
  day = MIN(MAX(day, 0), 7);

  NSString* address = [NSString stringWithFormat:
                       @"http://%@.appspot.com/LookupTheaterListings%@?country=%@&language=%@&postalcode=%@&day=%d&format=pb&latitude=%d&longitude=%d",
                       [Application apiHost], [Application apiVersion],
                       country,
                       [LocaleUtilities preferredLanguage],
                       [StringUtilities stringByAddingPercentEscapes:location.postalCode],
                       day,
                       (NSInteger)(location.latitude * 1000000),
                       (NSInteger)(location.longitude * 1000000)];

  return address;
}


- (NSString*) lookupServerHash {
  NSString* baseAddress = [self serverUrl];
  NSString* address = [baseAddress stringByAppendingString:@"&hash=true"];
  NSString* value = [NetworkUtilities stringWithContentsOfAddress:address pause:NO];
  return value;
}


- (NSMutableDictionary*) lookupServerScores {
  NSString* address = [self serverUrl];
  NSData* data = [NetworkUtilities dataWithContentsOfAddress:address pause:NO];
  if (data != nil) {
    @try {
      TheaterListingsProto* theaterListings = [TheaterListingsProto parseFromData:data];
      NSArray* movieProtos = theaterListings.moviesList;

      NSMutableDictionary* ratings = [NSMutableDictionary dictionary];

      for (MovieProto* movieProto in movieProtos) {
        NSString* identifier = movieProto.identifier;
        NSString* title = movieProto.title;
        NSInteger score = -1;
        if (movieProto.hasScore) {
          score = movieProto.score;
        }

        Score* info = [Score scoreWithTitle:title
                                   synopsis:@""
                                      score:[NSString stringWithFormat:@"%d", score]
                                   provider:@"google"
                                 identifier:identifier];

        [ratings setObject:info forKey:info.canonicalTitle];
      }

      return ratings;
    } @catch (NSException* e) {
    }
  }

  return nil;
}

@end
