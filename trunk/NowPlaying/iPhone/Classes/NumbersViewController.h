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

#if 0

@interface NumbersViewController : UITableViewController {
    NumbersNavigationController* navigationController;
    UISegmentedControl* segmentedControl;

    NSArray* movieNumbers;
    NSDictionary* movieMap;
}

@property (assign) NumbersNavigationController* navigationController;
@property (retain) UISegmentedControl* segmentedControl;
@property (retain) NSArray* movieNumbers;

- (id) initWithNavigationController:(NumbersNavigationController*) navigationController;

- (void) refresh;
- (NowPlayingModel*) model;
- (NowPlayingController*) controller;

@end

#endif