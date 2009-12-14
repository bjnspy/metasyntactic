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

#import "FAQViewController.h"

#import "Application.h"
#import "HelpCache.h"
#import "Model.h"
#import "QuestionCell.h"

@interface FAQViewController()
@property (retain) NSArray* questions;
@property (retain) NSArray* answers;
@property (retain) ActionsView* actionsView;
@end


@implementation FAQViewController

@synthesize questions;
@synthesize answers;
@synthesize actionsView;

- (void) dealloc {
  self.questions = nil;
  self.answers = nil;
  self.actionsView = nil;
  [super dealloc];
}


- (Model*) model {
  return [Model model];
}


- (id) init {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
    NSArray* qAndA = [[HelpCache cache] questionsAndAnswers];
    self.questions = [qAndA objectAtIndex:0];
    self.answers = [qAndA objectAtIndex:1];

    self.title = [NSString stringWithFormat:LocalizedString(@"%d Questions & Answers", @"i.e.: 20 Questions & Answers"), questions.count];
    self.tableView.backgroundColor = [ColorCache helpBlue];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    NSArray* selectors = [NSArray arrayWithObjects:
                          [NSValue valueWithPointer:@selector(sendFeedback)],
                          [NSValue valueWithPointer:@selector(addTheater)],nil];
    NSArray* titles = [NSArray arrayWithObjects:
                       LocalizedString(@"Send Feedback", nil),
                       LocalizedString(@"Add Theater", @"Title for a button that the user can use to request that a theater be added to the program"), nil];
    self.actionsView = [ActionsView viewWithTarget:self
                                         selectors:selectors
                                            titles:titles];
    actionsView.backgroundColor = self.tableView.backgroundColor;
  }

  return self;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
  return questions.count * 2;
}


- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section {
  return 1;
}


- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
  if (indexPath.section % 2 == 0) {
    static NSString* reuseIdentifier = @"questionCell";
    QuestionCell *cell = (id)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];

    if (cell == nil) {
      cell = [[[QuestionCell alloc] initWithQuestion:YES reuseIdentifier:reuseIdentifier] autorelease];
    }
    NSString* text = [questions objectAtIndex:indexPath.section / 2];
    [cell setQuestionText:text];

    return cell;
  } else {
    static NSString* reuseIdentifier = @"answerCell";
    QuestionCell *cell = (id)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
      cell = [[[QuestionCell alloc] initWithQuestion:NO reuseIdentifier:reuseIdentifier] autorelease];
    }

    NSString* text = [answers objectAtIndex:indexPath.section / 2];
    [cell setQuestionText:text];

    return cell;
  }
}


- (CGFloat)         tableView:(UITableView*) tableView_
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
  if (indexPath.section % 2 == 0) {
    NSString* text = [questions objectAtIndex:indexPath.section / 2];

    return [QuestionCell height:text];
  } else {
    NSString* text = [answers objectAtIndex:indexPath.section / 2];

    return [QuestionCell height:text];
  }
}


- (UIView*) tableView:(UITableView*) tableView viewForHeaderInSection:(NSInteger) section {
  if (section == 0) {
    return actionsView;
  } else if (section % 2 == 0) {
    UILabel* label = [[[UILabel alloc] init] autorelease];
    label.text = [NSString stringWithFormat:@"#%d", (section / 2) + 1];
    label.backgroundColor = [ColorCache helpBlue];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.contentMode = UIViewContentModeBottom;
    [label sizeToFit];
    return label;
  }

  return nil;
}


- (CGFloat) tableView:(UITableView*) tableView heightForHeaderInSection:(NSInteger) section {
  if (section == 0) {
    CGFloat height = [actionsView height];

    return height + 8;
  } else if (section % 2 == 0) {
    return [self tableView:tableView viewForHeaderInSection:section].frame.size.height;
  }

  return -4;
}


- (void) sendFeedback:(BOOL) addTheater {
  if (![Application canSendMail]) {
    [AlertUtilities showOkAlert:LocalizedString(@"You must first set up an email account on your device before you can send feedback.", nil)];
    return;
  }

  NSString* body = @"";

  if (addTheater) {
    body = [body stringByAppendingFormat:@"\n\nPlease provide the following:\nTheater Name: \nPhone Number: "];
  }

  body = [body stringByAppendingFormat:@"\n\nVersion: %@\nDevice: %@ v%@\nLocation: %@\nSearch Distance: %d\nSearch Date: %@\nReviews: %@\nAuto-Update Location: %@\nCountry: %@\nLanguage: %@",
          [Application version],
          [[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion],
          [Model model].userAddress,
          [Model model].searchRadius,
          [DateUtilities formatShortDate:[Model model].searchDate],
          [Model model].currentScoreProvider,
          ([Model model].autoUpdateLocation ? @"yes" : @"no"),
          [LocaleUtilities englishCountry],
          [LocaleUtilities englishLanguage]];

  NetflixAccount* account = [[NetflixAccountCache cache] currentAccount];
  if ([Model model].netflixCacheEnabled && account.userId.length > 0) {
    body = [body stringByAppendingFormat:@"\n\nNetflix:\nUser ID: %@\nKey: %@\nSecret: %@",
            [StringUtilities nonNilString:account.userId],
            [StringUtilities nonNilString:account.key],
            [StringUtilities nonNilString:account.secret]];
  }

  NSString* subject = LocalizedString(@"Now Playing Feedback", nil);

  MFMailComposeViewController* controller = [[[MFMailComposeViewController alloc] init] autorelease];
  controller.mailComposeDelegate = self;

  [controller setToRecipients:[NSArray arrayWithObject:@"cyrus.najmabadi@gmail.com"]];
  [controller setSubject:subject];
  [controller setMessageBody:body isHTML:NO];

  [self presentModalViewController:controller animated:YES];
}


- (void) mailComposeController:(MFMailComposeViewController*) controller
           didFinishWithResult:(MFMailComposeResult) result
                         error:(NSError*) error {
  [self dismissModalViewControllerAnimated:YES];
}


- (void) sendFeedback {
  [self sendFeedback:NO];
}


- (void) addTheater {
  [self sendFeedback:YES];
}

@end
