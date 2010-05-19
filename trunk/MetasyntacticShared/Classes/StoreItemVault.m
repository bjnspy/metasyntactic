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


- (void) lockItem:(NSString *)identifier {
  NSMutableSet* set = [NSMutableSet setWithSet:self.unlockedItemIdentifiers];
  [set removeObject:identifier];

  unlockedItemIdentifiersData.value = set;
}

@end
