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
