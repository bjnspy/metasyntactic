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

#import "PreviewNetworksMoviePosterDownloader.h"

#import "Application.h"
#import "InternationalDataCache.h"

@implementation PreviewNetworksMoviePosterDownloader

- (NSDictionary*) processElement:(XmlElement*) element {
  NSMutableDictionary* map = [NSMutableDictionary dictionary];
  for (XmlElement* child in element.children) {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    {
      NSString* title = [[[child element:@"title"] text] lowercaseString];
      NSString* poster = [[child element:@"poster"] text];

      if (title.length > 0 && poster.length > 0) {
        [map setObject:[NSArray arrayWithObject:poster] forKey:title];
      }
    }
    [pool release];
  }

  return map;
}


- (NSDictionary*) createMapWorker {
  if (![InternationalDataCache isAllowableCountry]) {
    return nil;
  }

  NSString* address = [NSString stringWithFormat:@"http://%@.iphone.filmtrailer.com/v2.0/cinema/AllCinemaMovies/?channel_user_id=391100099-1&format=mov&size=xlarge", [[LocaleUtilities isoCountry] lowercaseString]];
  NSString* fullAddress = [NSString stringWithFormat:@"http://%@.appspot.com/LookupCachedResource%@?q=%@",
                           [Application apiHost], [Application apiVersion],
                           [StringUtilities stringByAddingPercentEscapes:address]];

  XmlElement* element;
  if ((element = [NetworkUtilities xmlWithContentsOfAddress:fullAddress pause:NO]) == nil &&
      (element = [NetworkUtilities xmlWithContentsOfAddress:address pause:NO]) == nil) {
    return nil;
  }

  return [self processElement:element];
}

@end
