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
