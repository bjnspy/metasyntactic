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

#import "DVDCache.h"

#import "Application.h"
#import "NetworkUtilities.h"
#import "NowPlayingAppDelegate.h"
#import "NowPlayingModel.h"
#import "PointerSet.h"
#import "Utilities.h"
#import "XmlElement.h"

@implementation DVDCache


- (void) dealloc {
    [super dealloc];
}


- (id) initWithModel:(NowPlayingModel*) model_ {
    if (self = [super initWithModel:model_]) {
    }

    return self;
}


+ (DVDCache*) cacheWithModel:(NowPlayingModel*) model {
    return [[[DVDCache alloc] initWithModel:model] autorelease];
}


- (NSArray*) loadBookmarksArray {
    return [model bookmarkedDVD];
}


- (NSString*) serverAddress {
    return [NSString stringWithFormat:@"http://%@.appspot.com/LookupDVDListings?q=dvd", [Application host]];
}


- (NSString*) directory {
    return [Application dvdDirectory];
}

@end