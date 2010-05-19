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

#import "Article.h"

@interface Article()
@property (copy) NSString* title;
@property (copy) NSString* link;
@property (retain) NSArray* sections;
@end


@implementation Article

@synthesize title;
@synthesize link;
@synthesize sections;

- (void) dealloc {
  self.title = nil;
  self.link = nil;
  self.sections = nil;

  [super dealloc];
}


- (id) initWithTitle:(NSString*) title_
                link:(NSString*) link_
            sections:(NSArray*) sections_ {
  if ((self = [super init])) {
    self.title = title_;
    self.link = link_;
    self.sections = sections_;
  }

  return self;
}


+ (Article*) articleWithTitle:(NSString*) title
                         link:(NSString*) link
                     sections:(NSArray*) sections {
  return [[[Article alloc] initWithTitle:title
                                    link:link
                                sections:sections] autorelease];
}


+ (Article*) articleWithTitle:(NSString*) title
                         link:(NSString*) link
                      section:(Section*) section {
  return [Article articleWithTitle:title link:link sections:[NSArray arrayWithObject:section]];
}


+ (Article*) articleWithTitle:(NSString*) title
                      section:(Section*) section {
  return [Article articleWithTitle:title link:@"" section:section];
}

@end
