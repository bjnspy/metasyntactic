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

#import "PostersViewController.h"

#import "AbstractNavigationController.h"
#import "ColorCache.h"
#import "LargePosterCache.h"
#import "NonClippingView.h"
#import "NowPlayingModel.h"
#import "TappableScrollView.h"
#import "TappableScrollViewDelegate.h"
#import "ThreadingUtilities.h"

@interface PostersViewController()
@property (assign) AbstractNavigationController* navigationController;
@property (retain) Movie* movie;
@property (retain) NSMutableDictionary* pageNumberToView;
@property (retain) TappableScrollView* scrollView;
@property (retain) UIToolbar* topBar;
@end


@implementation PostersViewController

const double TRANSLUCENCY_LEVEL = 0.9;
const int ACTIVITY_INDICATOR_TAG = -1;
const int LABEL_TAG = -2;
const double LOAD_DELAY = 1;

@synthesize navigationController;
@synthesize pageNumberToView;
@synthesize movie;
@synthesize topBar;
@synthesize scrollView;

- (void) dealloc {
    self.navigationController = nil;
    self.pageNumberToView = nil;
    self.movie = nil;
    self.topBar = nil;
    self.scrollView = nil;

    [super dealloc];
}


- (id) initWithNavigationController:(AbstractNavigationController*) navigationController_
                              movie:(Movie*) movie_
                        posterCount:(NSInteger) posterCount_ {
    if (self = [super init]) {
        self.navigationController = navigationController_;
        self.movie = movie_;
        posterCount = posterCount_;

        self.pageNumberToView = [NSMutableDictionary dictionary];
    }

    return self;
}


- (NowPlayingController*) controller {
    return navigationController.controller;
}


- (NowPlayingModel*) model {
    return navigationController.model;
}


- (UILabel*) createDownloadingLabel:(NSString*) text; {
    UILabel* downloadingLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    downloadingLabel.tag = LABEL_TAG;
    downloadingLabel.backgroundColor = [UIColor clearColor];
    downloadingLabel.opaque = NO;
    downloadingLabel.text = text;
    downloadingLabel.font = [UIFont boldSystemFontOfSize:24];
    downloadingLabel.textColor = [UIColor whiteColor];
    [downloadingLabel sizeToFit];

    CGRect frame = [UIScreen mainScreen].applicationFrame;
    CGRect labelFrame = downloadingLabel.frame;
    labelFrame.origin.x = (int)((frame.size.width - labelFrame.size.width) / 2.0);
    labelFrame.origin.y = (int)((frame.size.height - labelFrame.size.height) / 2.0);
    downloadingLabel.frame = labelFrame;

    return downloadingLabel;
}


- (UIActivityIndicatorView*) createActivityIndicator:(UILabel*) label {
    UIActivityIndicatorView* activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
    activityIndicator.tag = ACTIVITY_INDICATOR_TAG;
    activityIndicator.hidesWhenStopped = YES;
    [activityIndicator sizeToFit];

    CGRect labelFrame = label.frame;
    CGRect activityFrame = activityIndicator.frame;

    activityFrame.origin.x = (int)(labelFrame.origin.x - activityFrame.size.width) - 5;
    activityFrame.origin.y = (int)(labelFrame.origin.y + (labelFrame.size.height / 2) - (activityFrame.size.height / 2));
    activityIndicator.frame = activityFrame;

    [activityIndicator startAnimating];

    return activityIndicator;
}


- (void) createDownloadViews:(UIView*) pageView page:(NSInteger) page {
    NSString* text;
    if ([self.model.largePosterCache posterExistsForMovie:movie index:page]) {
        text = NSLocalizedString(@"Loading poster", nil);
    } else {
        text = NSLocalizedString(@"Downloading poster", nil);
    }
    UILabel* downloadingLabel = [self createDownloadingLabel:text];
    UIActivityIndicatorView* activityIndicator = [self createActivityIndicator:downloadingLabel];

    CGRect frame = activityIndicator.frame;
    double width = frame.size.width;
    frame.origin.x = (int)(frame.origin.x + width / 2);
    activityIndicator.frame = frame;

    frame = downloadingLabel.frame;
    frame.origin.x = (int)(frame.origin.x + width / 2);
    downloadingLabel.frame = frame;

    [pageView addSubview:activityIndicator];
    [pageView addSubview:downloadingLabel];
}


