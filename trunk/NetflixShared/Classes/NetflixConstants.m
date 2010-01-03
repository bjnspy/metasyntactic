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

#import "NetflixConstants.h"


@implementation NetflixConstants

+ (NSInteger) etagMismatchError {
  return 412;
}

+ (NSInteger) titleAlreadyInQueueError {
  return 710;
}


+ (NSString*) titleKey {
  return @"title";
}


+ (NSString*) seriesKey {
  return @"series";
}


+ (NSString*) averageRatingKey {
  return @"average_rating";
}


+ (NSString*) linkKey {
  return @"link";
}


+ (NSString*) availabilityKey {
  return @"availability";
}


+ (NSString*) castKey {
  return @"cast";
}


+ (NSString*) formatsKey {
  return @"formats";
}


+ (NSString*) synopsisKey {
  return @"synopsis";
}


+ (NSString*) similarsKey {
  return @"similars";
}


+ (NSString*) directorsKey {
  return @"directors";
}


+ (NSString*) filmographyKey {
  return @"filmography";
}


+ (NSString*) recommendationKey {
  return @"http://schemas.netflix.com/feed.recommendations";
}


+ (NSString*) discQueueKey {
  return @"http://schemas.netflix.com/feed.queues.disc";
}


+ (NSString*) instantQueueKey {
  return @"http://schemas.netflix.com/feed.queues.instant";
}


+ (NSString*) atHomeKey {
  return @"http://schemas.netflix.com/feed.at_home";
}


+ (NSString*) rentalHistoryKey {
  return @"http://schemas.netflix.com/feed.rental_history";
}


+ (NSString*) rentalHistoryWatchedKey {
  return @"http://schemas.netflix.com/feed.rental_history.watched";
}


+ (NSString*) rentalHistoryReturnedKey {
  return @"http://schemas.netflix.com/feed.rental_history.returned";
}


+ (NSString*) instantFormat {
  return @"instant";
}


+ (NSString*) dvdFormat {
  return @"DVD";
}


+ (NSString*) blurayFormat {
  return @"Blu-ray";
}

@end
