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

@interface AbstractApplication : NSObject {
@protected
}

+ (NSLock*) gate;
+ (BOOL) shutdownCleanly;

+ (NSString*) name;
+ (NSString*) version;
+ (NSString*) nameAndVersion;

+ (NSString*) cacheDirectory;
+ (NSString*) tempDirectory;
+ (NSString*) trashDirectory;
+ (NSString*) imagesDirectory;
+ (NSString*) storeDirectory;

+ (NSString*) uniqueTemporaryDirectory;
+ (NSString*) uniqueTrashDirectory;

+ (void) moveItemToTrash:(NSString*) path;

+ (void) openBrowser:(NSString*) address;
+ (void) openMap:(NSString*) address;
+ (void) makeCall:(NSString*) phoneNumber;

+ (BOOL) useKilometers;
+ (BOOL) canSendMail;
+ (BOOL) canSendText;
+ (BOOL) canAccessCalendar;

/* @protected */
+ (void) clearStaleData;

+ (void) addDirectory:(NSString*) directory;
+ (void) createDirectories;
+ (void) resetDirectories;

@end
