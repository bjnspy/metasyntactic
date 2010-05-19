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

#import "NetflixUserCache.h"

#import "NetflixAccount.h"
#import "NetflixNetworking.h"
#import "NetflixPaths.h"
#import "NetflixSiteStatus.h"
#import "NetflixUser.h"

@implementation NetflixUserCache

static NetflixUserCache* cache;

+ (void) initialize {
  if (self == [NetflixUserCache class]) {
    cache = [[NetflixUserCache alloc] init];
  }
}


+ (NetflixUserCache*) cache {
  return cache;
}


- (XmlElement*) downloadXml:(NSURLRequest*) request
                    account:(NetflixAccount*) account {
  XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request];

  [[NetflixSiteStatus status] checkApiResult:element];

  return element;

}


- (NetflixUser*) downloadUserInformation:(NetflixAccount*) account {
  NSLog(@"NetflixCache:downloadUserInformation");

  NSString* address = [NSString stringWithFormat:@"http://api.netflix.com/users/%@", account.userId];
  NSURLRequest* request = [NetflixNetworking createGetURLRequest:address account:account];

  XmlElement* element = [self downloadXml:request account:account];

  NSString* firstName = [[element element:@"first_name"] text];
  NSString* lastName = [[element element:@"last_name"] text];
  BOOL canInstantWatch = [[[element element:@"can_instant_watch"] text] isEqual:@"true"];

  NSMutableArray* preferredFormats = [NSMutableArray array];
  for (XmlElement* child in [[element element:@"preferred_formats"] children]) {
    if ([@"category" isEqual:child.name]) {
      if ([@"http://api.netflix.com/categories/title_formats" isEqual:[child attributeValue:@"scheme"]]) {
        NSString* label = [child attributeValue:@"label"];
        if (label.length > 0) {
          [preferredFormats addObject:label];
        }
      }
    }
  }

  if (firstName.length == 0 && lastName.length == 0) {
    return nil;
  }

  [FileUtilities createDirectory:[NetflixPaths accountDirectory:account]];
  NetflixUser* user = [NetflixUser userWithFirstName:firstName lastName:lastName canInstantWatch:canInstantWatch preferredFormats:preferredFormats];
  [FileUtilities writeObject:user.dictionary toFile:[NetflixPaths userFile:account]];
  return user;
}


- (NetflixUser*) userForAccount:(NetflixAccount*) account {
  if (account == nil) {
    return nil;
  }

  NSDictionary* dictionary = [FileUtilities readObject:[NetflixPaths userFile:account]];
  return [NetflixUser createWithDictionary:dictionary];
}

@end
