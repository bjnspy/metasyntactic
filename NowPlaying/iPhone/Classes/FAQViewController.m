//
//  FAQViewController.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 4/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FAQViewController.h"

#import "AbstractNavigationController.h"
#import "ActionsView.h"
#import "Application.h"
#import "ColorCache.h"
#import "QuestionCell.h"
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
                        NSLocalizedString(@"I can absolutely try. Please tap the 'Add Theater' button to contact me. I'll need both the theater name and its telephone number. Thanks!", nil),
                        NSLocalizedString(@"Licensing restrictions with certain data providers only allow for a subset of all movie reviews. Sorry!", nil),
                        NSLocalizedString(@"Unfortunately, Movietickets.com will not provide ticketing support if i also provide ticketing through Fandango.com.", nil),
                        NSLocalizedString(@"Currently no. However, simply mark the theater as a 'favorite' (by tapping the 'star' in the theater details pane) and it will show up even if it is far away from you.", nil),
                        [NSString stringWithFormat:NSLocalizedString(@"%@ aggressively caches all data locally on your %@ so that it will be usable even without a network connection.  The only data not cached are movie trailers.", nil), [Application name], [[UIDevice currentDevice] localizedModel]],
                        [NSString stringWithFormat:NSLocalizedString(@"To make scrolling as fast and as smooth as possible, %@ does not show the poster until scrolling has stopped.", nil), [Application name]],
                        NSLocalizedString(@"Log out of Netflix and log back in with the user name and password for your alternative queue.", nil),
                        NSLocalizedString(@"IMDb's licensing fees are unfortunately too high for me to afford. Sorry!", nil),
                        NSLocalizedString(@"See the section on IMDb.", nil),
                        NSLocalizedString(@"Apple does not provide a mechanism for Apps to change their icon. When they do, i will provide this capability.", nil),
                        NSLocalizedString(@"Tap the 'Send Feedback' button above to contact me directly about anything else you need. Cheers! :-)", nil), nil];

        self.navigationItem.titleView = [ViewControllerUtilities viewControllerTitleLabel:NSLocalizedString(@"Frequently Asked Questions", nil)];
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


- (void) sendFeedback {
    [self.abstractNavigationController sendFeedback:NO];
}


- (void) addTheater {
    [self.abstractNavigationController sendFeedback:YES];
}

@end