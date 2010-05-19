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

#import "AbstractWikipediaPersonPosterDownloader.h"

#import "WikipediaCache.h"

@implementation AbstractWikipediaPersonPosterDownloader

- (NSArray*) determineImageAddresses:(Person*) person
                    wikipediaAddress:(NSString*) wikipediaAddress AbstractMethod;


- (NSString*) wikipediaAddress:(Person*) person {
  NSString* result = [[WikipediaCache cache] addressForPerson:person];
  if (result.length > 0) {
    return result;
  }
  [[WikipediaCache cache] updatePersonDetails:person force:YES];
  return [[WikipediaCache cache] addressForPerson:person];
}


- (NSArray*) determineImageAddresses:(Person*) person  {
  NSString* wikipediaAddress = [self wikipediaAddress:person];
  return [self determineImageAddresses:person
                      wikipediaAddress:wikipediaAddress];
}

@end
