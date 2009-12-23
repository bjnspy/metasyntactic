//
//  StoreDelegate.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 12/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@protocol StoreDelegate

- (NSString*) sendUnlockRequest:(AbstractUnlockRequest*) unlockRequest;


- (AbstractUnlockRequest*) createUnlockRequest:(id<StoreItem>) item
                         transactionIdentifier:(NSString*) transactionIdentifier 
                                       receipt:(NSString*) receipt 
                                   transaction:(SKPaymentTransaction*) transaction;


- (AbstractUnlockRequest*) createBypassStoreRequest:(id<StoreItem>) item
                                             reason:(NSString*) reason;

- (void) reportUnlockResult:(UnlockResult*) unlockResult;

- (id<StoreItem>) itemForItunesIdentifier:(NSString*) itunesIdentifier;

@end
