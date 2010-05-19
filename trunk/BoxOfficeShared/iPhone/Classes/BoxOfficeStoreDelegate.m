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

#import "BoxOfficeStoreDelegate.h"

#import "Donation.h"
#import "Model.h"
#import "UnlockRequest.h"

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


- (id<StoreItem>) itemForItunesIdentifier:(NSString*) itunesIdentifier {
  return [Donation donationWithItunesIdentifier:itunesIdentifier];
}

@end
