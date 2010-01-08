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
