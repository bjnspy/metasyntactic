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

#import "NetflixUtilities.h"

#import "Movie.h"
#import "NetflixAccount.h"
#import "NetflixAccountCache.h"
#import "NetflixAuthentication.h"
#import "NetflixConstants.h"
#import "NetflixSharedApplication.h"

@implementation NetflixUtilities

static NSDictionary* availabilityMap = nil;

+ (void) initialize {
  if (self == [NetflixUtilities class]) {


    availabilityMap =
    [[NSDictionary dictionaryWithObjects:
      [NSArray arrayWithObjects:
       LocalizedString(@"Awaiting Release", @"Movie can't be shipped because it hasn't been released yet"),
       LocalizedString(@"Available Now", @"Movie is available to be shipped now"),
       LocalizedString(@"Saved", @"Movie is the user's 'Saved to watch later' queue"),
       LocalizedString(@"Short Wait", @"There will be a short wait before the movie is released"),
       LocalizedString(@"Short Wait", nil),
       LocalizedString(@"Long Wait", @"There will be a long wait before the movie is released"),
       LocalizedString(@"Very Long Wait", @"There will be a very long wait before the movie is released"),
       LocalizedString(@"Available Soon", @"Movie will be released soon"),
       LocalizedString(@"Not Rentable", @"Movie is not currently rentable"),
       LocalizedString(@"Unknown Release Date", @"The release date for a movie is unknown."),
       LocalizedString(@"Unknown Release Date", nil),
       LocalizedString(@"Unknown Release Date", nil),
       nil]
                                 forKeys:
      [NSArray arrayWithObjects:
       @"awaiting release",
       @"available now",
       @"saved",
       @"possible short wait",
       @"short wait",
       @"long wait",
       @"very long wait",
       @"available soon",
       @"not rentable",
       @"release date is unknown; availability is not guaranteed.",
       @"release date is unknown.",
       @"availability date is unknown.",
       nil]] retain];
  }
}


+ (BOOL) canContinue:(NetflixAccount*) account {
  return [NetflixSharedApplication netflixEnabled] &&
  account.userId.length > 0 &&
  [account isEqual:[[NetflixAccountCache cache] currentAccount]];
}


+ (NSArray*) extractFormats:(XmlElement*) element {
  NSMutableArray* formats = [NSMutableArray array];
  for (XmlElement* child in element.children) {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    {
      if ([@"availability" isEqual:child.name]) {
        for (XmlElement* grandChild in child.children) {
          if ([@"category" isEqual:grandChild.name] &&
              [@"http://api.netflix.com/categories/title_formats" isEqual:[grandChild attributeValue:@"scheme"]]) {
            [formats addObject:[grandChild attributeValue:@"term"]];
          }
        }
      }
    }
    [pool release];
  }

  return formats;
}


