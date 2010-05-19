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

#import "XmlDocument.h"

@interface XmlDocument()
@property (retain) XmlElement* root;
@property (copy) NSString* version;
@property (copy) NSString* encoding;
@end


@implementation XmlDocument

@synthesize root;
@synthesize version;
@synthesize encoding;

- (void) dealloc {
  self.root = nil;
  self.version = nil;
  self.encoding = nil;
  [super dealloc];
}


+ (XmlDocument*) documentWithRoot:(XmlElement*) root {
  return [[[XmlDocument alloc] initWithRoot:root] autorelease];
}


- (id) initWithRoot:(XmlElement*) root_ {
  return [self initWithRoot:root_ version:@"1.0" encoding:@"UTF-8"];
}


- (id) initWithRoot:(XmlElement*) root_
            version:(NSString*) version_
           encoding:(NSString*) encoding_ {
  if ((self = [super init])) {
    self.root = root_;
    self.version = version_;
    self.encoding = encoding_;
  }
  return self;
}

@end
