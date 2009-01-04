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

#import "MetaFlixController.h"

#import "Application.h"
#import "AlertUtilities.h"
#import "DateUtilities.h"
#import "MetaFlixAppDelegate.h"
#import "MetaFlixModel.h"
#import "NetflixCache.h"
#import "ThreadingUtilities.h"
#import "Utilities.h"

@interface MetaFlixController()
@property (assign) MetaFlixAppDelegate* appDelegate;
@end


@implementation MetaFlixController

@synthesize appDelegate;

- (void) dealloc {
    self.appDelegate = nil;

    [super dealloc];
}


- (MetaFlixModel*) model {
    return appDelegate.model;
}


- (id) initWithAppDelegate:(MetaFlixAppDelegate*) appDelegate_ {
    if (self = [super init]) {
        self.appDelegate = appDelegate_;
    }

    return self;
}


+ (MetaFlixController*) controllerWithAppDelegate:(MetaFlixAppDelegate*) appDelegate {
    return [[[MetaFlixController alloc] initWithAppDelegate:appDelegate] autorelease];
}


- (void) spawnNetflixThread {
    NSAssert([NSThread isMainThread], nil);
    [self.model.netflixCache update];
}


- (void) start {
    NSAssert([NSThread isMainThread], nil);
    [self spawnNetflixThread];
}


- (void) setNetflixKey:(NSString*) key secret:(NSString*) secret userId:(NSString*) userId {
    [self.model setNetflixKey:key secret:secret userId:userId];
    [self spawnNetflixThread];
}

@end