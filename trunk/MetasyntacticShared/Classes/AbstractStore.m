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
