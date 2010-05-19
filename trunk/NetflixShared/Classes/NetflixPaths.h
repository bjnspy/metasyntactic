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

@interface NetflixPaths : NSObject {

}

+ (NSString*) accountDirectory:(NetflixAccount*) account;

+ (NSString*) feedsFile:(NetflixAccount*) account;

+ (NSString*) queueFile:(Feed*) feed account:(NetflixAccount*) account;
+ (NSString*) queueEtagFile:(Feed*) feed account:(NetflixAccount*) account;

+ (NSString*) userFile:(NetflixAccount*) account;

+ (NSString*) detailsFile:(Movie*) movie;
+ (NSString*) seriesFile:(NSString*) seriesKey;

+ (NSString*) userRatingsDirectory:(NetflixAccount*) account;
+ (NSString*) predictedRatingsDirectory:(NetflixAccount*) account;

+ (NSString*) userRatingsFile:(Movie*) movie account:(NetflixAccount*) account;
+ (NSString*) predictedRatingsFile:(Movie*) movie account:(NetflixAccount*) account;

+ (NSString*) rssFeedDirectory:(NSString*) address;
+ (NSString*) rssFile:(NSString*) address;
+ (NSString*) rssMovieFile:(NSString*) identifier address:(NSString*) address;

+ (NSString*) searchFile:(Movie*) movie;
+ (NSString*) filmographyFile:(NSString*) filmographyAddress;

@end
