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

#import "AbstractSimulatorStore.h"

#import "AlertUtilities.h"
#import "MetasyntacticSharedApplication.h"
#import "StoreItem.h"
#import "UnlockResult.h"

@interface AbstractSimulatorStore()
@property (retain) NSMutableSet* purchasing;
@end

@implementation AbstractSimulatorStore

@synthesize purchasing;

- (void) dealloc {
  self.purchasing = nil;
  [super dealloc];
}


- (id) initWithDelegate:(id<StoreDelegate>) delegate_
                  vault:(StoreItemVault*) vault_ {
  if ((self = [super initWithDelegate:delegate_
                                vault:vault_])) {
    self.purchasing = [NSMutableSet set];
  }

  return self;
}


- (void) purchaseItem:(id<StoreItem>) item {
  [AlertUtilities showOkAlert:@"You are currently running in the iPhone simulator. We are bypassing the iTunes store for this purchase."];

  [purchasing addObject:item];
  [self performSelector:@selector(bypass:) withObject:item afterDelay:5];
  [MetasyntacticSharedApplication minorRefresh];
}


- (void) bypass:(id<StoreItem>) item {
  [self bypassStore:item reason:@"Simulator"];
}


- (void) reportUnlockResult:(UnlockResult*) unlockResult {
  NSAssert([NSThread isMainThread], nil);
  [super reportUnlockResult:unlockResult];
  [purchasing removeObject:unlockResult.item];

  [MetasyntacticSharedApplication majorRefresh];
}


- (BOOL) isPurchasing:(id<StoreItem>) item {
  return [purchasing containsObject:item];
}


- (void) updatePrices:(NSSet*) items {
  // nothing to do.
}


- (NSString*) priceForItem:(id<StoreItem>) item {
  if (item.isFree) {
    return item.price;
  }

  return [NSString stringWithFormat:@"$%@", item.price];
}

@end
