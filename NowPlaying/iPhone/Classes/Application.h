//Copyright 2008 Cyrus Najmabadi
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

@interface Application : NSObject {
}

+ (NSString*) dataFolder;
+ (NSString*) documentsFolder;
+ (NSString*) imdbFolder;
+ (NSString*) locationsFolder;
+ (NSString*) userLocationsFolder;
+ (NSString*) postersFolder;
+ (NSString*) ratingsFolder;
+ (NSString*) reviewsFolder;
+ (NSString*) supportFolder;
+ (NSString*) tempFolder;
+ (NSString*) trailersFolder;

+ (NSString*) numbersFolder;
+ (NSString*) numbersDetailsFolder;

+ (NSString*) dvdFolder;
+ (NSString*) dvdPostersFolder;

+ (NSString*) upcomingFolder;
+ (NSString*) upcomingCastFolder;
+ (NSString*) upcomingIMDbFolder;
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

+ (BOOL) useKilometers;

@end