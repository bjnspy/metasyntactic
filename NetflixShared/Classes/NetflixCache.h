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

#import "AbstractMovieCache.h"

@interface NetflixCache : AbstractMovieCache {
@private
  NSError* lastError;
}

@property (retain) NSError* lastError;

+ (NetflixCache*) cache;

+ (NSString*) noInformationFound;

- (void) update:(NetflixAccount*) account force:(BOOL) force;
- (void) updateQueues:(NetflixAccount*) account force:(BOOL) force;

- (NSString*) titleForKey:(NSString*) key account:(NetflixAccount*) account;
- (NSString*) titleForKey:(NSString*) key includeCount:(BOOL) includeCount account:(NetflixAccount*) account;

- (Movie*) correspondingNetflixMovie:(Movie*) movie;

- (NSArray*) statusesForMovie:(Movie*) movie account:(NetflixAccount*) account;

- (NSString*) userRatingForMovie:(Movie*) movie account:(NetflixAccount*) account;
- (NSString*) netflixRatingForMovie:(Movie*) movie account:(NetflixAccount*) account;
- (NSString*) availabilityForMovie:(Movie*) movie;

- (NSArray*) castForMovie:(Movie*) movie;
- (NSArray*) directorsForMovie:(Movie*) movie;
- (NSString*) netflixAddressForMovie:(Movie*) movie;
- (NSString*) synopsisForMovie:(Movie*) movie;

- (NSString*) netflixAddressForPerson:(Person*) person;
- (NSArray*) filmographyAddressesForPerson:(Person*) person;
- (Movie*) movieForFilmographyAddress:(NSString*) filmographyAddress;

- (BOOL) isInstantWatch:(Movie*) movie;
- (BOOL) isDvd:(Movie*) movie;
- (BOOL) isBluray:(Movie*) movie;

- (BOOL) user:(NetflixUser*) user canRentMovie:(Movie*) movie;

+ (Movie*) promoteDiscToSeries:(Movie*) disc;
+ (NSString*) downloadEtag:(Feed*) feed account:(NetflixAccount*) account;

// Searching
- (NSArray*) movieSearch:(NSString*) query account:(NetflixAccount*) account error:(NSString**) error;
- (NSArray*) personSearch:(NSString*) query account:(NetflixAccount*) account error:(NSString**) error;

@end
