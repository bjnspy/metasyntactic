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

#import "Donation.h"

@interface Donation()
@property (copy) NSString* itunesIdentifier;
@end


@implementation Donation

@synthesize itunesIdentifier;

- (void) dealloc {
  self.itunesIdentifier = nil;
  [super dealloc];
}


- (id) initWithItunesIdentifier:(NSString*) itunesIdentifier_ {
  if ((self = [super init])) {
    self.itunesIdentifier = itunesIdentifier_;
  }

  return self;
}


+ (Donation*) donationWithItunesIdentifier:(NSString*) itunesIdentifier {
  return [[[Donation alloc] initWithItunesIdentifier:itunesIdentifier] autorelease];
}


- (NSString*) identifier {
  return itunesIdentifier;
}


- (NSString*) canonicalTitle {
  return LocalizedString(@"Donation", nil);
}


- (BOOL) isFree {
  return FALSE;
}


- (NSString*) price {
  unichar lastChar = [itunesIdentifier characterAtIndex:itunesIdentifier.length - 1];
  return [NSString stringWithFormat:@"%c.99", lastChar - 1];
}

@end
