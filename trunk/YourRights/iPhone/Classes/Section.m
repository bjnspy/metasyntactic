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

#import "Section.h"

@interface Section()
@property (copy) NSString* title;
@property (copy) NSString* text;
@end


@implementation Section

@synthesize title;
@synthesize text;

- (void) dealloc {
  self.title = nil;
  self.text = nil;

  [super dealloc];
}


- (id) initWithTitle:(NSString*) title_
                text:(NSString*) text_ {
  if ((self = [super init])) {
    self.title = title_;
    self.text = text_;
  }

  return self;
}


+ (Section*) sectionWithTitle:(NSString*) title
                         text:(NSString*) text {
  return [[[Section alloc] initWithTitle:title text:text] autorelease];
}


+ (Section*) sectionWithText:(NSString*) text {
  return [[[Section alloc] initWithTitle:@"" text:text] autorelease];
}

@end
