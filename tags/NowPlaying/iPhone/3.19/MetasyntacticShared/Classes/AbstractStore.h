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

@interface AbstractStore : AbstractCache<UIAlertViewDelegate> {
@protected
  id<StoreDelegate> delegate;
  StoreItemVault* vault;
}

@property (readonly, retain) StoreItemVault* vault;

- (id) initWithDelegate:(id<StoreDelegate>) delegate vault:(StoreItemVault*) vault;

- (void) purchaseItem:(id<StoreItem>) item;
- (BOOL) isPurchasing:(id<StoreItem>) item;

- (void) updatePrices:(NSSet*) items;
- (NSString*) priceForItem:(id<StoreItem>) item;

/* @protected */
- (void) reportUnlockResult:(UnlockResult*) unlockResult;
- (void)   bypassStore:(id<StoreItem>) item reason:(NSString*) reason;
- (void) sendUnlockRequest:(AbstractUnlockRequest*) request;

@end
