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

#import "NetflixStatusCell.h"

#import "ImageCache.h"
#import "Model.h"
#import "NetflixCache.h"
#import "Queue.h"
#import "Status.h"
#import "TappableImageView.h"

@interface NetflixStatusCell()
@property (retain) TappableImageView* deleteImageView;
@property (retain) TappableImageView* moveImageView;

@property (retain) Status* status;
@end


@implementation NetflixStatusCell

@synthesize deleteImageView;
@synthesize moveImageView;
@synthesize status;

- (void) dealloc {
    self.deleteImageView = nil;
    self.moveImageView = nil;
    self.status = nil;

    [super dealloc];
}


- (void) initialize {
    self.text = status.description;

    [deleteImageView removeFromSuperview];
    [moveImageView removeFromSuperview];

    if (!status.queue.isAtHomeQueue && status.description.length > 0) {
        CGRect deleteFrame = deleteImageView.frame;
        CGRect moveFrame = moveImageView.frame;

        deleteFrame.origin.x = moveFrame.size.width;
        deleteImageView.frame = deleteFrame;

        CGRect frame = CGRectMake(0, 0, deleteFrame.origin.x + deleteFrame.size.width, MAX(deleteFrame.size.height, moveFrame.size.height));
        UIView* view = [[[UIView alloc] initWithFrame:frame] autorelease];

        [view addSubview:deleteImageView];

        if (!status.saved && status.position != 0) {
            [view addSubview:moveImageView];
        }

        self.accessoryView = view;
    }
}


- (id) initWithStatus:(Status*) status_ {
    if (self = [super initWithFrame:CGRectZero]) {
        self.status = status_;

        self.font = [UIFont boldSystemFontOfSize:16];
        self.textAlignment = UITextAlignmentCenter;
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.deleteImageView = [[[TappableImageView alloc] initWithImage:[UIImage imageNamed:@"DeleteMovie.png"]] autorelease];
        self.moveImageView = [[[TappableImageView alloc] initWithImage:[ImageCache upArrow]] autorelease];
        deleteImageView.contentMode = moveImageView.contentMode = UIViewContentModeCenter;

        CGRect frame = deleteImageView.frame;
        frame.size.height += 20;
        frame.size.width += 20;
        deleteImageView.frame = frame;
        moveImageView.frame = frame;

        [self initialize];
    }

    return self;
}


- (void) enterReadonlyMode {
    UIActivityIndicatorView* view = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    self.accessoryView = view;
    [view startAnimating];
}

@end