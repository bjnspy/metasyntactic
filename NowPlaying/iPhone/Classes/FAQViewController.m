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

#import "AbstractNavigationController.h"
#import "ActionsView.h"
#import "Application.h"
#import "ColorCache.h"
#import "DateUtilities.h"
#import "LocaleUtilities.h"
#import "Model.h"
#import "QuestionCell.h"
#import "StringUtilities.h"
#import "ViewControllerUtilities.h"

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


- (id) init {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.questions = [NSArray arrayWithObjects:
                          NSLocalizedString(@"Why did my theater disappear?", nil),
                          [NSString stringWithFormat:NSLocalizedString(@"%@ doesn't list my favorite theater. Can you add it?", nil), [Application name]],
                          [NSString stringWithFormat:NSLocalizedString(@"Why don't I see ratings for all movies in %@?", nil), [Application name]],
                          [NSString stringWithFormat:NSLocalizedString(@"Why doesn't %@ offer ticketing through Movietickets.com as well as Fandango.com?", nil), [Application name]],
                          NSLocalizedString(@"Can you increase the maximum search distance for theaters?", nil),
                          [NSString stringWithFormat:NSLocalizedString(@"Why is %@ always downloading data? Why doesn't it store the data locally?", nil), [Application name]],
                          [NSString stringWithFormat:NSLocalizedString(@"If %@ caches data, why do i always see the 'loading spinner' even on posters that were already loaded?", nil), [Application name]],
                          NSLocalizedString(@"How do I get to my alternative queues for my Netflix account?", nil),
                          [NSString stringWithFormat:NSLocalizedString(@"Why doesn't %@ provide IMDb user ratings and reviews?", nil), [Application name]],
                          [NSString stringWithFormat:NSLocalizedString(@"Why doesn't %@ provide Yahoo ratings and reviews?", nil), [Application name]],
                          [NSString stringWithFormat:NSLocalizedString(@"Could you provide an option to let me choose the icon i want for the %@?", nil), [Application name]],
                          [NSString stringWithFormat:NSLocalizedString(@"What can I do if I have a question that hasn't been answered?", nil)], nil];

        self.answers = [NSArray arrayWithObjects:
                        [NSString stringWithFormat:NSLocalizedString(@"Theaters are removed when they do not provide up-to-date listings. When they do, they will reappear automatically in %@.", nil), [Application name]],
                        NSLocalizedString(@"I can absolutely try. Please tap the 'Add Theater' button above to contact me. I'll need the theater's name and its telephone number. Thanks!", nil),
                        NSLocalizedString(@"Licensing restrictions with certain data providers only allow for a subset of all movie reviews. Sorry!", nil),
                        NSLocalizedString(@"Unfortunately, Movietickets.com will not provide ticketing support if i also provide ticketing through Fandango.com.", nil),
                        NSLocalizedString(@"Currently no. However, simply mark the theater as a 'favorite' (by tapping the 'star' in the theater details pane) and it will show up even if it is outside your search range.", nil),
                        [NSString stringWithFormat:NSLocalizedString(@"%@ aggressively caches all data locally on your %@ so that it will be usable even without a network connection.  The only data not cached are movie trailers.", nil), [Application name], [[UIDevice currentDevice] localizedModel]],
                        [NSString stringWithFormat:NSLocalizedString(@"To make scrolling as fast and as smooth as possible, %@ does not show the poster until scrolling has stopped.", nil), [Application name]],
                        NSLocalizedString(@"Log out of Netflix and log back in with the user name and password for your alternative queue.", nil),
                        NSLocalizedString(@"IMDb's licensing fees are unfortunately too high for me to afford. Sorry!", nil),
                        NSLocalizedString(@"See the section on IMDb.", nil),
                        NSLocalizedString(@"Apple does not provide a mechanism for Apps to change their icon. When they do, i will provide this capability.", nil),
                        NSLocalizedString(@"Tap the 'Send Feedback' button above to contact me directly about anything else you need. Cheers! :-)", nil), nil];

        self.title = NSLocalizedString(@"Help", nil);
        self.tableView.backgroundColor = [UIColor colorWithRed:219.0/256.0 green:226.0/256.0 blue:237.0/256.0 alpha:1];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        NSArray* selectors = [NSArray arrayWithObjects:
                              [NSValue valueWithPointer:@selector(sendFeedback)],
                              [NSValue valueWithPointer:@selector(addTheater)],nil];
        NSArray* titles = [NSArray arrayWithObjects:
                           NSLocalizedString(@"Send Feedback", nil),
                           NSLocalizedString(@"Add Theater", nil), nil];
        NSArray* arguments = [NSArray arrayWithObjects:[NSNull null], [NSNull null], nil];
        self.actionsView = [ActionsView viewWithTarget:self
                                             selectors:selectors
                                                titles:titles
                                             arguments:arguments
                                             shiftDown:NO];
        actionsView.backgroundColor = self.tableView.backgroundColor;
    }

    return self;
}


