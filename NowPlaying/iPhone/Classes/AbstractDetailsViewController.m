//
//  AbstractDetailsViewController.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AbstractDetailsViewController.h"

#import "AbstractNavigationController.h"
#import "DataProvider.h"
#import "DateUtilities.h"
#import "NowPlayingModel.h"
#import "SearchDatePickerViewController.h"
#import "UpdatingListingsViewController.h"

@interface AbstractDetailsViewController()
@property (assign) AbstractNavigationController* navigationController;
@end


@implementation AbstractDetailsViewController

@synthesize navigationController;

- (void) dealloc {
    self.navigationController = nil;

    [super dealloc];
}


- (id) initWithNavigationController:(AbstractNavigationController*) navigationController_ {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.navigationController = navigationController_;
    }
    
    return self;
}


- (NowPlayingModel*) model {
    return navigationController.model;
}


- (NowPlayingController*) controller {
    return navigationController.controller;
}


- (void) changeDate {
    SearchDatePickerViewController* pickerController =
    [SearchDatePickerViewController pickerWithNavigationController:navigationController
                                                            object:self
                                                          selector:@selector(onSearchDateChanged:)];
    [navigationController pushViewController:pickerController animated:YES];
}


- (void) dismissUpdateListingsViewController {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(dismissUpdateListingsViewController) withObject:nil waitUntilDone:NO];
        return;
    }
    
    [self dismissModalViewControllerAnimated:YES];
}


- (void) presentUpdateListingsViewController {
    UpdatingListingsViewController* viewController =
    [[[UpdatingListingsViewController alloc] initWithTarget:self selector:@selector(onCancelPressed:)] autorelease];    
    [self presentModalViewController:viewController animated:YES];
}


- (void) onCancelPressed:(id) sender {
    ++updateId;
    [self dismissUpdateListingsViewController];
}


- (void) onSearchDateChanged:(NSString*) dateString {
    NSDate* searchDate = [DateUtilities dateWithNaturalLanguageString:dateString];
    if ([DateUtilities isSameDay:searchDate date:self.model.searchDate]) {
        return;
    }
    
    [self presentUpdateListingsViewController];
    
    NSArray* array = [NSArray arrayWithObjects:[NSNumber numberWithInt:++updateId],
                      searchDate, nil];
    [self.model.dataProvider update:searchDate delegate:self context:array];
}


- (void) onFailure:(NSString*) error context:(id) array {
    if (updateId != [[array objectAtIndex:0] intValue]) {
        return;
    }
    
    [self dismissUpdateListingsViewController];
    [self performSelectorOnMainThread:@selector(reportError:) withObject:error waitUntilDone:NO];
}


- (void) reportError:(NSString*) error {
    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:nil
                                                     message:error
                                                    delegate:nil
                                           cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                           otherButtonTitles:nil] autorelease];
    
    [alert show];
}


- (void) onSuccess:(LookupResult*) lookupResult context:(id) array {
    if (updateId != [[array objectAtIndex:0] intValue]) {
        return;
    }
    
    NSDate* searchDate = [array lastObject];

    // Save the results.  this will also force a refresh
    [self.model setSearchDate:searchDate];
    [self.model.dataProvider saveResult:lookupResult];
    
    [self dismissUpdateListingsViewController];
}


@end

