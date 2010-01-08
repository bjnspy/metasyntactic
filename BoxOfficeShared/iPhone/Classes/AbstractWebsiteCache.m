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

#import "AbstractWebsiteCache.h"

@interface AbstractWebsiteCache()
@end


@implementation AbstractWebsiteCache

- (NSString*) cacheDirectory AbstractMethod;


- (NSString*) serverUrl:(NSString*) name AbstractMethod;


- (NSString*) moviesCacheDirectory {
  return [self.cacheDirectory stringByAppendingPathComponent:@"Movies"];
}


- (NSString*) peopleCacheDirectory {
  return [self.cacheDirectory stringByAppendingPathComponent:@"People"];
}


- (id) init {
  if ((self = [super init])) {
    [FileUtilities createDirectory:self.moviesCacheDirectory];
    [FileUtilities createDirectory:self.peopleCacheDirectory];
  }

  return self;
}


- (NSString*) movieAddressFile:(Movie*) movie {
  NSString* name = [[FileUtilities sanitizeFileName:movie.canonicalTitle] stringByAppendingPathExtension:@"plist"];
  return [self.moviesCacheDirectory stringByAppendingPathComponent:name];
}


- (NSString*) personAddressFile:(Person*) person {
  NSString* name = [[FileUtilities sanitizeFileName:person.name] stringByAppendingPathExtension:@"plist"];
  return [self.peopleCacheDirectory stringByAppendingPathComponent:name];
}


- (void) updateObjectDetails:(NSString*) name
                        path:(NSString*) path
                       force:(BOOL) force {
  NSDate* lastLookupDate = [FileUtilities modificationDate:path];
  if (lastLookupDate != nil) {
    NSString* value = [FileUtilities readObject:path];
    if (value.length > 0) {
      // we have a real imdb value for this movie
      return;
    }

    if (!force) {
      // we have a sentinel.  only update if it's been long enough
      if (ABS(lastLookupDate.timeIntervalSinceNow) < THREE_DAYS) {
        return;
      }
    }
  }

  NSString* url = [self serverUrl:name];
  NSData* data = [NetworkUtilities dataWithContentsOfAddress:url pause:NO];
  if (data == nil) {
    return;
  }

  XmlElement* element = [XmlParser parse:data];
  NSString* addressValue = [element text];
  if (addressValue == nil) {
    addressValue = @"";
  }

  // write down the response (even if it is empty).  An empty value will
  // ensure that we don't update this entry too often.
  [FileUtilities writeObject:addressValue toFile:path];
  if (addressValue.length > 0) {
    [MetasyntacticSharedApplication minorRefresh];
  }
}


- (void) updateMovieDetails:(Movie*) movie
                      force:(BOOL) force {
  [self updateObjectDetails:movie.canonicalTitle
                       path:[self movieAddressFile:movie]
                      force:force];
}


- (void) updatePersonDetails:(Person*) person
                      force:(BOOL) force {
  [self updateObjectDetails:person.name
                       path:[self personAddressFile:person]
                      force:force];
}


- (NSString*) addressForMovie:(Movie*) movie {
  return [FileUtilities readObject:[self movieAddressFile:movie]];
}


- (NSString*) addressForPerson:(Person*) person {
  return [FileUtilities readObject:[self personAddressFile:person]];
}

@end
