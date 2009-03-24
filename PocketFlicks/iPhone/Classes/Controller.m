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

#import "Controller.h"

#import "Application.h"
#import "AlertUtilities.h"
#import "DateUtilities.h"
#import "AppDelegate.h"
#import "Model.h"
#import "NetflixCache.h"
#import "ThreadingUtilities.h"
#import "Utilities.h"

@interface Controller()
@end


@implementation Controller

static Controller* controller = nil;

- (void) dealloc {
    [super dealloc];
}


- (Model*) model {
    return [Model model];
}


- (id) init {
    if (self = [super init]) {
        controller = self;
    }

    return self;
}


+ (Controller*) controller {
    return controller;
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