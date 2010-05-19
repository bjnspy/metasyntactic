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

#import "NetflixConstants.h"


@implementation NetflixConstants

+ (NSInteger) etagMismatchError {
  return 412;
}


+ (NSInteger) titleAlreadyInQueueStatusCode {
  return 710;
}


+ (NSInteger) titleNotInQueueStatusCode {
  return 404;
}


+ (NSInteger) titleNotInQueueSubCode {
  return 610;
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


+ (NSString*) rentalHistoryShippedKey {
  return @"http://schemas.netflix.com/feed.rental_history.shipped";
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
