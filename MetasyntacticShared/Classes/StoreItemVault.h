
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
