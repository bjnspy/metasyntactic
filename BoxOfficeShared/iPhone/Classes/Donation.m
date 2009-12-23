//
//  Donation.m
//  BoxOfficeShared
//
//  Created by Cyrus Najmabadi on 12/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

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
