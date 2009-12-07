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


- (NSString*) createVersionedKey:(NSString*) base {
  return [NSString stringWithFormat:@"%@-%@", base, [AbstractApplication version]];
}


- (NSString*) reviewPeriodKey {
  return [self createVersionedKey:REVIEW_PERIOD_COMPLETE];
}


- (NSString*) firstLaunchKey {
  return [self createVersionedKey:FIRST_LAUNCH_DATE];
}


- (NSString*) writeReviewKey {
  return [self createVersionedKey:HAS_SHOWN_WRITE_REVIEW_REQUEST];
}


- (NSString*) runCountKey {
  return [self createVersionedKey:RUN_COUNT];
}


- (void) incrementRunCount {
  NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey:self.runCountKey];
  [[NSUserDefaults standardUserDefaults] setInteger:(runCount + 1) forKey:self.runCountKey];
  [self synchronize];
}


- (void) trySetFirstLaunchDate {
  NSDate* firstLaunchDate = [[NSUserDefaults standardUserDefaults] objectForKey:self.firstLaunchKey];
  if (firstLaunchDate == nil) {
    firstLaunchDate = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:firstLaunchDate forKey:self.firstLaunchKey];
    [self synchronize];
  }
}


- (id) init {
  if ((self = [super init])) {
    [self trySetFirstLaunchDate];
    [self incrementRunCount];
  }

  return self;
}


- (BOOL) isInReviewPeriodWorker {
  id value = [[NSUserDefaults standardUserDefaults] objectForKey:self.reviewPeriodKey];

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

  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:self.reviewPeriodKey];
  [self synchronize];
}


- (NSInteger) runCount {
  return [[NSUserDefaults standardUserDefaults] integerForKey:self.runCountKey];
}


- (void) tryShowWriteReviewRequest {
  NSString* url = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"iTunesApplicationUrl"];
  if (url.length == 0) {
    return;
  }

  NSDate* firstLaunchDate = [[NSUserDefaults standardUserDefaults] objectForKey:self.firstLaunchKey];
  if (firstLaunchDate == nil) {
    return;
  }

  NSTimeInterval interval = ABS(firstLaunchDate.timeIntervalSinceNow);
  if (interval < ONE_MONTH) {
    return;
  }

  NSInteger runCount = self.runCount;
  if (runCount < 20) {
    return;
  }

  BOOL hasShown = [[NSUserDefaults standardUserDefaults] boolForKey:self.writeReviewKey];
  if (hasShown) {
    return;
  }

  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:self.writeReviewKey];
  [self synchronize];

  UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:LocalizedString(@"Like This App?", nil)
                                                   message:LocalizedString(@"Please rate it in the App Store.\n\nAlready rated a previous version? Please update the rating to count against the current version.", nil)
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

@end
