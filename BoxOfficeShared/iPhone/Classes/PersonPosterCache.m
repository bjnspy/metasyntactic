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

#import "PersonPosterCache.h"

#import "Application.h"

@interface PersonPosterCache()
@end


@implementation PersonPosterCache

static PersonPosterCache* cache;

+ (void) initialize {
  if (self == [PersonPosterCache class]) {
    cache = [[PersonPosterCache alloc] init];
  }
}


- (void) dealloc {
  [super dealloc];
}


+ (PersonPosterCache*) cache {
  return cache;
}


- (void) updatePersonDetails:(Person*) person force:(BOOL) force {
  [self updateObjectDetails:person force:force];
}


- (NSString*) sentinelPath:(Person*) person {
  NSString* sanitizedTitle = [FileUtilities sanitizeFileName:person.identifier];
  return [[Application sentinelsPeoplePostersDirectory] stringByAppendingPathComponent:sanitizedTitle];
}


- (NSString*) posterFilePath:(Person*) person {
  NSString* sanitizedTitle = [FileUtilities sanitizeFileName:person.identifier];
  return [[[Application peoplePostersDirectory] stringByAppendingPathComponent:sanitizedTitle] stringByAppendingPathExtension:@"jpg"];
}


- (NSString*) smallPosterFilePath:(Person*) person {
  NSString* sanitizedTitle = [FileUtilities sanitizeFileName:person.identifier];
  return [[[Application peoplePostersDirectory] stringByAppendingPathComponent:sanitizedTitle] stringByAppendingString:@"-small.png"];
}


#if 0
- (BOOL) hasProperSuffix:(NSString*) name {
  NSString* lowercaseName = [name lowercaseString];

  return [lowercaseName hasSuffix:@"png"] ||
  [lowercaseName hasSuffix:@"jpg"] ||
  [lowercaseName hasSuffix:@"jpeg"];
}


- (BOOL) isStockImage:(NSString*) name {
  NSString* lowercaseName = [name lowercaseString];

  return
  [@"file:us-actor.png" isEqual:lowercaseName] ||
  [@"file:spainfilm.png" isEqual:lowercaseName];
}
#endif


- (NSString*) getMobileAddress:(NSString*) address {
  NSRange range = [address rangeOfString:@"en.wikipedia.org"];
  if (range.length <= 0) {
    return nil;
  }
  
  return [address stringByReplacingCharactersInRange:range withString:@"en.m.wikipedia.org"];
}


- (NSArray*) getImageAddresses:(NSString*) address {
  if (address.length == 0) {
    return [NSArray array];
  }
  
  NSMutableArray* result = [NSMutableArray array];
  
  NSString* contents = [NetworkUtilities stringWithContentsOfAddress:address];
  for (NSInteger i = 0; i < contents.length; i++) {
    NSRange imgRange = [contents rangeOfString:@"<img" options:0 range:NSMakeRange(i, contents.length - i)];
    if (imgRange.length == 0) {
      break;
    }
    NSString* srcText = @"src=\"";
    NSRange srcRange = [contents rangeOfString:srcText options:0 range:NSMakeRange(imgRange.location, contents.length - imgRange.location)];
    if (srcRange.length > 0) {
      NSInteger searchIndex = srcRange.location + [@"src=\"" length];
      NSRange endQuoteRange = [contents rangeOfString:@"\"" options:0 range:NSMakeRange(searchIndex, contents.length - searchIndex)];
      if (endQuoteRange.length > 0) {
        NSString* subString = [contents substringWithRange:NSMakeRange(searchIndex, endQuoteRange.location - searchIndex)];
        
        if (![result containsObject:subString]) {
          [result addObject:subString];
        }
      }
    }
    
    i = imgRange.location + 1;
  }
  
  return result;
}


- (NSData*) downloadPoster:(Person*) person 
                   address:(NSString*) address {
  NSArray* imageAddresses = [self getImageAddresses:address];
  for (NSString* imageAddress in imageAddresses) {
    NSData* data = [NetworkUtilities dataWithContentsOfAddress:imageAddress];
    UIImage* image = [UIImage imageWithData:data];
    if (image.size.height >= 140) {
      return data;
    }
  }
  
  return nil;
}


- (NSData*) downloadPoster:(Person*) person {
  NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupWikipediaListings%@?q=%@",
                   [Application apiHost], [Application apiVersion],
                   [StringUtilities stringByAddingPercentEscapes:person.name]];
  XmlElement* element = [NetworkUtilities xmlWithContentsOfAddress:url];
  NSString* wikipediaAddress = [element text];
  
  NSData* data = nil;
  if ((data = [self downloadPoster:person address:[self getMobileAddress:wikipediaAddress]]) != nil ||
      (data = [self downloadPoster:person address:wikipediaAddress]) != nil) {
    return data;
  }
  
  return nil;
}

#if 0
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

  NSString* imageName = nil;
  for (XmlElement* imElement in imElements) {
    NSString* name = [imElement attributeValue:@"title"];
    if ([self hasProperSuffix:name] &&
        ![self isStockImage:name]) {
      imageName = name;
      break;
    }
  }

  if (imageName.length == 0) {
    return nil;
  }

  NSString* wikiDetailsAddress = [NSString stringWithFormat:@"http://en.wikipedia.org/w/api.php?action=query&titles=%@&prop=imageinfo&iiprop=url&format=xml", [StringUtilities stringByAddingPercentEscapes:imageName]];
  XmlElement* apiElement2 = [NetworkUtilities xmlWithContentsOfAddress:wikiDetailsAddress];
  XmlElement* iiElement = [apiElement2 element:@"ii" recurse:YES];

  NSString* imageUrl = [iiElement attributeValue:@"url"];

  return [NetworkUtilities dataWithContentsOfAddress:imageUrl];
}
#endif


- (UIImage*) posterForPerson:(Person*) person
                loadFromDisk:(BOOL) loadFromDisk {
  return [self posterForObject:person loadFromDisk:loadFromDisk];
}


- (UIImage*) smallPosterForPerson:(Person*) person
                     loadFromDisk:(BOOL) loadFromDisk {
  return [self smallPosterForObject:person loadFromDisk:loadFromDisk];
}

@end
