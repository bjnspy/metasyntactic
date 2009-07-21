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

#import "PreviewNetworksPosterDownloader.h"

#import "Application.h"
#import "InternationalDataCache.h"

@implementation PreviewNetworksPosterDownloader

- (NSDictionary*) processElement:(XmlElement*) element {
  NSMutableDictionary* map = [NSMutableDictionary dictionary];
  for (XmlElement* child in element.children) {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    {
      NSString* title = [[[child element:@"title"] text] lowercaseString];
      NSString* poster = [[child element:@"poster"] text];

      if (title.length > 0 && poster.length > 0) {
        [map setObject:poster forKey:title];
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
  NSString* fullAddress = [NSString stringWithFormat:@"http://%@.appspot.com/LookupCachedResource?q=%@",
                           [Application host],
                           [StringUtilities stringByAddingPercentEscapes:address]];

  XmlElement* element;
  if ((element = [NetworkUtilities xmlWithContentsOfAddress:fullAddress pause:NO]) == nil &&
      (element = [NetworkUtilities xmlWithContentsOfAddress:address pause:NO]) == nil) {
    return nil;
  }

  return [self processElement:element];
}

@end