- (Model*) model {
    return [Model model];
}


- (void) reload {
    [self reloadTableViewData];
}


- (void) majorRefreshWorker {
    [self reload];
}


- (void) minorRefreshWorker {
    [self reload];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return questions.count * 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section % 2 == 0) {
        static NSString* reuseIdentifier = @"questionCell";
        QuestionCell *cell = (id)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];

        if (cell == nil) {
            cell = [[[QuestionCell alloc] initWithQuestion:YES reuseIdentifier:reuseIdentifier] autorelease];
        }
        NSString* text = [questions objectAtIndex:indexPath.section / 2];
        cell.text = text;

        return cell;
    } else {
        static NSString* reuseIdentifier = @"answerCell";
        QuestionCell *cell = (id)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[QuestionCell alloc] initWithQuestion:NO reuseIdentifier:reuseIdentifier] autorelease];
        }

        NSString* text = [answers objectAtIndex:indexPath.section / 2];
        cell.text = text;

        return cell;
    }
}


- (CGFloat)         tableView:(UITableView*) tableView_
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section % 2 == 0) {
        NSString* text = [questions objectAtIndex:indexPath.section / 2];

        return [QuestionCell height:YES text:text];
    } else {
        NSString* text = [answers objectAtIndex:indexPath.section / 2];

        return [QuestionCell height:NO text:text];
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return actionsView;
    }

    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        CGFloat height = [actionsView height];

        return height + 1;
    }

    return -1;
}


- (void) sendFeedback:(BOOL) addTheater {
    NSString* body = @"";

    if (addTheater) {
        body = [body stringByAppendingFormat:@"\n\nPlease provide the following:\nTheater Name: \nPhone Number: "];
    }

    body = [body stringByAppendingFormat:@"\n\nVersion: %@\nDevice: %@ v%@\nLocation: %@\nSearch Distance: %d\nSearch Date: %@\nReviews: %@\nAuto-Update Location: %@\nPrioritize Bookmarks: %@\nCountry: %@\nLanguage: %@",
            [Application version],
            [[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion],
            self.model.userAddress,
            self.model.searchRadius,
            [DateUtilities formatShortDate:self.model.searchDate],
            self.model.currentScoreProvider,
            (self.model.autoUpdateLocation ? @"yes" : @"no"),
            (self.model.prioritizeBookmarks ? @"yes" : @"no"),
            [LocaleUtilities englishCountry],
            [LocaleUtilities englishLanguage]];

    if (self.model.netflixEnabled && self.model.netflixUserId.length > 0) {
        body = [body stringByAppendingFormat:@"\n\nNetflix:\nUser ID: %@\nKey: %@\nSecret: %@",
                [StringUtilities nonNilString:self.model.netflixUserId],
                [StringUtilities nonNilString:self.model.netflixKey],
                [StringUtilities nonNilString:self.model.netflixSecret]];
    }

    NSString* subject;
    if ([LocaleUtilities isJapanese]) {
        subject = [StringUtilities stringByAddingPercentEscapes:@"Now Playingのフィードバック"];
    } else {
        subject = @"Now Playing Feedback";
    }

#ifdef IPHONE_OS_VERSION_3
    if ([Application canSendMail]) {
        MFMailComposeViewController* controller = [[[MFMailComposeViewController alloc] init] autorelease];
        controller.mailComposeDelegate = self;

        [controller setToRecipients:[NSArray arrayWithObject:@"cyrus.najmabadi@gmail.com"]];
        [controller setSubject:subject];
        [controller setMessageBody:body isHTML:NO];

        [self presentModalViewController:controller animated:YES];
    } else {
#endif
        NSString* encodedSubject = [StringUtilities stringByAddingPercentEscapes:subject];
        NSString* encodedBody = [StringUtilities stringByAddingPercentEscapes:body];
        NSString* url = [NSString stringWithFormat:@"mailto:cyrus.najmabadi@gmail.com?subject=%@&body=%@", encodedSubject, encodedBody];
        [Application openBrowser:url];
#ifdef IPHONE_OS_VERSION_3
    }
#endif
}


#ifdef IPHONE_OS_VERSION_3
- (void) mailComposeController:(MFMailComposeViewController*)controller
           didFinishWithResult:(MFMailComposeResult)result
                         error:(NSError*)error {
    [self dismissModalViewControllerAnimated:YES];
}
#endif


- (void) sendFeedback {
    [self sendFeedback:NO];
}


- (void) addTheater {
    [self sendFeedback:YES];
}

@end