- (UIImageView*) createImageView:(UIImage*) image {
    UIImageView* imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
    imageView.contentMode = UIViewContentModeScaleAspectFill;

    CGRect frame = [UIScreen mainScreen].applicationFrame;
    frame.origin.y = 0;

    if (image.size.width > image.size.height) {
        int offset = (int)((frame.size.height - frame.size.width) / 2.0);
        CGRect imageFrame = CGRectMake(-offset, offset + 5, frame.size.height, frame.size.width - 10);

        imageView.frame = imageFrame;
        imageView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    } else {
        CGRect imageFrame = CGRectMake(5, 0, frame.size.width - 10, frame.size.height);
        imageView.frame = imageFrame;
        imageView.clipsToBounds = YES;
    }

    return imageView;
}


- (TappableScrollView*) createScrollView {
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    frame.origin.y = 0;

    self.scrollView = [[[TappableScrollView alloc] initWithFrame:frame] autorelease];
    scrollView.delegate = self;
    scrollView.tapDelegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.alwaysBounceHorizontal = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.directionalLockEnabled = YES;
    scrollView.autoresizingMask = 0;
    scrollView.backgroundColor = [UIColor blackColor];

    frame.size.width *= posterCount;
    scrollView.contentSize = frame.size;

    return scrollView;
}


- (void) disableActivityIndicator:(UIView*) pageView {
    id view = [pageView viewWithTag:ACTIVITY_INDICATOR_TAG];
    [view stopAnimating];
    [view removeFromSuperview];

    view = [pageView viewWithTag:LABEL_TAG];
    [view removeFromSuperview];
}


- (void) addImage:(UIImage*) image toView:(UIView*) pageView {
    [self disableActivityIndicator:pageView];

    UIImageView* imageView = [self createImageView:image];
    [pageView addSubview:imageView];
    imageView.alpha = 0;

    [UIView beginAnimations:nil context:NULL];
    {
        imageView.alpha = 1;
    }
    [UIView commitAnimations];
}


- (void) addImageToView:(NSArray*) arguments {
    if (scrollView.dragging || scrollView.decelerating) {
        [self performSelector:@selector(addImageToView:) withObject:arguments afterDelay:1];
        return;
    }

    [self addImage:[arguments objectAtIndex:0] toView:[arguments objectAtIndex:1]];
}


- (void) loadPage:(NSInteger) page delay:(double) delay {
    if (page < 0 || page >= posterCount) {
        return;
    }

    NSNumber* pageNumber = [NSNumber numberWithInt:page];
    if ([pageNumberToView objectForKey:pageNumber] != nil) {
        return;
    }

    CGRect frame = [UIScreen mainScreen].applicationFrame;
    frame.origin.y = 0;
    frame.origin.x = page * frame.size.width;

    UIView* pageView = [[[UIView alloc] initWithFrame:frame] autorelease];
    pageView.backgroundColor = [UIColor blackColor];
    pageView.tag = page;
    pageView.clipsToBounds = YES;

    UIImage* image = nil;
    if (delay == 0) {
        image = [self.model.largePosterCache posterForMovie:movie index:page];
    }

    if (image != nil) {
        [self addImage:image toView:pageView];
    } else {
        [self createDownloadViews:pageView page:page];
        NSArray* indexAndPageView = [NSArray arrayWithObjects:[NSNumber numberWithInt:page], pageView, nil];
        [self performSelector:@selector(loadPoster:) withObject:indexAndPageView
                   afterDelay:delay];
    }

    [scrollView addSubview:pageView];

    [pageNumberToView setObject:pageView forKey:pageNumber];
}


- (void) loadPoster:(NSArray*) indexAndPageView {
    if (shutdown) {
        return;
    }

    NSNumber* index = [indexAndPageView objectAtIndex:0];

    if (index.intValue < (currentPage - 1) ||
        index.intValue > (currentPage + 1)) {
        return;
    }

    if (scrollView.dragging || scrollView.decelerating) {
        [self performSelector:@selector(loadPoster:) withObject:indexAndPageView afterDelay:1];
        return;
    }

    UIImage* image = [self.model.largePosterCache posterForMovie:movie index:index.intValue];
    if (image == nil) {
        [self performSelector:@selector(loadPoster:) withObject:indexAndPageView afterDelay:LOAD_DELAY];
    } else {
        UIView* pageView = [indexAndPageView objectAtIndex:1];
        NSArray* arguments = [NSArray arrayWithObjects:image, pageView, nil];
        [self addImageToView:arguments];
    }
}


