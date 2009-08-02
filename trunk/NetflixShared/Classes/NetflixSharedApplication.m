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

#import "NetflixSharedApplication.h"

#import "NetflixSharedApplicationDelegate.h"

@implementation NetflixSharedApplication

static id<NetflixSharedApplicationDelegate> delegate = nil;

+ (void) setSharedApplicationDelegate:(id<NetflixSharedApplicationDelegate>) delegate_ {
  delegate = delegate_;
}


+ (BOOL) netflixEnabled {
  return [delegate netflixEnabled];
}


+ (BOOL) netflixNotificationsEnabled {
  return [delegate netflixNotificationsEnabled];
}


+ (NetflixAccount*) currentNetflixAccount {
  return [delegate currentNetflixAccount];
}


+ (void) reportNetflixMovies:(NSArray*) movies {
  [delegate reportNetflixMovies:movies];
}


+ (void) reportNetflixMovie:(Movie*) movie {
  [delegate reportNetflixMovie:movie];
}


+ (void) addNetflixAccount:(NetflixAccount*) account {
  [delegate addNetflixAccount:account];
}

@end
