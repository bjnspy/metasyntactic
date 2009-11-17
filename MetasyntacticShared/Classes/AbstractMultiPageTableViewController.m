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

//#import "AbstractApplication.h"
#import "MetasyntacticSharedApplication.h"
#import "MetasyntacticStockImages.h"
#import "StyleSheet.h"

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


- (void) initializeData AbstractMethod;


- (void) moveBackward:(UITableView*) previousTableView AbstractMethod;


- (void) moveForward:(UITableView*) nextTableView AbstractMethod;


- (NSInteger) cacheTableViews AbstractMethod;


- (UIBarButtonItem*) createFlexibleSpace {
  return [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
}


- (UIView*) createLabelView {
  NSString* title =
  [NSString stringWithFormat:
   LocalizedString(@"%d of %d", @"i.e.: 5 of 15.  Used when scrolling through a list of items"), (currentPageIndex + 1), pageCount];

  UILabel* label = [[[UILabel alloc] init] autorelease];
  label.text = title;
  label.font = [UIFont boldSystemFontOfSize:18];
  label.textColor = [UIColor whiteColor];
  label.backgroundColor = [UIColor clearColor];
  label.opaque = NO;
  label.shadowColor = [UIColor darkGrayColor];
  [label sizeToFit];

  UIImage* backgroundImage = [MetasyntacticStockImage(@"MultiPageLabelBackground.png") stretchableImageWithLeftCapWidth:10 topCapHeight:10];
  if (backgroundImage == nil) {
    return label;
  }

  CGRect labelFrame = label.frame;
  CGRect imageFrame = labelFrame;
  const NSInteger buffer = 20;
  imageFrame.size.width += buffer * 2;

  labelFrame.origin.x += buffer;
  label.frame = labelFrame;

  UIImageView* backgroundView = [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
  backgroundView.frame = imageFrame;

  UIView* labelView = [[[UIView alloc] initWithFrame:imageFrame] autorelease];
  [labelView addSubview:backgroundView];
  [labelView addSubview:label];

  return labelView;
}


- (void) setupToolbarItems:(UIToolbar*) toolbar {
  UIView* labelView = [self createLabelView];

  NSMutableArray* items = [NSMutableArray array];

  UIBarButtonItem* leftArrow;
  UIBarButtonItem* rightArrow;

  if ([MetasyntacticStockImages leftArrow] == [MetasyntacticStockImages standardLeftArrow]) {
    leftArrow = [[[UIBarButtonItem alloc] initWithImage:[MetasyntacticStockImages leftArrow]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(onLeftTapped)] autorelease];
    rightArrow = [[[UIBarButtonItem alloc] initWithImage:[MetasyntacticStockImages rightArrow]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(onRightTapped)] autorelease];
  } else {
    UIImage* leftImage = [MetasyntacticStockImages leftArrow];
    UIImage* rightImage = [MetasyntacticStockImages rightArrow];

    UIButton* leftButton = [[[UIButton alloc] init] autorelease];
    CGRect frame = leftButton.frame;
    frame.size = leftImage.size;
    leftButton.frame = frame;
    [leftButton setImage:leftImage forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(onLeftTapped) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];

    UIButton* rightButton = [[[UIButton alloc] init] autorelease];
    frame = rightButton.frame;
    frame.size = rightImage.size;
    rightButton.frame = frame;
    [rightButton setImage:rightImage forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(onRightTapped) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];

    leftArrow = [[[UIBarButtonItem alloc] initWithCustomView:leftButton] autorelease];
    rightArrow = [[[UIBarButtonItem alloc] initWithCustomView:rightButton] autorelease];
  }

  [items addObject:self.createFlexibleSpace];
  [items addObject:self.createFlexibleSpace];
  [items addObject:leftArrow];
  [items addObject:self.createFlexibleSpace];
  [items addObject:[[[UIBarButtonItem alloc] initWithCustomView:labelView] autorelease]];
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
  toolbar.barStyle = [StyleSheet toolBarStyle];
  toolbar.translucent = [StyleSheet toolBarTranslucent];
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


- (void) loadView {
  [super loadView];

  if (pageCount > 1) {
    self.tableView.tableHeaderView = [self createToolbar];
    if (self.cacheTableViews) {
      [pageToTableView setObject:self.tableView forKey:[NSNumber numberWithInteger:currentPageIndex]];
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
    NSInteger page = number.integerValue;
    if (page == currentPageIndex) {
      continue;
    }

    if (ABS(currentPageIndex - page) > distance) {
      distance = ABS(currentPageIndex - page);
      pageToRemove = page;
    }
  }

  if (pageToRemove != -1) {
    [pageToTableView removeObjectForKey:[NSNumber numberWithInteger:pageToRemove]];
  }
}


- (UITableView*) findOrCreateTableView:(NSInteger) page {
  [self initializeData];

  NSNumber* pageNumber = [NSNumber numberWithInteger:page];
  UITableView* newTableView = [pageToTableView objectForKey:pageNumber];
  if (newTableView == nil) {
    newTableView = [[[UITableView alloc] initWithFrame:self.tableView.frame style:self.tableView.style] autorelease];
    newTableView.delegate = self;
    newTableView.dataSource = self;
    newTableView.tableHeaderView = [self createToolbar];
    if (self.hasOverriddenBackground) {
      newTableView.backgroundColor = [UIColor clearColor];
    }

    if (self.cacheTableViews) {
      [pageToTableView setObject:newTableView forKey:pageNumber];
    }
    [newTableView reloadData];
  }
  return newTableView;
}


- (void) onLeftTapped {
  currentPageIndex--;
  UITableView* previousTableView = [self findOrCreateTableView:currentPageIndex];
  [self moveBackward:previousTableView];
  [self performSelector:@selector(removeTableViews) withObject:nil afterDelay:5];
}


- (void) onRightTapped {
  currentPageIndex++;
  UITableView* nextTableView = [self findOrCreateTableView:currentPageIndex];
  [self moveForward:nextTableView];
  [self performSelector:@selector(removeTableViews) withObject:nil afterDelay:5];
}

@end
