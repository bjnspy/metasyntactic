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

#import "RefreshableTableViewController.h"
#import "NetflixModifyQueueDelegate.h"
#import "NetflixMoveMovieDelegate.h"
#import "TappableImageViewDelegate.h"

@interface NetflixQueueViewController :
    RefreshableTableViewController<
        TappableImageViewDelegate,
        NetflixModifyQueueDelegate,
        NetflixMoveMovieDelegate> {
@private
    NSString* feedKey;
    Feed* feed;
    Queue* queue;

    UIBarButtonItem* backButton;
    BOOL upArrowTapped;

    NSMutableArray* mutableMovies;
    NSMutableArray* mutableSaved;
    IdentitySet* deletedMovies;
    IdentitySet* reorderedMovies;

    BOOL readonlyMode;
}

- (id) initWithNavigationController:(AbstractNavigationController*) navigationController
                            feedKey:(NSString*) feedKey;

@end