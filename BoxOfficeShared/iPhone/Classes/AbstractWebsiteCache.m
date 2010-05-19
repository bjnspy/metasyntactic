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

#import "AbstractWebsiteCache.h"

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
