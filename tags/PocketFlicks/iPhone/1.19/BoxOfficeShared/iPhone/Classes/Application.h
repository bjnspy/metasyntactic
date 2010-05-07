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

@interface Application : AbstractApplication {
}

+ (NSString*) dataDirectory;
+ (NSString*) imdbDirectory;
+ (NSString*) amazonDirectory;
+ (NSString*) wikipediaDirectory;
+ (NSString*) metacriticDirectory;
+ (NSString*) rottenTomatoesDirectory;
+ (NSString*) userLocationsDirectory;

+ (NSString*) scoresDirectory;
+ (NSString*) reviewsDirectory;
+ (NSString*) trailersDirectory;
+ (NSString*) localizableStringsDirectory;

+ (NSString*) sentinelsMoviesPostersDirectory;
+ (NSString*) moviesPostersDirectory;
+ (NSString*) largeMoviesPostersDirectory;
+ (NSString*) largeMoviesPostersIndexDirectory;

+ (NSString*) sentinelsPeoplePostersDirectory;
+ (NSString*) peoplePostersDirectory;
+ (NSString*) largePeoplePostersDirectory;

+ (NSString*) dvdDirectory;
+ (NSString*) dvdDetailsDirectory;

+ (NSString*) blurayDirectory;
+ (NSString*) blurayDetailsDirectory;

+ (NSString*) upcomingDirectory;
+ (NSString*) upcomingSynopsesDirectory;
+ (NSString*) upcomingTrailersDirectory;

+ (NSString*) internationalDirectory;
+ (NSString*) helpDirectory;

+ (NSString*) apiHost;
+ (NSString*) apiVersion;

@end
