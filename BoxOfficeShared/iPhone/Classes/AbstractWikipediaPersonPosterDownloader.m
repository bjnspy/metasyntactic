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
