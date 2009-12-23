
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
