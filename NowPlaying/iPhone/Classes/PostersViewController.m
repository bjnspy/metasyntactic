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
#import "TappableScrollViewDelegate.h"
#import "TappableScrollView.h"
#import "ThreadingUtilities.h"

@implementation PostersViewController

const double TRANSLUCENCY_LEVEL = 0.9;
const int ACTIVITY_INDICATOR_TAG = -1;
const double LOAD_DELAY = 1;

@synthesize navigationController;
@synthesize pageNumberToView;
@synthesize movie;
@synthesize topBar;
@synthesize bottomBar;
@synthesize scrollView;

- (void) dealloc {
    self.navigationController = nil;
    self.pageNumberToView = nil;
    self.movie = nil;
    self.topBar = nil;
    self.bottomBar = nil;
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


- (void) setupTitle {
    NSString* title =
    [NSString stringWithFormat:
     NSLocalizedString(@"%d of %d", nil), (currentPage + 1), posterCount];

    [[topBar.items objectAtIndex:0] setTitle:title];
}


- (UILabel*) createDownloadingLabel:(NSString*) text; {
    UILabel* downloadingLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    downloadingLabel.backgroundColor = [UIColor clearColor];
    downloadingLabel.opaque = NO;
    downloadingLabel.text = text;
    downloadingLabel.font = [UIFont boldSystemFontOfSize:24];
    downloadingLabel.textColor = [UIColor whiteColor];
    [downloadingLabel sizeToFit];

    CGRect frame = [UIScreen mainScreen].bounds;
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
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.autoresizesSubviews = YES;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    CGRect frame = [UIScreen mainScreen].bounds;
    frame.origin.x = 5;
    frame.size.width -= 10;
    imageView.frame = frame;

    return imageView;
}


- (TappableScrollView*) createScrollView {
    CGRect frame = [UIScreen mainScreen].bounds;

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


- (void) loadPage:(NSInteger) page delay:(double) delay {
    if (page < 0 || page >= posterCount) {
        return;
    }
    
    NSNumber* pageNumber = [NSNumber numberWithInt:page];
    if ([pageNumberToView objectForKey:pageNumber] != nil) {
        return;
    }
         
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.origin.x = page * frame.size.width;

    UIView* pageView = [[[UIView alloc] initWithFrame:frame] autorelease];
    pageView.backgroundColor = [UIColor blackColor];
    pageView.tag = page;
    pageView.autoresizesSubviews = YES;
    pageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self createDownloadViews:pageView page:page];
    NSArray* indexAndPageView = [NSArray arrayWithObjects:[NSNumber numberWithInt:page], pageView, nil];
    [self performSelector:@selector(loadPoster:) withObject:indexAndPageView afterDelay:delay];

    [scrollView addSubview:pageView];

    [pageNumberToView setObject:pageView forKey:pageNumber];
}


- (void) disableActivityIndicator:(UIView*) pageView {
    id view = [pageView viewWithTag:ACTIVITY_INDICATOR_TAG];
    [view stopAnimating];
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


- (void) loadPoster:(NSArray*) indexAndPageView {
    if (shutdown) {
        return;
    }
    
    NSNumber* index = [indexAndPageView objectAtIndex:0];
    UIView* pageView = [indexAndPageView objectAtIndex:1];

    if (index.intValue < (currentPage - 1) ||
        index.intValue > (currentPage + 1)) {
        return;
    }
    
    UIImage* image = [self.model.largePosterCache posterForMovie:movie index:index.intValue];
    if (image == nil) {
        [self performSelector:@selector(loadPoster:) withObject:indexAndPageView afterDelay:LOAD_DELAY];
    } else {
        [self addImage:image toView:pageView];
    }
}


- (void) loadView {
    NonClippingView* view = [[[NonClippingView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
    view.autoresizesSubviews = YES;
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    [self createScrollView];
    scrollView.autoresizesSubviews = YES;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    self.topBar = [[[UINavigationBar alloc] initWithFrame:CGRectZero] autorelease];
    UINavigationItem* item = [[[UINavigationItem alloc] init] autorelease];
    item.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                             target:self
                                                                             action:@selector(onDoneTapped:)] autorelease];
    topBar.items = [NSArray arrayWithObject:item];
    topBar.barStyle = UIBarStyleBlackTranslucent;
    [topBar sizeToFit];
    [self setupTitle];

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
}


- (void) onDoneTapped:(id) argument {
    [self dismiss];
}


- (void) hideToolBars:(BOOL) hidden {
    toolBarsHidden = hidden;

    [UIView beginAnimations:nil context:NULL];
    {
        if (hidden) {
            topBar.alpha = 0;
            bottomBar.alpha = 0;
        } else {
            topBar.alpha = TRANSLUCENCY_LEVEL;
            bottomBar.alpha = TRANSLUCENCY_LEVEL;
        }
    }
    [UIView commitAnimations];
}


- (void) scrollView:(TappableScrollView*) scrollView
          wasTapped:(NSInteger) tapCount
            atPoint:(CGPoint) point {
    if (posterCount == 1) {
        // just dismiss us
        [self dismiss];
    } else {
        [self hideToolBars:!toolBarsHidden];
    }
}


- (void) scrollViewWillBeginDragging:(UIScrollView*) scrollView {
    [self hideToolBars:YES];
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


- (void) scrollViewDidEndDecelerating:(UIScrollView*) view {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = (NSInteger)((scrollView.contentOffset.x + pageWidth / 2) / pageWidth);

    if (page != currentPage) {
        currentPage = page;
        [self setupTitle];
        
        [self clearAndLoadPages];
    }
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
    return NO;
}

@end