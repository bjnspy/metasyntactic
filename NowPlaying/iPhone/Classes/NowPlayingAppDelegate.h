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

@interface NowPlayingAppDelegate : NSObject<UIApplicationDelegate> {
@private
    IBOutlet UIWindow* window;
    ApplicationTabBarController* tabBarController;

    NowPlayingModel* model;
    NowPlayingController* controller;
    Pulser* minorRefreshPulser;
    Pulser* majorRefreshPulser;
}

@property (readonly, nonatomic, retain) UIWindow* window;
@property (readonly, retain) ApplicationTabBarController* tabBarController;
@property (readonly, retain) NowPlayingController* controller;
@property (readonly, retain) NowPlayingModel* model;

+ (void) minorRefresh;
+ (void) majorRefresh;
+ (void) majorRefresh:(BOOL) force;

+ (UIWindow*) window;

@end