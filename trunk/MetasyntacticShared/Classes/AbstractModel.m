// Copyright 2010 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

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
  return NO;

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
