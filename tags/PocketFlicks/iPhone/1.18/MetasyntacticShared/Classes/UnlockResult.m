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

#import "UnlockResult.h"

@interface UnlockResult()
@property (retain) id<StoreItem> item;
@property (retain) SKPaymentTransaction* transaction;
@property BOOL succeeded;
@property (copy) NSString* message;
@end

@implementation UnlockResult

@synthesize item;
@synthesize transaction;
@synthesize succeeded;
@synthesize message;

- (void) dealloc {
  self.item = nil;
  self.transaction = nil;
  self.succeeded = NO;
  self.message = nil;
  [super dealloc];
}


- (id) initWithItem:(id<StoreItem>) item_
         transaction:(SKPaymentTransaction*) transaction_
           succeeded:(BOOL) succeeded_
             message:(NSString*) message_ {
  if ((self = [super init])) {
    self.item = item_;
    self.transaction = transaction_;
    self.succeeded = succeeded_;
    self.message = message_;
  }
  return self;
}

+ (UnlockResult*) resultWithItem:(id<StoreItem>) item
                      transaction:(SKPaymentTransaction*) transaction
                        succeeded:(BOOL) succeeded
                          message:(NSString*) message {
  return [[[UnlockResult alloc] initWithItem:item transaction:transaction succeeded:succeeded message:message] autorelease];
}

@end
