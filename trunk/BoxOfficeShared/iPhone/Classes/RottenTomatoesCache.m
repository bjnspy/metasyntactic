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

#import "RottenTomatoesCache.h"

#import "Application.h"

@implementation RottenTomatoesCache

static RottenTomatoesCache* cache;

+ (void) initialize {
  if (self == [RottenTomatoesCache class]) {
    cache = [[RottenTomatoesCache alloc] init];
  }
}


+ (RottenTomatoesCache*) cache {
  return cache;
}


- (NSString*) cacheDirectory {
  return [Application rottenTomatoesDirectory];
}


- (NSString*) serverUrl:(NSString*) name {
  return [NSString stringWithFormat:@"http://%@.appspot.com/LookupYahooSearch%@?q=%@&site=www.rottentomatoes.com",
          [Application apiHost], [Application apiVersion],
          [StringUtilities stringByAddingPercentEscapes:name]];
}

@end
