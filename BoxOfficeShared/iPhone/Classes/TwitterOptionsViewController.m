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

#import "TwitterOptionsViewController.h"

#import "BoxOfficeTwitterAccount.h"

@interface TwitterOptionsViewController()
@property (retain) UITextField* userNameField;
@property (retain) UITextField* passwordField;
@end


@implementation TwitterOptionsViewController

const NSInteger ENABLED_TAG = 1;
//const NSInteger PURCHASING_TAG = 2;
//const NSInteger READING_TAG = 3;
//const NSInteger RATING_TAG = 4;

@synthesize userNameField;
@synthesize passwordField;

- (void) dealloc {
  self.userNameField = nil;
  self.passwordField = nil;
  
  [super dealloc];
}


- (BoxOfficeTwitterAccount*) account {
  return [BoxOfficeTwitterAccount account];
}


- (id) init {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
    self.title = @"Twitter";
    
    CGRect fieldFrame = CGRectMake(100, 10, 200, 20);
    self.userNameField = [[[UITextField alloc] initWithFrame:fieldFrame] autorelease];
    userNameField.text = self.account.username;
    userNameField.autocorrectionType = UITextAutocorrectionTypeNo;
    userNameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    userNameField.placeholder = LocalizedString(@"username", nil);
    userNameField.delegate = self;
    userNameField.returnKeyType = UIReturnKeyNext;
    
    self.passwordField = [[[UITextField alloc] initWithFrame:fieldFrame] autorelease];
    passwordField.secureTextEntry = YES;
    passwordField.text = self.account.password;
    passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passwordField.placeholder = LocalizedString(@"password", nil);
    passwordField.delegate = self;
    passwordField.returnKeyType = UIReturnKeyGo;
  }
  return self;
}


- (void) majorRefresh {
  // do *NOT* remove this.  It prevents us from refreshing while the user is
  // typeing and causing nasty crashes.
}


- (void) minorRefresh {
  // do *NOT* remove this.  It prevents us from refreshing while the user is
  // typeing and causing nasty crashes.
}


- (void) login {
  [[BoxOfficeTwitterAccount account] setUserName:userNameField.text password:passwordField.text];
}


- (void) viewWillDisappear:(BOOL) animated {
  [super viewWillDisappear:animated];
  [self login];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 2;
}


- (UITableViewCell*) cellForAccountRow:(NSInteger) row {
  UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
  
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  if (row == 0) {
    cell.textLabel.text = LocalizedString(@"Login:", nil);
    [cell.contentView addSubview:userNameField];
  } else {
    cell.textLabel.text = LocalizedString(@"Password:", nil);
    [cell.contentView addSubview:passwordField];
  }
  
  return cell;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [self cellForAccountRow:indexPath.row];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
  return LocalizedString(@"Account", nil);
}


- (BOOL) textFieldShouldReturn:(UITextField *)textField {
  if (textField == userNameField) {
    [passwordField becomeFirstResponder];
  } else if (textField == passwordField) {
    [passwordField resignFirstResponder];
    [self login];
  }
  
  return NO;
}

@end
