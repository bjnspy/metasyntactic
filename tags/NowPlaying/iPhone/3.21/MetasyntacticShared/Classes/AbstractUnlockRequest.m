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
