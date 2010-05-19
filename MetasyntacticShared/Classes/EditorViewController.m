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

#import "EditorViewController.h"

@interface EditorViewController()
@property (assign) id object;
@property SEL selector;
@end


@implementation EditorViewController

@synthesize object;
@synthesize selector;

- (void) dealloc {
  self.object = nil;
  self.selector = nil;

  [super dealloc];
}


- (id) initWithObject:(id) object_
             selector:(SEL) selector_ {
  if ((self = [super init])) {
    self.object = object_;
    self.selector = selector_;
  }

  return self;
}


- (void) loadView {
  [super loadView];

  UIBarButtonItem* saveItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                             target:self
                                                                             action:@selector(save:)] autorelease];
  self.navigationItem.rightBarButtonItem = saveItem;

  UIBarButtonItem* cancelItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                               target:self
                                                                               action:@selector(cancel:)] autorelease];
  self.navigationItem.leftBarButtonItem = cancelItem;

  self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}


- (void) cancel:(id) sender {
  [self.abstractNavigationController popViewControllerAnimated:YES];
}


- (void) save:(id) sender {
  [self.abstractNavigationController popViewControllerAnimated:YES];
}

@end
