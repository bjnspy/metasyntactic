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

@interface StoreItemVault : AbstractCache {
@protected
  // The items that the user has actually purchased.
  // Note: just because they have purchased an item that does not mean that
  // they have downloaded it (or want to download it on this device).
  ThreadsafeValue*/*NSSet*/ unlockedItemIdentifiersData;
}

- (void) clear;

- (BOOL) isUnlocked:(NSString*) identifier;
- (void) unlockItem:(NSString*) identifier;

- (NSSet*) unlockedItemIdentifiers;

@end