+ (Movie*) processMovieItem:(XmlElement*) element
                      saved:(BOOL*) saved {
  if (element == nil) {
    return nil;
  }

  NSMutableDictionary* additionalFields = [NSMutableDictionary dictionary];

  NSString* identifier = nil;
  NSString* title = nil;
  NSString* poster = nil;
  NSString* rating = nil;
  NSString* year = nil;
  NSMutableArray* genres = [NSMutableArray array];
  BOOL save = NO;
  BOOL availableNow = YES;
  NSInteger length = 0;
  NSString* availabilityDate = nil;

  for (XmlElement* child in element.children) {
    if ([@"id" isEqual:child.name]) {
      identifier = child.text;
    } else if ([@"availability_date" isEqual:child.name]) {
      availabilityDate = child.text;
    } else if ([@"link" isEqual:child.name]) {
      NSString* rel = [child attributeValue:@"rel"];
      if ([@"alternate" isEqual:rel]) {
        [additionalFields setObject:[child attributeValue:@"href"] forKey:[NetflixConstants linkKey]];
      } else if ([@"http://schemas.netflix.com/catalog/title" isEqual:rel]) {
        NSString* title = [child attributeValue:@"href"];
        if (identifier.length == 0) {
          identifier = title;
        }

        [additionalFields setObject:[child attributeValue:@"href"] forKey:[NetflixConstants titleKey]];
      } else if ([@"http://schemas.netflix.com/catalog/titles.series" isEqual:rel]) {
        [additionalFields setObject:[child attributeValue:@"href"] forKey:[NetflixConstants seriesKey]];
      } else if ([@"http://schemas.netflix.com/catalog/titles/format_availability" isEqual:rel]) {
        NSArray* formats = [self extractFormats:[child element:@"delivery_formats"]];
        if (formats.count > 0) {
          [additionalFields setObject:formats forKey:[NetflixConstants formatsKey]];
        }
      }
    } else if ([@"title" isEqual:child.name]) {
      title = [child attributeValue:@"short"];
      if (title == nil) {
        title = [child attributeValue:@"medium"];
      }
    } else if ([@"box_art" isEqual:child.name]) {
      poster = [child attributeValue:@"large"];
      if (poster == nil) {
        poster = [child attributeValue:@"medium"];
        if (poster == nil) {
          poster = [child attributeValue:@"small"];
        }
      }
    } else if ([@"category" isEqual:child.name]) {
      NSString* scheme = [child attributeValue:@"scheme"];
      if ([@"http://api.netflix.com/categories/mpaa_ratings" isEqual:scheme]) {
        rating = [child attributeValue:@"label"];
      } else if ([@"http://api.netflix.com/categories/genres" isEqual:scheme]) {
        [genres addObject:[child attributeValue:@"label"]];
      } else if ([@"http://api.netflix.com/categories/queue_availability" isEqual:scheme]) {
        NSString* label = [child attributeValue:@"label"];
        save = [label isEqual:@"saved"];
        availableNow = [label isEqual:@"available now"];

        label = [StringUtilities nonNilString:[availabilityMap objectForKey:label]];

        [additionalFields setObject:label forKey:[NetflixConstants availabilityKey]];
      }
    } else if ([@"release_year" isEqual:child.name]) {
      year = child.text;
    } else if ([[NetflixConstants averageRatingKey] isEqual:child.name]) {
      [additionalFields setObject:child.text forKey:[NetflixConstants averageRatingKey]];
    } else if ([@"runtime" isEqual:child.name]) {
      length = ([child.text integerValue] / 60);
    }
  }

  if (identifier.length == 0) {
    return nil;
  }

  NSDate* date = nil;
  if (year.length > 0) {
    date = [DateUtilities dateWithNaturalLanguageString:year];
  }

  if (!availableNow) {
    if (availabilityDate.length > 0) {
      NSDate* date = [NSDate dateWithTimeIntervalSince1970:[availabilityDate integerValue]];
      NSString* string = [NSString stringWithFormat:LocalizedString(@"Available %@", nil), [DateUtilities formatShortDate:date]];

      [additionalFields setObject:string forKey:[NetflixConstants availabilityKey]];
    }
  }

  Movie* movie = [Movie movieWithIdentifier:identifier
                                      title:title
                                     rating:rating
                                     length:length
                                releaseDate:date
                                imdbAddress:nil
                                     poster:poster
                                   synopsis:nil
                                     studio:nil
                                  directors:nil
                                       cast:nil
                                     genres:genres
                           additionalFields:additionalFields];

  if (saved != NULL) {
    *saved = save;
  }

  return movie;
}


+ (NSArray*) extractPeople:(XmlElement*) element {
  NSMutableArray* cast = [NSMutableArray array];

  for (XmlElement* child in element.children) {
    if (cast.count >= 6) {
      // cap the number of actors we care about
      break;
    }

    NSString* name = [child attributeValue:@"title"];
    if (name.length > 0) {
      [cast addObject:name];
    }
  }

  return cast;
}


