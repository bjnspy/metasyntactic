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

#import "Amendment.h"

#import "Section.h"

@interface Amendment()
@property (copy) NSString* synopsis;
@property NSInteger year;
@property (copy) NSString* link;
@property (retain) NSArray* sections;
@end


@implementation Amendment

@synthesize synopsis;
@synthesize year;
@synthesize link;
@synthesize sections;

- (void) dealloc {
  self.synopsis = nil;
  self.year = 0;
  self.link = nil;
  self.sections = nil;

  [super dealloc];
}


- (id) initWithSynopsis:(NSString*) synopsis_
                   year:(NSInteger) year_
                   link:(NSString*) link_
               sections:(NSArray*) sections_ {
  if ((self = [super init])) {
    self.synopsis = synopsis_;
    self.year = year_;
    self.link = link_;
    self.sections = sections_;
  }

  return self;
}


+ (Amendment*) amendmentWithSynopsis:(NSString*) synopsis
                                year:(NSInteger) year
                                link:(NSString*) link
                            sections:(NSArray*) sections {
  return [[[Amendment alloc] initWithSynopsis:synopsis
                                         year:year
                                         link:link
                                     sections:sections] autorelease];
}


+ (Amendment*) amendmentWithSynopsis:(NSString*) synopsis
                                year:(NSInteger) year
                                link:(NSString*) link
                                text:(NSString*) text {
  NSArray* sections = [NSArray arrayWithObject:[Section sectionWithText:text]];
  return [[[Amendment alloc] initWithSynopsis:synopsis
                                         year:year
                                         link:link
                                     sections:sections] autorelease];
}

@end
