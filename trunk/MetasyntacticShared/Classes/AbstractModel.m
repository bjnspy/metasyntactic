//
//  AbstractModel.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 9/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AbstractModel.h"

#import "AbstractApplication.h"
#import "MetasyntacticSharedApplication.h"

@interface AbstractModel()
@property (retain) NSNumber* isInReviewPeriodData;
@end

@implementation AbstractModel

static NSString* FIRST_LAUNCH_DATE                          = @"firstLaunchDate";
static NSString* HAS_SHOWN_WRITE_REVIEW_REQUEST             = @"hasShownWriteReviewRequest";
static NSString* RUN_COUNT                                  = @"runCount";
static NSString* REVIEW_PERIOD_COMPLETE                     = @"reviewPeriodComplete";

@synthesize isInReviewPeriodData;

- (void) dealloc {
  self.isInReviewPeriodData = nil;
  [super dealloc];
}


- (void) synchronize {
  [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void) incrementRunCount {
  NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey:RUN_COUNT];
  [[NSUserDefaults standardUserDefaults] setInteger:(runCount + 1) forKey:RUN_COUNT];
  [self synchronize];
}


- (void) trySetFirstLaunchDate {
  NSDate* firstLaunchDate = [[NSUserDefaults standardUserDefaults] objectForKey:FIRST_LAUNCH_DATE];
  if (firstLaunchDate == nil) {
    firstLaunchDate = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:firstLaunchDate forKey:FIRST_LAUNCH_DATE];
    [self synchronize];
  }
}


- (void) tryShowWriteReviewRequest {
  NSString* url = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"iTunesApplicationUrl"];
  if (url.length == 0) {
    return;
  }

  NSDate* firstLaunchDate = [[NSUserDefaults standardUserDefaults] objectForKey:FIRST_LAUNCH_DATE];
  if (firstLaunchDate == nil) {
  }
  
  NSTimeInterval interval = ABS(firstLaunchDate.timeIntervalSinceNow);
  if (interval < ONE_MONTH) {
    return;
  }
  
  NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey:RUN_COUNT];
  if (runCount < 50) {
    return;
  }
  
  BOOL hasShown = [[NSUserDefaults standardUserDefaults] boolForKey:HAS_SHOWN_WRITE_REVIEW_REQUEST];
  if (hasShown) {
    return;
  }
  
  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HAS_SHOWN_WRITE_REVIEW_REQUEST];
  [self synchronize];
  
  UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:LocalizedString(@"Like This App?", nil)
                                                   message:LocalizedString(@"Please rate it in the App Store!", nil)
                                                  delegate:self
                                         cancelButtonTitle:LocalizedString(@"No Thanks", @"Must be short. 1-2 words max. Label for a button when a user does not want to write a review")
                                         otherButtonTitles:LocalizedString(@"Rate It!", @"Must be short. 1-2 words max. Label for a button a user can tap to rate this app"), nil] autorelease];
  [alert show];
}


- (void) alertView:(UIAlertView*) alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex != alertView.cancelButtonIndex) {
    NSString* url = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"iTunesApplicationUrl"];
    [AbstractApplication openBrowser:url];
  }
}


- (id) init {
  if ((self = [super init])) {
    [self trySetFirstLaunchDate];
    [self incrementRunCount];
    [self tryShowWriteReviewRequest];
  }
  
  return self;
}


- (BOOL) isInReviewPeriodWorker {
  NSString* key = [NSString stringWithFormat:@"%@-%@", REVIEW_PERIOD_COMPLETE, [AbstractApplication version]];
  id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
  
  return value == nil;
}


- (BOOL) isInReviewPeriod {
  if (isInReviewPeriodData == nil) {
    self.isInReviewPeriodData = [NSNumber numberWithBool:[self isInReviewPeriodWorker]];
  }
  
  return isInReviewPeriodData.boolValue;
}


- (void) clearInReviewPeriod {
  self.isInReviewPeriodData = [NSNumber numberWithBool:NO];
  
  NSString* key = [NSString stringWithFormat:@"%@-%@", REVIEW_PERIOD_COMPLETE, [AbstractApplication version]];
  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
  [self synchronize];
}


- (NSInteger) runCount {
  return [[NSUserDefaults standardUserDefaults] integerForKey:RUN_COUNT];
}

@end
