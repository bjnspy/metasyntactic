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

#import "StoreItemVault.h"

#import "AbstractApplication.h"
#import "PersistentSetThreadsafeValue.h"

@interface StoreItemVault()
@property (retain) ThreadsafeValue*/*NSSet*/ unlockedItemIdentifiersData;
@end

@implementation StoreItemVault

@synthesize unlockedItemIdentifiersData;

- (void) dealloc {
  self.unlockedItemIdentifiersData = nil;
  [super dealloc];
}


- (NSString*) unlockedItemIdentifiersFile {
  return [[AbstractApplication storeDirectory] stringByAppendingPathComponent:@"UnlockedStoreItems.plist"];
}


- (id) init {
  if ((self = [super init])) {
    self.unlockedItemIdentifiersData = [PersistentSetThreadsafeValue valueWithGate:dataGate file:self.unlockedItemIdentifiersFile];
  }
  return self;
}


- (void) clear {
  unlockedItemIdentifiersData.value = [NSSet set];
  [[NSFileManager defaultManager] removeItemAtPath:self.unlockedItemIdentifiersFile error:NULL];
}


- (NSSet*) unlockedItemIdentifiers {
  return unlockedItemIdentifiersData.value;
}


- (BOOL) isUnlocked:(NSString*) identifier {
  return [self.unlockedItemIdentifiers containsObject:identifier];
}


- (void) unlockItem:(NSString*) identifier {
  NSMutableSet* set = [NSMutableSet setWithSet:self.unlockedItemIdentifiers];
  [set addObject:identifier];

  unlockedItemIdentifiersData.value = set;
}

@end
