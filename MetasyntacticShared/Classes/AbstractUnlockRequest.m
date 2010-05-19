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

#import "AbstractUnlockRequest.h"

@interface AbstractUnlockRequest()
@property (retain) id<StoreItem> item;
@property (copy) NSString* transactionIdentifier;
@property (copy) NSString* receipt;
@property (retain) SKPaymentTransaction* transaction;
@end

@implementation AbstractUnlockRequest

@synthesize item;
@synthesize transactionIdentifier;
@synthesize receipt;
@synthesize transaction;

- (void) dealloc {
  self.item = nil;
  self.transactionIdentifier = nil;
  self.receipt = nil;
  self.transaction = nil;
  [super dealloc];
}


- (id) initWithItem:(id<StoreItem>) item_
transactionIdentifier:(NSString*) transactionIdentifier_
             receipt:(NSString*) receipt_
         transaction:(SKPaymentTransaction*) transaction_ {
  if ((self = [super init])) {
    self.item = item_;
    self.transactionIdentifier = transactionIdentifier_;
    self.receipt = receipt_;
    self.transaction = transaction_;
  }
  return self;
}

@end
