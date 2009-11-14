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

#import "AbstractCache.h"

@interface AbstractCache()
@property (retain) NSRecursiveLock* dataGate;
@property (retain) NSRecursiveLock* runGate;
@end


@implementation AbstractCache

@synthesize dataGate;
@synthesize runGate;

- (void) dealloc {
  self.dataGate = nil;
  self.runGate = nil;

  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.dataGate = [[[NSRecursiveLock alloc] init] autorelease];
    self.runGate = [[[NSRecursiveLock alloc] init] autorelease];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationDidReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
  }

  return self;
}


- (void) didReceiveMemoryWarning {

}


- (void) onApplicationDidReceiveMemoryWarning:(id) value {
  [self didReceiveMemoryWarning];
}

@end
