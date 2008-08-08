// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "SearchRequest.h"

@implementation SearchRequest

@synthesize text;
@synthesize searchId;

- (void) dealloc {
    self.text = nil;
    self.searchId = 0;

    [super dealloc];
}

- (id) initWithText:(NSString*) text_ searchId:(NSInteger) searchId_ {
    if (self = [super init]) {
        self.text = text_;
        self.searchId = searchId_;
    }

    return self;
}

+ (SearchRequest*) requestWithText:(NSString*) text searchId:(NSInteger) searchId {
    return [[[SearchRequest alloc] initWithText:text searchId:searchId] autorelease];
}


@end