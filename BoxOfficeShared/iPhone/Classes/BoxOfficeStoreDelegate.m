//
//  ComiXologyStoreDelegate.m
//  ComiXologyShared
//
//  Created by Cyrus Najmabadi on 12/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BoxOfficeStoreDelegate.h"

#import "UnlockRequest.h"
#import "Application.h"
#import "Model.h"
#import "UnlockRequest.h"
#import "Donation.h"

@implementation BoxOfficeStoreDelegate

+ (BoxOfficeStoreDelegate*) delegate {
  return [[[BoxOfficeStoreDelegate alloc] init] autorelease];
}


- (Model*) model {
  return [Model model];
}


- (NSString*) sendUnlockRequest:(UnlockRequest*) unlockRequest {
  // Success!
  return @"";
}


- (AbstractUnlockRequest*) createUnlockRequest:(id<StoreItem>) item
                         transactionIdentifier:(NSString*) transactionIdentifier 
                                       receipt:(NSString*) receipt 
                                   transaction:(SKPaymentTransaction*) transaction {
  return [UnlockRequest requestWithItem:item
                  transactionIdentifier:transactionIdentifier
                                receipt:receipt
                            transaction:transaction];
}


- (AbstractUnlockRequest*) createBypassStoreRequest:(id<StoreItem>) item
                                             reason:(NSString*) reason {
  NSString* transactionIdentifier = [NSString stringWithFormat:@"%@-%@-transactionId", reason, item.identifier];
  NSString* receipt = [NSString stringWithFormat:@"%@-%@-receipt", reason, item.identifier];
  
  return [self createUnlockRequest:item
             transactionIdentifier:transactionIdentifier 
                           receipt:receipt
                       transaction:nil];
}


- (void) reportUnlockResult:(UnlockResult*) unlockResult {
  
}


- (id<StoreItem>) itemForItunesIdentifier:(NSString *)itunesIdentifier {
  return [Donation donationWithItunesIdentifier:itunesIdentifier];
}

@end
