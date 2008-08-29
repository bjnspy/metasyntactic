// Copyright (C) 2008 Cyrus Najmabadi
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

@interface Application : NSObject {
}

+ (NSString*) dataFolder;
+ (NSString*) documentsFolder;
+ (NSString*) locationsFolder;
+ (NSString*) numbersFolder;
+ (NSString*) numbersDailyFolder;
+ (NSString*) numbersWeekendFolder;
+ (NSString*) postersFolder;
+ (NSString*) ratingsFolder;
+ (NSString*) reviewsFolder;
+ (NSString*) supportFolder;
+ (NSString*) tempFolder;
+ (NSString*) trailersFolder;
+ (NSString*) upcomingFolder;
+ (NSString*) upcomingPostersFolder;
+ (NSString*) upcomingSynopsesFolder;
+ (NSString*) upcomingTrailersFolder;
+ (NSString*) providerReviewsFolder:(NSString*) provider;

+ (NSString*) movieMapFile;
+ (NSString*) upcomingMoviesIndexFile;
+ (NSString*) ratingsFile:(NSString*) ratingsProvider;

+ (void) deleteFolders;

+ (NSString*) uniqueTemporaryFolder;

+ (void) openBrowser:(NSString*) address;
+ (void) openMap:(NSString*) address;
+ (void) makeCall:(NSString*) phoneNumber;

+ (DifferenceEngine*) differenceEngine;

+ (NSString*) host;

+ (unichar) starCharacter;
+ (NSString*) starString;

+ (void) createDirectory:(NSString*) path;
+ (NSString*) sanitizeFileName:(NSString*) name;

@end