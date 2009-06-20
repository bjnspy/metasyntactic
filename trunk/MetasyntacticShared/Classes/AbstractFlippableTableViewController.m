//
//  AbstractFlippableTableViewController.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 6/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AbstractFlippableTableViewController.h"

#import "MetasyntacticSharedApplication.h"
#import "MetasyntacticStockImages.h"
#import "NotificationCenter.h"

@interface AbstractFlippableTableViewController()
@property (retain) NSMutableDictionary* pageToTableView;
@end

@implementation AbstractFlippableTableViewController

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
    
  [items addObject:self.createFlexibleSpace];
  
  UIBarButtonItem* leftArrow = [[[UIBarButtonItem alloc] initWithImage:[MetasyntacticStockImages leftArrow]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(onLeftTapped:)] autorelease];
  [items addObject:leftArrow];
  
  [items addObject:self.createFlexibleSpace];
  
  UIBarItem* titleItem = [[[UIBarButtonItem alloc] initWithCustomView:label] autorelease];
  [items addObject:titleItem];
  
  [items addObject:self.createFlexibleSpace];
  
  UIBarButtonItem* rightArrow = [[[UIBarButtonItem alloc] initWithImage:[MetasyntacticStockImages rightArrow]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(onRightTapped:)] autorelease];
  [items addObject:rightArrow];
  
  [items addObject:self.createFlexibleSpace];
    
  [toolbar setItems:items animated:YES];
  //[self setToolbarItems:items animated:YES];
  
  if (currentPageIndex <= 0) {
    leftArrow.enabled = NO;
  }
  
  if (currentPageIndex >= (pageCount - 1)) {
    rightArrow.enabled = NO;
  }
}


- (UIView*) createToolbar {
  UIToolbar* toolbar = [[[UIToolbar alloc] init] autorelease];
  //toolbar.tintColor = [UIColor colorWithRed:190/256. green:200./256. blue:206/256. alpha:1];
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
    //[self setupToolbarItems];
    //self.navigationController.toolbar.barStyle = UIBarStyleBlack;
    //self.navigationController.toolbar.translucent = YES;
    //[self.navigationController setToolbarHidden:NO animated:animated];
    [NotificationCenter disableNotifications];
  }
}


- (void) viewWillDisappear:(BOOL) animated {
  [super viewWillDisappear:animated];
  
  //self.navigationController.toolbar.barStyle = UIBarStyleDefault;
  //self.navigationController.toolbar.translucent = NO;
  //[self.navigationController setToolbarHidden:YES animated:animated];
  if (pageCount > 1) {
    [NotificationCenter enableNotifications];
  }
}


- (void) loadView {
  [super loadView];
  
  if (pageCount > 1) {
    self.tableView.tableHeaderView = [self createToolbar];
    [pageToTableView setObject:self.tableView forKey:[NSNumber numberWithInt:currentPageIndex]];
  }
}


- (void) initializeData {
  @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (void) onButtonTapped:(UIViewAnimationTransition) transition {
  [self initializeData];
  
  NSNumber* pageNumber = [NSNumber numberWithInt:currentPageIndex];
  UITableView* newTableView = [pageToTableView objectForKey:pageNumber];
  if (newTableView == nil) {
    newTableView = [[[UITableView alloc] initWithFrame:self.tableView.frame style:self.tableView.style] autorelease];
    newTableView.delegate = self;
    newTableView.dataSource = self;
    newTableView.tableHeaderView = [self createToolbar];
    [pageToTableView setObject:newTableView forKey:pageNumber];
    [newTableView reloadData];
  }

  [UIView beginAnimations:nil context:NULL];
  {
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:transition forView:self.tableView.superview cache:YES];

    self.tableView = newTableView;
  }
  [UIView commitAnimations];

  [self performSelector:@selector(removeTableViews) withObject:nil afterDelay:5];
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


- (void) onLeftTapped:(id) sender {
  currentPageIndex--;
  [self onButtonTapped:UIViewAnimationTransitionFlipFromLeft];
}


- (void) onRightTapped:(id) sender {
  currentPageIndex++;
  [self onButtonTapped:UIViewAnimationTransitionFlipFromRight];
}

@end
