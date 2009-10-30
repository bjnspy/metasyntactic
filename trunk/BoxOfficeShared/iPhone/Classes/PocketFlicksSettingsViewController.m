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
  self.navigationController.navigationBar.tintColor = [StyleSheet navigationBarTintColor];
}


- (void) onDone {
  [self.navigationController.parentViewController dismissModalViewControllerAnimated:YES];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
  return 2;
}


- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
  if (section == 0) {
    return 1;
  } else {
    return 3;
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
      text = LocalizedString(@"Screen Rotation", @"This string has to be small enough to be visible with a picker switch next to it.  It means 'don't turn the screen automatically when i rotate my phone'");
      on = [MetasyntacticSharedApplication screenRotationEnabled];
      selector = @selector(onScreenRotationEnabledChanged:);
    } else if (row == 1) {
      text = LocalizedString(@"Show Notifications", @"This string has to be small enough to be visible with a picker switch next to it.  It means 'show update notifications in the UI to let me know what's happening'");
      on = self.model.notificationsEnabled;
      selector = @selector(onShowNotificationsChanged:);
    } else if (row == 2) {
      text = LocalizedString(@"Loading Indicators", @"This string has to be small enough to be visible with a picker switch next to it.  It means 'show update spinners in the UI when loading content'");
      on = self.model.loadingIndicatorsEnabled;
      selector = @selector(onLoadingIndicatorsChanged:);
    }

    return [self createSwitchCellWithText:text on:on selector:selector];
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
  if (indexPath.section == 0) {
    return [self cellForHeaderRow:indexPath.row];
  } else {
    return [self cellForSettingsRow:indexPath.row];
  }
}



- (void) onScreenRotationEnabledChanged:(UISwitch*) sender {
  [self.model setScreenRotationEnabled:sender.on];
}


- (void) onShowNotificationsChanged:(UISwitch*) sender {
  [self.model setNotificationsEnabled:sender.on];
}


- (void) onLoadingIndicatorsChanged:(UISwitch*) sender {
  [self.model setLoadingIndicatorsEnabled:sender.on];
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
  if (indexPath.section == 0) {
    UIViewController* controller = [[[PocketFlicksCreditsViewController alloc] init] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
  }
}

@end
