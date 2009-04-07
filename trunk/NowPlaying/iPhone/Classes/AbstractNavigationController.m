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

#import "AbstractNavigationController.h"

#import "Application.h"
#import "Controller.h"
#import "DateUtilities.h"
#import "LocaleUtilities.h"
#import "Model.h"
#import "Movie.h"
#import "MovieDetailsViewController.h"
#import "PostersViewController.h"
#import "ReviewsViewController.h"
#import "SearchViewController.h"
#import "SettingsViewController.h"
#import "StringUtilities.h"
#import "Theater.h"
#import "TheaterDetailsViewController.h"
#import "TicketsViewController.h"
#import "WebViewController.h"

#ifndef IPHONE_OS_VERSION_3
#endif

@interface AbstractNavigationController()
@property (retain) PostersViewController* postersViewController;
@property BOOL visible;
#ifndef IPHONE_OS_VERSION_3
@property BOOL isViewLoaded;
@property (retain) SearchViewController* searchViewController;
#endif
@end


@implementation AbstractNavigationController

@synthesize postersViewController;
@synthesize visible;
#ifndef IPHONE_OS_VERSION_3
@synthesize isViewLoaded;
@synthesize searchViewController;
#endif

- (void) dealloc {
    self.postersViewController = nil;
    self.visible = NO;

#ifndef IPHONE_OS_VERSION_3
    self.isViewLoaded = NO;
    self.searchViewController = nil;
#endif

    [super dealloc];
}


- (id) init {
    if (self = [super initWithNibName:nil bundle:nil]) {
    }

    return self;
}


- (void) loadView {
    [super loadView];

#ifndef IPHONE_OS_VERSION_3
    self.isViewLoaded = YES;
#endif

    self.view.autoresizesSubviews = YES;
}


- (void) refreshWithSelector:(SEL) selector {
    if (!self.isViewLoaded || !visible) {
        return;
    }

    for (id controller in self.viewControllers) {
        if ([controller respondsToSelector:selector]) {
            [controller performSelector:selector];
        }
    }
}


- (void) majorRefresh {
    [self refreshWithSelector:@selector(majorRefresh)];
}


- (void) minorRefresh {
    [self refreshWithSelector:@selector(minorRefresh)];
}


- (void) viewDidAppear:(BOOL) animated {
    [super viewDidAppear:animated];
    self.visible = YES;
}


- (void) viewDidDisappear:(BOOL) animated {
    [super viewDidDisappear:animated];
    self.visible = NO;
}


- (void) didReceiveMemoryWarning {
    if (visible || postersViewController != nil) {
        return;
    }

    [self popToRootViewControllerAnimated:NO];
    [super didReceiveMemoryWarning];
}


- (Model*) model {
    return [Model model];
}


- (Controller*) controller {
    return [Controller controller];
}


- (Movie*) movieForTitle:(NSString*) canonicalTitle {
    for (Movie* movie in self.model.movies) {
        if ([movie.canonicalTitle isEqual:canonicalTitle]) {
            return movie;
        }
    }

    return nil;
}


- (Theater*) theaterForName:(NSString*) name {
    for (Theater* theater in self.model.theaters) {
        if ([theater.name isEqual:name]) {
            return theater;
        }
    }

    return nil;
}


- (void) navigateToLastViewedPage {
    NSArray* types = self.model.navigationStackTypes;
    NSArray* values = self.model.navigationStackValues;

    for (int i = 0; i < types.count; i++) {
        NSInteger type = [[types objectAtIndex:i] intValue];
        id value = [values objectAtIndex:i];

        if (type == MovieDetails) {
            Movie* movie = [self movieForTitle:value];
            [self pushMovieDetails:movie animated:NO];
        } else if (type == TheaterDetails) {
            Theater* theater = [self theaterForName:value];
            [self pushTheaterDetails:theater animated:NO];
        } else if (type == Reviews) {
            Movie* movie = [self movieForTitle:value];
            [self pushReviews:movie animated:NO];
        } else if (type == Tickets) {
            Movie* movie = [self movieForTitle:[value objectAtIndex:0]];
            Theater* theater = [self theaterForName:[value objectAtIndex:1]];
            NSString* title = [value objectAtIndex:2];

            [self pushTicketsView:movie theater:theater title:title animated:NO];
        }
    }
}


- (void) pushReviews:(Movie*) movie animated:(BOOL) animated {
    ReviewsViewController* controller = [[[ReviewsViewController alloc] initWithMovie:movie] autorelease];

    [self pushViewController:controller animated:animated];
}


- (void) pushMovieDetails:(Movie*) movie
                 animated:(BOOL) animated {
    if (movie == nil) {
        return;
    }

    UIViewController* viewController = [[[MovieDetailsViewController alloc] initWithMovie:movie] autorelease];
    [self pushViewController:viewController animated:animated];
}


- (void) pushTheaterDetails:(Theater*) theater animated:(BOOL) animated {
    if (theater == nil) {
        return;
    }

    UIViewController* viewController = [[[TheaterDetailsViewController alloc] initWithTheater:theater] autorelease];
    [self pushViewController:viewController animated:animated];
}


- (void) pushTicketsView:(Movie*) movie
                 theater:(Theater*) theater
                   title:(NSString*) title
                animated:(BOOL) animated {
    if (movie == nil || theater == nil) {
        return;
    }

    UIViewController* viewController = [[[TicketsViewController alloc] initWithTheater:theater
                                                                                 movie:movie
                                                                                 title:title] autorelease];

    [self pushViewController:viewController animated:animated];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
    [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        return YES;
    }

    return self.model.screenRotationEnabled && postersViewController == nil;
}


- (void) hidePostersView {
    [self popViewControllerAnimated:YES];
    self.postersViewController = nil;
}


- (void) showPostersView:(Movie*) movie posterCount:(NSInteger) posterCount {
    if (postersViewController != nil) {
        [self hidePostersView];
    }

    self.postersViewController =
    [[[PostersViewController alloc] initWithMovie:movie
                                      posterCount:posterCount] autorelease];

    [self pushViewController:postersViewController animated:YES];
}


- (void) pushBrowser:(NSString*) address showSafariButton:(BOOL) showSafariButton animated:(BOOL) animated {
    WebViewController* controller = [[[WebViewController alloc] initWithAddress:address
                                                               showSafariButton:showSafariButton] autorelease];
    [self pushViewController:controller animated:animated];
}


- (void) pushBrowser:(NSString*) address animated:(BOOL) animated {
    [self pushBrowser:address showSafariButton:YES animated:animated];
}


- (void) pushInfoControllerAnimated:(BOOL) animated {
    UIViewController* controller = [[[SettingsViewController alloc] init] autorelease];
    [self pushViewController:controller animated:YES];
}

#ifndef IPHONE_OS_VERSION_3
- (void) showSearchView {
    if (searchViewController == nil) {
        self.searchViewController = [[[SearchViewController alloc] init] autorelease];
    }

    [self pushViewController:searchViewController animated:YES];
}
#endif


- (void) onTabBarItemSelected {
    for (id controller in self.viewControllers) {
        if ([controller respondsToSelector:@selector(onTabBarItemSelected)]) {
            [controller onTabBarItemSelected];
        }
    }
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

@end
