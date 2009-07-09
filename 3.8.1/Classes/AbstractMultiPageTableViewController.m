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

#import "AbstractMultiPageTableViewController.h"

#import "MetasyntacticSharedApplication.h"
#import "MetasyntacticStockImages.h"
#import "NotificationCenter.h"

@interface AbstractMultiPageTableViewController()
@property (retain) NSMutableDictionary* pageToTableView;
@end

@implementation AbstractMultiPageTableViewController

@synthesize pageToTableView;

- (void) dealloc {
  self.pageToTableView = nil;

  [super dealloc];
}

- (id) initWithStyle:(UITableViewStyle) style {
  if ((self = [super initWithStyle:style])) {
    pageCount = 1;
    currentPageIndex = 0;
    self.pageToTableView = [NSMutableDictionary dictionary];
  }
  return self;
}


- (void) initializeData {
  @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (void) moveBackward:(UITableView*) previousTableView {
  @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (void) moveForward:(UITableView*) nextTableView {
  @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (NSInteger) cacheTableViews {
  @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (UIBarButtonItem*) createFlexibleSpace {
  return [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
}


- (void) setupToolbarItems:(UIToolbar*) toolbar {
  NSString* title =
  [NSString stringWithFormat:
   LocalizedString(@"%d of %d", @"i.e.: 5 of 15.  Used when scrolling through a list of posters"), (currentPageIndex + 1), pageCount];

  UILabel* label = [[[UILabel alloc] init] autorelease];
  label.text = title;
  label.font = [UIFont boldSystemFontOfSize:18];
  label.textColor = [UIColor whiteColor];
  label.backgroundColor = [UIColor clearColor];
  label.opaque = NO;
  label.shadowColor = [UIColor darkGrayColor];
  [label sizeToFit];

  NSMutableArray* items = [NSMutableArray array];

  UIBarButtonItem* leftArrow = [[[UIBarButtonItem alloc] initWithImage:[MetasyntacticStockImages leftArrow]
                                                     style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(onLeftTapped:)] autorelease];
  UIBarButtonItem* rightArrow = [[[UIBarButtonItem alloc] initWithImage:[MetasyntacticStockImages rightArrow]
                                                      style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:@selector(onRightTapped:)] autorelease];

  [items addObject:self.createFlexibleSpace];
  [items addObject:self.createFlexibleSpace];
  [items addObject:leftArrow];
  [items addObject:self.createFlexibleSpace];
  [items addObject:[[[UIBarButtonItem alloc] initWithCustomView:label] autorelease]];
  [items addObject:self.createFlexibleSpace];
  [items addObject:rightArrow];
  [items addObject:self.createFlexibleSpace];
  [items addObject:self.createFlexibleSpace];

  [toolbar setItems:items animated:YES];
  //[self setToolbarItems:items animated:YES];

  leftArrow.enabled = (currentPageIndex > 0);
  rightArrow.enabled = (currentPageIndex < (pageCount - 1));
}


- (UIView*) createToolbar {
  UIToolbar* toolbar = [[[UIToolbar alloc] init] autorelease];
  toolbar.barStyle = UIBarStyleBlack;
  toolbar.translucent = YES;
  [toolbar sizeToFit];
  CGRect frame = toolbar.frame;
  frame.origin.y = -1;
  frame.size.height -= 8;
  toolbar.frame = frame;

  [self setupToolbarItems:toolbar];

  UIView* view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 1)] autorelease];
  [view addSubview:toolbar];

  return view;
}


- (void) viewWillAppear:(BOOL) animated {
  [super viewWillAppear:animated];
  if (pageCount > 1) {
    [NotificationCenter disableNotifications];
  }
}


- (void) viewWillDisappear:(BOOL) animated {
  [super viewWillDisappear:animated];

  if (pageCount > 1) {
    [NotificationCenter enableNotifications];
  }
}


- (void) loadView {
  [super loadView];

  if (pageCount > 1) {
    self.tableView.tableHeaderView = [self createToolbar];
    if (self.cacheTableViews) {
      [pageToTableView setObject:self.tableView forKey:[NSNumber numberWithInt:currentPageIndex]];
    }
  }
}


- (void) removeTableViews {
  if (pageToTableView.count <= 5) {
    return;
  }

  NSInteger distance = 0;
  NSInteger pageToRemove = -1;

  for (NSNumber* number in pageToTableView) {
    NSInteger page = number.intValue;
    if (page == currentPageIndex) {
      continue;
    }

    if (ABS(currentPageIndex - page) > distance) {
      distance = ABS(currentPageIndex - page);
      pageToRemove = page;
    }
  }

  if (pageToRemove != -1) {
    [pageToTableView removeObjectForKey:[NSNumber numberWithInt:pageToRemove]];
  }
}


- (UITableView*) findOrCreateTableView:(NSInteger) page {
  [self initializeData];

  NSNumber* pageNumber = [NSNumber numberWithInt:page];
  UITableView* newTableView = [pageToTableView objectForKey:pageNumber];
  if (newTableView == nil) {
    newTableView = [[[UITableView alloc] initWithFrame:self.tableView.frame style:self.tableView.style] autorelease];
    newTableView.delegate = self;
    newTableView.dataSource = self;
    newTableView.tableHeaderView = [self createToolbar];
    if (self.cacheTableViews) {
      [pageToTableView setObject:newTableView forKey:pageNumber];
    }
    [newTableView reloadData];
  }
  return newTableView;
}


- (void) onLeftTapped:(id) sender {
  currentPageIndex--;
  UITableView* previousTableView = [self findOrCreateTableView:currentPageIndex];
  [self moveBackward:previousTableView];
  [self performSelector:@selector(removeTableViews) withObject:nil afterDelay:5];
}


- (void) onRightTapped:(id) sender {
  currentPageIndex++;
  UITableView* nextTableView = [self findOrCreateTableView:currentPageIndex];
  [self moveForward:nextTableView];
  [self performSelector:@selector(removeTableViews) withObject:nil afterDelay:5];
}

@end
