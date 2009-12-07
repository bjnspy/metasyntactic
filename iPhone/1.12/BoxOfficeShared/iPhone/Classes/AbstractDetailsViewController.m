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

#import "AbstractDetailsViewController.h"

#import "BoxOfficeStockImages.h"
#import "DataProvider.h"
#import "Model.h"
#import "SearchDatePickerViewController.h"

@interface AbstractDetailsViewController()
@property NSInteger updateId;
@end


@implementation AbstractDetailsViewController

@synthesize updateId;

- (void) dealloc {
  self.updateId = 0;
  [super dealloc];
}


- (id) init {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
  }

  return self;
}


- (Model*) model {
  return [Model model];
}


- (CommonNavigationController*) commonNavigationController {
  return (id) self.navigationController;
}


- (void) changeDate {
  SearchDatePickerViewController* pickerController =
  [SearchDatePickerViewController pickerWithObject:self
                                          selector:@selector(onSearchDateChanged:)];
  [self.navigationController pushViewController:pickerController animated:YES];
}


- (UILabel*) createLabel {
  UILabel* label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
  label.text = LocalizedString(@"Updating Listings", nil);
  label.backgroundColor = [UIColor clearColor];
  label.opaque = NO;
  label.font = [UIFont boldSystemFontOfSize:24];
  label.textColor = [UIColor whiteColor];
  [label sizeToFit];

  CGRect frame = [UIScreen mainScreen].applicationFrame;
  CGRect labelFrame = label.frame;
  labelFrame.origin.x = (NSInteger)((frame.size.width - labelFrame.size.width) / 2.0);
  labelFrame.origin.y = (NSInteger)((frame.size.height - labelFrame.size.height) / 2.0) - 20;
  label.frame = labelFrame;

  return label;
}


- (UIActivityIndicatorView*) createActivityIndicator:(UILabel*) label {
  UIActivityIndicatorView* activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
  activityIndicator.hidesWhenStopped = YES;
  [activityIndicator sizeToFit];

  CGRect labelFrame = label.frame;
  CGRect activityFrame = activityIndicator.frame;

  activityFrame.origin.x = (NSInteger)(labelFrame.origin.x - activityFrame.size.width) - 5;
  activityFrame.origin.y = (NSInteger)(labelFrame.origin.y + (labelFrame.size.height / 2) - (activityFrame.size.height / 2));
  activityIndicator.frame = activityFrame;

  [activityIndicator startAnimating];

  return activityIndicator;
}


- (UIButton*) createButton {
  UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];

  button.backgroundColor = [UIColor blackColor];
  button.titleLabel.font = [button.titleLabel.font fontWithSize:button.titleLabel.font.pointSize + 4];
  button.opaque = NO;
  button.backgroundColor = [UIColor clearColor];
  [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [button setTitle:LocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
  [button addTarget:self action:@selector(onCancelTapped:) forControlEvents:UIControlEventTouchUpInside];

  UIImage* image = [BoxOfficeStockImage(@"BlackButton.png") stretchableImageWithLeftCapWidth:10 topCapHeight:0];
  [button setBackgroundImage:image forState:UIControlStateNormal];
  [button sizeToFit];

  CGRect applicationFrame = [UIScreen mainScreen].applicationFrame;
  CGRect frame = CGRectZero;
  frame.origin.x = 10;
  frame.origin.y = applicationFrame.size.height - frame.origin.x - image.size.height;
  frame.size.height = image.size.height;
  frame.size.width = (NSInteger)(applicationFrame.size.width - 2 * frame.origin.x);
  button.frame = frame;

  return button;
}


- (UIView*) createView {
  CGRect viewFrame = [UIScreen mainScreen].applicationFrame;
  viewFrame.origin.y = 0;

  UIView* view = [[[UIView alloc] initWithFrame:viewFrame] autorelease];
  view.backgroundColor = [UIColor blackColor];

  UILabel* label = [self createLabel];
  UIActivityIndicatorView* activityIndicator = [self createActivityIndicator:label];
  UIButton* button = [self createButton];

  CGRect frame = activityIndicator.frame;
  double width = frame.size.width;
  frame.origin.x = (NSInteger)(frame.origin.x + width / 2);
  activityIndicator.frame = frame;

  frame = label.frame;
  frame.origin.x = (NSInteger)(frame.origin.x + width / 2);
  label.frame = frame;

  [view addSubview:activityIndicator];
  [view addSubview:label];
  [view addSubview:button];

  return view;
}


- (void) presentUpdateListingsViewController {
  UIViewController* viewController = [[[UIViewController alloc] init] autorelease];
  viewController.view = [self createView];

  [self presentModalViewController:viewController animated:YES];
}


- (void) dismissUpdateListingsViewController {
  if (![NSThread isMainThread]) {
    [self performSelectorOnMainThread:@selector(dismissUpdateListingsViewController) withObject:nil waitUntilDone:NO];
    return;
  }

  [self dismissModalViewControllerAnimated:YES];
}


- (void) onCancelTapped:(id) sender {
  self.updateId++;
  [self dismissUpdateListingsViewController];
}


- (void) onSearchDateChanged:(NSDate*) searchDate {
  if ([DateUtilities isSameDay:searchDate date:self.model.searchDate]) {
    return;
  }

  [self presentUpdateListingsViewController];

  self.updateId++;
  NSArray* array = [NSArray arrayWithObjects:
                    [NSNumber numberWithInteger:updateId],
                    searchDate,
                    nil];
  [self.model.dataProvider update:searchDate delegate:self context:array force:YES];
}


- (void) onDataProviderUpdateFailure:(NSString*) error context:(NSArray*) array {
  if (updateId != [array.firstObject integerValue]) {
    return;
  }

  [self dismissUpdateListingsViewController];
  [self performSelectorOnMainThread:@selector(reportError:) withObject:error waitUntilDone:NO];
}


- (void) reportError:(NSString*) error {
  NSAssert([NSThread isMainThread], nil);

  [AlertUtilities showOkAlert:error];
}


- (void) onDataProviderUpdateSuccess:(LookupResult*) lookupResult context:(NSArray*) array {
  if (updateId != [array.firstObject integerValue]) {
    return;
  }

  NSDate* searchDate = array.lastObject;

  // Save the results.
  [self.model setSearchDate:searchDate];
  [self.model.dataProvider saveResult:lookupResult];

  [self dismissUpdateListingsViewController];

  [MetasyntacticSharedApplication majorRefresh:YES];
}


- (void) onDataProviderUpdateComplete:(BOOL) force {
}


- (void) openMailWithSubject:(NSString*) subject
                        body:(NSString*) body {
  MFMailComposeViewController* controller = [[[MFMailComposeViewController alloc] init] autorelease];
  controller.mailComposeDelegate = self;

  [controller setSubject:subject];
  [controller setMessageBody:body isHTML:YES];

  [self presentModalViewController:controller animated:YES];
}


- (void) mailComposeController:(MFMailComposeViewController*) controller
           didFinishWithResult:(MFMailComposeResult) result
                         error:(NSError*) error {
  [self dismissModalViewControllerAnimated:YES];
}

@end
