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
