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

#import "PocketFlicksSettingsViewController.h"

#import "Controller.h"
#import "Model.h"
#import "PocketFlicksCreditsViewController.h"

@interface PocketFlicksSettingsViewController()
@end


@implementation PocketFlicksSettingsViewController

static BOOL refreshed = NO;

typedef enum {
  SendFeedbackSection,
  StandardSettingsSection,
  RefreshSection,
  LastSection
} SettingsSection;

- (void) dealloc {
  [super dealloc];
}


- (id) init {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
    self.title = LocalizedString(@"Settings", nil);
  }

  return self;
}


- (Model*) model {
  return [Model model];
}


- (Controller*) controller {
  return [Controller controller];
}


- (void) minorRefresh {
  [self majorRefresh];
}


- (void) onBeforeViewControllerPushed {
  [super onBeforeViewControllerPushed];
  self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDone)] autorelease];
}


- (void) onDone {
  [self.navigationController.parentViewController dismissModalViewControllerAnimated:YES];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
  return LastSection;
}


- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
  if (section == SendFeedbackSection) {
    return 1;
  } else if (section == StandardSettingsSection) {
    return 2;
  } else if (section == RefreshSection) {
    if (refreshed) {
      return 0;
    } else {
      return 1;
    }
  } else {
    return 0;
  }
}


- (UITableViewCell*) createSwitchCellWithText:(NSString*) text
                                           on:(BOOL) on
                                     selector:(SEL) selector {
  static NSString* reuseIdentifier = @"switchCellReuseIdentifier";

  SwitchCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[SwitchCell alloc] initWithReuseIdentifier:reuseIdentifier] autorelease];
  }

  [cell.switchControl removeTarget:self action:NULL forControlEvents:UIControlEventValueChanged];
  [cell.switchControl addTarget:self action:selector forControlEvents:UIControlEventValueChanged];
  cell.switchControl.on = on;
  cell.textLabel.text = text;

  return cell;
}


- (UITableViewCell*) cellForHeaderRow:(NSInteger) row {
  UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

  NSString* text = [NSString stringWithFormat:@"%@ / %@", LocalizedString(@"About", @"Title for the 'About' page (where we list who was involved in making the program and who supplied the data)"), LocalizedString(@"Send Feedback", @"Title for a button that a user can click on to send a feedback email to the developers")];
  cell.textLabel.text = text;
  return cell;
}


- (UITableViewCell*) cellForSettingsRow:(NSInteger) row {
    NSString* text = @"";
    BOOL on = NO;
    SEL selector = nil;
    if (row == 0) {
      text = LocalizedString(@"Show Notifications", @"This string has to be small enough to be visible with a picker switch next to it.  It means 'show update notifications in the UI to let me know what's happening'");
      on = [Model model].notificationsEnabled;
      selector = @selector(onShowNotificationsChanged:);
    } else if (row == 1) {
      text = LocalizedString(@"Loading Indicators", @"This string has to be small enough to be visible with a picker switch next to it.  It means 'show update spinners in the UI when loading content'");
      on = [Model model].loadingIndicatorsEnabled;
      selector = @selector(onLoadingIndicatorsChanged:);
    }

    return [self createSwitchCellWithText:text on:on selector:selector];
}


- (UITableViewCell*) cellForRefreshRow:(NSInteger) row {
  UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
  cell.textLabel.textAlignment = UITextAlignmentCenter;
  cell.textLabel.text = LocalizedString(@"Force Refresh", nil);
  if (refreshed) {
    cell.textLabel.textColor = [UIColor grayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  } else {
    cell.textLabel.textColor = [ColorCache commandColor];
  }

  return cell;
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
  if (indexPath.section == SendFeedbackSection) {
    return [self cellForHeaderRow:indexPath.row];
  } else if (indexPath.section == StandardSettingsSection) {
    return [self cellForSettingsRow:indexPath.row];
  } else {
    return [self cellForRefreshRow:indexPath.row];
  }
}


- (void) onShowNotificationsChanged:(UISwitch*) sender {
  [[Model model] setNotificationsEnabled:sender.on];
}


- (void) onLoadingIndicatorsChanged:(UISwitch*) sender {
  [[Model model] setLoadingIndicatorsEnabled:sender.on];
}


- (void) didSelectRefreshRow:(NSInteger) row {
  if (refreshed) {
    return;
  }
  refreshed = YES;

  NSArray* indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:2]];
  [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];

  [[Controller controller] start:YES];
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
  if (indexPath.section == SendFeedbackSection) {
    UIViewController* controller = [[[PocketFlicksCreditsViewController alloc] init] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
  } else if (indexPath.section == RefreshSection) {
    [self didSelectRefreshRow:indexPath.row];
  }
}

@end
