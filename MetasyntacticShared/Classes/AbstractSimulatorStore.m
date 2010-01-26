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
