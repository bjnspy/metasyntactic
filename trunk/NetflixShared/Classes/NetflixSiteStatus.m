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

#import "NetflixSiteStatus.h"

@interface NetflixSiteStatus()
@property BOOL overQuota;
@end


@implementation NetflixSiteStatus

static NetflixSiteStatus* status = nil;

+ (void) initialize {
  if (self == [NetflixSiteStatus class]) {
    status = [[NetflixSiteStatus alloc] init];
  }
}


+ (NetflixSiteStatus*) status {
  return status;
}


@synthesize overQuota;

- (void) dealloc {
  self.overQuota = NO;
  [super dealloc];
}


- (void) checkApiResult:(XmlElement*) element {
  NSString* message = [[element element:@"message"] text];

  // Such a total hack.  Netflix doesn't give any error code for this.  We have
  // to extract it ourselves.  Bleagh.
  if ([@"Over queries per day limit" isEqual:message]) {
    overQuota = YES;
    [MetasyntacticSharedApplication minorRefresh];
  }
}

@end
