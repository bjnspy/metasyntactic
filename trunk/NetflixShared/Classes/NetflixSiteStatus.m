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

#import "NetflixSiteStatus.h"

@interface NetflixSiteStatus()
@property (retain) NSDate* lastQuotaErrorDate;
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


@synthesize lastQuotaErrorDate;

- (void) dealloc {
  self.lastQuotaErrorDate = nil;
  [super dealloc];
}


- (void) checkApiResult:(XmlElement*) element {
  NSString* message = [[element element:@"message"] text];

  // Such a total hack.  Netflix doesn't give any error code for this.  We have
  // to extract it ourselves.  Bleagh.
  if ([@"Over queries per day limit" isEqual:message]) {
    self.lastQuotaErrorDate = [NSDate date];
    [MetasyntacticSharedApplication minorRefresh];
  }
}

@end