- (void) setupTopBar {
    NSString* title =
    [NSString stringWithFormat:
     NSLocalizedString(@"%d of %d", nil), (currentPage + 1), posterCount];

    UILabel* label = [[[UILabel alloc] init] autorelease];
    label.text = title;
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.opaque = NO;
    label.shadowColor = [UIColor darkGrayColor];
    [label sizeToFit];

    NSMutableArray* items = [NSMutableArray array];

    [items addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]];
    [items addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]];
    [items addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]];

    UIBarButtonItem* leftArrow = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"LeftArrow.png"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(onLeftTapped:)] autorelease];
    [items addObject:leftArrow];

    [items addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]];

    UIBarItem* titleItem = [[[UIBarButtonItem alloc] initWithCustomView:label] autorelease];
    [items addObject:titleItem];

    [items addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]];

    UIBarButtonItem* rightArrow = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"RightArrow.png"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(onRightTapped:)] autorelease];
    [items addObject:rightArrow];


    [items addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]];

    UIBarButtonItem* doneItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDoneTapped:)] autorelease];
    [items addObject:doneItem];

    [topBar setItems:items animated:YES];

    if (currentPage <= 0) {
        leftArrow.enabled = NO;
    }

    if (currentPage >= (posterCount - 1)) {
        rightArrow.enabled = NO;
    }
}


- (void) clearAndLoadPages {
    for (NSNumber* pageNumber in pageNumberToView.allKeys) {
        if (pageNumber.intValue < (currentPage - 1) || pageNumber.intValue > (currentPage + 1)) {
            UIView* pageView = [pageNumberToView objectForKey:pageNumber];
            [self disableActivityIndicator:pageView];

            [pageView removeFromSuperview];
            [pageNumberToView removeObjectForKey:pageNumber];
        }
    }

    [self loadPage:currentPage - 1 delay:LOAD_DELAY];
    [self loadPage:currentPage     delay:LOAD_DELAY];
    [self loadPage:currentPage + 1 delay:LOAD_DELAY];
}


- (void) setPage:(NSInteger) page {
    if (page != currentPage) {
        currentPage = page;

        [self setupTopBar];
        [self clearAndLoadPages];
    }
}


- (void) hideToolBar {
    [UIView beginAnimations:nil context:NULL];
    {
        topBar.alpha = 0;
    }
    [UIView commitAnimations];
}


- (void) showToolBar {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideToolBar) object:nil];

    [UIView beginAnimations:nil context:NULL];
    {
        topBar.alpha = TRANSLUCENCY_LEVEL;

        [self performSelector:@selector(hideToolBar) withObject:nil afterDelay:4];
    }
    [UIView commitAnimations];
}


- (void) onRightTapped:(id) argument {
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    rect.origin.y = 0;
    rect.origin.x = (currentPage + 1) * rect.size.width;
    [scrollView scrollRectToVisible:rect animated:YES];
    [self setPage:currentPage + 1];
    [self showToolBar];
}


- (void) onLeftTapped:(id) argument {
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    rect.origin.y = 0;
    rect.origin.x = (currentPage - 1) * rect.size.width;
    [scrollView scrollRectToVisible:rect animated:YES];
    [self setPage:currentPage - 1];
    [self showToolBar];
}


- (void) loadView {
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    frame.origin.y = 0;
    NonClippingView* view = [[[NonClippingView alloc] initWithFrame:frame] autorelease];

    [self createScrollView];

    {
        self.topBar = [[[UIToolbar alloc] initWithFrame:CGRectZero] autorelease];
        topBar.barStyle = UIBarStyleBlackTranslucent;
        [self setupTopBar];
        [topBar sizeToFit];

        CGRect topBarFrame = topBar.frame;
        topBarFrame.origin.y = frame.size.height - topBarFrame.size.height;
        topBar.frame = topBarFrame;

        [self showToolBar];
    }

    // load the first two pages.  Try to load the first one immediately.
    [self loadPage:0 delay:0];
    [self loadPage:1 delay:LOAD_DELAY];

    [view addSubview:scrollView];
    [view addSubview:topBar];

    self.view = view;
}


- (void) dismiss {
    shutdown = YES;
    [navigationController hidePostersView];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideToolBar) object:nil];
}


- (void) onDoneTapped:(id) argument {
    [self dismiss];
}


- (void) scrollView:(TappableScrollView*) scrollView
          wasTapped:(NSInteger) tapCount
            atPoint:(CGPoint) point {
    if (posterCount == 1) {
        // just dismiss us
        [self dismiss];
    } else {
        if (topBar.alpha == 0) {
            [self showToolBar];
        } else {
            [self hideToolBar];
        }
    }
}


- (void) scrollViewWillBeginDragging:(UIScrollView*) scrollView {
    [self hideToolBar];
}


- (void) scrollViewDidEndDecelerating:(UIScrollView*) view {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = (NSInteger)((scrollView.contentOffset.x + pageWidth / 2) / pageWidth);

    [self setPage:page];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
    return NO;
}

@end