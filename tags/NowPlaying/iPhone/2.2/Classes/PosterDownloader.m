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

#import "PosterDownloader.h"

#import "ApplePosterDownloader.h"
#import "FandangoPosterDownloader.h"
#import "ImdbPosterDownloader.h"
#import "Movie.h"
#import "NetworkUtilities.h"

@implementation PosterDownloader

+ (NSData*) download:(Movie*) movie postalCode:(NSString*) postalCode {
    NSData* data = [NetworkUtilities dataWithContentsOfAddress:movie.poster important:NO];
    if (data != nil) {
        return data;
    }

    data = [ApplePosterDownloader download:movie];
    if (data != nil) {
        return data;
    }

    data = [FandangoPosterDownloader download:movie postalCode:postalCode];
    if (data != nil) {
        return data;
    }

    data = [ImdbPosterDownloader download:movie];
    if (data != nil) {
        return data;
    }

    return nil;
}


@end