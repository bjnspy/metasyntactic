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

@interface Application : NSObject {
}

/*
+ (NSString*) supportDirectory;
+ (NSString*) tempDirectory;
+ (NSString*) documentsDirectory;
*/

+ (NSString*) dataDirectory;
+ (NSString*) imdbDirectory;
+ (NSString*) userLocationsDirectory;
+ (NSString*) postersDirectory;
+ (NSString*) largePostersDirectory;
+ (NSString*) scoresDirectory;
+ (NSString*) reviewsDirectory;
+ (NSString*) trailersDirectory;

/*
+ (NSString*) numbersDirectory;
+ (NSString*) numbersDetailsDirectory;
*/

+ (NSString*) dvdDirectory;
+ (NSString*) dvdDetailsDirectory;
+ (NSString*) dvdIMDbDirectory;
+ (NSString*) dvdPostersDirectory;

+ (NSString*) blurayDirectory;
+ (NSString*) blurayDetailsDirectory;
+ (NSString*) blurayIMDbDirectory;
+ (NSString*) blurayPostersDirectory;

+ (NSString*) netflixDirectory;
+ (NSString*) netflixQueuesDirectory;
+ (NSString*) netflixPostersDirectory;
+ (NSString*) netflixSynopsesDirectory;
+ (NSString*) netflixCastDirectory;
+ (NSString*) netflixDirectorsDirectory;
+ (NSString*) netflixIMDbDirectory;
+ (NSString*) netflixSeriesDirectory;
+ (NSString*) netflixUserRatingsDirectory;
+ (NSString*) netflixPredictedRatingsDirectory;

+ (NSString*) upcomingDirectory;
+ (NSString*) upcomingCastDirectory;
+ (NSString*) upcomingIMDbDirectory;
+ (NSString*) upcomingPostersDirectory;
+ (NSString*) upcomingSynopsesDirectory;
+ (NSString*) upcomingTrailersDirectory;

+ (void) resetDirectories;
+ (void) resetNetflixDirectories;

+ (NSString*) uniqueTemporaryDirectory;

+ (void) openBrowser:(NSString*) address;
+ (void) openMap:(NSString*) address;
+ (void) makeCall:(NSString*) phoneNumber;

+ (DifferenceEngine*) differenceEngine;

+ (NSString*) host;

+ (unichar) starCharacter;
+ (NSString*) emptyStarString;
+ (NSString*) halfStarString;
+ (NSString*) starString;

+ (BOOL) useKilometers;

@end