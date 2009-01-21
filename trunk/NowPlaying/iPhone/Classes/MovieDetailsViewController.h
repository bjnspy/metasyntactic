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

#import "AbstractDetailsViewController.h"
#import "NetflixAddMovieDelegate.h"
#import "NetflixModifyQueueDelegate.h"
#import "NetflixMoveMovieDelegate.h"
#import "TappableImageViewDelegate.h"

@interface MovieDetailsViewController : AbstractDetailsViewController<TappableImageViewDelegate, NetflixAddMovieDelegate, UIActionSheetDelegate, NetflixModifyQueueDelegate, NetflixMoveMovieDelegate> {
@private
    Movie* movie;
    DVD* dvd;
        
    Movie* netflixMovie;
    BOOL isEnqueued;
    NetflixRatingsCell* netflixRatingsCell;
    NSArray* netflixStatusCells;
        
    NSMutableArray* theatersArray;
    NSMutableArray* showtimesArray;
    NSString* trailer;
    NSArray* reviewsArray;
    NSDictionary* websites;

    NSInteger hiddenTheaterCount;

    ActionsView* actionsView;
    UIButton* bookmarkButton;

    BOOL filterTheatersByDistance;
    BOOL expandedDetails;
    BOOL shutdown;
    BOOL visible;
    BOOL readonlyMode;

    NSLock* posterDownloadLock;
    UIImage* posterImage;
    TappableImageView* posterImageView;
    ActivityIndicatorViewWithBackground* posterActivityView;
    NSInteger posterCount;
}

- (id) initWithNavigationController:(AbstractNavigationController*) navigationController
                              movie:(Movie*) movie;

- (void) minorRefresh;
- (void) majorRefresh;

+ (UIImage*) posterForMovie:(Movie*) movie model:(Model*) model;

@end