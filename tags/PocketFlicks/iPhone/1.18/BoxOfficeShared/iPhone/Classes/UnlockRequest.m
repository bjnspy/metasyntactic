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

#import "UnlockRequest.h"

@implementation UnlockRequest

- (id) initWithItem:(id<StoreItem>) item_
transactionIdentifier:(NSString*) transactionIdentifier_
            receipt:(NSString*) receipt_
        transaction:(SKPaymentTransaction*) transaction_ {
  if ((self = [super initWithItem:item_
            transactionIdentifier:transactionIdentifier_
                          receipt:receipt_
                      transaction:transaction_])) {
  }
  return self;
}


+ (UnlockRequest*) requestWithItem:(id<StoreItem>) item
             transactionIdentifier:(NSString*) transactionIdentifier
                           receipt:(NSString*) receipt
                       transaction:(SKPaymentTransaction*) transaction {
  return [[[UnlockRequest alloc] initWithItem:item transactionIdentifier:transactionIdentifier receipt:receipt transaction:transaction] autorelease];
}

@end