+ (NSDictionary*) extractMovieDetails:(XmlElement*) element {
  NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
  for (XmlElement* child in element.children) {
    if ([@"link" isEqual:child.name]) {
      NSString* rel = [child attributeValue:@"rel"];
      if ([@"http://schemas.netflix.com/catalog/titles/synopsis" isEqual:rel]) {
        NSString* synopsis = [HtmlUtilities removeHtml:[[child element:@"synopsis"] text]];
        if (synopsis.length > 0) {
          [dictionary setObject:synopsis forKey:[NetflixConstants synopsisKey]];
        }
      } else if ([@"http://schemas.netflix.com/catalog/titles/format_availability" isEqual:rel]) {
        NSArray* formats = [self extractFormats:[child element:@"delivery_formats"]];
        if (formats.count > 0) {
          [dictionary setObject:formats forKey:[NetflixConstants formatsKey]];
        }
      } else if ([@"http://schemas.netflix.com/catalog/people.cast" isEqual:rel]) {
        NSArray* cast = [self extractPeople:[child element:@"people"]];
        if (cast.count > 0) {
          [dictionary setObject:cast forKey:[NetflixConstants castKey]];
        }
      } else if ([@"http://schemas.netflix.com/catalog/people.directors" isEqual:rel]) {
        NSArray* directors = [self extractPeople:[child element:@"people"]];
        if (directors.count > 0) {
          [dictionary setObject:directors forKey:[NetflixConstants directorsKey]];
        }
      }/* else if ([@"http://schemas.netflix.com/catalog/titles.similars" isEqual:rel]) {
        NSArray* similars = [self extractSimilars:[child element:@"catalog_titles"]];
        if (similars.count > 0) {
        [dictionary setObject:similars forKey:similars_key];
        }
        }*/
    }
  }
  return dictionary;
}


+ (NSString*) extractErrorMessage:(XmlElement*) element {
  NSInteger statusCode = [[[element element:@"status_code"] text] integerValue];
  if (statusCode == [NetflixConstants etagMismatchError]) {
    // override this error message since the netflix message is very confusing.
    return [NSString stringWithFormat:LocalizedString(@"%@ must first update your local movie queue before it can process your change. Please try your change again shortly.", nil), [AbstractApplication name]];
  }

  NSString* message = [[element element:@"message"] text];
  if (message.length > 0) {
    return message;
  } else if (element == nil) {
    NSLog(@"Could not parse Netflix result.", nil);
    return LocalizedString(@"Could not connect to Netflix.", nil);
  } else {
    NSLog(@"Netflix response had no 'message' element.\n%@", element);
    return LocalizedString(@"An unknown error occurred.", nil);
  }
}


+ (void) processMovieItem:(XmlElement*) element
                   movies:(NSMutableArray*) movies
                    saved:(NSMutableArray*) saved {
  if (![@"queue_item" isEqual:element.name] &&
      ![@"rental_history_item" isEqual:element.name] &&
      ![@"at_home_item" isEqual:element.name] &&
      ![@"recommendation" isEqual:element.name] &&
      ![@"catalog_title" isEqual:element.name]) {
    return;
  }

  BOOL save;
  Movie* movie = [NetflixUtilities processMovieItem:element saved:&save];

  if (movie == nil) {
    return;
  }

  if (save) {
    [saved addObject:movie];
  } else {
    [movies addObject:movie];
  }
}


+ (void) processMovieItemList:(XmlElement*) element
                       movies:(NSMutableArray*) movies
                        saved:(NSMutableArray*) saved
                     maxCount:(NSInteger) maxCount {
  for (XmlElement* child in element.children) {
    if (maxCount >= 0) {
      if ((movies.count + saved.count) > maxCount) {
        return;
      }
    }
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    {
      [self processMovieItem:child
                      movies:movies
                       saved:saved];
    }
    [pool release];
  }
}


+ (void) processMovieItemList:(XmlElement*) element
                       movies:(NSMutableArray*) movies
                        saved:(NSMutableArray*) saved {
  [self processMovieItemList:element movies:movies
                       saved:saved
                    maxCount:-1];
}

@end
