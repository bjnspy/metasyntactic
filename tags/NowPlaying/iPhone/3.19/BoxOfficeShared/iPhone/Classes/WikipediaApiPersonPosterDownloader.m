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

#import "WikipediaApiPersonPosterDownloader.h"

#import "Application.h"

@interface WikipediaApiPersonPosterDownloader()
@property (retain) NSSet* stockImageNames;
@end


@implementation WikipediaApiPersonPosterDownloader

@synthesize stockImageNames;

- (void) dealloc {
  self.stockImageNames = nil;
  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.stockImageNames =
      [NSSet setWithObjects:
       @"file:us-actor.png",
       @"file:spainfilm.png", nil];
  }

  return self;
}


- (BOOL) hasProperSuffix:(NSString*) name {
  NSString* lowercaseName = [name lowercaseString];

  return
    [lowercaseName hasSuffix:@"png"] ||
    [lowercaseName hasSuffix:@"jpg"] ||
    [lowercaseName hasSuffix:@"jpeg"];
}


- (BOOL) isStockImage:(NSString*) name {
  NSString* lowercaseName = [name lowercaseString];
  return [stockImageNames containsObject:lowercaseName];
}


- (NSArray*) determineImageAddresses:(Person*) person
                    wikipediaAddress:(NSString*) wikipediaAddress {
  NSRange slashRange = [wikipediaAddress rangeOfString:@"/" options:NSBackwardsSearch];
  if (slashRange.length == 0) {
    return nil;
  }

  NSString* wikiTitle = [wikipediaAddress substringFromIndex:slashRange.location + 1];
  if (wikiTitle.length == 0) {
    return nil;
  }

  NSString* wikiSearchAddress = [NSString stringWithFormat:@"http://en.wikipedia.org/w/api.php?action=query&titles=%@&prop=images&format=xml", wikiTitle];
  XmlElement* apiElement = [NetworkUtilities xmlWithContentsOfAddress:wikiSearchAddress];
  NSArray* imElements = [apiElement elements:@"im" recurse:YES];

  NSMutableArray* imageNames = [NSMutableArray array];
  for (XmlElement* imElement in imElements) {
    NSString* name = [imElement attributeValue:@"title"];
    if ([self hasProperSuffix:name] &&
        ![self isStockImage:name]) {
      [imageNames addObject:name];
    }
  }

  NSMutableArray* imageAddresses = [NSMutableArray array];
  for (NSString* imageName in imageNames) {
    NSString* wikiDetailsAddress = [NSString stringWithFormat:@"http://en.wikipedia.org/w/api.php?action=query&titles=%@&prop=imageinfo&iiprop=url&format=xml",
                                    [StringUtilities stringByAddingPercentEscapes:imageName]];
    XmlElement* apiElement2 = [NetworkUtilities xmlWithContentsOfAddress:wikiDetailsAddress];
    XmlElement* iiElement = [apiElement2 element:@"ii" recurse:YES];

    NSString* imageUrl = [iiElement attributeValue:@"url"];
    if (imageUrl.length > 0) {
      [imageAddresses addObject:imageUrl];
    }
  }

  return imageAddresses;
}

@end
