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

#import "FederalistPapersSectionViewController.h"

#import "Article.h"
#import "Section.h"
#import "WrappableCell.h"
#import "YourRightsNavigationController.h"

@interface FederalistPapersSectionViewController()
@property (retain) Section* section;
@property (retain) NSArray* chunks;
@end


@implementation FederalistPapersSectionViewController

@synthesize section;
@synthesize chunks;

- (void) dealloc {
  self.section = nil;
  self.chunks = nil;

  [super dealloc];
}


- (id) initWithSection:(Section*) section_ {
  if ((self = [super initWithStyle:UITableViewStylePlain])) {
    self.section = section_;
    self.title = section.title;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.chunks = [StringUtilities splitIntoChunks:section.text];
  }

  return self;
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return chunks.count;
}


- (UITableViewCell*) cellForSectionRow:(NSInteger) row {
  NSString* text = [chunks objectAtIndex:row];
  WrappableCell *cell = [[[WrappableCell alloc] initWithTitle:text] autorelease];
  cell.accessoryType = UITableViewCellAccessoryNone;
  cell.selectionStyle = UITableViewCellSeparatorStyleNone;

  return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [self cellForSectionRow:indexPath.row];
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
  NSString* text = [chunks objectAtIndex:indexPath.row];
  return [WrappableCell height:text
                 accessoryType:UITableViewCellAccessoryNone];
}

@end
