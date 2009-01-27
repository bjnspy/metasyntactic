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

#import "YourRightsAppDelegate.h"

#import "Model.h"
#import "YourRightsNavigationController.h"

@interface YourRightsAppDelegate()
@property (retain) YourRightsNavigationController* navigationController;
@property (retain) Model* model;
@end

@implementation YourRightsAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize model;

- (void) dealloc {
    self.window = nil;
    self.navigationController = nil;
    self.model = nil;
    [super dealloc];
}

- (void) applicationDidFinishLaunching:(UIApplication*) application {  
    self.navigationController = [[[YourRightsNavigationController alloc] initWithAppDelegate:self] autorelease];
    self.model = [[[Model alloc] init] autorelease];
    [window addSubview:navigationController.view];
    [window makeKeyAndVisible];
}


@end
