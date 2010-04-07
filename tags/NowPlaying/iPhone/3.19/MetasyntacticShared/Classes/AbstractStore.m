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

#import "AbstractStore.h"

#import "AbstractUnlockRequest.h"
#import "AlertUtilities.h"
#import "MetasyntacticSharedApplication.h"
#import "StoreDelegate.h"
#import "StoreItem.h"
#import "StoreItemVault.h"
#import "ThreadingUtilities.h"
#import "UnlockResult.h"

@interface AbstractStore()
@property (retain) id<StoreDelegate> delegate;
@property (retain) StoreItemVault* vault;
@end

@implementation AbstractStore

@synthesize delegate;
@synthesize vault;

- (void) dealloc {
  self.delegate = nil;
  self.vault = nil;
  [super dealloc];
}


- (id) initWithDelegate:(id<StoreDelegate>) delegate_
                  vault:(StoreItemVault*) vault_ {
  if ((self = [super init])) {
    self.delegate = delegate_;
    self.vault = vault_;
  }

  return self;
}


- (void) purchaseItem:(id<StoreItem>) item AbstractMethod;


- (BOOL) isPurchasing:(id<StoreItem>) item AbstractMethod;


- (void) updatePrices:(NSSet*) items AbstractMethod;


- (NSString*) priceForItem:(id<StoreItem>) item AbstractMethod;


- (void) sendUnlockRequest:(AbstractUnlockRequest*) request {
  [ThreadingUtilities backgroundSelector:@selector(sendUnlockRequestBackgroundEntryPoint:)
                                onTarget:self
                              withObject:request
                                    gate:nil
                                  daemon:NO];
  [MetasyntacticSharedApplication minorRefresh];
}


- (void) sendUnlockRequestBackgroundEntryPoint:(AbstractUnlockRequest*) unlockRequest {
  NSString* error = [delegate sendUnlockRequest:unlockRequest];

  UnlockResult* unlockResult = [UnlockResult resultWithItem:unlockRequest.item
                                                 transaction:unlockRequest.transaction
                                                   succeeded:error.length == 0
                                                     message:error];

  [ThreadingUtilities foregroundSelector:@selector(reportUnlockResult:)
                                onTarget:self
                              withObject:unlockResult];
  [MetasyntacticSharedApplication minorRefresh];
}


- (void) reportUnlockResult:(UnlockResult*) unlockResult {
  NSAssert([NSThread isMainThread], nil);

  // 5) We've tried recording the purchase with comixology.  It either failed
  //    (in which case we need to tell the user), or it succeeded.  In the latter
  //    case, we can now start pullng down the item.
  if (unlockResult.succeeded) {
    [self.vault unlockItem:unlockResult.item.identifier];
    //[self.model.bookCache markItemForDownload:unlockResult.item.identifier];
  } else if (unlockResult.message.length > 0) {
    [AlertUtilities showOkAlert:unlockResult.message];
  }

  [delegate reportUnlockResult:unlockResult];
}


- (void)      bypassStore:(id<StoreItem>) item
                   reason:(NSString*) reason {
  AbstractUnlockRequest* request = [delegate createBypassStoreRequest:item reason:reason];

  [self sendUnlockRequest:request];
}

@end
